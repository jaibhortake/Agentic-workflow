# Install the agentic workflow into a project.
# Usage: .\install.ps1 [-Project <dir>] [-Tool claude|cursor|codex|gemini|all|<a,b>] [-Build <model>] [-Review <model>] [-Explore <model>]
#   -Tool defaults to claude; comma-separate several.
#   Models (Claude only): inherit (default), opus, sonnet, haiku, fable, or a full id.
#   Re-run to update skills; model choices already set in the project are kept unless you pass a flag.
param([string]$Project = ".", [string]$Tool = "claude", [string]$Build = "", [string]$Review = "", [string]$Explore = "")
$ErrorActionPreference = "Stop"

$Src  = $PSScriptRoot
$Dest = (Resolve-Path $Project).Path
$Name = Split-Path $Dest -Leaf
$Mark = "<!-- agentic-workflow -->"
$Utf8 = New-Object System.Text.UTF8Encoding $false

if ($Src -eq $Dest) { throw "Run this from (or point it at) your project, not the workflow repo." }

if ($Tool -eq "all") { $Tool = "claude,cursor,codex,gemini" }
$Claude = $false; $Shared = $false; $Gemini = $false
foreach ($t in $Tool.Split(",")) {
  switch ($t.Trim()) {
    "claude" { $Claude = $true }
    { $_ -in "cursor", "codex" } { $Shared = $true }
    "gemini" { $Shared = $true; $Gemini = $true }
    default { Write-Error "Unknown -Tool '$t'. Use claude, cursor, codex, gemini, all, or a comma-separated list."; exit 1 }
  }
}

Write-Host "Installing agentic-workflow ($Tool) into $Dest"

# Prepend an import line to a file unless it already has it (creates the file if missing).
function Add-Import([string]$file, [string]$content) {
  if (-not (Test-Path $file)) { [IO.File]::WriteAllText($file, $content, $Utf8); return }
  $c = [IO.File]::ReadAllText($file)
  if ($c -notmatch "@AGENTS\.md") { [IO.File]::WriteAllText($file, "@AGENTS.md`n`n$c", $Utf8) }
}

# Shared by every tool: config (the skills read .claude/workflow.json), stack presets, plan folders.
New-Item -ItemType Directory -Force "$Dest\.claude\presets" | Out-Null
Copy-Item "$Src\presets\*.md" "$Dest\.claude\presets\" -Force
if (-not (Test-Path "$Dest\.claude\workflow.json")) { Copy-Item "$Src\templates\workflow.json" "$Dest\.claude\workflow.json" }
foreach ($d in "docs\plans\new", "docs\plans\active", "docs\plans\done", "docs\decisions") {
  New-Item -ItemType Directory -Force "$Dest\$d" | Out-Null
  $keep = "$Dest\$d\.gitkeep"
  if (-not (Test-Path $keep)) { New-Item -ItemType File $keep | Out-Null }
}

if ($Claude) {
  New-Item -ItemType Directory -Force "$Dest\.claude\skills", "$Dest\.claude\agents", "$Dest\.claude\hooks" | Out-Null
  Copy-Item "$Src\skills\*" "$Dest\.claude\skills\" -Recurse -Force
  # Agents: keep the model line the project already chose, unless a flag overrides it.
  foreach ($pair in @(@("builder", $Build), @("reviewer", $Review), @("explorer", $Explore))) {
    $f = "$Dest\.claude\agents\$($pair[0]).md"; $want = $pair[1]
    if (-not $want -and (Test-Path $f)) {
      $m = Select-String -Path $f -Pattern '^model:\s*(.+)$' | Select-Object -First 1
      if ($m) { $want = $m.Matches[0].Groups[1].Value.Trim() }
    }
    $text = [IO.File]::ReadAllText("$Src\agents\$($pair[0]).md")
    if ($want) { $text = [regex]::Replace($text, '(?m)^model:.*$', "model: $want") }
    [IO.File]::WriteAllText($f, $text, $Utf8)
  }
  Copy-Item "$Src\agents\outside-reviewer.md" "$Dest\.claude\agents\outside-reviewer.md" -Force
  Copy-Item "$Src\hooks\*.sh" "$Dest\.claude\hooks\" -Force
  # Hooks: install settings.json if absent; never overwrite an existing one.
  $settings = "$Dest\.claude\settings.json"
  if (-not (Test-Path $settings)) {
    Copy-Item "$Src\templates\settings.json" $settings
  } elseif (-not (Select-String -Path $settings -Pattern "plan-gate.sh" -Quiet)) {
    Write-Host "NOTE: .claude/settings.json exists; merge the hooks from $Src\templates\settings.json manually."
  }
}

# Cursor, Codex and Gemini CLI all read project skills from .agents/skills/: one copy serves them all.
if ($Shared) {
  New-Item -ItemType Directory -Force "$Dest\.agents\skills" | Out-Null
  Copy-Item "$Src\skills\*" "$Dest\.agents\skills\" -Recurse -Force
}

# AGENTS.md (read natively by Cursor and Codex, imported by CLAUDE.md and GEMINI.md):
# create, or replace our marked block, or append it.
$block = "$Mark`n" + [IO.File]::ReadAllText("$Src\AGENTS.md").TrimEnd() + "`n$Mark"
$agents = "$Dest\AGENTS.md"
if (-not (Test-Path $agents)) {
  $out = "$block`n"
} else {
  $text = [IO.File]::ReadAllText($agents)
  $pattern = [regex]::Escape($Mark) + "[\s\S]*?" + [regex]::Escape($Mark)
  if ($text -match $pattern) {
    $out = [regex]::Replace($text, $pattern, { param($m) $block })
  } else {
    $out = $text.TrimEnd() + "`n`n$block`n"
  }
}
[IO.File]::WriteAllText($agents, $out, $Utf8)

# CLAUDE.md: create from template, or make sure it imports AGENTS.md.
if ($Claude) { Add-Import "$Dest\CLAUDE.md" ([IO.File]::ReadAllText("$Src\templates\CLAUDE.md").Replace("{{PROJECT_NAME}}", $Name)) }
# GEMINI.md: Gemini CLI reads GEMINI.md, so import AGENTS.md from it.
if ($Gemini) { Add-Import "$Dest\GEMINI.md" "@AGENTS.md`n" }

# Keep personal notes, handoffs and the S-task marker out of git.
$gi = "$Dest\.gitignore"
if (-not (Test-Path $gi)) { New-Item -ItemType File $gi | Out-Null }
$lines = @(Get-Content $gi)
foreach ($p in "CLAUDE.local.md", "docs/handoff.md", "docs/plans/.s-task") {
  if ($lines -notcontains $p) { Add-Content $gi $p }
}

if ($Claude) { Write-Host "Done. Next: open the project in Claude Code and run /setup-project" }
else { Write-Host "Done. Next: open the project in your agent and ask it to run the setup-project skill" }

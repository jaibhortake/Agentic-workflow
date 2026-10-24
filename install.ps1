# Install the agentic workflow into a project.
# Usage: .\install.ps1 [-Project <dir>] [-Build <model>] [-Review <model>] [-Explore <model>]
#   Models: inherit (default), opus, sonnet, haiku, fable, or a full id.
#   Re-run to update skills; model choices already set in the project are kept unless you pass a flag.
param([string]$Project = ".", [string]$Build = "", [string]$Review = "", [string]$Explore = "")
$ErrorActionPreference = "Stop"

$Src  = $PSScriptRoot
$Dest = (Resolve-Path $Project).Path
$Name = Split-Path $Dest -Leaf
$Mark = "<!-- agentic-workflow -->"
$Utf8 = New-Object System.Text.UTF8Encoding $false

if ($Src -eq $Dest) { throw "Run this from (or point it at) your project, not the workflow repo." }

Write-Host "Installing agentic-workflow into $Dest"

New-Item -ItemType Directory -Force "$Dest\.claude\skills", "$Dest\.claude\agents", "$Dest\.claude\hooks", "$Dest\.claude\presets" | Out-Null
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
Copy-Item "$Src\presets\*.md" "$Dest\.claude\presets\" -Force
if (-not (Test-Path "$Dest\.claude\workflow.json")) { Copy-Item "$Src\templates\workflow.json" "$Dest\.claude\workflow.json" }

# Hooks: install settings.json if absent; never overwrite an existing one.
$settings = "$Dest\.claude\settings.json"
if (-not (Test-Path $settings)) {
  Copy-Item "$Src\templates\settings.json" $settings
} elseif (-not (Select-String -Path $settings -Pattern "guard.sh" -Quiet)) {
  Write-Host "NOTE: .claude/settings.json exists - merge the hooks from $Src\templates\settings.json manually."
}

foreach ($d in "docs\plans\new", "docs\plans\active", "docs\plans\done", "docs\decisions") {
  New-Item -ItemType Directory -Force "$Dest\$d" | Out-Null
  $keep = "$Dest\$d\.gitkeep"
  if (-not (Test-Path $keep)) { New-Item -ItemType File $keep | Out-Null }
}

# AGENTS.md: create, or replace our marked block, or append it.
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
$claude = "$Dest\CLAUDE.md"
if (-not (Test-Path $claude)) {
  $t = [IO.File]::ReadAllText("$Src\templates\CLAUDE.md").Replace("{{PROJECT_NAME}}", $Name)
  [IO.File]::WriteAllText($claude, $t, $Utf8)
} else {
  $c = [IO.File]::ReadAllText($claude)
  if ($c -notmatch "@AGENTS\.md") { [IO.File]::WriteAllText($claude, "@AGENTS.md`n`n$c", $Utf8) }
}

# Keep personal notes and handoffs out of git.
$gi = "$Dest\.gitignore"
if (-not (Test-Path $gi)) { New-Item -ItemType File $gi | Out-Null }
$lines = @(Get-Content $gi)
foreach ($p in "CLAUDE.local.md", "docs/handoff.md", "docs/plans/.s-task") {
  if ($lines -notcontains $p) { Add-Content $gi $p }
}

Write-Host "Done. Next: open the project in Claude Code and run /setup-project"

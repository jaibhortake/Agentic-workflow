# Vendor two skills from obra/superpowers (MIT, Jesse Vincent) into skills/.
# They are committed (not gitignored) so the Claude plugin, which installs from git, ships them.
# Never hand-edit skills\test-driven-development or skills\systematic-debugging; re-run this.
# Usage: .\pull-superpowers.ps1 [-Ref <branch|tag|commit>]
param([string]$Ref = "main")
$ErrorActionPreference = "Stop"

$Src = $PSScriptRoot
$RepoUrl = "https://github.com/obra/superpowers.git"
$Skills = @("test-driven-development", "systematic-debugging")
# Skills of theirs we never install: our /verify replaces verification-before-completion.
$RetiredSkills = @("verification-before-completion")
# Upstream's records of how they tested their skills; nothing reads them at runtime, so they are not shipped.
$Exclude = @("CREATION-LOG.md", "test-academic.md", "test-pressure-*.md")

$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("sp-" + [guid]::NewGuid())
try {
  git clone -q --filter=blob:none $RepoUrl "$Tmp\sp"
  if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
  git -C "$Tmp\sp" checkout -q $Ref
  if ($LASTEXITCODE -ne 0) { throw "git checkout $Ref failed" }
  $Commit = (git -C "$Tmp\sp" rev-parse HEAD).Trim()

  foreach ($s in $Skills) {
    if (-not (Test-Path "$Tmp\sp\skills\$s")) { throw "missing upstream skill: $s" }
    if (Test-Path "$Src\skills\$s") { Remove-Item "$Src\skills\$s" -Recurse -Force }
    Copy-Item "$Tmp\sp\skills\$s" "$Src\skills\$s" -Recurse
    foreach ($x in $Exclude) { Get-ChildItem "$Src\skills\$s" -Recurse -Filter $x | Remove-Item -Force }
    Copy-Item "$Tmp\sp\LICENSE" "$Src\skills\$s\LICENSE"
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText("$Src\skills\$s\SOURCE.md", "Vendored from $RepoUrl at $Commit. Do not edit; re-run pull-superpowers.`n", $utf8)
    # Drop the plugin namespace and point their verification reference at our gate.
    Get-ChildItem "$Src\skills\$s" -Recurse -Filter *.md | ForEach-Object {
      $t = [System.IO.File]::ReadAllText($_.FullName)
      $t = $t -replace 'superpowers:verification-before-completion', '/verify' -replace 'superpowers:([a-z-]*)', '/$1'
      [System.IO.File]::WriteAllText($_.FullName, $t, $utf8)
    }
    Write-Host "vendored $s"
  }
  foreach ($s in $RetiredSkills) {
    if (Test-Path "$Src\skills\$s") { Remove-Item "$Src\skills\$s" -Recurse -Force; Write-Host "removed retired $s" }
  }
  Write-Host "obra/superpowers @ $Commit"
} finally {
  if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force }
}

param(
    [ValidateSet('Install', 'Update', 'Remove', 'Verify')]
    [string]$Action = 'Install',

    [string]$SkillsRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceSkillRoot = Join-Path $repoRoot 'project-control'
$requiredEntries = @(
    'SKILL.md',
    'agents',
    'references'
)
$requiredFiles = @(
    'SKILL.md',
    'agents\openai.yaml',
    'references\command-spec.md',
    'references\workflow-map.md',
    'references\state-update-rules.md'
)

function Resolve-SkillsRoot {
    param([string]$InputRoot)

    if ($InputRoot) {
        return $InputRoot
    }

    if ($env:CODEX_HOME) {
        return (Join-Path $env:CODEX_HOME 'skills')
    }

    return (Join-Path $HOME '.codex\skills')
}

function Test-SkillPackage {
    param([string]$RootPath)

    foreach ($entry in $requiredFiles) {
        $path = Join-Path $RootPath $entry
        if (-not (Test-Path $path)) {
            throw "필수 파일이 없습니다: $path"
        }
    }
}

function Install-SkillPackage {
    param(
        [string]$SourceRoot,
        [string]$DestinationRoot
    )

    if (-not (Test-Path $DestinationRoot)) {
        New-Item -ItemType Directory -Path $DestinationRoot | Out-Null
    }

    foreach ($entry in $requiredEntries) {
        $target = Join-Path $DestinationRoot $entry
        if (Test-Path $target) {
            Remove-Item -LiteralPath $target -Recurse -Force
        }
    }

    Copy-Item -LiteralPath (Join-Path $SourceRoot 'SKILL.md') -Destination (Join-Path $DestinationRoot 'SKILL.md') -Force
    Copy-Item -LiteralPath (Join-Path $SourceRoot 'agents') -Destination $DestinationRoot -Recurse -Force
    Copy-Item -LiteralPath (Join-Path $SourceRoot 'references') -Destination $DestinationRoot -Recurse -Force
}

Test-SkillPackage -RootPath $sourceSkillRoot

$skillsRootPath = Resolve-SkillsRoot -InputRoot $SkillsRoot
$installRoot = Join-Path $skillsRootPath 'project-control'

switch ($Action) {
    'Install' {
        if (-not (Test-Path $skillsRootPath)) {
            New-Item -ItemType Directory -Path $skillsRootPath -Force | Out-Null
        }

        Install-SkillPackage -SourceRoot $sourceSkillRoot -DestinationRoot $installRoot
        Test-SkillPackage -RootPath $installRoot

        Write-Output "project-control skill 설치 완료"
        Write-Output "Source      : $sourceSkillRoot"
        Write-Output "Destination : $installRoot"
    }
    'Update' {
        if (-not (Test-Path $skillsRootPath)) {
            New-Item -ItemType Directory -Path $skillsRootPath -Force | Out-Null
        }

        Install-SkillPackage -SourceRoot $sourceSkillRoot -DestinationRoot $installRoot
        Test-SkillPackage -RootPath $installRoot

        Write-Output "project-control skill 업데이트 완료"
        Write-Output "Source      : $sourceSkillRoot"
        Write-Output "Destination : $installRoot"
    }
    'Remove' {
        if (Test-Path $installRoot) {
            Remove-Item -LiteralPath $installRoot -Recurse -Force
            Write-Output "project-control skill 제거 완료"
            Write-Output "Removed     : $installRoot"
        }
        else {
            Write-Output "제거 대상이 없습니다: $installRoot"
        }
    }
    'Verify' {
        Test-SkillPackage -RootPath $installRoot
        Write-Output "project-control skill 검증 완료"
        Write-Output "Verified    : $installRoot"
    }
}

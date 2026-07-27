param(
    [ValidateSet('Install', 'Update', 'Remove', 'Verify')]
    [string]$Action = 'Install',

    [string]$SkillsRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
$projectControlRoot = Split-Path -Parent $scriptDir
$workspaceRoot = Split-Path -Parent $projectControlRoot
$sourceSkillRoot = Join-Path $projectControlRoot 'project-control'

# Claude Code skills do not use the Codex "agents" interface metadata folder.
$requiredEntries = @(
    'SKILL.md',
    'references'
)
$requiredFiles = @(
    'SKILL.md',
    'references\command-spec.md',
    'references\workflow-map.md',
    'references\state-update-rules.md'
)

function Resolve-SkillsRoot {
    param([string]$InputRoot)

    if ($InputRoot) {
        return $InputRoot
    }

    return (Join-Path $workspaceRoot '.claude\skills')
}

function Test-SkillPackage {
    param([string]$RootPath)

    foreach ($entry in $requiredFiles) {
        $path = Join-Path $RootPath $entry
        if (-not (Test-Path $path)) {
            throw "Required file is missing: $path"
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

        Write-Output "project-control skill (Claude Code) install completed"
        Write-Output "Source      : $sourceSkillRoot"
        Write-Output "Destination : $installRoot"
    }
    'Update' {
        if (-not (Test-Path $skillsRootPath)) {
            New-Item -ItemType Directory -Path $skillsRootPath -Force | Out-Null
        }

        Install-SkillPackage -SourceRoot $sourceSkillRoot -DestinationRoot $installRoot
        Test-SkillPackage -RootPath $installRoot

        Write-Output "project-control skill (Claude Code) update completed"
        Write-Output "Source      : $sourceSkillRoot"
        Write-Output "Destination : $installRoot"
    }
    'Remove' {
        if (Test-Path $installRoot) {
            Remove-Item -LiteralPath $installRoot -Recurse -Force
            Write-Output "project-control skill (Claude Code) removal completed"
            Write-Output "Removed     : $installRoot"
        }
        else {
            Write-Output "Nothing to remove: $installRoot"
        }
    }
    'Verify' {
        Test-SkillPackage -RootPath $installRoot
        Write-Output "project-control skill (Claude Code) verification completed"
        Write-Output "Verified    : $installRoot"
    }
}

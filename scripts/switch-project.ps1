param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName
)

$registry = @(
    @{
        Key = 'defect_manage'
        Aliases = @('defect manage', 'defect manager', 'defect_manage', 'defect')
        Path = 'D:\Workspace\defect_manage'
        StateFile = 'D:\Workspace\project_control\states\defect_manage_current.md'
        Run = 'npm.cmd start'
        Verify = 'npm.cmd run check:syntax / npm.cmd run test:unit'
        Port = '3000'
        Docs = @('README.md', 'docs\README_ko.md', 'docs\CHANGELOG.md')
    },
    @{
        Key = 'n8n_defect_automation'
        Aliases = @('n8n', 'n8n defect', 'n8n automation', 'n8n-defect-automation')
        Path = 'D:\Workspace\n8n-defect-automation'
        StateFile = 'D:\Workspace\project_control\states\n8n_defect_automation_current.md'
        Run = 'n8n workflow import / activate'
        Verify = 'review docs and workflow json'
        Port = '-'
        Docs = @('docs\n8n_project_manual.md', 'docs\n8n_setup_guide.md', 'workflow\defect_report_workflow.json')
    },
    @{
        Key = 'auth_pro'
        Aliases = @('auth', 'auth pro', 'auth_pro')
        Path = 'D:\Workspace\auth_pro'
        StateFile = 'D:\Workspace\project_control\states\auth_pro_current.md'
        Run = 'open index.html or static server'
        Verify = 'review index.html / js/app.js / css/style.css'
        Port = '-'
        Docs = @('index.html', 'js\app.js', 'css\style.css')
    }
)

function Normalize-Name {
    param([string]$Name)
    return ($Name.ToLower().Trim() -replace '[_-]+', ' ' -replace '\s+', ' ')
}

$normalized = Normalize-Name -Name $ProjectName
$entry = $registry | Where-Object {
    $_.Key -eq $normalized -or ($_.Aliases | ForEach-Object { Normalize-Name -Name $_ }) -contains $normalized
} | Select-Object -First 1

if (-not $entry) {
    Write-Output "Project not found: $ProjectName"
    Write-Output "Available projects:"
    $registry | ForEach-Object {
        Write-Output ("- " + $_.Key + " => " + ($_.Aliases -join ', '))
    }
    exit 1
}

Write-Output ("Project Key : " + $entry.Key)
Write-Output ("Path        : " + $entry.Path)
Write-Output ("State File  : " + $entry.StateFile)
Write-Output ("Run         : " + $entry.Run)
Write-Output ("Verify      : " + $entry.Verify)
Write-Output ("Port        : " + $entry.Port)
Write-Output "Key Docs    :"
$entry.Docs | ForEach-Object { Write-Output ("  - " + $_) }

if (Test-Path $entry.StateFile) {
    Write-Output ""
    Write-Output "State Summary:"
    Get-Content $entry.StateFile | Select-Object -First 20
}

if (Test-Path (Join-Path $entry.Path '.git')) {
    Write-Output ""
    Write-Output "Git Status:"
    git -C $entry.Path status --short
}

if ($entry.Port -ne '-' -and $entry.Port) {
    Write-Output ""
    Write-Output ("Port Check (" + $entry.Port + "):")
    netstat -ano | findstr (":" + $entry.Port)
}

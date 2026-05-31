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
    },
    @{
        Key = 'makeyourtoday'
        Aliases = @('makeyourtoday', 'make your today', 'make-your-today')
        Path = 'D:\Workspace\makeyourtoday'
        StateFile = 'D:\Workspace\project_control\states\makeyourtoday_current.md'
        Run = 'N/A'
        Verify = 'review planning docs'
        Port = '-'
        Docs = @('범용_멀티에이전트_운영체계.md', 'MBDP_요구사항정의서_v1.0.md', 'pm_도구_ai_에이전트_전체_설계서_mvp_포함.md')
    },
    @{
        Key = 'trinity_room'
        Aliases = @('trinity_room', 'trinity room', 'trinity meeting room', 'trinity soul shell')
        Path = 'D:\Workspace\trinity_room'
        StateFile = 'D:\Workspace\project_control\states\trinity_room_current.md'
        Run = 'npm.cmd run preview:web'
        Verify = 'npm.cmd run build / npm.cmd run check:types'
        Port = '4317'
        Docs = @('trinity_meeting_room_plan.md', 'room_protocol.md', 'trinity_soul_shell_architecture.md', 'trinity_room_work_plan_checklist.md')
    },
    @{
        Key = 'ui_code_helper'
        Aliases = @('ui_code_helper', 'ui code helper', 'ui-code-helper', 'ui markdown capture')
        Path = 'D:\Workspace\ui_code_helper'
        StateFile = 'D:\Workspace\project_control\states\ui_code_helper_current.md'
        Run = 'load unpacked extension in Chrome'
        Verify = 'npm.cmd run check:syntax'
        Port = '-'
        Docs = @('README.md', 'docs\mvp_spec.md', 'docs\사용자_매뉴얼.md', 'docs\다중선택_UX_설계안.md', 'manifest.json')
    },
    @{
        Key = 'unit_test'
        Aliases = @('unit_test', 'unit test', 'unit-test')
        Path = 'D:\Workspace\unit_test'
        StateFile = 'D:\Workspace\project_control\states\unit_test_current.md'
        Run = 'N/A'
        Verify = 'review README.md / docs / SKILL.md'
        Port = '-'
        Docs = @('README.md', 'docs\unit_test_workflow.md', 'docs\unit_test_rules.md', 'docs\common_checklist_master.md', 'SKILL.md')
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

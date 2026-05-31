param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectAlias,

    [string]$To = $env:PROJECT_CONTROL_MAIL_TO,

    [string]$Cc = $env:PROJECT_CONTROL_MAIL_CC,

    [string]$From = $(if ($env:PROJECT_CONTROL_MAIL_FROM) { $env:PROJECT_CONTROL_MAIL_FROM } else { $env:PROJECT_CONTROL_SMTP_USER }),

    [string]$SmtpHost = $env:PROJECT_CONTROL_SMTP_HOST,

    [int]$SmtpPort = $(if ($env:PROJECT_CONTROL_SMTP_PORT) { [int]$env:PROJECT_CONTROL_SMTP_PORT } else { 587 }),

    [string]$SmtpUser = $env:PROJECT_CONTROL_SMTP_USER,

    [string]$SmtpPassword = $env:PROJECT_CONTROL_SMTP_PASSWORD,

    [bool]$UseSsl = $(if ($env:PROJECT_CONTROL_SMTP_USE_SSL) { [System.Convert]::ToBoolean($env:PROJECT_CONTROL_SMTP_USE_SSL) } else { $true }),

    [int]$RecentCommitCount = 5,

    [string]$SubjectPrefix = '[Project Control]',

    [string]$ExtraNote,

    [string]$OutputPath,

    [switch]$PreviewOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectControlRoot = Split-Path -Parent $PSScriptRoot
$registryPath = Join-Path $projectControlRoot 'project_registry.md'

function Normalize-Name {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ''
    }

    return (($Value.ToLowerInvariant().Trim()) -replace '[`"]', '' -replace '[_-]+', ' ' -replace '\s+', ' ')
}

function Split-Recipients {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return @()
    }

    return ($Value -split '[,;]') |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }
}

function ConvertTo-HtmlSafe {
    param([string]$Value)

    if ($null -eq $Value) {
        return ''
    }

    return [System.Net.WebUtility]::HtmlEncode($Value)
}

function Convert-MarkdownListToArray {
    param([string[]]$Lines)

    $items = @()
    foreach ($line in $Lines) {
        $trimmed = $line.Trim()
        if (-not $trimmed) {
            continue
        }

        if ($trimmed.StartsWith('- ')) {
            $items += $trimmed.Substring(2).Trim()
            continue
        }

        if ($trimmed.StartsWith('* ')) {
            $items += $trimmed.Substring(2).Trim()
            continue
        }

        $items += $trimmed
    }

    return $items
}

function Parse-StateFile {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "State file not found: $Path"
    }

    $lines = Get-Content -Path $Path
    $sections = @{}
    $currentSection = ''

    foreach ($line in $lines) {
        if ($line -match '^##\s+(.+)$') {
            $currentSection = $Matches[1].Trim()
            if (-not $sections.ContainsKey($currentSection)) {
                $sections[$currentSection] = New-Object System.Collections.Generic.List[string]
            }
            continue
        }

        if ($currentSection) {
            $sections[$currentSection].Add($line)
        }
    }

    return @{
        RawLines = $lines
        Sections = $sections
    }
}

function Parse-Registry {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Registry file not found: $Path"
    }

    $entries = @()
    foreach ($line in Get-Content -Path $Path) {
        if ($line -notmatch '^\|') {
            continue
        }

        if ($line -match '^\|\s*-+\s*\|') {
            continue
        }

        $parts = $line.Split('|')
        if ($parts.Count -lt 10) {
            continue
        }

        $projectKey = ($parts[1].Trim() -replace '`', '')
        if (-not $projectKey -or $projectKey -eq 'project_key') {
            continue
        }

        $aliases = ($parts[2].Trim() -replace '`', '') -split ',' |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ }

        $stateFileValue = ($parts[6].Trim() -replace '`', '')
        $stateFilePath = if ($stateFileValue -match '^[A-Za-z]:\\') {
            $stateFileValue
        } else {
            Join-Path $projectControlRoot $stateFileValue
        }

        $entries += @{
            ProjectKey = $projectKey
            Aliases = $aliases
            Path = ($parts[3].Trim() -replace '`', '')
            Type = ($parts[4].Trim() -replace '`', '')
            RunVerify = ($parts[5].Trim() -replace '`', '')
            StateFile = $stateFilePath
            KeyDocs = ($parts[7].Trim() -replace '`', '')
            Deploy = ($parts[8].Trim() -replace '`', '')
        }
    }

    return $entries
}

function Resolve-Project {
    param(
        [string]$Alias,
        [object[]]$RegistryEntries
    )

    $normalizedAlias = Normalize-Name -Value $Alias

    foreach ($entry in $RegistryEntries) {
        $candidateNames = @($entry.ProjectKey) + $entry.Aliases
        foreach ($candidate in $candidateNames) {
            if ((Normalize-Name -Value $candidate) -eq $normalizedAlias) {
                return $entry
            }
        }
    }

    return $null
}

function Get-GitSummary {
    param(
        [string]$ProjectPath,
        [int]$CommitCount
    )

    if (-not $ProjectPath -or $ProjectPath -eq 'TBD') {
        return @{
            Branch = ''
            RecentCommits = @()
            StatusLines = @()
        }
    }

    $gitPath = Join-Path $ProjectPath '.git'
    if (-not (Test-Path $gitPath)) {
        return @{
            Branch = ''
            RecentCommits = @()
            StatusLines = @()
        }
    }

    $branchLine = git -C $ProjectPath status --short --branch 2>$null | Select-Object -First 1
    $branch = if ($branchLine) { $branchLine.Trim() } else { '' }

    $statusLines = git -C $ProjectPath status --short 2>$null
    $recentCommits = git -C $ProjectPath log -n $CommitCount --pretty=format:'%h | %ad | %s' --date=short 2>$null

    return @{
        Branch = $branch
        RecentCommits = @($recentCommits)
        StatusLines = @($statusLines)
    }
}

function Build-ListHtml {
    param([string[]]$Items)

    if (-not $Items -or $Items.Count -eq 0) {
        return '<p style="margin:0;color:#6b7280;">없음</p>'
    }

    $htmlItems = foreach ($item in $Items) {
        '<li style="margin:0 0 8px 0;">' + (ConvertTo-HtmlSafe -Value $item) + '</li>'
    }

    return '<ul style="margin:12px 0 0 18px;padding:0;">' + ($htmlItems -join '') + '</ul>'
}

function Build-MailBody {
    param(
        [object]$Project,
        [hashtable]$State,
        [hashtable]$GitSummary,
        [string]$MachineName,
        [string]$SentAt,
        [string]$ExtraNoteValue
    )

    $sections = $State.Sections
    $goalItems = Convert-MarkdownListToArray -Lines $sections['현재 목표']
    $completedItems = Convert-MarkdownListToArray -Lines $sections['최근 완료 작업']
    $nextItems = Convert-MarkdownListToArray -Lines $sections['다음 작업']
    $riskItems = Convert-MarkdownListToArray -Lines $sections['리스크 / 주의사항']
    $executionItems = Convert-MarkdownListToArray -Lines $sections['실행 / 검증']
    $basicInfoItems = Convert-MarkdownListToArray -Lines $sections['기본 정보']

    $gitItems = @()
    if ($GitSummary.Branch) {
        $gitItems += "branch: $($GitSummary.Branch)"
    }
    $gitItems += $GitSummary.RecentCommits
    if ($GitSummary.StatusLines.Count -gt 0) {
        $gitItems += 'working tree changes:'
        $gitItems += $GitSummary.StatusLines
    }

    $extraNoteHtml = if ([string]::IsNullOrWhiteSpace($ExtraNoteValue)) {
        ''
    } else {
        @"
<section style="margin-top:24px;">
  <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">추가 메모</h2>
  <div style="padding:14px 16px;border-radius:12px;background:#fff7ed;border:1px solid #fdba74;color:#7c2d12;line-height:1.7;">
    $(ConvertTo-HtmlSafe -Value $ExtraNoteValue)
  </div>
</section>
"@
    }

    return @"
<html>
<body style="margin:0;padding:24px;background:#f3f4f6;font-family:'Segoe UI',sans-serif;color:#111827;">
  <div style="max-width:860px;margin:0 auto;background:#ffffff;border:1px solid #e5e7eb;border-radius:18px;overflow:hidden;">
    <div style="padding:24px 28px;background:linear-gradient(135deg,#111827,#1f2937);color:#f9fafb;">
      <div style="font-size:12px;letter-spacing:1px;text-transform:uppercase;color:#f59e0b;">Project Control Work Summary</div>
      <h1 style="margin:10px 0 6px 0;font-size:28px;">$((ConvertTo-HtmlSafe -Value $Project.ProjectKey)) 진행 작업 메일</h1>
      <p style="margin:0;color:#d1d5db;line-height:1.7;">보낸 PC: $((ConvertTo-HtmlSafe -Value $MachineName)) | 생성 시각: $((ConvertTo-HtmlSafe -Value $SentAt))</p>
    </div>
    <div style="padding:24px 28px;">
      <section>
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">프로젝트 기본 정보</h2>
        $(Build-ListHtml -Items (@("project_key: $($Project.ProjectKey)", "path: $($Project.Path)", "state_file: $($Project.StateFile)", "deploy: $($Project.Deploy)") + $basicInfoItems))
      </section>

      <section style="margin-top:24px;">
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">현재 목표</h2>
        $(Build-ListHtml -Items $goalItems)
      </section>

      <section style="margin-top:24px;">
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">최근 완료 작업</h2>
        $(Build-ListHtml -Items $completedItems)
      </section>

      <section style="margin-top:24px;">
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">다음 작업</h2>
        $(Build-ListHtml -Items $nextItems)
      </section>

      <section style="margin-top:24px;">
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">실행 / 검증</h2>
        $(Build-ListHtml -Items $executionItems)
      </section>

      <section style="margin-top:24px;">
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">리스크 / 주의사항</h2>
        $(Build-ListHtml -Items $riskItems)
      </section>

      <section style="margin-top:24px;">
        <h2 style="margin:0 0 10px 0;font-size:16px;color:#111827;">Git 요약</h2>
        $(Build-ListHtml -Items $gitItems)
      </section>

      $extraNoteHtml
    </div>
  </div>
</body>
</html>
"@
}

function Build-PlainTextBody {
    param(
        [object]$Project,
        [hashtable]$State,
        [hashtable]$GitSummary,
        [string]$MachineName,
        [string]$SentAt,
        [string]$ExtraNoteValue
    )

    $sections = $State.Sections
    $goalItems = Convert-MarkdownListToArray -Lines $sections['현재 목표']
    $completedItems = Convert-MarkdownListToArray -Lines $sections['최근 완료 작업']
    $nextItems = Convert-MarkdownListToArray -Lines $sections['다음 작업']
    $riskItems = Convert-MarkdownListToArray -Lines $sections['리스크 / 주의사항']
    $executionItems = Convert-MarkdownListToArray -Lines $sections['실행 / 검증']
    $basicInfoItems = Convert-MarkdownListToArray -Lines $sections['기본 정보']

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("Project Control Work Summary")
    $lines.Add("project: $($Project.ProjectKey)")
    $lines.Add("sent from: $MachineName")
    $lines.Add("sent at: $SentAt")
    $lines.Add("")
    $lines.Add("[프로젝트 기본 정보]")
    $lines.Add("- path: $($Project.Path)")
    $lines.Add("- state_file: $($Project.StateFile)")
    $lines.Add("- deploy: $($Project.Deploy)")
    foreach ($item in $basicInfoItems) { $lines.Add("- $item") }
    $lines.Add("")
    $lines.Add("[현재 목표]")
    foreach ($item in $goalItems) { $lines.Add("- $item") }
    $lines.Add("")
    $lines.Add("[최근 완료 작업]")
    foreach ($item in $completedItems) { $lines.Add("- $item") }
    $lines.Add("")
    $lines.Add("[다음 작업]")
    foreach ($item in $nextItems) { $lines.Add("- $item") }
    $lines.Add("")
    $lines.Add("[실행 / 검증]")
    foreach ($item in $executionItems) { $lines.Add("- $item") }
    $lines.Add("")
    $lines.Add("[리스크 / 주의사항]")
    foreach ($item in $riskItems) { $lines.Add("- $item") }
    $lines.Add("")
    $lines.Add("[Git 요약]")
    if ($GitSummary.Branch) { $lines.Add("- branch: $($GitSummary.Branch)") }
    foreach ($item in $GitSummary.RecentCommits) { $lines.Add("- $item") }
    if ($GitSummary.StatusLines.Count -gt 0) {
        $lines.Add("- working tree changes:")
        foreach ($item in $GitSummary.StatusLines) { $lines.Add("  $item") }
    }

    if (-not [string]::IsNullOrWhiteSpace($ExtraNoteValue)) {
        $lines.Add("")
        $lines.Add("[추가 메모]")
        $lines.Add($ExtraNoteValue)
    }

    return ($lines -join [Environment]::NewLine)
}

$registryEntries = Parse-Registry -Path $registryPath
$project = Resolve-Project -Alias $ProjectAlias -RegistryEntries $registryEntries

if (-not $project) {
    $available = $registryEntries | ForEach-Object { $_.ProjectKey } | Sort-Object
    throw "Project alias not found: $ProjectAlias`nAvailable projects: $($available -join ', ')"
}

$state = Parse-StateFile -Path $project.StateFile
$gitSummary = Get-GitSummary -ProjectPath $project.Path -CommitCount $RecentCommitCount
$machineName = $env:COMPUTERNAME
$sentAt = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz')
$subject = "$SubjectPrefix $($project.ProjectKey) work summary - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$htmlBody = Build-MailBody -Project $project -State $state -GitSummary $gitSummary -MachineName $machineName -SentAt $sentAt -ExtraNoteValue $ExtraNote
$plainTextBody = Build-PlainTextBody -Project $project -State $state -GitSummary $gitSummary -MachineName $machineName -SentAt $sentAt -ExtraNoteValue $ExtraNote

if ($OutputPath) {
    $resolvedOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    Set-Content -Path $resolvedOutputPath -Value $htmlBody -Encoding UTF8
}

Write-Output "Project Key : $($project.ProjectKey)"
Write-Output "State File  : $($project.StateFile)"
Write-Output "Subject     : $subject"
if ($OutputPath) {
    Write-Output "Preview HTML: $resolvedOutputPath"
}

if ($PreviewOnly) {
    Write-Output ''
    Write-Output 'Preview Mode: no mail sent.'
    Write-Output ''
    Write-Output $plainTextBody
    exit 0
}

$toRecipients = Split-Recipients -Value $To
$ccRecipients = Split-Recipients -Value $Cc
$missing = @()

if ($toRecipients.Count -eq 0) { $missing += 'PROJECT_CONTROL_MAIL_TO or -To' }
if (-not $From) { $missing += 'PROJECT_CONTROL_MAIL_FROM or -From' }
if (-not $SmtpHost) { $missing += 'PROJECT_CONTROL_SMTP_HOST or -SmtpHost' }
if (-not $SmtpUser) { $missing += 'PROJECT_CONTROL_SMTP_USER or -SmtpUser' }
if (-not $SmtpPassword) { $missing += 'PROJECT_CONTROL_SMTP_PASSWORD or -SmtpPassword' }

if ($missing.Count -gt 0) {
    throw "Missing mail settings: $($missing -join ', ')"
}

$message = New-Object System.Net.Mail.MailMessage
$message.From = $From
foreach ($recipient in $toRecipients) { [void]$message.To.Add($recipient) }
foreach ($recipient in $ccRecipients) { [void]$message.CC.Add($recipient) }
$message.Subject = $subject
$message.Body = $htmlBody
$message.IsBodyHtml = $true

$smtpClient = New-Object System.Net.Mail.SmtpClient($SmtpHost, $SmtpPort)
$smtpClient.EnableSsl = $UseSsl
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($SmtpUser, $SmtpPassword)

try {
    $smtpClient.Send($message)
    Write-Output "Mail sent successfully."
} finally {
    $message.Dispose()
    $smtpClient.Dispose()
}

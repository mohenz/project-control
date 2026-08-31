[CmdletBinding()]
param(
    [ValidateSet('Capture', 'Restore', 'Verify')]
    [string]$Mode = 'Verify',
    [Parameter(Mandatory)]
    [string]$BackupRoot,
    [string]$WorkspaceSource = 'D:\Workspace',
    [string]$WorkspaceDestination = 'D:\Workspace',
    [switch]$CopyWorkspace,
    [switch]$IncludeDatabases
)

$ErrorActionPreference = 'Continue'
$toolkitDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$reportPath = Join-Path $BackupRoot ("{0}-report.txt" -f $Mode.ToLowerInvariant())

function Write-Result {
    param([string]$Level, [string]$Message)
    $line = "[{0}] {1} {2}" -f $Level, (Get-Date -Format 's'), $Message
    Write-Host $line
    Add-Content -LiteralPath $reportPath -Value $line -Encoding UTF8
}

function Invoke-Logged {
    param([string]$Name, [scriptblock]$Action)
    try {
        & $Action
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { throw "종료 코드 $LASTEXITCODE" }
        Write-Result 'OK' $Name
    } catch {
        Write-Result 'FAIL' ("{0}: {1}" -f $Name, $_.Exception.Message)
    }
}

function Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Copy-TreeSafe {
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path -LiteralPath $Source)) { throw "원본 경로 없음: $Source" }
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    & robocopy.exe $Source $Destination /E /COPY:DAT /DCOPY:DAT /R:2 /W:2 /XJ /FFT /NP
    if ($LASTEXITCODE -ge 8) { throw "robocopy 종료 코드 $LASTEXITCODE" }
    $global:LASTEXITCODE = 0
}

function Capture-Environment {
    New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
    Set-Content -LiteralPath $reportPath -Value "Windows 재설치 수집 보고서" -Encoding UTF8
    $inventory = Join-Path $BackupRoot 'inventory'
    New-Item -ItemType Directory -Force -Path $inventory | Out-Null

    Invoke-Logged '복구 도구 자체 복사' {
        Copy-TreeSafe $toolkitDir (Join-Path $BackupRoot 'toolkit')
    }
    Invoke-Logged 'winget 전체 패키지 목록 내보내기' {
        winget export --output (Join-Path $inventory 'winget-export.json') --include-versions --accept-source-agreements
    }
    Invoke-Logged 'winget 표시 목록 저장' {
        winget list --accept-source-agreements | Out-File (Join-Path $inventory 'winget-list.txt') -Encoding utf8
    }
    Invoke-Logged 'VS Code 확장 저장' {
        code --list-extensions --show-versions | Out-File (Join-Path $inventory 'vscode-extensions.txt') -Encoding ascii
    }
    Invoke-Logged '전역 npm 패키지 저장' {
        npm.cmd list -g --depth=0 --json | Out-File (Join-Path $inventory 'npm-global.json') -Encoding utf8
    }
    Invoke-Logged 'Git 설정 키 목록 저장(값 제외)' {
        git config --global --name-only --list | Sort-Object -Unique | Out-File (Join-Path $inventory 'git-config-keys.txt') -Encoding utf8
    }
    Invoke-Logged '도구 버전 저장' {
        $commands = 'git','gh','node','npm.cmd','pnpm.cmd','python','py','uv','psql','code','codex.cmd'
        $versionLines = foreach ($command in $commands) {
            $resolved = Get-Command $command -ErrorAction SilentlyContinue
            if ($resolved) { "${command}: $(& $command --version 2>&1 | Select-Object -First 1)" }
            else { "${command}: MISSING" }
        }
        $versionLines | Out-File (Join-Path $inventory 'tool-versions.txt') -Encoding utf8
    }
    Invoke-Logged '환경 변수 이름 저장(값 제외)' {
        Get-ChildItem Env: | Select-Object -ExpandProperty Name | Sort-Object | Out-File (Join-Path $inventory 'environment-variable-names.txt') -Encoding utf8
    }
    if ($CopyWorkspace) {
        Invoke-Logged '작업공간 백업' {
            Copy-TreeSafe $WorkspaceSource (Join-Path $BackupRoot 'Workspace')
        }
    } else {
        Invoke-Logged 'D 드라이브 작업공간 상태 기록' {
            "workspace_path=$WorkspaceSource" | Out-File (Join-Path $inventory 'workspace-location.txt') -Encoding utf8
            git -C $WorkspaceSource status --short --branch | Out-File (Join-Path $inventory 'workspace-git-status.txt') -Encoding utf8
        }
        Write-Result 'WARN' 'D 드라이브 유지 전제에 따라 작업공간 파일 복사를 생략했습니다. 별도 물리 백업이 필요하면 -CopyWorkspace를 사용하십시오.'
    }

    if ($IncludeDatabases) {
        if (-not (Test-Command 'pg_dumpall')) {
            Write-Result 'FAIL' 'DB 수집: pg_dumpall을 찾을 수 없습니다.'
        } else {
            $dbDir = Join-Path $BackupRoot 'postgres-dumps'
            New-Item -ItemType Directory -Force -Path $dbDir | Out-Null
            foreach ($port in 5432,54323,54324,54325) {
                Invoke-Logged "PostgreSQL 포트 $port 덤프" {
                    pg_dumpall --host=127.0.0.1 --port=$port --username=postgres --file=(Join-Path $dbDir "postgres-$port.sql")
                }
            }
        }
    } else {
        Write-Result 'WARN' 'DB 수집을 생략했습니다. 필요한 경우 -IncludeDatabases로 다시 실행하십시오.'
    }

    Write-Result 'WARN' 'SSH 개인키, .env, 토큰, 브라우저 쿠키는 자동 수집하지 않았습니다.'
    Write-Result 'OK' "수집 완료: $BackupRoot"
}

function Restore-Environment {
    New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
    Set-Content -LiteralPath $reportPath -Value "Windows 재설치 복원 보고서" -Encoding UTF8
    if (-not (Test-Command 'winget')) { throw 'winget이 없습니다. Microsoft Store에서 App Installer를 설치하십시오.' }

    $packageManifest = Join-Path $toolkitDir 'packages.curated.json'
    Invoke-Logged '핵심 winget 패키지 설치' {
        winget import --import-file $packageManifest --ignore-unavailable --accept-package-agreements --accept-source-agreements --disable-interactivity
    }
    $extensionFile = Join-Path $BackupRoot 'inventory\vscode-extensions.txt'
    if (Test-Path -LiteralPath $extensionFile) {
        Invoke-Logged 'VS Code 확장 설치' {
            foreach ($entry in Get-Content -LiteralPath $extensionFile) {
                $id = ($entry -split '@')[0]
                if ($id) { code --install-extension $id --force }
            }
        }
    }
    Invoke-Logged '핵심 전역 npm 도구 설치' {
        npm.cmd install --global pnpm@10 @openai/codex @anthropic-ai/claude-code @google/gemini-cli @executeautomation/playwright-mcp-server
    }
    $workspaceBackup = Join-Path $BackupRoot 'Workspace'
    if (Test-Path -LiteralPath $workspaceBackup) {
        Invoke-Logged '작업공간 복원(기존 파일 비삭제)' {
            Copy-TreeSafe $workspaceBackup $WorkspaceDestination
        }
    } else {
        Write-Result 'WARN' "작업공간 백업 없음: $workspaceBackup"
    }
    Write-Result 'WARN' 'DB SQL은 자동 복원하지 않았습니다. README의 절차에 따라 DB/역할을 확인 후 복원하십시오.'
    Write-Result 'WARN' 'GitHub·클라우드·AI CLI·동기화 앱에 다시 로그인하십시오.'
}

function Verify-Environment {
    New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
    Set-Content -LiteralPath $reportPath -Value "Windows 재설치 검증 보고서" -Encoding UTF8
    foreach ($command in 'winget','git','gh','node','npm.cmd','pnpm.cmd','python','py','uv','psql','code','codex.cmd') {
        if (Test-Command $command) { Write-Result 'OK' "명령 사용 가능: $command" }
        else { Write-Result 'FAIL' "명령 없음: $command" }
    }
    if (Test-Path -LiteralPath $WorkspaceDestination) {
        $count = @(Get-ChildItem -LiteralPath $WorkspaceDestination -Force -ErrorAction SilentlyContinue).Count
        Write-Result 'OK' "작업공간 확인: $WorkspaceDestination (최상위 항목 $count개)"
    } else { Write-Result 'FAIL' "작업공간 없음: $WorkspaceDestination" }
    foreach ($port in 5432,54323,54324,54325) {
        $listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
        if ($listener) { Write-Result 'OK' "DB 포트 리스닝: $port" }
        else { Write-Result 'WARN' "DB 포트 미사용: $port" }
    }
    Write-Result 'WARN' '각 프로젝트의 .env, DB 연결, 빌드/테스트는 프로젝트별로 추가 검증해야 합니다.'
}

switch ($Mode) {
    'Capture' { Capture-Environment }
    'Restore' { Restore-Environment }
    'Verify' { Verify-Environment }
}

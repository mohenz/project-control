param(
    [string]$ProjectKey
)

$registryPath = Join-Path $PSScriptRoot '..\project_docs\development_systems.csv'
$systems = Import-Csv -LiteralPath $registryPath

if ($ProjectKey) {
    $systems = @($systems | Where-Object { $_.project_key -eq $ProjectKey })
    if ($systems.Count -eq 0) {
        Write-Error "등록되지 않은 project_key: $ProjectKey"
        exit 1
    }
}

$result = foreach ($system in $systems) {
    $listener = if ($system.port) {
        Get-NetTCPConnection -LocalPort ([int]$system.port) -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
    }

    [PSCustomObject]@{
        Project = $system.project_key
        Service = $system.service
        Endpoint = if ($system.url) { $system.url } elseif ($system.port) { "$($system.host):$($system.port)" } else { $system.protocol }
        Policy = $system.policy
        Runtime = if ($listener) { "LISTENING" } elseif ($system.port) { "STOPPED" } else { "N/A" }
        PID = if ($listener) { $listener.OwningProcess } else { $null }
    }
}

$result | Format-Table -AutoSize

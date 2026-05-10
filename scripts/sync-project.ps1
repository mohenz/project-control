param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory = $false)]
    [switch]$In,
    
    [Parameter(Mandatory = $false)]
    [switch]$Out
)

# This is a simplified registry lookup for the script
# In a real scenario, this would read project_registry.md
$projectPath = "d:\Bloom" # Default for soyeon_soul for now

if ($ProjectName -match "soyeon|soul|bloom soul") {
    $syncScript = Join-Path $projectPath "system\soul_sync_gcs.py"
    $python = "python" # Or path to venv python if fixed
    
    if ($In) {
        Write-Output "[*] Synchronizing IN for $ProjectName..."
        & $python $syncScript in
    } elseif ($Out) {
        Write-Output "[*] Synchronizing OUT for $ProjectName..."
        & $python $syncScript out
    } else {
        Write-Output "[!] Please specify --In or --Out"
    }
} else {
    Write-Output "[!] Sync not implemented for project: $ProjectName"
}

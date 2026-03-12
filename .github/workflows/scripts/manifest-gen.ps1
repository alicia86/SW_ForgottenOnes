# .github/workflows/scripts/manifest-gen.ps1
param (
    [switch]$ForceUpdate = $false
)

$jsonDir = "Chapter_Logs/JSON"
$manifestPath = "Chapter_Logs/log-manifest.json"

# 1. Load existing manifest if it exists
$existingManifest = @()
if (Test-Path $manifestPath) {
    $existingManifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
}

$files = Get-ChildItem "$jsonDir/*.json"
$newManifest = @()

foreach ($file in $files) {
    try {
        # Check if this file already exists in our manifest
        $existingEntry = $existingManifest | Where-Object { $_.file -eq $file.Name }
        
        $prettyName = ""
        $order = 0

        # 2. Logic: Keep existing title UNLESS ForceUpdate is active or entry is missing
        if ($existingEntry -and -not $ForceUpdate) {
            Write-Host "Keeping existing metadata for $($file.Name)"
            $prettyName = $existingEntry.title
            $order = $existingEntry.order
        } 
        else {
            Write-Host "Processing/Updating metadata for $($file.Name)..."
            $data = Get-Content $file.FullName -Raw | ConvertFrom-Json
            $messages = if ($data.PSObject.Properties.Name -contains 'messages') { $data.messages } else { $data }

            # Find Chapter/Prelude header
            $headerMsg = $messages | Where-Object { $_.content -match '^#+\s+.*(Chapter|Prelude)' } | Select-Object -First 1
            
            if ($headerMsg) {
                $prettyName = ($headerMsg.content -replace '^#+\s*', '' -replace '\n.*', '').ToUpper()
            } else {
                $prettyName = ($file.BaseName -replace '_', ' ' -replace '-', ' ').ToUpper()
            }

            # Extract order number from filename
            $order = if ($file.BaseName -match '(\d+)') { [int]$matches[1] } else { 0 }
        }

        $newManifest += @{
            file  = $file.Name
            title = $prettyName
            order = [int]$order
        }
    } catch {
        Write-Warning "Failed to process $($file.Name): $($_.Exception.Message)"
    }
}

# 3. Sort and Save
$newManifest | Sort-Object order -Descending | ConvertTo-Json | Out-File $manifestPath -Encoding UTF8
Write-Host "Manifest Update Complete."
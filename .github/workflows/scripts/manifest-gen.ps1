# .github/workflows/scripts/manifest-gen.ps1
param (
    [switch]$ForceUpdate = $false
)

$jsonDir = "Chapter_Logs/JSON"
$manifestPath = "assets/log-manifest.json"

# 1. Load existing manifest if it exists
$existingManifest = @()
if (Test-Path $manifestPath) {
    Write-Host "Loading existing manifest from $manifestPath"
    $existingManifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
}

$files = Get-ChildItem "$jsonDir/*.json"
$newManifest = @()

foreach ($file in $files) {
    try {
        # Check for existing entry to preserve manual overrides
        $existingEntry = $existingManifest | Where-Object { $_.file -eq $file.Name }
        
        # Determine if we need to open the JSON file
        # Scan if: Force is on, entry is new, or key metadata is missing
        $needsDeepScan = $ForceUpdate -or (-not $existingEntry) -or 
                         (-not $existingEntry.channelID) -or 
                         (-not $existingEntry.lastMessageTimestamp)

        if (-not $needsDeepScan) {
            Write-Host "Using cached metadata for $($file.Name)"
            $newManifest += $existingEntry
            continue
        }

        Write-Host "Deep Scanning $($file.Name)..."
        $rawData = Get-Content $file.FullName -Raw | ConvertFrom-Json
        $messages = if ($rawData.PSObject.Properties.Name -contains 'messages') { $rawData.messages } else { $rawData }
        
        # Sort messages by timestamp to ensure metadata accuracy
        $sortedMsgs = $messages | Sort-Object { [datetime]$_.timestamp }

        # --- EXTRACT TITLE ---
        # Prioritize existing title from manifest unless ForceUpdate is active
        $prettyName = ""
        if ($existingEntry.title -and -not $ForceUpdate) {
            $prettyName = $existingEntry.title
        } else {
            $headerMsg = $sortedMsgs | Where-Object { $_.content -match '^#+\s+.*(Chapter|Prelude)' } | Select-Object -First 1
            $prettyName = if ($headerMsg) { 
                ($headerMsg.content -replace '^#+\s*', '' -replace '\n.*', '').ToUpper() 
            } else { 
                ($file.BaseName -replace '_', ' ' -replace '-', ' ').ToUpper() 
            }
        }

        # --- EXTRACT CHANNEL ID ---
        # Find the most frequent parent_id (Main Channel)
        $grouping = $sortedMsgs | Where-Object { $_.thread -and $_.thread.parent_id } | Group-Object { $_.thread.parent_id } | Sort-Object Count -Descending
        $channelID = if ($grouping) { $grouping[0].Name } else { $sortedMsgs[0].channel_id }

        # --- EXTRACT METADATA ---
        $lastTimestamp = $sortedMsgs[-1].timestamp
        $userCount = ($sortedMsgs.author.id | Select-Object -Unique).Count
        
        # Preview: Find first non-header message, grab first 120 chars
        $firstText = $sortedMsgs | Where-Object { $_.content -notmatch '^#' -and $_.content -ne "" } | Select-Object -First 1
        $preview = ""
        if ($firstText) {
            $cleaned = $firstText.content -replace '\n', ' ' -replace '\|\|', '' # Remove newlines and spoilers
            $preview = if ($cleaned.Length -gt 120) { $cleaned.Substring(0, 120) + "..." } else { $cleaned }
        }

        # --- BUILD ENTRY ---
        $newManifest += @{
            file                 = $file.Name
            title                = $prettyName
            order                = if ($file.BaseName -match '(\d+)') { [int]$matches[1] } else { 0 }
            channelID            = [string]$channelID
            lastMessageTimestamp = $lastTimestamp
            participants         = [int]$userCount
            preview              = [string]$preview
        }
    } catch {
        Write-Warning "Failed to process $($file.Name): $($_.Exception.Message)"
    }
}

# 3. Sort by order descending (Newest Chapter first) and save
$newManifest | Sort-Object order -Descending | ConvertTo-Json -Depth 5 | Out-File $manifestPath -Encoding UTF8
Write-Host "Successfully updated manifest with $($newManifest.Count) entries."

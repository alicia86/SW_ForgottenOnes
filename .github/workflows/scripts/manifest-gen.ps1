# .github/workflows/scripts/manifest-gen.ps1
param (
    [switch]$ForceUpdate = $false
)

$jsonDir = "Chapter_Logs/JSON"
$manifestPath = "assets/log-manifest.json"

# 1. Load existing manifest
$existingManifest = @()
if (Test-Path $manifestPath) {
    Write-Host "Loading existing manifest..."
    $existingManifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
}

$files = Get-ChildItem "$jsonDir/*.json"
$newManifest = @()

foreach ($file in $files) {
    try {
        Write-Host "Analyzing $($file.Name)..."
        $rawData = Get-Content $file.FullName -Raw | ConvertFrom-Json
        $messages = if ($rawData.PSObject.Properties.Name -contains 'messages') { $rawData.messages } else { $rawData }
        $sortedMsgs = $messages | Sort-Object { [datetime]$_.timestamp }

        # --- Identify the unique Key (Channel ID) ---
        $grouping = $sortedMsgs | Where-Object { $_.thread -and $_.thread.parent_id } | Group-Object { $_.thread.parent_id } | Sort-Object Count -Descending
        $currentChannelID = if ($grouping) { $grouping[0].Name } else { $sortedMsgs[0].channel_id }

        # --- Find Existing Entry by Channel ID (Handle Renames) ---
        $existingEntry = $existingManifest | Where-Object { $_.channelID -eq $currentChannelID }

        # --- Dynamic Metadata (Always Overwrite) ---
        # 1. Post Count (Filter thread-starters and empty messages)
        $validMessages = $sortedMsgs | Where-Object { 
            -not ($_.thread -and $_.channel_id -eq $currentChannelID) -and $_.content -ne ""
        }
        $msgCount = $validMessages.Count
        # 2. Last Message Timestamp
        $lastTimestamp = $sortedMsgs[-1].timestamp

        # --- Static Metadata (Preserve if exists) ---
        $prettyName = ""
        $previewText = ""

        if ($existingEntry -and -not $ForceUpdate) {
            Write-Host "  -> Matching Channel ID found. Preserving Title and Preview."
            $prettyName = $existingEntry.title
            $previewText = $existingEntry.preview
        } else {
            # Extraction Logic for New or Forced entries
            Write-Host "  -> Generating new Title and Preview..."
            $headerMsg = $sortedMsgs | Where-Object { $_.content -match '^#+\s+.*(Chapter|Prelude)' } | Select-Object -First 1
            $prettyName = if ($headerMsg) { 
                ($headerMsg.content -replace '^#+\s*', '' -replace '\n.*', '').ToUpper() 
            } else { 
                ($file.BaseName -replace '_', ' ' -replace '-', ' ').ToUpper() 
            }

            $firstText = $validMessages | Where-Object { $_.content -notmatch '^#' } | Select-Object -First 1
            if ($firstText) {
                $cleaned = $firstText.content -replace '\n', ' ' -replace '\|\|', ''
                $previewText = if ($cleaned.Length -gt 120) { $cleaned.Substring(0, 120) + "..." } else { $cleaned }
            }
        }

        # --- Build/Update the Record ---
        $newManifest += @{
            file                 = $file.Name  # This will overwrite the old filename if it changed
            title                = $prettyName # Preserved
            order                = if ($file.BaseName -match '(\d+)') { [int]$matches[1] } else { 0 }
            channelID            = [string]$currentChannelID
            lastMessageTimestamp = $lastTimestamp # Overwritten
            messageCount         = [int]$msgCount     # Overwritten
            preview              = [string]$previewText # Preserved
        }
    } catch {
        Write-Warning "Failed to process $($file.Name): $($_.Exception.Message)"
    }
}

# 3. Sort by order descending and save
$newManifest | Sort-Object order -Descending | ConvertTo-Json -Depth 5 | Out-File $manifestPath -Encoding UTF8
Write-Host "Manifest Update Complete. $($newManifest.Count) frequencies synced."

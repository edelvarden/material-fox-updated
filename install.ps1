function Get-ProfileDirectory {

  $installationDirectory = ""
  $directories = (Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory  |
    Where-Object {
      if (Get-ChildItem $_.FullName -File -Name "*prefs.js") {
        return $true
      }
      else {
        return $false
      }
    } |
    Sort-Object Name)

  if ($directories.Count -gt 1) {
    for ($i = 0; $i -lt $directories.Count; $i++) {
      $directory = $directories[$i]

      Write-Host "$($i + 1). $($directory)"
    } 
  
    while (!($installationDirectory)) {
      $index = Read-Host "Select profile: "
      $directory = $directories[$index - 1]

      if ($directory) {
        Write-Host "You selected $directory."
        $installationDirectory = $directory
      }
      else {
        Write-Host "Invalid selection."
      }
    }
  }
  else {
    $installationDirectory = $directories[0]
  }

  if ($installationDirectory) {
    return "$env:APPDATA\Mozilla\Firefox\Profiles\$installationDirectory"
  }
  else {
    Write-Host "Can't get profile directory!"
    return
  }
}


function Update-FirefoxTheme {
  param(
    [string]$DownloadUrl,
    [string]$DestinationPath
  )

  try {
    $hash = [System.Guid]::NewGuid().ToString("N")
    $tempDir = $env:TEMP
    $zipPath = Join-Path $tempDir ("$AppName" + "_" + $hash + ".zip")

    # Create temp directory if it doesn't exist
    if (!(Test-Path $tempDir)) {
      New-Item -ItemType Directory -Path $tempDir | Out-Null
    }

    # Download the latest version of the portable app
    (New-Object System.Net.WebClient).DownloadFile($DownloadUrl, $zipPath)

    Expand-Archive -LiteralPath $zipPath -DestinationPath $DestinationPath -Force
  }
  catch {
    Write-Host "Can't install firefox theme!"
  }
  finally {
    Write-Host "Done. Clean up temp files..."
    Remove-Item $zipPath -Recurse -Force
  }
}


function Get-FileDownloadUrlFromGithubReales {
  param (
    [string]$RealesUrl,
    [string]$FileName
  )
  # Get download url from github realeses
  $source = (Invoke-RestMethod -Uri $RealesUrl -Method Get -ErrorAction Stop)

  return ($source[0].assets | Where-Object name -Match $FileName)[0].browser_download_url
}


function Invoke-Installation {
  param(
    [string]$ProfileDirectory = (Get-ProfileDirectory),
    [string]$DownloadUrl = (Get-FileDownloadUrlFromGithubReales -RealesUrl "https://api.github.com/repos/edelvarden/material-fox-updated/releases/latest" -FileName "chrome.zip")
  )
  $status = $false

  if (-not (Test-Path "$ProfileDirectory\chrome")) {
    $status = $true
  }
  else {
    $confirm = Read-Host "The chrome folder already exist. Do you want replace? (Y/N)"

    if ($confirm -eq "Y") {
      $status = $true
    }
  }

  if ($status) {
    Update-FirefoxTheme -DownloadUrl $DownloadUrl -DestinationPath $ProfileDirectory
  }
}

Invoke-Installation

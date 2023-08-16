function Get-ProfileDirectory {

  $profileName = ""
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
    Write-Host "Select a user profile:"
    Write-Host ""
    for ($i = 0; $i -lt $directories.Count; $i++) {
      $directory = $directories[$i]

      Write-Host "$($i + 1). $($directory)"
    } 
    Write-Host ""
  
    while (!($profileName)) {
      $index = Read-Host "Profile number: "
      $directory = $directories[$index - 1]

      if ($directory) {
        Write-Host "You selected $directory."
        $profileName = $directory
      }
      else {
        Write-Warning "Invalid profile number. Enter a number from the list."
      }
    }
  }
  else {
    $profileName = $directories[0]
  }

  if ($profileName) {
    return "$env:APPDATA\Mozilla\Firefox\Profiles\$profileName"
  }
  else {
    Write-Warning "Can't get profile directory!"
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
    Write-Warning "Can't install firefox theme!"
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
  $isUpdate = $false

  if (-not (Test-Path "$ProfileDirectory\chrome")) {
    $isUpdate = $true
  }
  else {
    Write-Warning "The chrome folder already exist."
    $confirm = Read-Host "Do you want replace? (Y/N)"

    if ($confirm -eq "Y") {
      $isUpdate = $true
    }
  }

  if ($isUpdate) {
    Update-FirefoxTheme -DownloadUrl $DownloadUrl -DestinationPath $ProfileDirectory
  }

  # Also install the user.js file
  $includeUserJS = $false

  if (-not (Test-Path "$ProfileDirectory\user.js")) {
    $includeUserJS = $true
  }
  else {
    Write-Warning "The user.js file already exist."
    $confirm = Read-Host "Do you want replace? (Y/N)"

    if ($confirm -eq "Y") {
      $includeUserJS = $true
    }
  }

  if ($includeUserJS) {
    $userJSDownloadUrl = (Get-FileDownloadUrlFromGithubReales -RealesUrl "https://api.github.com/repos/edelvarden/material-fox-updated/releases/latest" -FileName "user.js")
    (New-Object System.Net.WebClient).DownloadFile($userJSDownloadUrl, "$ProfileDirectory\user.js")
  }
}


Write-Host "----------------------------------------------------------------"
Write-Host "MaterialFox UPDATED"
Write-Host "----------------------------------------------------------------"
Invoke-Installation

function Get-FirefoxProfileDirectory {
    
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [string]$ProfileName = ""
  )

  # Get the list of Firefox profiles
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

  # If there are multiple profiles, prompt the user to select one
  if ($directories.Count -gt 1) {
    Write-Host "Select a Firefox profile:"
    Write-Host ""
    for ($i = 0; $i -lt $directories.Count; $i++) {
      $directory = $directories[$i]
      Write-Host "$($i + 1). $($directory)"
    } 
    Write-Host ""

    while (!($ProfileName)) {
      $profileNumber = Read-Host "Profile number"

      if (($profileNumber -ne 0) -and (($profileNumber -match "^\d+$") -and ($profileNumber -le $directories.Count))) {
        $selectedProfile = $directories[$profileNumber - 1]
        Write-Host "You selected $($profileNumber). $($selectedProfile)."
        $ProfileName = $selectedProfile
      }
      else {
        Write-Warning "Invalid profile number. Enter a number from the list."
      }
    }
  }
  else {
    # First profile, if there is only one
    $ProfileName = $directories[0]
  }

  if ($ProfileName) {
    # Return the selected profile directory
    return "$env:APPDATA\Mozilla\Firefox\Profiles\$ProfileName"
  }
  else {
    Write-Warning "Can't get profile directory!"
    return
  }

}


function Update-FirefoxTheme {
    
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$DownloadUrl,
    [Parameter(Mandatory = $true)]
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


function Get-FileDownloadUrlFromGithubReleases {
    
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$ReleasesUrl,
    [Parameter(Mandatory = $true)]
    [string]$FileName
  )

  # Get download url from github realeses
  $source = (Invoke-RestMethod -Uri $ReleasesUrl -Method Get -ErrorAction Stop)

  return ($source[0].assets | Where-Object name -Match $FileName)[0].browser_download_url
}


function Invoke-Installation {
    
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [string]$ProfileDirectory = (Get-FirefoxProfileDirectory),
    [Parameter(Mandatory = $false)]
    [string]$DownloadUrl = (Get-FileDownloadUrlFromGithubReleases -ReleasesUrl "https://api.github.com/repos/edelvarden/material-fox-updated/releases/latest" -FileName "chrome.zip"),
    [Parameter(Mandatory = $false)]
    [string]$UserJSDownloadUrl = "https://raw.githubusercontent.com/edelvarden/material-fox-updated/main/user.js"
  )

  $isUpdate = $false

  if (-not (Test-Path "$ProfileDirectory\chrome")) {
    $isUpdate = $true
  }
  else {
    Write-Warning "The chrome folder already exist!"
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
    Write-Warning "The user.js file already exist!"
    $confirm = Read-Host "Do you want replace? (Y/N)"

    if ($confirm -eq "Y") {
      $includeUserJS = $true
    }
  }

  if ($includeUserJS) {
    try {
      (New-Object System.Net.WebClient).DownloadFile($UserJSDownloadUrl, "$ProfileDirectory\user.js")
      Write-Host "Done. `user.js` successfully downloaded."
    }
    catch {
      Write-Warning "Can't download the user.js file!"
    }
  }
}


Write-Host "----------------------------------------------------------------"
Write-Host "MaterialFox UPDATED"
Write-Host "----------------------------------------------------------------"
Invoke-Installation
pause

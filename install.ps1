function Get-FirefoxProfileDirectory {

  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [string]$ProfileName = ""
  )

  $browserDirectories = @(
    "$env:APPDATA\Mozilla\Firefox",
    "$env:APPDATA\Waterfox",
    "$env:APPDATA\librewolf"
  )

  # If there are multiple browsers, prompt the user to select one
  $selectedDirectories = @()

  foreach ($firefoxBrowserDirectory in $browserDirectories) {
    if (Test-Path -Path $firefoxBrowserDirectory) {
      $selectedDirectories += $firefoxBrowserDirectory
    }
  }

  if ($selectedDirectories.Count -eq 0) {
    return ""
  }

  if ($selectedDirectories.Count -gt 1) {
    Write-Host "Select a Firefox browser:"
    Write-Host ""
    for ($i = 0; $i -lt $selectedDirectories.Count; $i++) {
      $directory = $selectedDirectories[$i]
      Write-Host "$($i + 1). $($directory)"
    }
    Write-Host ""

    while (!$BrowserProfile) {
      $profileNumber = Read-Host "Firefox browser number from list"

      if (($profileNumber -ne 0) -and (($profileNumber -match "^\d+$") -and ($profileNumber -le $selectedDirectories.Count))) {
        $selectedProfile = $selectedDirectories[$profileNumber - 1]
        Write-Host "You selected $($profileNumber). $($selectedProfile)."
        $BrowserProfile = $selectedProfile
      }
      else {
        Write-Warning "Invalid number. Enter a number from the list."
      }
    }
  }
  else {
    # First profile, if there is only one
    $BrowserProfile = $selectedDirectories[0]
  }

  $profilesDirectory = "$BrowserProfile\Profiles"
  
  # Get the list of Firefox profiles
  $profileDirectories = (Get-ChildItem -Path $profilesDirectory -Directory  |
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
  if ($profileDirectories.Count -gt 1) {
    Write-Host "Select a Firefox profile:"
    Write-Host ""
    for ($i = 0; $i -lt $profileDirectories.Count; $i++) {
      $directory = $profileDirectories[$i]
      Write-Host "$($i + 1). $($directory)"
    } 
    Write-Host ""

    while (!$ProfileName) {
      $profileNumber = Read-Host "Firefox profile number"

      if (($profileNumber -ne 0) -and (($profileNumber -match "^\d+$") -and ($profileNumber -le $profileDirectories.Count))) {
        $selectedProfile = $profileDirectories[$profileNumber - 1]
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
    $ProfileName = $profileDirectories[0]
  }

  if ($ProfileName) {
    # Return the selected profile directory
    return "$profilesDirectory\$ProfileName"
  }
  else {
    Write-Warning "Can't get Firefox profile directory!"
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

  try {
    # Get download url from github realeses
    $source = (Invoke-RestMethod -Uri $ReleasesUrl -Method Get -ErrorAction Stop)

    return ($source[0].assets | Where-Object name -Match $FileName)[0].browser_download_url
  }
  catch {}

  return ""
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

  if (!($DownloadUrl)) {
    Write-Warning "Can't get download url. Installation aborted."

    return;
  }

  if ((!($ProfileDirectory)) -or (!(Test-Path -Path $ProfileDirectory))) {
    Write-Warning "Can't find Firefox profile directory. Installation aborted."

    return;
  }

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

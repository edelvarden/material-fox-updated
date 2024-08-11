param (
    [string]$ReleasesUrl = "https://api.github.com/repos/edelvarden/material-fox-updated/releases/$env:MATERIAL_FOX_VERSION"
)

function Get-FirefoxProfileDirectory {

  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [string]$ProfileName = ""
  )

  $browserDirectories = @(
    "$env:APPDATA\Mozilla\Firefox",
    "$env:APPDATA\Waterfox",
    "$env:APPDATA\librewolf",
    "$env:APPDATA\Floorp"
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
    $BrowserProfile = Show-ConsoleMenu -Items $selectedDirectories -Prompt "Select a Firefox browser profile directory"
  } else {
    $BrowserProfile = $selectedDirectories[0]
  }

  $profilesDirectory = "$BrowserProfile\Profiles"

  $profileDirectories = (Get-ChildItem -Path $profilesDirectory -Directory  |
    Where-Object {
      if (Get-ChildItem $_.FullName -File -Name "*prefs.js") {
        return $true
      } else {
        return $false
      }
    } |
    Sort-Object Name)

  if ($profileDirectories.Count -gt 1) {
    $ProfileName = Show-ConsoleMenu -Items $profileDirectories.Name -Prompt "Select a Firefox profile"
  } else {
    $ProfileName = $profileDirectories[0].Name
  }

  if ($ProfileName) {
    return "$profilesDirectory\$ProfileName"
  } else {
    Write-Warning "Couldn't retrieve the Firefox profile directory!"
    return
  }
}

function Show-ConsoleMenu {
  param (
    [Parameter(Mandatory = $true)]
    [string[]]$Items,
    [Parameter(Mandatory = $true)]
    [string]$Prompt
  )

  $selectedIndex = 0
  $itemCount = $Items.Count

  # Store the initial cursor position
  $initialCursorPos = $Host.UI.RawUI.CursorPosition

  # Display the prompt and menu
  Write-Host "? " -ForegroundColor Yellow -NoNewline
  Write-Host "$Prompt " -ForegroundColor White  -NoNewline
  Write-Host ""

  $menuStartLine = $Host.UI.RawUI.CursorPosition.Y
  $menuLines = @()

  for ($i = 0; $i -lt $itemCount; $i++) {
    if ($i -eq $selectedIndex) {
      $menuLines += " > $($Items[$i])"
    } else {
      $menuLines += "   $($Items[$i])"
    }
  }

  # Function to redraw the menu
  function Redraw-Menu {
    $Host.UI.RawUI.CursorPosition = @{X=0; Y=$menuStartLine}
    for ($i = 0; $i -lt $itemCount; $i++) {
      if ($i -eq $selectedIndex) {
        Write-Host $menuLines[$i].PadRight($Host.UI.RawUI.WindowSize.Width) -ForegroundColor Cyan
      } else {
        Write-Host $menuLines[$i].PadRight($Host.UI.RawUI.WindowSize.Width) -ForegroundColor DarkGray
      }
    }
  }

  Redraw-Menu

  while ($true) {
    $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode

    switch ($key) {
      38 { # Up Arrow
        $selectedIndex = ($selectedIndex - 1) % $itemCount
        if ($selectedIndex -lt 0) { $selectedIndex = $itemCount - 1 }
      }
      40 { # Down Arrow
        $selectedIndex = ($selectedIndex + 1) % $itemCount
      }
      13 { # Enter
        return $Items[$selectedIndex]
      }
    }

    # Update the menu lines with the new selection
    $menuLines = @()
    for ($i = 0; $i -lt $itemCount; $i++) {
      if ($i -eq $selectedIndex) {
        $menuLines += " > $($Items[$i])"
      } else {
        $menuLines += "   $($Items[$i])"
      }
    }

    Redraw-Menu
  }
}


function Show-ConfirmationDialog {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $selectedOption = $null

    while ($null -eq $selectedOption) {
        Write-Host "? "  -ForegroundColor Yellow -NoNewline
        Write-Host "$Message " -ForegroundColor White -NoNewline
        Write-Host "(y/n) > " -ForegroundColor DarkGray -NoNewline
        
        $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode

        switch ($key) {
            89 { # Y key
                $selectedOption = "yes"
                Write-Host "yes" -ForegroundColor Green
            }
            78 { # N key
                $selectedOption = "no"
                Write-Host "no" -ForegroundColor Red
            }
            13 { # Enter
                $selectedOption = "no"
                Write-Host "no" -ForegroundColor Red
            }
            default {
              break
            }
        }

        if (-not $selectedOption) {
            Write-Host "`b`b`b`b" -NoNewline  # Backspace characters to overwrite the " › " prompt
        }
    }

    return $selectedOption
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
    Write-Warning "Couldn't install the Firefox theme!"
  }
  finally {
    Write-Host "Done. Cleaning up temp files..."
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
    # [string]$DownloadUrl = (Get-FileDownloadUrlFromGithubReleases -ReleasesUrl "https://api.github.com/repos/edelvarden/material-fox-updated/releases/latest" -FileName "chrome.zip"),
    # [string]$DownloadUrl = (Get-FileDownloadUrlFromGithubReleases -ReleasesUrl "https://api.github.com/repos/edelvarden/material-fox-updated/releases/tags/v1.0.7" -FileName "chrome.zip"),
    [string]$DownloadUrl = (Get-FileDownloadUrlFromGithubReleases -ReleasesUrl $ReleasesUrl -FileName "chrome.zip"),
    [Parameter(Mandatory = $false)]
    [string]$UserJSDownloadUrl = "https://raw.githubusercontent.com/edelvarden/material-fox-updated/main/user.js"
  )

  if (!($DownloadUrl)) {
    Write-Warning "Couldn't retrieve the download URL. Installation aborted."

    return
  }

  if ((!($ProfileDirectory)) -or (!(Test-Path -Path $ProfileDirectory))) {
    Write-Warning "Couldn't find the Firefox profile directory. Installation aborted."

    return
  }

  $isUpdate = $false

  if (-not (Test-Path "$ProfileDirectory\chrome")) {
    $isUpdate = $true
  }
  else {
    Write-Warning "The chrome folder already exists!"
        $confirmation = Show-ConfirmationDialog -Message "Do you want to overwrite?"

    if ($confirmation -eq "yes") {
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
    Write-Warning "The user.js file already exists!"
    $confirmation = Show-ConfirmationDialog -Message "Do you want to overwrite?"

    
    if ($confirmation -eq "yes") {
      $includeUserJS = $true
    }
  }

  if ($includeUserJS) {
    try {
      (New-Object System.Net.WebClient).DownloadFile($UserJSDownloadUrl, "$ProfileDirectory\user.js")
      Write-Host "Done. `user.js` successfully downloaded."
    }
    catch {
      Write-Warning "Couldn't download the user.js file!"
    }
  }
}


Write-Host "----------------------------------------------------------------"  -ForegroundColor DarkGray
Write-Host "MaterialFox UPDATED" -ForegroundColor White
Write-Host "----------------------------------------------------------------" -ForegroundColor DarkGray
Invoke-Installation
pause

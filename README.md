# MaterialFox UPDATED

_A Material Design-inspired userChrome.css theme for Firefox_

![preview](assets/preview.png)

## Requirements

The following properties from `about:config` must be `true`

- `toolkit.legacyUserProfileCustomizations.stylesheets`
- `svg.context-properties.content.enabled`
- `layout.css.color-mix.enabled`

## Installation

### Manual installation

1. Go to the following url address `about:support`
2. Find `Profile Folder` and click `Open Folder` button
3. Download `chrome.zip` from project [releases](https://github.com/edelvarden/material-fox-updated/releases) and extract into Firefox profile directory
4. Restart Firefox to apply changes

### Installation script

For **Windows** you can run the following PowerShell command:

```powershell
PowerShell -ExecutionPolicy Unrestricted -Command "iwr https://raw.githubusercontent.com/edelvarden/material-fox-updated/main/install.ps1 -useb | iex"
```

## Screenshots

<table>
  <tr>
    <th>Light</th>
    <th>Dark</th>
  </tr>
  <tr>
    <td><img src="assets/preview-light.png" alt="preview-light"></img></td>
    <td><img src="assets/preview-dark.png" alt="preview-dark"></img></td>
  </tr>
 </table>

## Manual Customization

If you want to change the colors, you can change the values of the variables in the following files:

- `user-chrome.css` for the browser shell;
- `user-content.css` for the content part (e.g. the "New tab" page);

Follow this steps:

1. Open the css file in a text editor
2. Find the desired variable
3. Change the value, for example, set the accent color to red: --mf-accent-color: #ea4335;
4. Restart Firefox to apply changes

### Available values

<table>
  <tr>
    <th>Variable name</th>
    <th>Description</th>
    <th>Default value</th>
  </tr>
  <tr>
    <td>--mf-accent-color</td>
    <td>accent color</td>
    <td>#8ab4f8</td>
  </tr>
  <tr>
    <td>--mf-background-color-0</td>
    <td>dark tones</td>
    <td>#202124</td>
  </tr>
  <tr>
    <td>--mf-background-color-50</td>
    <td>middle tones</td>
    <td>#292a2d</td>
  </tr>
  <tr>
    <td>--mf-background-color-100</td>
    <td>light tones</td>
    <td>#35363a</td>
  </tr>
  <tr>
    <td>--mf-text-primary</td>
    <td>main text color</td>
    <td>#e8eaed</td>
  </tr>
  <tr>
    <td>--mf-text-secondary</td>
    <td>secondary text color</td>
    <td>#9aa0a6</td>
  </tr>
  <tr>
    <td>--mf-text-on-accent</td>
    <td>text on primary button</td>
    <td>#202124</td>
  </tr>
  <tr>
    <td>--mf-menu-border-color</td>
    <td>controls border color</td>
    <td>#3c4043</td>
  </tr>
  <tr>
    <td>--mf-content-separator-color</td>
    <td>separator line between browser and content area</td>
    <td>#606164</td>
  </tr>
  <tr>
    <td>--mf-selection-text-color</td>
    <td>text selection color</td>
    <td>#fff</td>
  </tr>
  <tr>
    <td>--mf-selection-background-color</td>
    <td>selection background color</td>
    <td>#4285f4</td>
  </tr>
</table>

## Build & Development

### Prerequisite

- [Visual Studio Code](https://code.visualstudio.com/) (development environment)
- [NodeJS](https://nodejs.org/en/download) (for npm)

### Installation

1. Open Firefox profile folder.
2. Clone this repo with the following command:

```bash
git clone https://github.com/edelvarden/material-fox-updated.git chrome
```

Project structure

```plaintext
[Profile Folder]
└── chrome
    ├── chrome
    ├── src
    │   ├── user-chrome
    │   ├── user-content
    │   ├── user-chrome.scss
    │   └── user-content.scss
    ├── package-lock.json
    ├── package.json
    ├── userChrome.css
    └── userContent.css
```

3. On the project root directory, install the dependencies listed in `package.json` by using the following command:

```bash
npm install
```

3. Watch for changes to the `src` files and automatically build them into the `chrome` folder using the following command:

```bash
npm run dev
```

## Credits

- [MaterialFox](https://github.com/muckSponge/MaterialFox) by [muckSponge](https://github.com/muckSponge)
- [edge-frfox](https://github.com/bmFtZQ/edge-frfox) by [bmFtZQ](https://github.com/bmFtZQ)

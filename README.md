# MaterialFox UPDATED

![preview](assets/preview.png)

## Overview

MaterialFox UPDATED is a user CSS theme designed for the Firefox browser, inspired by material design.

## Motivation

The motivation behind creating this theme is my appreciation for material design, and the desire to bring this visually appealing style to the Firefox browser.

## Functionality

MaterialFox UPDATED overriding the default CSS with custom styles, utilizing the CSS `!important` rule.

## Getting Started

To start using MaterialFox UPDATED, follow these steps:

1. Go to the following url address `about:config`
2. Ensure the following properties are set to `true`:

   - `toolkit.legacyUserProfileCustomizations.stylesheets`
   - `svg.context-properties.content.enabled`
   - `layout.css.color-mix.enabled`

3. Go to the following url address `about:support`
4. Find `Profile Folder` and click `Open Folder` button
5. Download `chrome.zip` from the latest project releases -> [here](https://github.com/edelvarden/material-fox-updated/releases/latest) (or for Firefox **119** or below -> [here](https://github.com/edelvarden/material-fox-updated/releases/tag/v1.0.7)) and extract into your Firefox profile directory
6. Restart Firefox to apply changes

### Installation script (for advanced)

As an alternative to manual installation, you can use PowerShell script.

For **Windows** you can run the following PowerShell command:

```powershell
PowerShell -ExecutionPolicy Unrestricted -Command "iwr https://raw.githubusercontent.com/edelvarden/material-fox-updated/main/install.ps1 -useb | iex"
```

### Manual Customization

MaterialFox UPDATED support some `about:config` customization options.

To set preference:

1. Go to `about:config`
2. Create a custom boolean preference, just type the preference name and click the plus button, for example `userChrome.theme-default`

To disable preference, search by name and remove the preference:

1. Go to `about:config`.
2. Search by name and remove the preference.

#### Available preferences

<table>
  <tr>
    <th>Preference</th>
    <th>Description</th>
  </tr>
    <tr>
    <td><code>userChrome.ui-chrome-refresh</code></td>
    <td>Enabling new Chrome design which named as "Chrome Refresh".<img src="assets/preview-chrome-refresh.png" alt="preview-chrome-refresh"></img></td>
  </tr>
  <tr>
    <td><code>userChrome.theme-chrome-refresh</code></td>
    <td>Enabling new color scheme like in "Chrome Refresh".</img></td>
  </tr>
  <tr>
    <td><code>userChrome.theme-material</code></td>
    <td>Enabling Meterial color schemes. <a href="#theme-material" _blank>Read more</a>.</img></td>
  </tr>
  <tr>
    <td><code>userChrome.theme-default</code></td>
    <td>Enabling default color scheme. This can be useful if you want use with <a href="https://addons.mozilla.org/firefox/addon/adaptive-tab-bar-colour/" _blank>Adaptive Tab Bar Color</a> or native Firefox themes</td>
  </tr>
  <tr>
    <td><code>userChrome.ui-compact-url-bar</code></td>
    <td>Make the URL bar more compact by reducing its height.</td>
  </tr>
    <tr>
    <td><code>userChrome.ui-no-menu-icons</code></td>
    <td>Hide menu icons</td>
  </tr>
  <tr>
    <td><code>userChrome.ui-force-animation</code></td>
    <td>Force enable control animation, because by default respects the user animation disable preference. <em>(Not required if you do not disable animation)</em></td>
  </tr>
</table>

### Custom CSS rules

MaterialFox UPDATED support custom css rules, or additionally, if you want to change some colors, you can override the default values with your own.

Follow this steps:

1. Find and rename in the root folder `custom_example.css` to `custom.css`
2. Open `custom.css` in a text editor
3. Find the desired variable
4. Add your values, for example, set the accent color to red:

```css
:root,
html,
body {
  /* add your css variables below */
  --md-accent-color: #ea4335 !important;
}
```

5. Save the file and restart Firefox to apply changes

Using these custom css files can separate your changes from the source project and you can easily backup your files and don't worry about overwriting your changes if you want to update or reinstall the main files.

#### Available variables

<table>
  <tr>
    <th>Variable name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>--md-accent-color</code></td>
    <td>accent color</td>
  </tr>
  <tr>
    <td><code>--md-background-color-0</code></td>
    <td>dark tones</td>
  </tr>
  <tr>
    <td><code>--md-background-color-50</code></td>
    <td>middle tones</td>
  </tr>
  <tr>
    <td><code>--md-background-color-100</code></td>
    <td>light tones</td>
  </tr>
  <tr>
    <td><code>--md-text-primary</code></td>
    <td>main text color</td>
  </tr>
  <tr>
    <td><code>--md-text-secondary</code></td>
    <td>secondary text color</td>
  </tr>
  <tr>
    <td><code>--md-text-on-accent</code></td>
    <td>text on primary button</td>
  </tr>
  <tr>
    <td><code>--md-menu-background-color</code></td>
    <td>menu background color</td>
  </tr>
  <tr>
    <td><code>--md-menu-background-color-hover</code></td>
    <td>menu items background color on mouse over</td>
  </tr>
  <tr>
    <td><code>--md-menu-border-color</code></td>
    <td>controls border color</td>
  </tr>
  <tr>
    <td><code>--md-icon-color-primary</code></td>
    <td>navigation bar icons color</td>
  </tr>
  <tr>
    <td><code>--md-icon-color-secondary</code></td>
    <td>URL bar icons color</td>
  </tr>
  <tr>
    <td><code>--md-content-separator-color</code></td>
    <td>separator line between browser and content area</td>
  </tr>
  <tr>
    <td><code>--md-selection-text-color</code></td>
    <td>text selection color</td>
  </tr>
  <tr>
    <td><code>--md-selection-background-color</code></td>
    <td>selection background color</td>
  </tr>
</table>

TIPS: You can find more variables in the [variables/\_colors.scss](src/variables/_colors.scss) file. To use these variables just add `--md-` prefix, eg. `"accent-color": #a8c7fa,` to `--md-accent-color: #a8c7fa;`

#### Custom css use cases

- Replacing the font with your own, change `"YourFontName"` to the name of your font:

  ```css
  :root,
  html,
  body {
    /* add your css variables below */
  }

  /* add your user css below */
  *,
  *::before,
  *::after {
    font-family: "YourFontName" !important;
  }
  ```

- Remove the separator line between browser and content:

  ```css
  :root,
  html,
  body {
    /* add your css variables below */
    --md-content-separator-color: transparent !important;
  }
  ```

#### Custom css use cases for create your own color themes

You can use variables to completly recolor to your own color, some examples with code:

<table>
  <tr>
    <th>Description</th>
    <th>Preview</th>
  </tr>
  <tr>
    <td>
      <h2>System accent colors</h6>
      Source code: <br><a href="assets/examples/system-accent-colors.css" _blank>system-accent-colors.css</a>
    </td>
    <td><img src="assets/preview-accent-1.png" alt=""/><img src="assets/preview-accent-2.png" alt=""/><img src="assets/preview-accent-3.png" alt=""/></td>
  </tr>
  <tr>
    <td>
      <h2>Github theme</h6>
      Source code: <br><a href="assets/examples/github-theme.css" _blank>github-theme.css</a>
    </td>
    <td><img src="assets/preview-github.png" alt="preview-github"></img></td>
  </tr>
  <tr>
    <td>
      <h2>Dracula theme</h6>
      Source code: <br><a href="assets/examples/dracula-theme.css" _blank>dracula-theme.css</a>
    </td>
    <td><img src="assets/preview-dracula.png" alt="preview-dracula"/></td>
  </tr>

</table>

#### Theme Material

Now you can use [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/) to create a color theme from an image.

1. Set to `true` or create `userChrome.theme-material` variable in the `about:config` page.
2. Go to the [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/) website.
3. Select from the presented images, upload your own or use "Random color" button to generate theme.
4. Then click "Pick your fonts" button in the right bottom corner, scipt this step and click "Export theme".
5. Click "Export" and select "Web (CSS)" from the drop down menu.
   ![material-theme-tutorial](assets/material-theme-tutorial.png)

This will download an archive of CSS files, you need only two files `light.css` and `dark.css`.
Open in a text editor and extract variables to your `custom.css` file.
Wrap variables to appropriate media rule for light and dark theme.

Examples with previews
| Example | Preview |
| --- | --- |
| [theme-material-blue.css](chrome/theme-material-blue.css) | ![material-blue-preview](assets/material-blue-preview.png) |
| [theme-material-red.css](assets/examples/theme-material-red.css) | ![material-red-preview](assets/material-red-preview.png) |
| [theme-material-yellow.css](assets/examples/theme-material-yellow.css) | ![material-yellow-preview](assets/material-yellow-preview.png) |
| [theme-material-green.css](assets/examples/theme-material-green.css) | ![material-green-preview](assets/material-green-preview.png) |

## Build & Development (for developers)

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) (development environment)
- [NodeJS](https://nodejs.org/en/download) (for npm)

### Installation

1. Open Firefox profile directory in terminal.
2. Clone this repo with the following command:

```bash
git clone https://github.com/edelvarden/material-fox-updated.git chrome
cd chrome
npm install
npm run dev
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

3. Then you can modify the files in the `src` directory, all changes will be automatically build in the `[Profile Folder]/chrome/chrome` folder.

To subsequently start the development mode, just use the following command:

```bash
npm run dev
```

### Screenshots

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

## Credits

- [MaterialFox](https://github.com/muckSponge/MaterialFox) by [muckSponge](https://github.com/muckSponge)
- [edge-frfox](https://github.com/bmFtZQ/edge-frfox) by [bmFtZQ](https://github.com/bmFtZQ)

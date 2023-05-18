# MaterialFox UPDATED

_A Material Design-inspired userChrome.css theme for Firefox_

<!-- preview -->
| Light                                   | Dark                                   |
| --------------------------------------- | -------------------------------------- |
| ![Light][mf-light]                      | ![Dark][mf-dark]                       |

<!-- preview references -->
[mf-light]: mf-light.png
[mf-dark]: mf-dark.png

## Requirements

The following properties from `about:config` must be `true` 

- `toolkit.legacyUserProfileCustomizations.stylesheets`
- `svg.context-properties.content.enabled`
- `layout.css.color-mix.enabled`

## Installation

1. Go to the following url address `about:support`
2. Find `Profile Folder` and click `Open Folder` button
3. Download `chrome.zip` from project [Realeses](https://github.com/edelvarden/material-fox-updated/releases) and extract into Firefox profile directory
4. Restart Firefox

## Build & Development

- [Visual Studio Code](https://code.visualstudio.com/) (development environment)
- [NodeJS](https://nodejs.org/en/download) (for npm)

1. Clone this repo or extract downloaded zip to `[Profile Folder]/chrome`

```
git clone https://github.com/edelvarden/material-fox-updated.git .
```

Project structure

```
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

2. On the project root directory, install the dependencies listed in `package.json` by using the following command

```
npm install
```

3. Watch for changes to the `src` files and automatically build them to the `chrome` folder by using the following command

```
npm run dev
```

## Credits

- [MaterialFox](https://github.com/muckSponge/MaterialFox) by [muckSponge](https://github.com/muckSponge)
- [edge-frfox](https://github.com/bmFtZQ/edge-frfox) by [bmFtZQ](https://github.com/bmFtZQ)

# MaterialFox UPDATED
*A Material Design-inspired userChrome.css theme for Firefox*

![Preview](https://github.com/edelvarden/material-fox-updated/blob/main/preview.png?raw=true)

## Installation
1. Go to ```about:support``` url address
2. Find ```Profile Folder``` and click ```Open Folder``` button.
3. Move ```chrome``` folder and ```user.js``` file into Firefox profile directory.
4. Restart Firefox.

## Build & Development
[Visual Studio Code](https://code.visualstudio.com/) to develop this project.

1. Clone this repo to ```[Profile Folder]/chrome```

````
git clone https://github.com/edelvarden/material-fox-updated.git .
````

Project structure

```
[Profile Folder]
└── chrome
    ├── chrome
    ├── src
        ├── user-chrome
        ├── user-content
        ├── user-chrome.scss
        └── user-content.scss
    ├── package-lock.json
    ├── package.json
    ├── userChrome.css
    └── userContent.css
```

2. On the project root directory, install the dependencies listed in ```package.json``` by using the following command

````
npm install
````

3. Watch for changes to the ```src``` files and automatically build them to the ```chrome``` folder by using the following command

````
npm run watch
````

## Credits
* [MaterialFox](https://github.com/muckSponge/MaterialFox) by [muckSponge](https://github.com/muckSponge)
* [edge-frfox](https://github.com/bmFtZQ/edge-frfox) by [bmFtZQ](https://github.com/bmFtZQ)
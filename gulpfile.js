// --------------------------------------------------------------------------------
// -- Plugins require
// --------------------------------------------------------------------------------
import ttf2woff2 from "gulp-ttf2woff2";
import svgmin from "gulp-svgmin";
import autoprefixer from "autoprefixer"; // add -webkit and other prefixes
import cssnano from "cssnano";
import gulp from "gulp";
import postcss from "gulp-postcss";
import gulpSass from "gulp-sass";
import dartSass from "sass";
const sass = gulpSass(dartSass);

// --------------------------------------------------------------------------------
// -- Compile scss
// --------------------------------------------------------------------------------
function buildStyles(srcPath, destPath) {
  return gulp
    .src(srcPath, { sourcemaps: false })
    .pipe(sass().on("error", sass.logError))
    .pipe(postcss([autoprefixer({ grid: true, overrideBrowserslist: ["last 3 firefox version"], cascade: true }), cssnano()]))
    .pipe(gulp.dest(destPath));
}

// --------------------------------------------------------------------------------
// -- Variables
// --------------------------------------------------------------------------------
const srcRoot = "src";
const destRoot = "chrome";
const src = {
  css: `${srcRoot}/**/*.scss`,
  userChrome: `${srcRoot}/user-chrome.scss`,
  userContent: `${srcRoot}/user-content.scss`,
  fonts: `${srcRoot}/fonts/*.ttf`,
  icons: `${srcRoot}/icons/*.svg`,
};

const dest = {
  fonts: `${destRoot}/fonts/`,
  icons: `${destRoot}/icons/`
};

// --------------------------------------------------------------------------------
// -- Tasks
// --------------------------------------------------------------------------------
gulp.task("default", () => {
  gulp.watch(src.css, (done) => buildStyles(src.userChrome, destRoot)(done));
  gulp.watch(src.css, (done) => buildStyles(src.userContent, destRoot)(done));
});

// --------------------------------------------------------------------------------
// -- Convert font
// --------------------------------------------------------------------------------
gulp.task("ttf2woff2", function () {
  return gulp
    .src(src.fonts)
    .pipe(ttf2woff2())
    .pipe(gulp.dest(dest.fonts));
});
// --------------------------------------------------------------------------------
// -- Optimize svg
// --------------------------------------------------------------------------------
gulp.task("svgmin", function () {
  return gulp
    .src(src.icons)
    .pipe(svgmin())
    .pipe(gulp.dest(dest.icons));
});

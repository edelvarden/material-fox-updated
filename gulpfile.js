// --------------------------------------------------------------------------------
// -- Plugins require
// --------------------------------------------------------------------------------
import gulp from "gulp";
import ttf2woff2 from "gulp-ttf2woff2";
import svgmin from "gulp-svgmin";
import gulpSass from "gulp-sass";
import dartSass from "sass";
const sass = gulpSass(dartSass);
import postcss from "gulp-postcss";
import autoprefixer from "autoprefixer";
import cssnano from "cssnano";

// --------------------------------------------------------------------------------
// -- Compile scss
// --------------------------------------------------------------------------------
function buildCss(srcPath, destPath) {
  return gulp.src(srcPath, { sourcemaps: false })
    .pipe(sass().on("error", sass.logError))
    .pipe(postcss([autoprefixer(), cssnano()]))
    .pipe(gulp.dest(destPath));
}

// --------------------------------------------------------------------------------
// -- Optimize svg
// --------------------------------------------------------------------------------
function svgOptimize() {
  return gulp.src(src.icons).pipe(svgmin()).pipe(gulp.dest(dest.icons));
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
  icons: `${destRoot}/icons/`,
};

// --------------------------------------------------------------------------------
// -- Tasks
// --------------------------------------------------------------------------------
gulp.task(
  "default",
  gulp.parallel(() => {
    gulp.watch(src.icons, svgOptimize);
    gulp.watch(src.css, (done) => buildCss(src.userChrome, destRoot)(done));
    gulp.watch(src.css, (done) => buildCss(src.userContent, destRoot)(done));
  })
);

// --------------------------------------------------------------------------------
// -- Convert font
// --------------------------------------------------------------------------------
gulp.task("ttf2woff2", function () {
  return gulp.src(src.fonts).pipe(ttf2woff2()).pipe(gulp.dest(dest.fonts));
});

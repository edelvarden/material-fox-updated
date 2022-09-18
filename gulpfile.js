// --------------------------------------------------------------------------------
// -- Plugins require
// --------------------------------------------------------------------------------
import gulp from 'gulp';
import autoprefixer from 'gulp-autoprefixer';
import cleancss from 'gulp-clean-css';
import groupmediaqueries from 'gulp-group-css-media-queries';
import gulpSass from 'gulp-sass';
import dartSass from 'sass';
const sass = gulpSass(dartSass);

// --------------------------------------------------------------------------------
// -- Compile scss
// --------------------------------------------------------------------------------
function buildStyles(srcPath, destPath) {
    return gulp.src(srcPath, { sourcemaps: false })
        .pipe(sass().on('error', sass.logError))
        .pipe(groupmediaqueries())
        .pipe(autoprefixer({
            grid: true,
            overrideBrowserslist: ["Firefox > 76"],
            cascade: true
        }))
        .pipe(cleancss({
            level: 2
        }))
        .pipe(gulp.dest(destPath));
}

// --------------------------------------------------------------------------------
// -- Variables
// --------------------------------------------------------------------------------
const srcRoot = 'src';
const destRoot = 'chrome';
const src = {
    css: `${srcRoot}/**/*.scss`,
    userChrome: `${srcRoot}/user-chrome.scss`,
    userContent: `${srcRoot}/user-content.scss`,
    font: `${srcRoot}/font/*.ttf`
};

// --------------------------------------------------------------------------------
// -- Tasks
// --------------------------------------------------------------------------------
gulp.task('default', () => {
    gulp.watch(src.css, (done) => buildStyles(src.userChrome, destRoot)(done));
    gulp.watch(src.css, (done) => buildStyles(src.userContent, destRoot)(done));
});


// --------------------------------------------------------------------------------
// -- Convert font
// --------------------------------------------------------------------------------
gulp.task('ttf2woff2', function () {
    return gulp.src(src.font)
        .pipe(ttf2woff2())
        .pipe(gulp.dest(`${destPath}/font/`));
});
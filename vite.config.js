import cssnano from 'cssnano';
import { resolve } from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  root: resolve(__dirname, "src"),
  server: {
    port: 3000,
  },
  build: {
    outDir: resolve(__dirname, "chrome"),
    rollupOptions: {
      input: {
        "chrome": "src/user-chrome.scss",
        "content": "src/user-content.scss"
      },
      output: {
        entryFileNames: "[name].css",
        assetFileNames: "[name].css",
      },
      plugins: [
        cssnano({ 
          preset: ['advanced', { 
            autoprefixer: false, 
            discardComments: { removeAll: true }, 
          }] 
        }),
      ],
    },
  },
  watcher: {
    include: 'src/**/*.scss'
  }
});

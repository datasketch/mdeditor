import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';

export default defineConfig({
  root: 'srcjs',
  build: {
    outDir: path.resolve(process.cwd(), 'inst/www/mdeditor/markdowneditor'),
    emptyOutDir: false,
    rollupOptions: {
      input: path.resolve(process.cwd(), 'srcjs/dev.jsx'),
      external: ['reactR'],
      output: {
        globals: {
          reactR: 'window.reactR'
        },
        entryFileNames: 'markdowneditor.js',
      },
    },
  },
  plugins: [react()],
  server: {
    open: true,
  },
}); 
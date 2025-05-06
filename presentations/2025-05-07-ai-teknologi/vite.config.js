import { defineConfig } from 'vite'

export default defineConfig({
    slidev: {
        // any slidev specific configs for presentation-A
    },
    base: 'presentations/2025-05-07-ai-teknologi', // Crucial: Set the base path
    build: {
        outDir: '../../dist/2025-05-07-ai-teknologi',
        assetsDir: '../../assets/', // Output to a subfolder in a common dist
        // Adjust path based on your vite.config.js location
    },
})
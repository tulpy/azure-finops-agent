import vue from "@vitejs/plugin-vue";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    proxy: {
      "/auth": "http://localhost:5000",
      "/api": "http://localhost:5000",
    },
  },
  build: {
    outDir: "../wwwroot",
    emptyOutDir: true,
    rollupOptions: {
      onwarn(warning, warn) {
        // applicationinsights-web uses /*#__PURE__*/ inside parens, which Rolldown flags as invalid
        if (warning.code === "INVALID_ANNOTATION" && warning.id?.includes("@microsoft/applicationinsights")) return;
        warn(warning);
      },
      output: {
        manualChunks: (id) => {
          if (id.includes("echarts") || id.includes("zrender")) return "echarts";
        },
      },
    },
  },
});

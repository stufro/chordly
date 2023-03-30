const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://localhost:5017",
    defaultCommandTimeout: 5000,
    viewportHeight: 1080,
    viewportWidth: 1920,
    experimentalSessionAndOrigin: true
  }
});

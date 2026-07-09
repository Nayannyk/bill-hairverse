const { app, BrowserWindow } = require("electron");
const { spawn } = require("child_process");
const path = require("path");

let backend;

function createWindow() {
  const win = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, "preload.js")
    }
  });
  win.loadFile("index.html");
}

app.whenReady().then(() => {
  backend = spawn("node", ["server.js"], { stdio: "ignore" });
  backend.on("error", (err) => console.error("Backend spawn error:", err));
  backend.on("exit", (code) => {
    if (code !== 0) console.error("Backend exited with code", code);
  });
  createWindow();
});

app.on("window-all-closed", () => {
  if (backend) backend.kill();
  if (process.platform !== "darwin") app.quit();
});

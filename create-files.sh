#!/bin/bash

PROJECT="hairverse-app"

echo "📁 Creating project structure..."

mkdir -p $PROJECT
cd $PROJECT || exit

# ---------- index.html ----------
cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Hairverse Billing</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<h2>Hairverse Billing App</h2>
<p>Frontend UI will be loaded here.</p>
</body>
</html>
EOF

# ---------- server.js ----------
cat > server.js <<'EOF'
const express = require("express");
const ExcelJS = require("exceljs");
const fs = require("fs");
const path = require("path");
const os = require("os");

const app = express();
app.use(express.json());

const dataDir = path.join(os.homedir(), "Documents", "Hairverse");
const filePath = path.join(dataDir, "bills.xlsx");

if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, { recursive: true });

async function initExcel() {
  if (!fs.existsSync(filePath)) {
    const wb = new ExcelJS.Workbook();
    const ws = wb.addWorksheet("Bills");
    ws.columns = [
      { header: "Invoice No", key: "invoice" },
      { header: "Date Time", key: "date" },
      { header: "Customer Name", key: "name" },
      { header: "Phone", key: "phone" },
      { header: "Services", key: "services" },
      { header: "Total", key: "total" },
      { header: "Payment Mode", key: "payment" }
    ];
    await wb.xlsx.writeFile(filePath);
  }
}
initExcel();

app.post("/save", async (req, res) => {
  const { invoice, name, phone, services, total } = req.body;
  const wb = new ExcelJS.Workbook();
  await wb.xlsx.readFile(filePath);
  const ws = wb.getWorksheet("Bills");

  ws.addRow({
    invoice,
    date: new Date().toLocaleString(),
    name,
    phone,
    services,
    total,
    payment: "UPI"
  });

  await wb.xlsx.writeFile(filePath);
  res.json({ success: true });
});

app.listen(3000, () => console.log("Backend running on port 3000"));
EOF

# ---------- main.js ----------
cat > main.js <<'EOF'
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
  createWindow();
});

app.on("window-all-closed", () => {
  if (backend) backend.kill();
  if (process.platform !== "darwin") app.quit();
});
EOF

# ---------- preload.js ----------
cat > preload.js <<'EOF'
window.addEventListener("DOMContentLoaded", () => {
  console.log("Hairverse preload loaded");
});
EOF

# ---------- package.json ----------
cat > package.json <<'EOF'
{
  "name": "hairverse",
  "version": "1.0.0",
  "description": "Hairverse Salon Billing Software",
  "author": "Hairverse Unisex Salon",
  "main": "main.js",
  "scripts": {
    "start": "electron .",
    "build": "electron-builder"
  },
  "dependencies": {
    "express": "^4.18.2",
    "exceljs": "^4.4.0"
  },
  "devDependencies": {
    "electron": "^28.3.3",
    "electron-builder": "^24.13.3"
  },
  "build": {
    "appId": "com.hairverse.salon",
    "productName": "Hairverse",
    "win": {
      "target": "nsis"
    }
  }
}
EOF

echo "✅ Files created successfully"

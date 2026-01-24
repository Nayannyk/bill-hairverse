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

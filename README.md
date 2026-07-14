# Bill Hairverse

A salon billing and invoicing desktop application for **Hairverse Unisex Salon**. Generates and saves billing invoices to Excel spreadsheets, built with Electron and Node.js.

## About

Bill Hairverse is a lightweight desktop app designed to streamline the billing process at Hairverse Unisex Salon. It allows staff to create invoices and automatically saves them to an Excel file (`bills.xlsx`) stored locally in `~/Documents/Hairverse/`.

## Features

- **Invoice Generation** — Create billing invoices with customer details, services, and totals
- **Excel Export** — Automatically saves all invoices to a formatted Excel spreadsheet
- **Persistent Storage** — Invoices are stored in `~/Documents/Hairverse/bills.xlsx`
- **Desktop App** — Standalone Windows application via Electron
- **REST API** — Express backend with `/save` endpoint for bill persistence

## Tech Stack

| Layer | Technology |
|---|---|
| Desktop Framework | Electron 28 |
| Backend | Node.js + Express 4 |
| Data Storage | ExcelJS (`.xlsx` files) |
| Build/Packaging | electron-builder (Windows NSIS installer) |
| Frontend | HTML (vanilla) |

## Project Structure

```
bill-hairverse/
├── hairverse-app/
│   ├── main.js              # Electron main process (BrowserWindow + backend spawn)
│   ├── server.js            # Express backend (static files, /save API, Excel management)
│   ├── preload.js           # Electron preload script
│   ├── index.html           # Frontend UI
│   ├── package.json         # Dependencies and build config
│   └── bills.xlsx           # Generated invoice data (created on first run)
├── create-files.sh          # Project bootstrap script
└── README.md
```

## Prerequisites

- [Node.js](https://nodejs.org/) 16+
- npm

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/Nayannyk/bill-hairverse.git
cd bill-hairverse/hairverse-app
```

### 2. Install dependencies

```bash
npm install
```

### 3. Run the application

```bash
npm start
```

This launches the Electron desktop window and starts the Express backend on port 3000.

### 4. Build Windows Installer

```bash
npx electron-builder --win
```

The installer `.exe` will be generated in the `dist/` directory.

## Invoice Format

Each invoice saved to `bills.xlsx` contains the following fields:

| Column | Description |
|---|---|
| Invoice No | Auto-generated invoice number |
| Date Time | Timestamp of the transaction |
| Customer Name | Name of the customer |
| Phone | Customer phone number |
| Services | List of services availed |
| Total | Total amount in INR |
| Payment Mode | Payment method used |

The Excel file is created automatically on first run at `~/Documents/Hairverse/bills.xlsx`.

## API

The Express backend exposes the following endpoint:

| Method | Endpoint | Description |
|---|---|---|
| POST | `/save` | Save a new bill to the Excel file |

### Request Body

```json
{
  "invoice": "INV-001",
  "name": "Customer Name",
  "phone": "9876543210",
  "services": "Haircut, Styling",
  "total": 500,
  "payment": "Cash"
}
```

## License

Private — for Hairverse Unisex Salon use.

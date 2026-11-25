# Future 25 — static analysis and “how the app works”

**Date:** 2026-11-25  
**Scope:** `D:\future_25 old`, `D:\future_25 - Special`, `D:\future_25`, `D:\Future Elshamy`  
**Safety:** No executable was launched. No file on `D:` was modified. REA MCP was used for PE, shortcut, and release-exposure inspection; read-only byte/string scans were used for PowerBuilder `.pbd` libraries and the data files.

---

## 1. Executive summary

Future 25 is a **PowerBuilder 9 desktop ERP/accounting application**, not an Electron app and not a web app.

Observed start-up chain:

```text
Desktop shortcut
  -> Run_Pro.exe                  (VB6 launcher/security wrapper; in three copies)
  -> future.exe                   (PowerBuilder 9 generated executable)
  -> PBVM90.dll                   (PowerBuilder runtime)
  -> 100+ PBD libraries           (compiled windows, DataWindows, functions, structures)
  -> fmg.ini                      (ODBC DSN, station, user, devices, license/protection values)
  -> ODBC DSN                     (actual DB host resolved by Windows ODBC configuration)
  -> Sybase SQL Anywhere database (local fmgret.db in Elshamy copy; central DSN in others)
  -> MobiLink synchronization     (from SQL Anywhere/MobiLink metadata in the data file)
```

In the Elshamy copy the shortcut points directly at `future.exe`, so `Run_Pro.exe` is bypassed there.

The application appears to cover **accounts, inventory, purchases, sales, payroll, fixed assets, general services, reporting, maintenance, barcode printing, receipts, cash drawer, customer display, call center/caller ID, and backup**. This is inferred from PBD family names, object names, `.ini` sections, and embedded SQL table names.

---

## 2. Copies inspected

| Folder | Files | Bytes | Distinctive content |
|---|---:|---:|---|
| `D:\future_25 old` | 134 | 123,540,938 | 114 `.pbd` libraries; `dsn=store`; shortcut to `E:\future_25\Run_Pro.exe` |
| `D:\future_25 - Special` | 268 | 249,096,089 | 228 `.pbd` libraries; `dsn=SPICIAL_HQ`; nested `future_25\fmg.ini` with `dsn=store`; extra `Run_Pro.exe`, `run_scripts.exe` |
| `D:\future_25` | 134 | 124,548,042 | 114 `.pbd` libraries; `dsn=store`; shortcut to `E:\future_25\Run_Pro.exe` |
| `D:\Future Elshamy` | 145 | 302,739,324 | 117 `.pbd` libraries; includes `Data\fmgret.db` (120 MB), `fmgret.log` (16 MB), `working\180425AA.LOG`; shortcut directly to `D:\future25\future.exe` |

The three non-Elshamy shortcuts are byte-identical (SHA-256 `958141ca…74315`) and point to `E:\future_25\Run_Pro.exe` with working directory `E:\future_25`. The Elshamy shortcut points to `D:\future25\future.exe` with working directory `D:\future25` (SHA-256 `452fb14d…f6b8dda30c390b09353cf`).

---

## 3. Executables and launch path

### `future.exe`

`D:\future_25 - Special\future.exe`:

- PE32 / x86, 38,400 bytes.
- SHA-256: `2e74e0296741879a5b205aa9451789cc8261227df8d49a9a6ad3a9936a98c92f`.
- Imports `PBVM90.dll` (ordinal 137) and `KERNEL32.dll`.
- Resources: type 16 (`RT_VERSION`) and type 24 (`RT_MANIFEST`).
- No Electron fuse sentinel; fuse state is **unknown/not applicable**, not “disabled”.
- Static strings embed **105 `.pbd` library references**, i.e. the PowerBuilder library list the runtime loads.

Elshamy’s `future.exe` is different: SHA-256 `c941d694052075e7d81cc75be3d915c1de9981623c52745b745142fa7af668a1`, PE32/x86, imports `PBVM90.dll`, but has only the version resource. `fashion.exe` in the same copy is another PBVM90 executable.

### `Run_Pro.exe`

`D:\future_25 - Special\Run_Pro.exe`:

- PE32 / x86, SHA-256 `4ce504d5ff37c14255e82f0a07b1e6812c664d5572556a007a1228e14010e94d`.
- Imports `MSVBVM60.DLL` with 162 functions → **Visual Basic 6** program.
- Static strings include `\future.exe`, `ShellExecuteA`, `WScript.Shell`, `Run_Pro`, `Future 2010 Security`, `START_STOP_COUNT`, and `Future Error`.
- Resources include types 3, 14, and 16.

**Inference:** `Run_Pro.exe` is a small VB6 security/launch wrapper that uses ShellExecute/WScript to start `future.exe`. The exact license check or command-line behavior was not decompiled.

### `run_scripts.exe`

`D:\future_25 - Special\run_scripts.exe`:

- PE32 / x86, SHA-256 `bd59cdd43b694330092ff026e847f4512fbfe8e33fc9d7f0e76d7bfdb3555384`.
- Imports `PBVM90.dll`, so it is also a PowerBuilder program.
- Strings reference `rep_branchs.pbd` and `w_run_scripts_support_25.win`.

**Inference:** companion utility for running report/support scripts; likely not the main application.

---

## 4. Application architecture

### 4.1 PowerBuilder library model

The `.pbd` files are **PowerBuilder dynamic libraries**; their headers begin with `HDR*PowerBuilder`. They are not PDB debug files. They contain compiled PowerBuilder objects, observed by name:

| Object kind | Prefix/count from strings | Meaning |
|---|---:|---|
| DataWindow | `d_` ≈ 2,648 | SQL-backed grid/form/report definitions |
| Window | `w_` ≈ 869 | UI windows |
| DataStore | `ds_` ≈ 295 | non-visual DataWindow/SQL retrieval objects |
| Object functions | `of_` ≈ 144 | methods on custom objects |
| Global functions | `f_` ≈ 97 | shared functions |
| DW/DDDW | `dw_`, `dddw_` | embedded/dropdown DataWindows |
| Structures | `str_` ≈ 42 | data structures |
| User objects | `uo_`, `n_`, `nv_` | custom classes/non-visual objects |

Counts are string-derived, not a full decompilation.

### 4.2 Functional families

From `D:\future_25` library names:

| Family | Libraries | Inferred role |
|---|---:|---|
| `inv` | 28 | Inventory: items, stores, balances, issues, receipts, transfers, expiry, prices |
| `pay` | 14 | Payroll: payslips, allowances/deductions, employee data |
| `acc` | 13 | Accounting: vouchers, chart of accounts, balances, periods |
| `fas` | 12 | Fixed assets |
| `sal` | 8 | Sales |
| `pur` | 7 | Purchasing |
| `gen` | 2 | General/setup |
| `future` | 2 | Application shell, login, frame, menus, security |
| `common`, `fmgfuncs`, `fmgances` | 3 | Shared DataWindows, helper functions, generic base windows/user objects |
| `menus1`–`menus4` | 4 | Menu libraries |
| `mt*` / `MMmt*` / `XXmt*` | ~14 | Maintenance/variant modules |
| `rlcomm`, `tr_data`, `rep_*`, `Y_G1` | 4 | Communications, transaction data, reports, miscellaneous |

`future.exe` embeds a library list including all major families: `acc_*`, `fas_*`, `inv_*`, `pay_*`, `pur_*`, `sal_*`, `gen_*`, `common.pbd`, `fmgfuncs.pbd`, `fmgances.pbd`, `future.pbd`, `future_dd1.pbd`, `menus1-4.pbd`, `mt*.pbd`, `rlcomm.pbd`, `tr_data.pbd`.

### 4.3 Application shell objects in `future.pbd`

Observed objects include:

- Login/security: `d_logon`, `w_logon`, `w_sec`, `w_protect`, `change_pass.fun`, `of_securety23.fun`, `of_protection.fun`, `of_end_protection.fun`
- Main UI: `w_genapp_frame`, `w_genapp_frame_arb`, `w_genapp_frame_eng`, `w_genapp_toolbars*`, `w_menu_new_arb`, `w_menu_new_eng`
- Application classes: `n_appmanager.udo`, `n_version.udo`, `n_osapi.udo`, `n_external_functions*`
- Crypto/protection helpers: `f_encrypte_x.fun`, `f_decrypte_x.fun`, `f_encrypte_x_again.fun`, `of_get_x.fun`, `str_protect`, `str_serial`
- Data structures: `str_logon`, `str_sys_par`, `memory1`, `system_info1`

This supports aPB conventional “app manager → login → MDI frame → module menus → module windows/DataWindows” architecture.

---

## 5. Configuration and database connection

### `fmg.ini`

All copies contain a similar `fmg.ini`. Observed sections:

```text
[database] [Definition] [help] [Current] [Backup] [validate]
[BarCodePrint] [CustomerDisplay] [CashDrawer] [ReceiptPrint]
[purchaseitems] [SoundPay] [message] [CallCenter] [CallerId] [future]
```

Important values:

| Setting | Value/observation |
|---|---|
| `DBMS=ODBC` | Active in all copies |
| `dsn=SPICIAL_HQ` | Active in `D:\future_25 - Special\fmg.ini` |
| `dsn=store` | Active in old, plain, and `Special\future_25\fmg.ini` |
| `;dsn=future`, `;dsn=rady` | Commented/historical |
| `;ServerName = sengam` | Commented/historical server name |
| `;DBMS=MSS Microsoft SQL Server`, `;database=fmgret5` | Commented/historical SQL Server settings |
| `logid = dba` | DB login id |
| `;LogPassWord =` | Password not stored in the file |
| `AutoCommit=false` | Explicit transactions |
| `stationId=101`, `User=admin`, `security=2`, `Module=1` | Runtime identity/permissions |
| `[Backup] Path=F:\backup`, `auto=1`, `missed_allowed=3` | Backup policy |
| Barcode/receipt settings | COM ports, baud rate, parity, label formats, printer model |
| `[future] version=23`, `handler23=...`, `DB23=...` | Obfuscated protection/config values |

`key.txt` contains two short key-like strings; their use was not decoded.

### Runtime DSN resolution

`future.pbd` and `future (2).pbd00` contain `Connectstring='DSN=` and `ls_dsname`. Therefore, the actual DB host/driver is assembled at runtime from the DSN name and resolved through **Windows ODBC configuration**, not hardcoded as an IP in the PBDs.

### Data file in Elshamy copy

`D:\Future Elshamy\future25\Data\fmgret.db`:

- 120,193,024 bytes.
- REA `inspect_sqlite_database` rejected it: **not a SQLite database**.
- Header is proprietary/ISAM-like (`00 00 00 00 41 00 00 00 EC 7F ...`).
- Embedded strings identify **Sybase SQL Anywhere / Adaptive Server Anywhere 9.0.2.2451**.
- Contains MobiLink system objects: `ml_script_version`, `ml_add_connection_script`, `ml_add_table_script`, `ml_set_device_address`, publications, subscriptions, `sync_id`, `consolidate`, `synchronize`.
- Companion `fmgret.log` is 16,842,752 bytes, consistent with a SQL Anywhere transaction log.

**Inference:** Future 25 uses SQL Anywhere as a local/remote database and MobiLink for synchronization with a consolidated server. The sync server address was not found in static files.

---

## 6. Business data and SQL model

From embedded SQL strings across the PBDs, repeatedly referenced tables include:

- Organization: `company`, `stores`, `employee`, `salesman`, `vendor`, `customer`, `customer_comapny`, `user_company_store`
- Items/pricing: `item_master`, `item_groups`, `item_company`, `item_company_price`, `item_store_company`, `item_company_store_price`, `item_unit`, `item_lacks`, `item_company_customer_price`
- Accounting: `chart_of_accounts`, `company_chart_of_account`, `gl_journal_voucher_detail`, `company_modules`, `company_cost_centers`, `company_bank_accounts`, `system_balance`
- Inventory transactions: `issue_trans_header`, `issue_trans_header_ext`, `issue_transaction_items`, `balance_issue`, `balance_ret_issue`, `item_store_company_expiry`
- Retail/sales: `ratr_transaction_header`, `ratr_transaction_items`
- Payroll: `payslip_monthly_copy`, `allowan_deduction`, `emp_working_calender`
- Reports/temp: `characteristic_rep_form_i`, `payslip_report_temp_table`, `module_lang_tran_type_2`

High-frequency SQLCA symbols (`sqlca`, `sqlcode`, `sqlerrtext`, `connectioninfo`, `setsqselect`/`getsqlselect`) show extensive DataWindow-driven SQL through the PowerBuilder transaction object.

---

## 7. Devices, printing, and peripheral integrations

`fmg.ini` shows the application is configured for point-of-sale/retail use:

- Barcode reader and barcode printing enabled.
- Receipt printing enabled.
- Customer display and cash drawer flags present.
- Serial settings: `comport`, `BaudRate`, `Parity`, `StopBits`, `Wordlength`.
- Label templates in `common.pbd` include many Zebra/Canon/HP/Samsung datawindow labels.
- `[CallCenter]` and `[CallerId]` sections with modem/caller-ID settings.
- Backup path and “missed allowed” backup count.

These are configuration facts; actual device activity was not observed.

---

## 8. Protection and licensing

Observed indicators:

- `future.pbd`: `w_protect`, `change_pass.fun`, `of_securety23.fun`, `f_encrypte_x.fun`, `f_decrypte_x.fun`, `str_serial`, `str_protect`.
- `future.pbd` / `future (2).pbd00`: `Bconnect`, `B-CONNECT`, `Connectstring='DSN=`, `ls_dsname`, “Number send from Bconnect is not correct”, “You have exceeded the number of trials, Please call B-CONNECT”.
- Static path: `C:\Program Files\B-connect\Future license\FutureLicense.exe`.
- Contacts: `futurelicense@gmail.com`, `futureteam@bconnect`.
- `fmg.ini`: obfuscated `handler` and `[future] handler23` / `DB23` values.
- `key.txt`: two key-like strings.

**Inference:** a third-party B-CONNECT license/protection gate is likely involved in startup/serial validation. Exact checks were not decompiled.

---

## 9. Servers and network endpoints found

This answers the earlier “list every server it talks to” request. These are **static candidates**, not proven live connections.

| Type | Value | Source | Status |
|---|---|---|---|
| ODBC DSN | `SPICIAL_HQ` | `D:\future_25 - Special\fmg.ini` | Active |
| ODBC DSN | `store` | old/plain/Special nested `fmg.ini` | Active |
| ODBC DSN | `future` | Elshamy `fmg.ini` | Commented |
| ODBC DSN | `rady` | all `fmg.ini` copies | Commented |
| Server name | `sengam` | all `fmg.ini` copies | Commented/historical |
| Database | `fmgret5` | all `fmg.ini` copies | Commented/historical |
| DBMS | `MSS Microsoft SQL Server` | all `fmg.ini` copies | Commented/historical |
| URL | `http://www.devlib.net` | `rep_branchs.pbd` and one other file | Static string only |
| Email | `futurelicense@gmail.com` | `future (2).pbd00` | Contact, not server |
| Email | `futureteam@bconnect` | `future (2).pbd00` | Contact, not server |
| IP address | none | all scanned files | No IPv4 literals found |

The real DB endpoint is resolved from the Windows ODBC DSN at runtime. No network capture was performed, so actual connected hosts remain **unknown**.

---

## 10. REA evidence index

Selected retained Evidence IDs from this investigation:

| Operation | Target | Evidence ID |
|---|---|---|
| `inspect_pe_resources` | Special `future.exe` | `ev_a7255d987497dd1e7b1a9cc5022f966b5841cc2a8b1e09d504d1281381384008` |
| `inspect_pe_imports` | Special `future.exe` | `ev_8deee6cc27431f17b096b8888043ffc25c73d155c254aab84dabf44f324dc5b4` |
| `inspect_electron_fuses` | Special `future.exe` | `ev_7780780b5af605d314cc5acf4c69cb48f0af4ce9dc048abaf6c9b21651aa04e2` |
| `inspect_pe_resources` / imports | Special `Run_Pro.exe` | `ev_ff92c9b93ae1a22260ccb64294c99f350706bc41e47f0c5550923c78b499aa5d`, `ev_9a7c6be59a8ef2280cfb3ca5fe16a6a88d63137d33f3a3cdda5016f33086d47f` |
| `inspect_pe_resources` / imports | Special `run_scripts.exe` | `ev_2778a79ae5ed95143cbd7ba690fbb9665ecc1259eb30919b848a31f09b8e4898`, `ev_2d02b01d5c9479f160300b1017edf68abebcb72fd1070d1254238ffdc8ef28fe` |
| `inspect_windows_shortcut` | old / Special / plain `future_25.lnk` | `ev_0e26a8592ef9ab98dda4def16324219023e1323fc58fc7be568407a71e58bc90`, `ev_8f6bb6ace66b5a4b89c91f0dfa4e0db59d7d2275a472620f041f13db09c42def`, `ev_ba2e07b11952ec8b8d3a619d0ac46fb13c79d7daa5a7008d5ec3ed466d2c36e0` |
| `inspect_windows_shortcut` | Elshamy `Future 25.lnk` | `ev_6a542cdd319ae0123a2e57f8b1d8c97f9ba477e829ed7c728bf43462a53f07c0` |
| `inspect_pe_resources` / imports | Elshamy `future.exe` | `ev_da1caa767c357f4ae69e61e29b42f2d52065f1e9e2ea526403049d201f1d0395`, `ev_a98cf47b9a6298bdc09407cc3ec395463be8b1bc4eb16c234109eb5a47dc4e10` |
| `inspect_pe_resources` / imports | Elshamy `fashion.exe` | `ev_22b7db486b0d21c1618e346dcff38e7012dad07b42f41a53a35c3b7ee7658f75`, `ev_8a46d361819fb3ce83dbf1673e984979d1268d26c093641cb3d13615d8f45a1f` |
| `audit_release_exposure` | `D:\future_25 - Special` | `ev_ea436b6e52f5bea38392672bbe4a29031eebb54104d7d03ec85122614eb6c116` |

---

## 11. Limitations and unknowns

- Native REA engines (`ghidra`, `ida`, `kuna`, `jadx`) are not configured on this Windows host; compiled PBD bytecode was **not decompiled**.
- PBD/module roles are inferred from library filenames, object names, config sections, and SQL strings, not from disassembled code.
- The Windows ODBC registry/DSN definitions were not inspected; the actual DB host/driver is therefore unknown.
- `fmgret.db` is not SQLite and was not parsed table-by-table; DB engine identification is from header/embedded SQL Anywhere/MobiLink strings.
- No runtime observation, process capture, registry read, or network capture was performed, so no live connection or device action is proven.
- “Analysis on D drive” was limited to the four folders named by the user, not the entire `D:` volume.

---

## 12. Bottom line

Future 25 is a legacy PowerBuilder 9 ERP/POS application. It starts through a VB6 wrapper in most copies, loads a large set of compiled PBD modules through PBVM90, reads `fmg.ini` for ODBC DSN and workstation settings, connects to a Sybase SQL Anywhere database, and appears to synchronize branch data through MobiLink. The Elshamy copy is the most informative because it includes the actual database and transaction log. The only network URL found in the PBDs is `http://www.devlib.net`; database servers are referenced only through DSN names and commented legacy values.

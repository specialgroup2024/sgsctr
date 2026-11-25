# Future 25 — database schema

## Source and method

- Database: `D:\Future Elshamy\future25\Data\fmgret.db`
- Transaction log: `D:\Future Elshamy\future25\Data\fmgret.log`
- Engine: Adaptive Server Anywhere / SQL Anywhere 9.0.2.2451
- Original files were not opened read-write, modified, or executed. A temporary copy of the log was translated with SQL Anywhere `dbtran`.
- DDL was extracted from the translated log into `future25_schema.sql`.
- The DB login password was not available, so this is a transaction-log DDL recovery, not an authenticated live catalog export.

## Recovered DDL totals

| Item | Count |
|---|---:|
| CREATE TABLE statements | 321 |
| ALTER TABLE statements (mostly foreign keys) | 475 |
| CREATE INDEX statements | 36 |
| CREATE VIEW statements | 1 |
| Foreign-key clauses | 475 |
| Primary-key clauses | 297 |
| Total extracted DDL statements | 833 |

## Tables by functional area

| Area | Tables |
|---|---:|
| Accounting / finance | 45 |
| Application / support | 83 |
| Fixed assets | 6 |
| Inventory / stores | 87 |
| Payroll / HR | 27 |
| Purchasing | 12 |
| Sales / customers | 14 |
| Setup / security | 26 |
| System / PowerBuilder / MobiLink support | 21 |

## Largest table-name families

| Name prefix | Tables |
|---|---:|
| ITEM | 39 |
| GL | 18 |
| COMPANY | 15 |
| balance | 12 |
| EMP | 9 |
| fa | 7 |
| RATR | 6 |
| CUSTOMER | 6 |
| MODULE | 5 |
| PAYSLIP | 5 |
| VENDOR | 5 |
| ISSUE | 5 |
| PROMOTION | 5 |
| SALES | 4 |
| SECURITY | 4 |
| CHOICE | 4 |
| characteristic | 4 |
| DEMAND | 4 |
| PURCHASE | 4 |
| CUR | 4 |
| YEAR | 3 |
| SALARY | 3 |
| claim | 3 |
| equation | 3 |
| STORE | 3 |
| SYSTEM | 3 |
| CURRENCY | 2 |
| YEARLY | 2 |
| ORDERS | 2 |
| isc | 2 |
| ALLOWAN | 2 |
| cus | 2 |
| pbcatcol | 2 |
| REQUISITION | 2 |
| SHIFTS | 2 |
| CHART | 2 |
| branch | 2 |
| pbcatedt | 2 |
| PAY | 2 |
| ALLOWANCES | 2 |

## All tables

| Table (as logged) | Columns | Area |
|---|---:|---|
| DBA.account_autogenerator_case | 8 | Accounting / finance |
| DBA.ACCOUNT_CHART_TREE | 22 | Accounting / finance |
| DBA.alico | 7 | Application / support |
| DBA.ALLOWAN_DEDUC_GROUP | 7 | Payroll / HR |
| DBA.ALLOWAN_DEDUCTION | 21 | Payroll / HR |
| DBA.ALLOWANCES_ACCUMULATION_DETAIL | 9 | Accounting / finance |
| DBA.ALLOWANCES_ACCUMULATION_HEADER | 14 | Accounting / finance |
| DBA.ALTERNATE_ITEM | 8 | Inventory / stores |
| DBA.apsent_dates | 3 | Application / support |
| DBA.ATTENDANCE_SHEET | 19 | Payroll / HR |
| DBA.b2b_settings | 2 | Setup / security |
| DBA.bal_trace | 12 | Application / support |
| DBA.balance_adjustment | 18 | Inventory / stores |
| DBA.balance_issue | 18 | Inventory / stores |
| DBA.balance_issue_rm | 18 | Inventory / stores |
| DBA.balance_issue1 | 21 | Inventory / stores |
| DBA.balance_recieve | 18 | Inventory / stores |
| DBA.balance_recieve1 | 21 | Inventory / stores |
| DBA.balance_ret_issue | 18 | Inventory / stores |
| DBA.balance_ret_issue1 | 21 | Inventory / stores |
| DBA.balance_ret_rec | 18 | Inventory / stores |
| DBA.balance_ret_rec1 | 21 | Inventory / stores |
| DBA.balance_transf_in | 18 | Inventory / stores |
| DBA.balance_transf_out | 18 | Inventory / stores |
| DBA.BANK_ACCOUNT_TRANSACTION | 16 | Accounting / finance |
| DBA.BANK_ACCOUNT_TYPES | 8 | Accounting / finance |
| DBA.BANKS | 8 | Accounting / finance |
| DBA.BENEFIT | 7 | Payroll / HR |
| DBA.branch_items | 8 | Inventory / stores |
| DBA.branch_items_temp | 6 | Inventory / stores |
| DBA.branches | 5 | Inventory / stores |
| DBA.CAUSE | 8 | Application / support |
| DBA.characteristic_def | 11 | Application / support |
| DBA.characteristic_def_table | 4 | Application / support |
| DBA.characteristic_rep_form_h | 11 | Application / support |
| DBA.characteristic_rep_form_i | 9 | Application / support |
| DBA.CHART_OF_ACCOUNTS | 24 | Accounting / finance |
| DBA.CHART_OPEN_BAL | 9 | Application / support |
| DBA.CHOICE_DWO | 3 | System / PowerBuilder / MobiLink support |
| DBA.CHOICE_MODIFIED_COLUMNS | 7 | System / PowerBuilder / MobiLink support |
| DBA.CHOICE_SPECS | 4 | System / PowerBuilder / MobiLink support |
| DBA.CHOICE_TYPES | 2 | System / PowerBuilder / MobiLink support |
| DBA.claim_detail | 17 | Application / support |
| DBA.claim_header | 16 | Application / support |
| DBA.claim_print_followup | 5 | Application / support |
| DBA.class | 1 | Application / support |
| DBA.COLUMN_DEPENDENCIES | 4 | System / PowerBuilder / MobiLink support |
| DBA.com_job | 15 | Application / support |
| DBA.COM_MEDICAL_INS | 20 | Payroll / HR |
| DBA.COMP_HOLIDAY_RULE_DETAIL | 10 | Application / support |
| DBA.COMP_HOLIDAY_RULE_MASTER | 8 | Application / support |
| DBA.COMPANY | 66 | Setup / security |
| DBA.COMPANY_ACCOUNT_CHART_TREE | 12 | Accounting / finance |
| DBA.COMPANY_BANK_ACCOUNTS | 10 | Accounting / finance |
| DBA.COMPANY_CHART_OF_ACCOUNT | 33 | Accounting / finance |
| DBA.COMPANY_COST_CENTERS | 19 | Accounting / finance |
| DBA.COMPANY_COST_CENTERS_ORG | 20 | System / PowerBuilder / MobiLink support |
| DBA.COMPANY_MODULES | 4 | Setup / security |
| DBA.COMPANY_NATURE | 9 | Setup / security |
| DBA.COMPANY_SALESMAN | 12 | Sales / customers |
| DBA.COMPANY_SERIALS | 10 | Setup / security |
| DBA.COMPANY_STORES | 16 | Inventory / stores |
| DBA.COMPANY_STORES_SERIALS | 11 | Inventory / stores |
| DBA.company_trans_type3 | 18 | Setup / security |
| DBA.COMPANY_TYPE | 7 | Setup / security |
| DBA.COMPANY_VENDORS | 42 | Purchasing |
| DBA.contract_detail | 23 | Application / support |
| DBA.contract_master | 26 | Application / support |
| DBA.COST_CENTERS | 22 | Accounting / finance |
| DBA.COUNTRY | 21 | Application / support |
| DBA.credit_report | 5 | Application / support |
| DBA.CST_JOB_ORDER_DETAIL | 16 | Accounting / finance |
| DBA.CST_JOB_ORDER_HEADER | 33 | Accounting / finance |
| DBA.CUR_DETAIL_TABLE | 37 | Application / support |
| DBA.CUR_FACILITY_GROUP_DISCOUNT | 19 | Sales / customers |
| DBA.CUR_FACILITY_ITEM_DISCOUNT | 14 | Inventory / stores |
| DBA.CUR_FACILITY_TABLE | 34 | Application / support |
| DBA.CURRENCY | 8 | Accounting / finance |
| DBA.CURRENCY_EXCHANGE | 11 | Accounting / finance |
| DBA.CURRENT_SETTINGS | 16 | Setup / security |
| DBA.cus_contract | 14 | Application / support |
| DBA.cus_diseases | 9 | Payroll / HR |
| DBA.CUSTOMER | 71 | Sales / customers |
| DBA.CUSTOMER_COMAPNY | 48 | Sales / customers |
| DBA.customer_complain_inquire | 14 | Sales / customers |
| DBA.customer_ext | 21 | Sales / customers |
| DBA.CUSTOMER_ITEM_GROUP_DISCOUNT | 18 | Inventory / stores |
| DBA.CUSTOMER_OPEN_BAL | 9 | Sales / customers |
| DBA.datawindow_character | 16 | Application / support |
| DBA.DEMAND_REPORT_HEADER | 9 | Application / support |
| DBA.DEMAND_REPORT_ITEMS | 13 | Inventory / stores |
| DBA.DEMAND_REPORT_REQ | 9 | Application / support |
| DBA.DEMAND_REPORT_VENDORS | 14 | Purchasing |
| DBA.diseases | 10 | Payroll / HR |
| DBA.DRUG_INTERACTION_ITEM | 7 | Inventory / stores |
| DBA.DW_COLUMN_SPECS | 5 | System / PowerBuilder / MobiLink support |
| DBA.DW_SPECS | 2 | System / PowerBuilder / MobiLink support |
| DBA.EDUCATION_SEPC | 22 | Application / support |
| DBA.EMP_ALL_DED | 9 | Payroll / HR |
| DBA.EMP_ALL_DED_EDIT_VALUE | 10 | Payroll / HR |
| DBA.EMP_BANKS | 11 | Accounting / finance |
| DBA.EMP_BENEFITS | 10 | Payroll / HR |
| DBA.EMP_HOLIDAY_BALANCE | 8 | Inventory / stores |
| DBA.EMP_HOLIDAY_OB | 8 | Payroll / HR |
| DBA.EMP_MEDICAL_INS | 8 | Payroll / HR |
| DBA.EMP_TEMP_TABLE2 | 16 | Payroll / HR |
| DBA.EMP_WORKING_CALENDER | 8 | Payroll / HR |
| DBA.EMPLOYEE | 68 | Payroll / HR |
| DBA.equation_in_parameters | 13 | Setup / security |
| DBA.equation_setup | 19 | Application / support |
| DBA.equation_setup_journal | 14 | Accounting / finance |
| DBA.fa_asset_card | 34 | Fixed assets |
| DBA.fa_asset_class | 51 | Fixed assets |
| DBA.fa_asset_serials | 3 | Fixed assets |
| DBA.fa_asset_setup | 17 | Fixed assets |
| DBA.fa_asset_trans_detail | 53 | Fixed assets |
| DBA.fa_asset_trans_header | 20 | Fixed assets |
| DBA.fa_dep_journal_voucher_detail | 25 | Accounting / finance |
| DBA.FIAT_TABLE | 7 | Application / support |
| DBA.financial_claim_setup | 29 | Accounting / finance |
| DBA.foad | 9 | Application / support |
| DBA.FOOD | 7 | Application / support |
| DBA.FOOD_DRUG_INTERACTION | 7 | Payroll / HR |
| DBA.Future_menus | 26 | Application / support |
| DBA.GENERAL_RULE | 57 | Application / support |
| DBA.GIFTS_AND_BONUS | 22 | Application / support |
| DBA.GL_BALANCE_SHEET_CALC | 16 | Accounting / finance |
| DBA.GL_BALANCE_SHEET_SETUP | 31 | Accounting / finance |
| DBA.gl_balance_sheet_setup_detail | 6 | Accounting / finance |
| DBA.GL_BANK_DETAIL_SUMMARY | 17 | Accounting / finance |
| DBA.GL_BUDGET | 10 | Accounting / finance |
| DBA.GL_COST_CENTER_DETAIL | 18 | Accounting / finance |
| DBA.GL_COST_CENTER_SUMMERY | 15 | Accounting / finance |
| DBA.GL_INTEGERATION_ACCOUNTS | 15 | Accounting / finance |
| DBA.GL_JOURNAL_VOUCHER_DETAIL | 45 | Accounting / finance |
| DBA.GL_JOURNAL_VOUCHER_HEADER | 37 | Accounting / finance |
| DBA.GL_JV_SUMMERY | 15 | Accounting / finance |
| DBA.GL_LABEL | 6 | Accounting / finance |
| DBA.GL_NOTES_MODIFICATIONS | 13 | Accounting / finance |
| DBA.GL_PAPAER | 35 | Accounting / finance |
| DBA.GL_PAPER_COLLECTION_DETAIL | 18 | Accounting / finance |
| DBA.GL_PAPER_COLLECTION_HEADER | 13 | Accounting / finance |
| DBA.GL_PERIOD | 8 | Accounting / finance |
| DBA.GL_VOUCHER_DETAIL_DIST | 30 | Accounting / finance |
| DBA.GROUP_CUSTOMER_PRICE | 16 | Sales / customers |
| DBA.hire_type | 4 | Application / support |
| DBA.HOLIDAY | 10 | Application / support |
| DBA.INDUSTRY | 7 | Application / support |
| DBA.ins_off_table | 10 | Application / support |
| DBA.INSURANCE_TAX | 30 | Accounting / finance |
| DBA.ip_settings | 2 | Setup / security |
| DBA.isc_exp_from_transaction | 13 | Application / support |
| DBA.isc_from_transaction | 12 | Application / support |
| DBA.iss_header_print_followup | 8 | Application / support |
| DBA.issue_trans_header | 61 | Inventory / stores |
| DBA.ISSUE_TRANS_HEADER_EXT | 39 | Inventory / stores |
| DBA.issue_trans_items_ext | 29 | Inventory / stores |
| DBA.issue_transaction_items | 38 | Inventory / stores |
| DBA.issue_types | 5 | Inventory / stores |
| DBA.ITEM_BOUNS_DETAIL | 13 | Inventory / stores |
| DBA.ITEM_BOUNS_HEADER | 22 | Inventory / stores |
| DBA.ITEM_CATEGORY | 9 | Inventory / stores |
| DBA.item_chek_qty | 10 | Inventory / stores |
| DBA.ITEM_COLOR | 9 | Inventory / stores |
| DBA.ITEM_COMPANY | 58 | Inventory / stores |
| DBA.ITEM_COMPANY_CUSTOMER_PRICE | 14 | Inventory / stores |
| DBA.ITEM_COMPANY_PRICE | 20 | Inventory / stores |
| DBA.ITEM_COMPANY_STORE_PRICE | 17 | Inventory / stores |
| DBA.ITEM_COMPANY_VENDOR | 14 | Inventory / stores |
| DBA.ITEM_COMPANY_VENDOR_1 | 14 | Inventory / stores |
| DBA.ITEM_COMPANY_VENDOR_PRICE | 14 | Inventory / stores |
| DBA.item_cus_issue_hist | 10 | Inventory / stores |
| DBA.ITEM_CUSTOMER | 7 | Inventory / stores |
| DBA.item_errors_from_issue_and_ratr | 12 | System / PowerBuilder / MobiLink support |
| DBA.item_exp_errors_from_issue_and_ratr | 11 | System / PowerBuilder / MobiLink support |
| DBA.ITEM_GENDER | 9 | Inventory / stores |
| DBA.ITEM_GROUPS | 21 | Inventory / stores |
| DBA.item_lacks | 13 | Inventory / stores |
| DBA.item_lacks_local | 10 | Inventory / stores |
| DBA.ITEM_MASTER | 104 | Inventory / stores |
| DBA.item_matched | 4 | Inventory / stores |
| DBA.ITEM_MODEL | 9 | Inventory / stores |
| DBA.ITEM_NATURE | 8 | Inventory / stores |
| DBA.item_new | 19 | Inventory / stores |
| DBA.ITEM_PURCHASE_HIST | 14 | Inventory / stores |
| DBA.ITEM_RFQ | 13 | Inventory / stores |
| DBA.ITEM_SEASON | 9 | Inventory / stores |
| DBA.ITEM_SIZE | 9 | Inventory / stores |
| DBA.item_store_comp_ven_followup | 9 | Inventory / stores |
| DBA.ITEM_STORE_COMPANY | 53 | Inventory / stores |
| DBA.ITEM_STORE_COMPANY_EXPIRY | 9 | Inventory / stores |
| DBA.ITEM_STORE_OPEN_BAL | 17 | Inventory / stores |
| DBA.ITEM_STORE_OPEN_BAL_DETAIL | 11 | Inventory / stores |
| DBA.ITEM_TYPE | 9 | Inventory / stores |
| DBA.ITEM_UNIT | 8 | Inventory / stores |
| DBA.ITEM_UNITS_CONVERSION | 8 | Inventory / stores |
| DBA.item_vendor_dowload | 34 | Inventory / stores |
| DBA.item_vendor_dowload_temp | 34 | Inventory / stores |
| DBA.JOB_TITLE | 7 | Application / support |
| DBA.LANGUAGE | 8 | Application / support |
| DBA.LAST_SHIFT | 9 | Application / support |
| DBA.licenses_modules | 8 | Setup / security |
| DBA.LIVELS_CODES | 7 | Application / support |
| DBA.lupdate | 4 | Application / support |
| DBA.MANUAL_IN_OUT | 8 | Application / support |
| DBA.manufactures | 5 | Application / support |
| DBA.matrix_setup | 19 | Application / support |
| DBA.MEDICAL_INS_TREE | 22 | Payroll / HR |
| DBA.menus_tabes | 3 | Application / support |
| DBA.MODULE_LANG_TRAN_TYPE_1 | 9 | Setup / security |
| DBA.MODULE_LANG_TRAN_TYPE_2 | 9 | Setup / security |
| DBA.MODULE_LANGUAGE | 7 | Setup / security |
| DBA.MODULE_TRANSACTIONS | 11 | Setup / security |
| DBA.MODULE_TRANSACTIONS_GL_ACCOUNT | 27 | Accounting / finance |
| DBA.MODULES | 8 | Setup / security |
| DBA.NATIONALITY | 7 | Application / support |
| DBA.newcodes | 7 | Application / support |
| DBA.OPEN_BAL_ITEM_COMPANY | 8 | Inventory / stores |
| DBA.ORDER_LINES_TABLE | 17 | Purchasing |
| DBA.ORDERS_HEADER_TABEL | 15 | System / PowerBuilder / MobiLink support |
| DBA.ORDERS_QUANTITY_TABLE | 9 | System / PowerBuilder / MobiLink support |
| DBA.ORGANIZATION_CHART | 22 | Application / support |
| DBA.organize_follow_up_transfers | 8 | Inventory / stores |
| DBA.organize_prepare_claim | 7 | Application / support |
| DBA.PAY_SLIP_CALC | 11 | Payroll / HR |
| DBA.PAY_SLIP_SETUP | 15 | Payroll / HR |
| DBA.payroll_jv_acc_header_setup | 15 | Accounting / finance |
| DBA.PAYROLL_JV_ACC_LINES_SETUP | 10 | Accounting / finance |
| DBA.PAYSLIP_CALC_MONTH | 9 | Payroll / HR |
| DBA.PAYSLIP_MONTHLY | 11 | Payroll / HR |
| DBA.payslip_monthly_copy | 17 | Payroll / HR |
| DBA.PAYSLIP_REPORT_TEMP_TABLE | 26 | Payroll / HR |
| DBA.PAYSLIP_SHEET_SETUP | 8 | Payroll / HR |
| "backup".pbcatcol | 20 | System / PowerBuilder / MobiLink support |
| DBA.pbcatcol | 20 | System / PowerBuilder / MobiLink support |
| "backup".pbcatedt | 7 | System / PowerBuilder / MobiLink support |
| DBA.pbcatedt | 7 | System / PowerBuilder / MobiLink support |
| DBA.pbcatfmt | 4 | System / PowerBuilder / MobiLink support |
| "backup".pbcatfmt | 4 | System / PowerBuilder / MobiLink support |
| "backup".pbcattbl | 25 | System / PowerBuilder / MobiLink support |
| "backup".pbcatvld | 5 | System / PowerBuilder / MobiLink support |
| DBA.pbcatvld | 5 | System / PowerBuilder / MobiLink support |
| DBA.prepare_claim | 9 | Application / support |
| DBA.PRICE_TYPE | 8 | Sales / customers |
| DBA.print_foter_txt | 5 | Application / support |
| DBA.promotion | 12 | Application / support |
| DBA.PROMOTION_GROUB_DETAIL | 13 | Application / support |
| DBA.PROMOTION_HEADER | 14 | Application / support |
| DBA.PROMOTION_ITEMS_DETAIL | 8 | Inventory / stores |
| DBA.promotion_temp | 9 | Payroll / HR |
| DBA.PURCHASE_ORDER_HEADER | 44 | Purchasing |
| DBA.PURCHASE_ORDER_ITEMS | 35 | Inventory / stores |
| DBA.purchase_order_send | 3 | Purchasing |
| DBA.PURCHASE_ORDER_STORE_ITEMS | 19 | Inventory / stores |
| DBA.quta | 13 | Application / support |
| DBA.RATR_TRANSACTION_HEADER | 46 | Application / support |
| DBA.RATR_TRANSACTION_HEADER_COST | 14 | Accounting / finance |
| DBA.RATR_TRANSACTION_HEADER_PO | 13 | Application / support |
| DBA.ratr_transaction_header_temp | 46 | Payroll / HR |
| DBA.RATR_TRANSACTION_ITEMS | 44 | Inventory / stores |
| DBA.ratr_transaction_items_temp | 44 | Inventory / stores |
| DBA.reference_for_transfer_between_branches | 14 | Inventory / stores |
| DBA.REPEATED_TRANSACTION | 18 | Application / support |
| DBA.REPLACEMENT_ITEM | 9 | Inventory / stores |
| DBA.REQUEST_FOR_QUOTATION | 14 | Application / support |
| DBA.REQUISITION_HEADER | 18 | Application / support |
| DBA.REQUISITION_ITEMS | 14 | Inventory / stores |
| DBA.SALARY_TIME_EFFECT | 14 | Sales / customers |
| DBA.salary_transaction_detail | 15 | Sales / customers |
| DBA.salary_transaction_header | 14 | Sales / customers |
| DBA.sales_order_followup | 21 | Purchasing |
| DBA.sales_order_header | 24 | Purchasing |
| DBA.sales_order_items | 16 | Inventory / stores |
| DBA.SALES_TAX_TRANSACTION | 15 | Accounting / finance |
| DBA.SALESMAN | 33 | Sales / customers |
| DBA.script_status | 4 | Application / support |
| DBA.SECTORS | 7 | Setup / security |
| DBA.SECURITY_GROUPINGS | 2 | Setup / security |
| DBA.SECURITY_INFO | 4 | Setup / security |
| DBA.SECURITY_TEMPLATE | 4 | Payroll / HR |
| DBA.SECURITY_USERS | 6 | Setup / security |
| DBA.SERIALS | 2 | Application / support |
| DBA.shift_report | 12 | Application / support |
| DBA.SHIFTS | 8 | Application / support |
| DBA.SHIFTS_MONEY | 75 | Application / support |
| DBA.shortcut_setup | 12 | Application / support |
| DBA.SOCIAL_STATUS | 9 | Application / support |
| DBA.STORE_DATE_SERIAL | 7 | Inventory / stores |
| DBA.store_date_serial_ext | 9 | Inventory / stores |
| DBA.STORE_TYPES | 8 | Inventory / stores |
| DBA.STORES | 20 | Inventory / stores |
| DBA.system_balance | 38 | Inventory / stores |
| DBA.SYSTEM_MESSAGES | 8 | Setup / security |
| DBA.SYSTEM_PARAMETER | 12 | Setup / security |
| DBA.sysuserperm | 8 | Setup / security |
| DBA.t_db | 2 | Application / support |
| DBA.TABLE_COLUMNS_SPECS | 8 | Application / support |
| DBA.TABLE_SPECS | 5 | Application / support |
| DBA.TIME_DESIGNATOR_DAILY | 15 | Application / support |
| DBA.TIME_SHEET_TRANSACTION | 24 | Application / support |
| DBA.trans_details | 5 | Application / support |
| DBA.trans_items | 2 | Inventory / stores |
| DBA.UNIQUE_COLUMNS | 8 | Application / support |
| DBA.update_item_balance | 8 | Inventory / stores |
| DBA.updated_items | 15 | Inventory / stores |
| DBA.USER_COMPANY | 3 | Setup / security |
| DBA.USER_COMPANY_STORE | 4 | Inventory / stores |
| DBA.VENDOR | 40 | Purchasing |
| DBA.vendor_b2b | 3 | Purchasing |
| DBA.VENDOR_OPEN_BAL | 9 | Purchasing |
| DBA.VENDOR_QUOTATION | 17 | Purchasing |
| DBA.VENDOR_QUOTATION_ITEMS | 15 | Inventory / stores |
| DBA."WINDOW" | 3 | Application / support |
| DBA.WORK_STATION | 7 | Setup / security |
| DBA.WORK_STATION_COMPANY | 9 | Setup / security |
| DBA.WORKING_CALENDER | 27 | Application / support |
| DBA.YEAR_COMPANY_VENDOR | 16 | Purchasing |
| DBA.YEAR_CUSTOMER_COMPANY | 16 | Sales / customers |
| DBA.YEAR_ITEM_STORE_COMPANY | 17 | Inventory / stores |
| DBA.YEARLY_INCREASE_DETAIL | 10 | Application / support |
| DBA.YEARLY_INCREASE_HEADER | 11 | Application / support |

## Notes

- Column counts are derived from the recovered `CREATE TABLE` text and exclude inline constraints.
- Constraints and indexes were logged separately and are included in `future25_schema.sql`.
- Support tables such as `pbcat*`, `DW_SPECS`, `CHOICE_*`, `ml_*`, and `ul_*` are part of the recovered schema but are not business data tables.
- Business tables cluster around accounting/finance, inventory/stores, sales/customers, purchasing, payroll/HR, and setup/security.
- The SQL file preserves schema-qualified names exactly as logged (for example `DBA.COMPANY` and `"backup".pbcatcol`).

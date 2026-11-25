-- Future 25 database schema recovered from SQL Anywhere transaction log
-- Source: D:\Future Elshamy\future25\Data\fmgret.log
-- Method: read-only dbtran translation, DDL statements extracted; no target file modified
-- Statements: 321 tables, 475 ALTER TABLE constraints, 36 indexes, 1 views

create table DBA.pbcatcol(
  pbc_tnam char(129) not null,
  pbc_tid integer null,
  pbc_ownr char(129) not null,
  pbc_cnam char(129) not null,
  pbc_cid smallint null,
  pbc_labl char(254) null,
  pbc_lpos smallint null,
  pbc_hdr char(254) null,
  pbc_hpos smallint null,
  pbc_jtfy smallint null,
  pbc_mask char(31) null,
  pbc_case smallint null,
  pbc_hght smallint null,
  pbc_wdth smallint null,
  pbc_ptrn char(31) null,
  pbc_bmap char(1) null,
  pbc_init char(254) null,
  pbc_cmnt char(254) null,
  pbc_edit char(31) null,
  pbc_tag char(254) null,
  );

create table DBA.pbcatfmt(
  pbf_name char(30) not null,
  pbf_frmt char(254) null,
  pbf_type smallint null,
  pbf_cntr integer null,
  );

create table DBA.pbcatvld(
  pbv_name char(30) not null,
  pbv_vald char(254) null,
  pbv_type smallint null,
  pbv_cntr integer null,
  pbv_msg char(254) null,
  );

create table DBA.pbcatedt(
  pbe_name char(30) not null,
  pbe_edit char(254) null,
  pbe_type smallint null,
  pbe_cntr integer null,
  pbe_seqn smallint not null,
  pbe_flag integer null,
  pbe_work char(32) null,
  );

create table DBA.DW_SPECS(
  DS_DWO_NAME varchar(60) not null,
  DS_FIRST_COLUMN varchar(60) not null,
  primary key( DS_DWO_NAME) ,
  );

create table DBA.CHOICE_TYPES(
  CHT_TYPE_NAME varchar(60) not null,
  CHT_TYPE_DESCRIPTION varchar(100) null,
  primary key( CHT_TYPE_NAME) ,
  );

create table DBA.CHOICE_SPECS(
  DS_DWO_NAME varchar(60) not null,
  CHS_CHOICE_CODE varchar(30) not null,
  CHT_TYPE_NAME varchar(60) not null,
  CHS_CHOICE_WINDOW varchar(60) null,
  primary key( DS_DWO_NAME,
  CHS_CHOICE_CODE) ,
  );

create table DBA.DW_COLUMN_SPECS(
  DS_DWO_NAME varchar(60) not null,
  DCS_COLUMN_NAME char(60) not null,
  CHO_DS_DWO_NAME varchar(60) null,
  CHS_CHOICE_CODE varchar(30) null,
  DCS_SENSITIVITY char(1) null,
  primary key( DS_DWO_NAME,
  DCS_COLUMN_NAME) ,
  );

create table DBA.CHOICE_DWO(
  DS_DWO_NAME varchar(60) not null,
  CHS_CHOICE_CODE varchar(30) not null,
  CDW_DWO_NAME varchar(60) not null,
  primary key( DS_DWO_NAME,
  CHS_CHOICE_CODE,CDW_DWO_NAME) ,
  );

create table DBA.CHOICE_MODIFIED_COLUMNS(
  CMC_COLUMN_NAME varchar(60) not null,
  DS_DWO_NAME varchar(60) null,
  CHS_CHOICE_CODE varchar(30) null,
  CHO_DS_DWO_NAME varchar(60) null,
  CHO_CHS_CHOICE_CODE varchar(30) null,
  CDW_DWO_NAME varchar(60) null,
  CMC_CHOICE_COLUMN_NAME varchar(60) null,
  primary key( CMC_COLUMN_NAME) ,
  );

create table DBA.COLUMN_DEPENDENCIES(
  DW__DS_DWO_NAME varchar(60) not null,
  DW__DCS_COLUMN_NAME char(60) not null,
  DS_DWO_NAME varchar(60) not null,
  DCS_COLUMN_NAME char(60) not null,
  primary key( DW__DS_DWO_NAME,
  DW__DCS_COLUMN_NAME,DS_DWO_NAME,DCS_COLUMN_NAME) ,
  );

create table DBA.STORE_TYPES(
  STT_CODE char(3) not null,
  STT_NAME_L1 varchar(60) not null,
  STT_NAME_L2 varchar(60) null,
  STT_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( STT_CODE) ,
  );

create table DBA.CURRENCY(
  CUR_CODE char(3) not null,
  CUR_NAME_L1 varchar(60) not null,
  CUR_NAME_L2 varchar(60) null,
  CUR_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( CUR_CODE) ,
  );

create table DBA.COUNTRY(
  COU_CODE_L1 char(3) not null,
  COU_CODE_L2 char(3) not null,
  COU_CODE_L3 char(3) not null,
  COU_CODE_L4 char(3) not null,
  COU_CODE_L5 char(3) not null,
  COU_CODE_L6 char(3) not null,
  COU_PARENT_CODE_L1 char(3) null,
  COU_PARENT_CODE_L2 char(3) null,
  COU_PARENT_CODE_L3 char(3) null,
  COU_PARENT_CODE_L4 char(3) null,
  COU_PARENT_CODE_L5 char(3) null,
  COU_PARENT_CODE_L6 char(3) null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COU_CODE_L1,
  COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6) ,
  );

create table DBA.ITEM_GROUPS(
  ITG_CODE_L1 char(3) not null,
  ITG_CODE_L2 char(3) not null,
  ITG_CODE_L3 char(3) not null,
  ITG_CODE_L4 char(3) not null,
  ITG_CODE_L5 char(3) not null,
  ITG_CODE_L6 char(3) not null,
  ITG_PARENT_CODE_L1 char(3) null,
  ITG_PARENT_CODE_L2 char(3) null,
  ITG_PARENT_CODE_L3 char(3) null,
  ITG_PARENT_CODE_L4 char(3) null,
  ITG_PARENT_CODE_L5 char(3) null,
  ITG_PARENT_CODE_L6 char(3) null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITG_CODE_L1,
  ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6) ,
  );

create table DBA.COST_CENTERS(
  COC_CODE_L1 char(3) not null,
  COC_CODE_L2 char(3) not null,
  COC_CODE_L3 char(3) not null,
  COC_CODE_L4 char(3) not null,
  COC_CODE_L5 char(3) not null,
  COC_CODE_L6 char(3) not null,
  COC_PARENT_CODE_L1 char(3) null,
  COC_PARENT_CODE_L2 char(3) null,
  COC_PARENT_CODE_L3 char(3) null,
  COC_PARENT_CODE_L4 char(3) null,
  COC_PARENT_CODE_L5 char(3) null,
  COC_PARENT_CODE_L6 char(3) null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  USED_FLAG char(1) null,
  primary key( COC_CODE_L1,
  COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6) ,
  );

create table DBA.ORGANIZATION_CHART(
  ORG_CODE_L1 char(3) not null,
  ORG_CODE_L2 char(3) not null,
  ORG_CODE_L3 char(3) not null,
  ORG_CODE_L4 char(3) not null,
  ORG_CODE_L5 char(3) not null,
  ORG_CODE_L6 char(3) not null,
  ORG_PARENT_CODE_L1 char(3) null,
  ORG_PARENT_CODE_L2 char(3) null,
  ORG_PARENT_CODE_L3 char(3) null,
  ORG_PARENT_CODE_L4 char(3) null,
  ORG_PARENT_CODE_L5 char(3) null,
  ORG_PARENT_CODE_L6 char(3) null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  ORG_SALARIES_BUDGET numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ORG_CODE_L1,
  ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6) ,
  );

create table DBA.COMPANY_TYPE(
  CTY_CODE char(3) not null,
  CTY_NAME_L1 varchar(60) not null,
  CTY_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( CTY_CODE) ,
  );

create table DBA.COMPANY_NATURE(
  CNA_CODE char(3) not null,
  CNA_NAME_L1 varchar(60) not null,
  CNA_NAME_L2 varchar(60) null,
  CNA_IS_RELATED char(1) not null,
  CNA_IS_HOLDING char(1) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( CNA_CODE) ,
  );

create table DBA.PRICE_TYPE(
  PRT_CODE char(3) not null,
  PRT_NAME_L1 varchar(60) not null,
  PRT_NAME_L2 varchar(60) null,
  PRT_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( PRT_CODE) ,
  );

create table DBA.ITEM_UNIT(
  ITU_CODE char(3) not null,
  ISP_NAME_L1 varchar(60) not null,
  ISP_NAME_L2 varchar(60) null,
  ISP_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITU_CODE) ,
  );

create table DBA.ITEM_NATURE(
  ITN_CODE char(3) not null,
  ISP_NAME_L1 varchar(60) not null,
  ISP_NAME_L2 varchar(60) null,
  ISP_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITN_CODE) ,
  );

create table DBA.ITEM_MODEL(
  IMO_CODE char(20) not null,
  ISP_NAME_L1 varchar(60) not null,
  ISP_NAME_L2 varchar(60) null,
  ISP_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  imo_picture varchar(30) null,
  primary key( IMO_CODE) ,
  );

create table DBA.ITEM_COLOR(
  ITC_CODE char(20) not null,
  ISP_NAME_L1 varchar(60) not null,
  ISP_NAME_L2 varchar(60) null,
  ISP_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  itc_picture varchar(30) null,
  primary key( ITC_CODE) ,
  );

create table DBA.ITEM_SIZE(
  ITS_CODE char(20) not null,
  ISP_NAME_L1 varchar(60) not null,
  ISP_NAME_L2 varchar(60) null,
  ISP_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  its_picture varchar(30) null,
  primary key( ITS_CODE) ,
  );

create table DBA.INDUSTRY(
  INDUSTRY_CODE char(3) not null,
  INDUSTRY_NAME_1 varchar(60) not null,
  INDUSTRY_NAME_2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( INDUSTRY_CODE) ,
  );

create table DBA.SECTORS(
  SECTOR_CODE char(3) not null,
  SECTOR_NAME_1 varchar(60) not null,
  SECTOR_NAME_2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( SECTOR_CODE) ,
  );

create table DBA.LANGUAGE(
  LNG_ID char(3) not null,
  LNG_NAME char(15) not null,
  LNG_ORIENTATION numeric(1) not null,
  LNG_NUMBER integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( LNG_ID) ,
  );

create table DBA.STORES(
  STO_CODE char(3) not null,
  STT_CODE char(3) not null,
  COU_CODE_L1 char(3) null,
  COU_CODE_L2 char(3) null,
  COU_CODE_L3 char(3) null,
  COU_CODE_L4 char(3) null,
  COU_CODE_L5 char(3) null,
  COU_CODE_L6 char(3) null,
  STO_NAME_L1 varchar(60) not null,
  STO_NAME_L2 varchar(60) null,
  STO_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRT_SERIAL double null,
  STO_MAIN_PURCHASE char(1) null,
  STO_REORDER_COVER_DAY smallint null,
  STO_MAX_COVER_DAY smallint null,
  br_serial double null,
  primary key( STO_CODE) ,
  );

create table DBA.VENDOR(
  VEN_SERIAL double not null,
  VEN_CODE varchar(30) not null,
  COU_CODE_L1 char(3) null,
  COU_CODE_L2 char(3) null,
  COU_CODE_L3 char(3) null,
  COU_CODE_L4 char(3) null,
  COU_CODE_L5 char(3) null,
  COU_CODE_L6 char(3) null,
  CUR_CODE char(3) null,
  VEN_NAME_L1 varchar(60) not null,
  VEN_NAME_L2 varchar(60) null,
  VEN_TYPE char(1) not null,
  VEN_NATURE char(1) not null,
  VEN_MANAGER_1 varchar(60) null,
  VEN_MANAGER_2 varchar(60) null,
  VEN_MANAGER_3 varchar(60) null,
  VEN_ADDRESS varchar(100) null,
  VEN_TELEPHONE_1 varchar(15) null,
  VEN_TELEPHONE_2 varchar(15) null,
  VEN_FAX_1 varchar(15) null,
  VEN_FAX_2 varchar(15) null,
  VEN_TELEX varchar(15) null,
  VEN_POSTAL_NUMBER varchar(15) null,
  VEN_DEALING_TYPE char(2) not null,
  VEN_BANK_ACCOUNT varchar(15) null,
  VEN_GL_ACCOUNT char(6) null,
  VEN_TAX_NUMBER char(6) null,
  VEN_SALES_TAX_NUMBER varchar(20) null,
  HOLDING_VEN_SERIAL double null,
  VEN_COMPANY_TYPE varchar(40) null,
  VEN_FACILITIES_TYPE char(1) null,
  VEN_FACILITIES_DAY integer null,
  VEN_FACILITIES_VALUE numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  SATUS_FLAG char(1) null,
  CHRT_SERIAL double null,
  VEN_POST_ON_MAIN char(1) null,
  primary key( VEN_SERIAL) ,
  );

create table DBA.COMPANY(
  COM_CODE char(3) not null,
  CNA_CODE char(3) not null,
  CTY_CODE char(3) not null,
  COM_HOLDING_CODE char(3) null,
  CUR_CODE char(3) not null,
  COM_NAME_L1 varchar(60) not null,
  COM_NAME_L2 varchar(60) null,
  COM_TRADE_NAME_L1 varchar(60) null,
  COM_TRADE_NAME_L2 varchar(60) null,
  COM_CHAIRMAN varchar(60) null,
  COM_ADDRESS varchar(100) null,
  COM_TELEPHONE_1 varchar(15) null,
  COM_TELEPHONE_2 varchar(15) null,
  COM_FAX_1 varchar(15) null,
  COM_FAX_2 varchar(15) null,
  COM_POSTAL_NUMBER varchar(15) null,
  COM_TELEX varchar(15) null,
  COM_CREATION_DATE timestamp not null,
  COM_FISCAL_YEAR_START char(4) not null,
  COM_ALLOWANCE_PERIOD numeric(2) not null,
  COM_FISCAL_START_1 timestamp not null,
  COM_FISCAL_START_2 timestamp not null,
  COM_FISCAL_START_3 timestamp not null,
  COM_FISCAL_START_4 timestamp not null,
  COM_FISCAL_START_5 timestamp not null,
  COM_FISCAL_START_6 timestamp not null,
  COM_FISCAL_START_7 timestamp not null,
  COM_FISCAL_START_8 timestamp not null,
  COM_FISCAL_START_9 timestamp not null,
  COM_FISCAL_START_10 timestamp not null,
  COM_FISCAL_START_11 timestamp not null,
  COM_FISCAL_START_12 timestamp not null,
  COM_FISCAL_END_1 timestamp not null,
  COM_FISCAL_END_2 timestamp not null,
  COM_FISCAL_END_3 timestamp not null,
  COM_FISCAL_END_4 timestamp not null,
  COM_FISCAL_END_5 timestamp not null,
  COM_FISCAL_END_6 timestamp not null,
  COM_FISCAL_END_7 timestamp not null,
  COM_FISCAL_END_8 timestamp not null,
  COM_FISCAL_END_9 timestamp not null,
  COM_FISCAL_END_10 timestamp not null,
  COM_FISCAL_END_11 timestamp not null,
  COM_FISCAL_END_12 timestamp not null,
  com_fiscal_start_c_1 char(4) null,
  com_fiscal_start_c_2 char(4) null,
  com_fiscal_start_c_3 char(4) null,
  com_fiscal_start_c_4 char(4) null,
  com_fiscal_start_c_5 char(4) null,
  com_fiscal_start_c_6 char(4) null,
  com_fiscal_start_c_7 char(4) null,
  com_fiscal_start_c_8 char(4) null,
  com_fiscal_start_c_9 char(4) null,
  com_fiscal_start_c_10 char(4) null,
  com_fiscal_start_c_11 char(4) null,
  com_fiscal_start_c_12 char(4) null,
  current_fiscal_year char(11) null,
  current_month smallint null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  HOLDING char(1) null,
  COM_ADDRESS2 varchar(100) null,
  LAST_CLOSED_YEAR char(11) null,
  matrix char(1) null,
  primary key( COM_CODE) ,
  );

create table DBA.COMPANY_STORES(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  CST_TOTAL_ITEMS numeric(7) null,
  CST_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CST_MAIN_PURCHASE char(1) null,
  CST_REORDER_COVER_DAY smallint null,
  CST_MAX_COVER_DAY smallint null,
  CHRT_SERIAL double null,
  CCC_COST_SERIAL double null,
  SAFE_CHRT_SERIAL double null,
  m_charge_item double null,
  m_change_item double null,
  primary key( COM_CODE,
  STO_CODE) ,
  );

create table DBA.COMPANY_VENDORS(
  COM_CODE char(3) not null,
  VEN_SERIAL double not null,
  VCOMP_TOTAL_CREDIT_CASH numeric(15,5) null,
  VCOMP_TOTAL_DEBIT_CASH numeric(15,5) null,
  VCOMP_TOTAL_CREDIT_PAPER numeric(15,5) null,
  VCOMP_TOTAL_DEBIT_PAPER numeric(15,5) null,
  VCOMP_TOTAL_DISC_TAX numeric(15,5) null,
  VCOMP_TOTAL_DISC_FOR_US numeric(15,5) null,
  VCOMP_BALANCE_0 numeric(15,5) null,
  VCOMP_BALANCE_1 numeric(15,5) null,
  VCOMP_BALANCE_2 numeric(15,5) null,
  VCOMP_BALANCE_3 numeric(15,5) null,
  VCOMP_BALANCE_4 numeric(15,5) null,
  VCOMP_BALANCE_5 numeric(15,5) null,
  VCOMP_BALANCE_6 numeric(15,5) null,
  VCOMP_BALANCE_7 numeric(15,5) null,
  VCOMP_BALANCE_8 numeric(15,5) null,
  VCOMP_BALANCE_9 numeric(15,5) null,
  VCOMP_BALANCE_10 numeric(15,5) null,
  VCOMP_BALANCE_11 numeric(15,5) null,
  VCOMP_BALANCE_12 numeric(15,5) null,
  ven_manager_1 varchar(60) null,
  ven_manager_2 varchar(60) null,
  ven_manager_3 varchar(60) null,
  ven_dealing_type char(2) null,
  ven_bank_account varchar(15) null,
  ven_gl_account char(6) null,
  ven_facilities_type char(1) null,
  ven_facilities_day integer null,
  ven_facilities_value numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CUS_SERIAL double null,
  STATUS_FLAG char(1) null,
  CHRT_SERIAL double null,
  VCOMP_TOTAL_GOODS_IN numeric(15,5) null,
  VCOMP_TOTAL_GOODS_OUT numeric(15,5) null,
  VCOMP_LAST_MONTH numeric(2) null,
  VCOMP_LAST_YEAR char(11) null,
  VCOMP_POST_ON_MAIN char(1) null,
  primary key( COM_CODE,
  VEN_SERIAL) ,
  );

create table DBA.CUSTOMER_COMAPNY(
  COM_CODE char(3) not null,
  CUS_SERIAL double not null,
  CUSCOMP_TOTAL_CREDIT_CASH numeric(15,5) null,
  CUSCOMP_TOTAL_DEBIT_CASH numeric(15,5) null,
  CUSCOMP_TOTAL_CREDIT_PAPER numeric(15,5) null,
  CUSCOMP_TOTAL_DEBIT_PAPER numeric(15,5) null,
  CUSCOMP_TOTAL_DISC_FOR_CUSTOME numeric(15,5) null,
  CUSCOMP_BALANCE_0 numeric(15,5) null,
  CUSCOMP_BALANCE_1 numeric(15,5) null,
  CUSCOMP_BALANCE_2 numeric(15,5) null,
  CUSCOMP_BALANCE_3 numeric(15,5) null,
  CUSCOMP_BALANCE_4 numeric(15,5) null,
  CUSCOMP_BALANCE_5 numeric(15,5) null,
  CUSCOMP_BALANCE_6 numeric(15,5) null,
  CUSCOMP_BALANCE_7 numeric(15,5) null,
  CUSCOMP_BALANCE_8 numeric(15,5) null,
  CUSCOMP_BALANCE_9 numeric(15,5) null,
  CUSCOMP_BALANCE_10 numeric(15,5) null,
  CUSCOMP_BALANCE_11 numeric(15,5) null,
  CUSCOMP_BALANCE_12 numeric(15,5) null,
  resp_manager varchar(60) null,
  payment_method char(1) null,
  working_time char(1) null,
  invoice_attention char(1) null,
  sales_certification char(1) null,
  cus_bank varchar(60) null,
  gl_code char(30) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  VEN_SERIAL double null,
  STATUS_FLAG char(1) null,
  CHRT_SERIAL double null,
  CUSCOMP_TOTAL_GOODS_IN numeric(15,5) null,
  CUSCOMP_TOTAL_GOODS_OUT numeric(15,5) null,
  CUSCOMP_LAST_MONTH numeric(2) null,
  CUSCOMP_LAST_YEAR char(11) null,
  SAL_SAL_SERIAL double null,
  DIST_SAL_SERIAL double null,
  first_rec_date timestamp null,
  last_visit_date timestamp null,
  last_counter_rd varchar(60) null,
  cc_total_copon numeric(15,5) null default
  0,
  total_cobons numeric(15,5) null default 0,
  cc_fcs_serial double null,
  cus_target numeric(15,5) null,
  cus_minimum_charge numeric(15,5) null,
  primary key( COM_CODE,CUS_SERIAL) ,
  );

create table DBA.COMPANY_SALESMAN(
  COM_CODE char(3) not null,
  SAL_SERIAL double not null,
  COMPSAL_TOTAL_COMMESIONS numeric(8,3) null,
  COMPSAL_TOTAL_WITHDRAWALS numeric(8,3) null,
  COMPSAL_TOTAL_RETURNS numeric(8,3) null,
  COMPSAL_TOTAL_CASH_INVOICES numeric(8,3) null,
  COMPSAL_TOTAL_CREDIT_INVOICES numeric(8,3) null,
  COMPSAL_TOTAL_COLLECTIONS numeric(8,3) null,
  SEC_UPDATE_UID varchar(4) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(4) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  SAL_SERIAL) ,
  );

create table DBA.ITEM_STORE_COMPANY(
  STO_CODE char(3) not null,
  ITM_SERIAL double not null,
  ISC_MAX_LIMIT numeric(15,5) null,
  ISC_MIN_LIMIT numeric(15,5) null,
  ISC_SAFETY_STOCK numeric(15,5) null,
  ISC_REORDER_POINT numeric(15,5) null,
  ISC_AVR_CONSUMPTION_DAY numeric(15,5) null,
  ISC_AVR_CONSUMPTION_MONTH numeric(15,5) null,
  ISC_AVR_CONSUMPTION_YEAR numeric(15,5) null,
  ISC_DISCOUNT_1 numeric(6,4) null,
  ISC_DISCOUNT_2 numeric(6,4) null,
  ISC_DISCOUNT_3 numeric(6,4) null,
  ISC_LOCATION varchar(20) null,
  ISC_OPEN_BALANCE numeric(15,5) null,
  ISC_ALLOCATED_FROM_BALANCE numeric(15,5) null,
  ISC_ALLOCATED_OUT_BALANCE numeric(15,5) null,
  ISC_PO numeric(15,5) null,
  ISC_RECIVED numeric(15,5) null,
  ISC_CURRENT_BALANCE numeric(15,5) null,
  ISC_LAST_ISSUE_DATE date null,
  ISC_LAST_ADD_DATE date null,
  ISC_BALANCE_0 numeric(15,5) null,
  ISC_BALANCE_1 numeric(15,5) null,
  ISC_BALANCE_2 numeric(15,5) null,
  ISC_BALANCE_3 numeric(15,5) null,
  ISC_BALANCE_4 numeric(15,5) null,
  ISC_BALANCE_5 numeric(15,5) null,
  ISC_BALANCE_6 numeric(15,5) null,
  ISC_BALANCE_7 numeric(15,5) null,
  ISC_BALANCE_8 numeric(15,5) null,
  ISC_BALANCE_9 numeric(15,5) null,
  ISC_BALANCE_10 numeric(15,5) null,
  ISC_BALANCE_11 numeric(15,5) null,
  ISC_BALANCE_12 numeric(15,5) null,
  COM_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRT_SERIAL double null,
  SATUS_FLAG char(1) null,
  ISC_LAST_MONTH numeric(2) null,
  ISC_LAST_YEAR varchar(11) null,
  ITT_CODE char(3) null,
  ISC_TRANS_DONE char(1) null,
  ISC_LAST_INVENTORY_DATE timestamp null,
  isc_tax_value numeric(15,5) null,
  isc_count_cycle numeric(15,5) null,
  added_profit numeric(6,4) null,
  cash_disc numeric(6,4) null,
  issue_return_flag char(1) null default '0',
  item_user char(8) null,
  isc_iss_max_discount numeric(6,4) null default
  0,
  primary key( STO_CODE,ITM_SERIAL,COM_CODE) ,
  );

create table DBA.ITEM_COMPANY_VENDOR(
  VEN_SERIAL double not null,
  ITM_SERIAL double not null,
  ITV_LEAD_TIME numeric(5,2) null,
  COM_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PURCHASE_PRICE numeric(15,5) null,
  DISCOUNT_1 numeric(15,5) null,
  DISCOUNT_2 numeric(15,5) null,
  DISCOUNT_3 numeric(15,5) null,
  ITU_CODE char(3) null,
  ITV_FACTOR_PUR_TO_SMALL numeric(15,5) null,
  primary key( VEN_SERIAL,
  ITM_SERIAL,COM_CODE) ,
  );

create table DBA.ITEM_MASTER(
  ITM_SERIAL double not null,
  ITM_CODE varchar(30) not null,
  ITG_CODE_L1 char(3) not null,
  ITG_CODE_L2 char(3) not null,
  ITG_CODE_L3 char(3) not null,
  ITG_CODE_L4 char(3) not null,
  ITG_CODE_L5 char(3) not null,
  ITG_CODE_L6 char(3) not null,
  ITT_CODE char(3) not null,
  ITN_CODE char(3) not null,
  IMO_CODE char(20) null,
  ITC_CODE char(20) null,
  ITS_CODE char(20) null,
  ITU_PURCHASE_CODE char(3) not null,
  ITU_STORED_CODE char(3) not null,
  ITU_SMALL_ISSUE_CODE char(3) not null,
  ITU_MEDIUM_ISSUE_CODE char(3) null,
  ITU_LARGE_ISSUE_CODE char(3) null,
  ITM_NAME_L1 varchar(60) not null,
  ITM_NAME_L2 varchar(60) null,
  ITM_SCIENTIFIC_NAME_L1 varchar(60) null,
  ITM_SCIENTIFIC_NAME_L2 varchar(60) null,
  ITM_DIN_NUM varchar(30) null,
  ITM_VOLUME numeric(15,5) null,
  ITM_ALTERNATE_FLAG char(1) not null,
  ITM_REPLACEMENT_FLAG char(1) not null,
  ITM_EXPIRY_DATE_FLAG char(1) not null,
  ITM_INSPECTION_FLAG char(1) not null,
  ITM_PLANNING_FLAG char(1) not null,
  ITM_PURCHASE_TAX_PERCENT numeric(15,5) null,
  ITM_SALES_TAX_PERCENT numeric(6,4) null,
  ITM_OTHER_TAX_PERCENT numeric(6,4) null,
  ITM_CUSTOM_PERCENT numeric(6,4) null,
  ITM_LAST_PURCHAGE_UNIT_PRICE numeric(15,5) null,
  ITM_LAST_SALES_UNIT_PRICE numeric(15,5) null,
  ITM_AVR_COST numeric(15,5) null,
  ITM_MAX_LEAD_TIME numeric(3) null,
  ITM_SHIPMENT_TIME numeric(3) null,
  ITM_OTHER_LEAD_TIME numeric(3) null,
  ITM_PASSWORD varchar(15) null,
  ITM_MAX_LIMIT numeric(15,5) null,
  ITM_MIN_LIMIT numeric(15,5) null,
  ITM_SAFETY_STOCK numeric(15,5) null,
  ITM_REORDER_POINT numeric(15,5) null,
  ITM_OPTIMUM_PURCHASE_QTY numeric(15,5) null,
  ITM_AVR_CONSUMPTION_DAY numeric(15,5) null,
  ITM_AVR_CONSUMPTION_MONTH numeric(15,5) null,
  ITM_AVR_CONSUMPTION_YEAR numeric(15,5) null,
  ITM_ISSUE_FACTOR_LARGE_TO_MEDIUM numeric(15,5) null,
  ITM_ISSUE_FACTOR_MEDIUM_TO_SMALL numeric(15,5) null,
  ITM_DISCOUNT_1 numeric(6,4) null,
  ITM_DISCOUNT_2 numeric(6,4) null,
  ITM_DISCOUNT_3 numeric(6,4) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ITM_ISSUE_FACTOR_PUR_TO_SMALL numeric(15,5) null,
  SATUS_FLAG char(1) null,
  CHRT_SERIAL double null,
  ITM_GL_CODE varchar(30) null,
  ITM_TRANS_DONE char(1) null,
  IS_CODE char(20) null,
  IG_CODE char(20) null,
  IC_CODE char(20) null,
  ITM_PURCHASE_TAX_PERC numeric(6,4) null,
  ITM_SALES_TAX_AMOUNT numeric(15,5) null,
  itm_tax_value numeric(15,5) null,
  itm_count_cycle double null,
  added_profit numeric(6,4) null,
  cash_disc numeric(6,4) null,
  itm_code1 varchar(30) null,
  itm_code2 varchar(30) null,
  itm_code3 varchar(30) null,
  itm_code4 varchar(30) null,
  itm_pic varchar(60) null,
  itm_cancel varchar(1) null,
  itm_code5 varchar(30) null,
  itm_code6 varchar(30) null,
  itm_code7 varchar(30) null,
  itm_code8 varchar(30) null,
  itm_code9 varchar(30) null,
  itm_code10 varchar(30) null,
  itm_code11 varchar(30) null,
  itm_code12 varchar(30) null,
  itm_code13 varchar(30) null,
  itm_code14 varchar(30) null,
  itm_code15 varchar(30) null,
  itm_code16 varchar(30) null,
  itm_code17 varchar(30) null,
  itm_code18 varchar(30) null,
  itm_code19 varchar(30) null,
  itm_code20 varchar(30) null,
  itm_code21 varchar(30) null,
  itm_code22 varchar(30) null,
  itm_code23 varchar(30) null,
  itm_code24 varchar(30) null,
  itm_code25 varchar(30) null,
  itm_code26 varchar(30) null,
  itm_code27 varchar(30) null,
  itm_code28 varchar(30) null,
  itm_code29 varchar(30) null,
  itm_code30 varchar(30) null,
  menue_tab_code char(2) null,
  primary key( ITM_SERIAL) ,
  );

create table DBA.CUSTOMER(
  CUS_SERIAL double not null,
  INDUSTRY_CODE char(3) null,
  SECTOR_CODE char(3) null,
  COU_CODE_L1 char(3) null,
  COU_CODE_L2 char(3) null,
  COU_CODE_L3 char(3) null,
  COU_CODE_L4 char(3) null,
  COU_CODE_L5 char(3) null,
  COU_CODE_L6 char(3) null,
  CUS_HOLDING_SERIAL double null,
  CUR_CODE_1 char(3) null,
  CUR_CODE_2 char(3) null,
  CUR_CODE_3 char(3) null,
  CUS_CODE char(30) not null,
  CUS_NAME_1 varchar(150) not null,
  CUS_NAME_2 varchar(60) null,
  CUS_TYPE char(1) not null,
  CUS_NATURE char(1) not null,
  RESP_MANAGER varchar(60) null,
  COMPANY_TYPE varchar(60) null,
  CUS_ADDRESS varchar(150) null,
  CUS_TELEPHONE_1 char(15) null,
  CUS_TELEPHONE_2 char(15) null,
  CUS_TELEPHONE_3 char(15) null,
  CUS_FAX_1 char(15) null,
  CUS_FAX_2 char(15) null,
  CUS_POSTAL_NUMBER char(15) null,
  PAYMENT_METHOD char(1) null,
  CUS_KIND char(1) null,
  WORKING_TIME char(1) null,
  COMMERCIAL_RECORD char(30) null,
  INSURANCE_NUMBER char(30) null,
  TAXES_CARD char(30) null,
  INSURANCE_FILE char(30) null,
  INVOICE_ATTENTION char(1) null,
  SALES_CERTIFICATION char(1) null,
  CUS_BANK varchar(60) null,
  CUS_TELEX char(15) null,
  GL_CODE char(30) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  SATUS_FLAG char(1) null,
  CHRT_SERIAL double null,
  first_rec_date timestamp null,
  last_visit_date timestamp null,
  cus_target numeric(15,5) null,
  cus_minimum_charge numeric(15,5) null,
  cus_call_flag char(1) null,
  cus_call_data1 varchar(15) null,
  cus_call_data2 varchar(15) null,
  cus_call_data3 varchar(15) null,
  cus_call_data4 varchar(15) null,
  cus_call_data5 varchar(15) null,
  cus_call_data6 varchar(15) null,
  cus_call_data7 varchar(15) null,
  time_from1 time null,
  time_from2 time null,
  time_from3 time null,
  time_from4 time null,
  time_from5 time null,
  time_from6 time null,
  time_from7 time null,
  time_to1 time null,
  time_to2 time null,
  time_to3 time null,
  time_to4 time null,
  time_to5 time null,
  time_to6 time null,
  time_to7 time null,
  primary key( CUS_SERIAL) ,
  );

create table DBA.CURRENCY_EXCHANGE(
  CUR_BASE_CODE char(3) not null,
  CUR_EXCHANGE_CODE char(3) not null,
  CEX_DATE timestamp not null,
  CEX_BUY_CASH numeric(16,6) not null,
  CEX_SELL_CASH numeric(16,6) not null,
  CEX_BUY_TRANSFER numeric(16,6) not null,
  CEX_SELL_TRANSFER numeric(16,6) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( CUR_BASE_CODE,
  CUR_EXCHANGE_CODE,CEX_DATE) ,
  );

create table DBA.COMPANY_COST_CENTERS_ORG(
  COM_CODE char(3) not null,
  COC_CODE_L1 char(3) not null,
  COC_CODE_L2 char(3) not null,
  COC_CODE_L3 char(3) not null,
  COC_CODE_L4 char(3) not null,
  COC_CODE_L5 char(3) not null,
  COC_CODE_L6 char(3) not null,
  ORG_CODE_L1 char(3) not null,
  ORG_CODE_L2 char(3) not null,
  ORG_CODE_L3 char(3) not null,
  ORG_CODE_L4 char(3) not null,
  ORG_CODE_L5 char(3) not null,
  ORG_CODE_L6 char(3) not null,
  CCO_CASH_IN numeric(15,5) null,
  CCO_CASH_OUT numeric(15,5) null,
  CCO_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6,ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6) ,
  );

create table DBA.ITEM_UNITS_CONVERSION(
  ITU_BASE_CODE char(3) not null,
  ITU_CONVERSION_CODE char(3) not null,
  IUC_FACTOR numeric(16,6) not null,
  IUC_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITU_BASE_CODE,
  ITU_CONVERSION_CODE) ,
  );

create table DBA.ITEM_COMPANY_PRICE(
  ITM_SERIAL double not null,
  COM_CODE char(3) not null,
  PRT_CODE char(3) not null,
  ICP_PRICE_DATE timestamp not null,
  ICP_PRICE numeric(15,5) not null,
  ICP_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ICP_QTY numeric(15,5) null,
  ICP_VALUE numeric(15,5) null,
  ICP_DISCOUNT numeric(6,4) null,
  ICP_DISCOUNT_VALUE numeric(15,5) null,
  ICP_PRICE_FACTOR char(1) null,
  ICP_SALES_TAX_2 numeric(4,2) null,
  icp_discount1 numeric(15,5) null default
  0.0,
  icp_discount2 numeric(15,5) null default 0.0,
  icp_discount3 numeric(15,5) null default 0.0,
  icp_price_befor_3disc numeric(15,5) null default 0.0,
  primary key( ITM_SERIAL,COM_CODE,PRT_CODE,ICP_PRICE_DATE) ,
  );

create table DBA.ALTERNATE_ITEM(
  ITM_BASE_SERIAL double not null,
  ITM_ALTERNATE_SERIAL double not null,
  ITI_REMARKS varchar(100) null,
  ALI_REVERSE_FLAG char(1) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITM_BASE_SERIAL,
  ITM_ALTERNATE_SERIAL) ,
  );

create table DBA.DRUG_INTERACTION_ITEM(
  ITM_BASE_SERIAL double not null,
  ITM_INTERACTION_SERIAL double not null,
  ITI_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITM_BASE_SERIAL,
  ITM_INTERACTION_SERIAL) ,
  );

create table DBA.CUR_DETAIL_TABLE(
  CUR_CODE char(3) not null,
  CUD_UNIT_ABS char(10) null,
  CUD_UNIT_REM char(10) null,
  CUD_F1 numeric(7) null,
  CUD_F1_D char(10) null,
  CUD_F2 numeric(7) null,
  CUD_F2_D char(10) null,
  CUD_F3 numeric(7) null,
  CUD_F3_D char(10) null,
  CUD_F4 numeric(7) null,
  CUD_F4_D char(10) null,
  CUD_F5 numeric(7) null,
  CUD_F5_D char(10) null,
  CUD_F6 numeric(7) null,
  CUD_F6_D char(10) null,
  CUD_F7 numeric(7) null,
  CUD_F7_D char(10) null,
  CUD_F8 numeric(7) null,
  CUD_F8_D char(10) null,
  CUD_F9 numeric(7) null,
  CUD_F9_D char(10) null,
  CUD_F10 numeric(7) null,
  CUD_F10_D char(10) null,
  CUD_F11 numeric(7) null,
  CUD_F11_D char(10) null,
  CUD_F12 numeric(7) null,
  CUD_F12_D char(10) null,
  CUD_F13 numeric(7) null,
  CUD_F13_D char(10) null,
  CUD_F14 numeric(7) null,
  CUD_F14_D char(10) null,
  CUD_F15 numeric(7) null,
  CUD_F15_D char(10) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( CUR_CODE) ,
  );

create table DBA.ORDERS_QUANTITY_TABLE(
  COM_CODE char(3) not null,
  ORD_SERIAL double not null,
  ORD_LINE_LOCAL_SERIAL double not null,
  ORD_QTY_DATE date not null,
  QUNTITY numeric(12,2) null,
  SEC_UPDATE_UID varchar(4) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(4) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  ORD_SERIAL,ORD_LINE_LOCAL_SERIAL) ,
  );

create table DBA.COMPANY_STORES_SERIALS(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  MOD_MODULE_ID char(10) not null,
  MTT_TRANS_TYPE_1 char(10) not null,
  MTT_TRANS_TYPE_2 char(10) not null,
  CSS_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CSS_FISCAL_YEAR char(11) not null,
  primary key( COM_CODE,
  STO_CODE,MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2,CSS_FISCAL_YEAR) ,
  );

create table DBA.SYSTEM_MESSAGES(
  LNG_ID char(3) not null,
  MES_ID double not null,
  MES_CLASS char(2) not null,
  MES_TEXT varchar(200) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( LNG_ID,
  MES_ID) ,
  );

create table DBA.SERIALS(
  TABLE_NAME char(50) not null,
  LAST_SERIAL double null,
  primary key( TABLE_NAME) ,
  );

create table DBA.TABLE_SPECS(
  TS_TABLE_NAME varchar(60) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( TS_TABLE_NAME) ,
  );

create table DBA.SALESMAN(
  SAL_SERIAL double not null,
  COU_CODE_L1 char(3) null,
  COU_CODE_L2 char(3) null,
  COU_CODE_L3 char(3) null,
  COU_CODE_L4 char(3) null,
  COU_CODE_L5 char(3) null,
  COU_CODE_L6 char(3) null,
  SAL_NAME_1 varchar(60) not null,
  SAL_NAME_2 varchar(60) null,
  SAL_ADD varchar(60) null,
  SAL_PHONE char(15) null,
  SAL_ACCOUNTING_METHOD char(1) null,
  SAL_COMMISSION char(1) null,
  SAL_WORK_LINE varchar(60) null,
  SAL_TYPE char(1) null,
  SAL_CODE varchar(30) not null,
  COM_CODE char(3) not null,
  SAL_TOTAL_COMMESIONS numeric(15,5) null,
  SAL_TOTAL_WITHDRAWALS numeric(15,5) null,
  SAL_TOTAL_RETURNS numeric(15,5) null,
  SAL_TOTAL_CASH_INVOICES numeric(15,5) null,
  SAL_TOTAL_CREDIT_INVOICES numeric(15,5) null,
  SAL_TOTAL_COLLECTIONS numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  SAL_COMM_PRECENT numeric(5,2) null,
  SAL_DOWN_PAYMENT numeric(15,5) null,
  CHRT_SERIAL double null,
  SAL_ACCOUNT_CODE char(30) null,
  SAL_CATEGORY char(1) null,
  sal_discount_percent numeric(6,4) null default
  0,
  primary key( SAL_SERIAL,COM_CODE) ,
  );

create table DBA.TABLE_COLUMNS_SPECS(
  TS_TABLE_NAME varchar(60) not null,
  TCS_COLUMN_NAME varchar(60) not null,
  TCS_PRIMARY_KEY char(1) not null,
  TCS_AUTOINCREMENT char(10) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( TS_TABLE_NAME,
  TCS_COLUMN_NAME) ,
  );

create table DBA.UNIQUE_COLUMNS(
  TAB_TS_TABLE_NAME varchar(60) not null,
  TCS_COLUMN_NAME varchar(60) not null,
  TS_TABLE_NAME varchar(60) not null,
  UNC_GROUP char(10) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( TAB_TS_TABLE_NAME,
  TCS_COLUMN_NAME,TS_TABLE_NAME,UNC_GROUP) ,
  );

create table DBA.ORDERS_HEADER_TABEL(
  COM_CODE char(3) not null,
  ORD_SERIAL double not null,
  CUS_SERIAL double not null,
  SAL_SERIAL double null,
  YEAR char(9) null,
  SYSTEM_DATE date null,
  DOC_NUMBER char(20) not null,
  NO_OF_QUANTITIES numeric(2) null,
  EMP_CODE char(30) null,
  ORD_DOC_DATE date null,
  SAL_COM_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  ORD_SERIAL) ,
  );

create table DBA.ORDER_LINES_TABLE(
  ORD_SERIAL double not null,
  ORD_LINE_LOCAL_SERIAL double not null,
  ITM_SERIAL double not null,
  IMO_CODE char(3) null,
  ITC_CODE char(3) null,
  SALES_PRICE numeric(15,5) null,
  ORDER_Q numeric(15,5) null,
  SERTIF_Q numeric(15,5) null,
  OUT_Q numeric(15,5) null,
  RETURN_Q numeric(15,5) null,
  ORD_QTY_DATE date not null,
  COM_CODE char(3) not null,
  ORD_RECIVED_QTY numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ORD_SERIAL,
  ORD_LINE_LOCAL_SERIAL,ORD_QTY_DATE,COM_CODE) ,
  );

create table DBA.ITEM_STORE_COMPANY_EXPIRY(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  ITM_SERIAL double not null,
  EXP_DATE date not null,
  EXP_QTY numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  STO_CODE,ITM_SERIAL,EXP_DATE) ,
  );

create table DBA.REQUEST_FOR_QUOTATION(
  COM_CODE char(3) not null,
  RFQ_SERIAL double not null,
  VEN_SERIAL double not null,
  RFQ_CODE char(6) null,
  RFQ_FISCAL_YEAR char(11) not null,
  RFQ_SYSTEM_DATE date null,
  RFQ_DATE date null,
  RFQ_ANSWER_DATE date null,
  RFQ_TOTAL_ITEMS numeric(6) null,
  RFQ_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  RFQ_SERIAL,RFQ_FISCAL_YEAR) ,
  );

create table DBA.VENDOR_QUOTATION(
  COM_CODE char(3) not null,
  VEQ_SERIAL double not null,
  RFQ_SERIAL double null,
  VEN_SERIAL double null,
  VEQ_FISCAL_YEAR char(11) not null,
  VEQ_SYSTEM_DATE date null,
  VEQ_QUOTATIONS_DATE date null,
  VEQ_QUOTATION_TYPE char(1) null,
  VEQ_NUMBER_OF_ITEMS integer null,
  VEQ_VALIDATE_PERIOD numeric(7,2) null,
  VEQ_REMARKS varchar(100) null,
  VEQ_CODE char(6) not null,
  RFQ_FISCAL_YEAR char(11) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  VEQ_SERIAL,VEQ_FISCAL_YEAR) ,
  );

create table DBA.REQUISITION_HEADER(
  COM_CODE char(3) not null,
  REQ_SERIAL double not null,
  ORG_CODE_L1 char(3) null,
  ORG_CODE_L2 char(3) null,
  ORG_CODE_L3 char(3) null,
  ORG_CODE_L4 char(3) null,
  ORG_CODE_L5 char(3) null,
  ORG_CODE_L6 char(3) null,
  REQ_USER_CODE char(10) null,
  REQ_FISICAL_YEAR char(11) not null,
  REQ_DATE date null,
  REQ_TYPE char(1) null,
  REQ_TOTAL_NUMBER_OF_ITEMS integer null,
  REQ_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  REQ_SERIAL,REQ_FISICAL_YEAR) ,
  );

create table DBA.PURCHASE_ORDER_HEADER(
  COM_CODE char(3) not null,
  PO_SERIAL double not null,
  VEN_SERIAL double null,
  PO_USER_CODE char(15) null,
  PO_FISCAL_YEAR char(11) not null,
  PO_TOTAL_PO_VALUE numeric(15,5) null,
  PO_TOTAL_TRANSPORTATION numeric(15,5) null,
  PO_TOTAL_TAX numeric(15,5) null,
  PO_TOTAL_EXPENSES numeric(15,5) null,
  PO_TOTAL_PAYMENT numeric(15,5) null,
  PO_REMARKS varchar(100) null,
  PO_PAYMRNT_TYPE char(1) null,
  PO_CONTRACT_CODE char(10) null,
  PO_DELIVARY_SIDE char(1) null,
  PO_DATE date null,
  PO_TOTAL_NUMBER_OF_ITEMS integer null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PO_DOCUMENT_TYPE char(1) null,
  PO_POSTING_DATE timestamp null,
  PO_RECEIVED_FLAG char(1) null,
  STO_CODE char(3) null,
  PO_START_DATE timestamp null,
  PO_END_DATE timestamp null,
  PO_AVERAGE_TYPE char(1) null,
  PO_COM_STO_FLAG char(1) null,
  PO_GENERATOR char(1) null,
  ISS_STO_CODE char(3) null,
  ISS_COM_CODE char(3) null,
  TRANS_TYPE_CODE_LEVEL1 char(2) null,
  TRANS_TYPE_CODE_LEVEL2 char(2) null,
  TRANS_NO double null,
  FISICAL_YEAR char(11) null,
  po_web_flag char(1) not null default 'N',
  b2b_flag char(1) not null default '0',
  po_items_have_stok char(1) null,
  po_new_items char(1) null,
  po_quota_flag char(1) null,
  po_prom_flag char(1) null,
  po_date_from_issue timestamp null default
  today(*),
  po_date_to_issue timestamp null default today(*),
  po_days_issue numeric(15,5) null default 0,
  primary key( COM_CODE,PO_SERIAL,PO_FISCAL_YEAR) ,
  );

create table DBA.DEMAND_REPORT_HEADER(
  COM_CODE char(3) not null,
  DEM_DEMAND_SERIAL double not null,
  DEM_DEMAND_DATE date null,
  DEM_DEMAND_TOTAL_NUMBER_OF_ITEMS integer null,
  DEM_FISCAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR) ,
  );

create table DBA.ITEM_RFQ(
  RFQ_SERIAL double not null,
  IRF_SERIAL integer not null,
  COM_CODE char(3) not null,
  VEN_SERIAL double not null,
  ITM_SERIAL double not null,
  IRF_QUANTITY_REQUESTED numeric(15,5) null,
  IRF_QUANTITY_AVAILABLE numeric(15,5) null,
  IRF_REMARKS varchar(100) null,
  RFQ_FISCAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( RFQ_SERIAL,
  IRF_SERIAL,COM_CODE,RFQ_FISCAL_YEAR) ,
  );

create table DBA.VENDOR_QUOTATION_ITEMS(
  COM_CODE char(3) not null,
  VEQ_SERIAL double not null,
  VQI_SERIAL integer not null,
  VEN_SERIAL double null,
  ITM_SERIAL double null,
  VQI_QUANTITY numeric(15,5) null,
  VQI_ECONOMICAL_QTY numeric(15,5) null,
  VQI_LEAD_TIME numeric(7,2) null,
  VQI_UNIT_PRICE numeric(15,5) null,
  VQI_REMARKS varchar(100) null,
  VEQ_FISCAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  VEQ_SERIAL,VQI_SERIAL,VEQ_FISCAL_YEAR) ,
  );

create table DBA.REQUISITION_ITEMS(
  COM_CODE char(3) not null,
  REQ_SERIAL double not null,
  ITM_SERIAL double not null,
  RQI_SERIAL double not null,
  RQI_REQUEST_QUANTITY numeric(15,5) null,
  RQI_APPROVED_QUANTITY numeric(15,5) null,
  RQI_RECIVED_QUANTITY numeric(15,5) null,
  RQI_RECIVED_DATE date null,
  RQI_REMARKS varchar(100) null,
  REQ_FISICAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  REQ_SERIAL,RQI_SERIAL,REQ_FISICAL_YEAR) ,
  );

create table DBA.PURCHASE_ORDER_ITEMS(
  COM_CODE char(3) not null,
  PO_SERIAL double not null,
  POI_ITEM_SERIAL double not null,
  VEN_SERIAL double null,
  ITM_SERIAL double null,
  POI_DELIVARY_DATE date null,
  POI_QUANTITY numeric(15,5) null,
  POI_ITEM_PRICE numeric(15,5) null,
  POI_LEAD_TIME numeric(5,2) null,
  POI_RECIVED_QTY numeric(15,5) null,
  POI_RETURN_QTY numeric(15,5) null,
  POI_REMARKS varchar(100) null,
  PO_FISCAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  POI_RECIVED char(1) null,
  POI_CURRENT_BALANCE numeric(15,5) null,
  POI_REORDER_POINT numeric(15,5) null,
  POI_CALC_QTY numeric(15,5) null,
  POI_PO_QTY numeric(15,5) null,
  POI_EXPIRY_DATE timestamp null,
  POI_START_DATE timestamp null,
  POI_END_DATE timestamp null,
  ISP_CODE char(3) null,
  POI_FACTOR numeric(15,5) null,
  poi_actual_qty numeric(15,5) not null,
  poi_status varchar(1) null,
  poi_b2b_sent char(1) null,
  poi_bonus_qty numeric(15,5) null default
  0,
  poi_quota_qty numeric(15,5) null default 0,
  poi_prom_text varchar(300) null,
  poi_bonus_flag char(1) null,
  poi_other_bouns numeric(15,5) null default 0,
  primary key( COM_CODE,PO_SERIAL,POI_ITEM_SERIAL,PO_FISCAL_YEAR) ,
  );

create table DBA.DEMAND_REPORT_VENDORS(
  COM_CODE char(3) not null,
  DEM_DEMAND_SERIAL double not null,
  VEN_SERIAL double null,
  PO_SERIAL double null,
  DMV_QUANTITY_PO numeric(15,5) null,
  DMV_PO_DATE date null,
  DMV_DELIVERY_DATE date null,
  DMV_DELIVERY_LOCATION char(15) null,
  DEM_FISCAL_YEAR char(11) not null,
  PO_FISCAL_YEAR char(11) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR) ,
  );

create table DBA.DEMAND_REPORT_REQ(
  COM_CODE char(3) not null,
  DEM_DEMAND_SERIAL double not null,
  REQ_SERIAL double null,
  DEM_FISCAL_YEAR char(11) not null,
  REQ_FISICAL_YEAR char(11) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR) ,
  );

create table DBA.DEMAND_REPORT_ITEMS(
  DEM_DEMAND_SERIAL double not null,
  ITM_SERIAL double not null,
  DMI_QUANTITY_REQUIRED numeric(15,5) null,
  DMI_QUANTITY_APPROVED numeric(15,5) null,
  DMI_QUANTITY_PO numeric(15,5) null,
  DMI_LAST_PURCHASE_PRICE numeric(15,5) null,
  DMI_AVRAGE_COST numeric(15,5) null,
  COM_CODE char(3) not null,
  DEM_FISCAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( DEM_DEMAND_SERIAL,
  ITM_SERIAL,COM_CODE,DEM_FISCAL_YEAR) ,
  );

create table DBA.MODULES(
  MOD_MODULE_ID char(10) not null,
  MOD_MODULE_NAME varchar(30) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  MOD_MODULE_NAME2 varchar(30) null,
  MOD_CODE char(2) null,
  primary key( MOD_MODULE_ID) ,
  );

create table DBA.MODULE_LANGUAGE(
  LNG_ID char(3) not null,
  MOD_MODULE_ID char(10) not null,
  MOL_DESC varchar(30) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( LNG_ID,
  MOD_MODULE_ID) ,
  );

create table DBA.MODULE_LANG_TRAN_TYPE_1(
  LNG_ID char(3) not null,
  MOD_MODULE_ID char(10) not null,
  MLTT1_TYPE_1 char(2) not null,
  MLTT1_DESC varchar(60) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  MLTT1_EXIST char(1) null,
  primary key( LNG_ID,
  MOD_MODULE_ID,MLTT1_TYPE_1) ,
  );

create table DBA.MODULE_TRANSACTIONS(
  MOD_MODULE_ID char(10) not null,
  MTT_TRANS_TYPE_1 char(2) not null,
  MTT_TRANS_TYPE_2 char(2) not null,
  MTT_SCOPE char(10) not null,
  MTT_SERIAL double null,
  TS_TABLE_NAME varchar(60) null,
  TCS_COLUMN_NAME varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( MOD_MODULE_ID,
  MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2) ,
  );

create table DBA.MODULE_LANG_TRAN_TYPE_2(
  LNG_ID char(3) not null,
  MOD_MODULE_ID char(10) not null,
  MLTT1_TYPE_1 char(2) not null,
  MLTT2_TYPE_2 char(2) not null,
  MLTT2_DESC varchar(60) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( LNG_ID,
  MOD_MODULE_ID,MLTT1_TYPE_1,MLTT2_TYPE_2) ,
  );

create table DBA.RATR_TRANSACTION_HEADER(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  TRANSACTION_TYPE_CODE_LEVEL1 char(2) not null,
  TRANSACTION_TYPE_CODE_LEVEL2 char(2) not null,
  TRANSACTION_NUMBER double not null,
  RETURN_TRANSACTION_TYPE_CODE_LEVEL1 char(2) null,
  RETURN_TRANSACTION_TYPE_CODE_LEVEL2 char(2) null,
  RETURN_TRANSACTION_NUMBER double null,
  VEN_SERIAL double null,
  RATR_FISICAL_YEAR char(11) not null,
  TRANSACTION_DATE date not null,
  INVOICE_NUMBER char(10) null,
  INVOICE_DATE date null,
  SHIPPMENT_NUMBER char(10) null,
  TOTAL_ITEMS_VALUE numeric(15,5) null,
  TOTAL_TAX_VALUE numeric(15,5) null,
  TOTAL_DISCOUNT_VALUE numeric(15,5) null,
  TOTAL_CUSTOM_VALUE numeric(15,5) null,
  TOTAL_OTHER_VALUE numeric(15,5) null,
  CLOSED_FLAG char(1) null,
  ACCEPT_ITEMS_VALUE numeric(15,5) null,
  ACCEPT_TAX_VALUE numeric(15,5) null,
  ACCEPT_SALES_TAX_VALUE numeric(15,5) null,
  ACCEPT_CUSTOM_VALUE numeric(15,5) null,
  ACCEPT_OTHER_VALUE numeric(15,5) null,
  TRANSACTION_USER_NUMBER char(10) null,
  RATR_TOTAL_NUMBER_OF_ITEMS numeric(4) null,
  RATR_POST_FLAG char(1) null,
  RATR_REMARKS varchar(100) null,
  RATR_TOTAL_SALES_TAX_VALUE numeric(15,5) null,
  RATR_PHONE char(15) null,
  RETURN_FISICAL_YEAR char(11) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  RATR_POSTING_DATE timestamp null,
  RATR_PAID_AMOUNT numeric(15,5) null,
  JOB_ORDER_FISCAL_YEAR char(11) null,
  JOB_ORDER_NO char(10) null,
  CUR_CODE char(3) null,
  EXCHANGE_RATE numeric(16,6) null,
  RATR_DROPPED varchar(1) null,
  RATR_RETURN_STORE char(3) null,
  paper_count integer null default
  0,
  other_tax numeric(15,5) null default 0,
  primary key( COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR) ,
  );

create table DBA.RATR_TRANSACTION_HEADER_PO(
  STO_CODE char(3) not null,
  TRANSACTION_TYPE_CODE_LEVEL1 char(2) not null,
  TRANSACTION_TYPE_CODE_LEVEL2 char(2) not null,
  TRANSACTION_NUMBER double not null,
  PO_SERIAL double not null,
  RATR_PO_REMARKS char(10) null,
  RATR_FISICAL_YEAR char(11) not null,
  PO_FISCAL_YEAR char(11) not null,
  COM_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( STO_CODE,
  TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,PO_SERIAL,RATR_FISICAL_YEAR,PO_FISCAL_YEAR,COM_CODE) ,
  );

create table DBA.RATR_TRANSACTION_HEADER_COST(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  TRANSACTION_TYPE_CODE_LEVEL1 char(2) not null,
  TRANSACTION_TYPE_CODE_LEVEL2 char(2) not null,
  TRANSACTION_NUMBER double not null,
  MTGL_ACCOUNT_SERIAL double not null,
  COST_VALUE numeric(15,5) null,
  COST_PERCENT numeric(5,2) null,
  RATR_FISICAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRT_SERIAL double null,
  primary key( COM_CODE,
  STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,MTGL_ACCOUNT_SERIAL,RATR_FISICAL_YEAR) ,
  );

create table DBA.SHIFTS(
  COM_CODE char(3) not null,
  SHFT_CODE char(2) not null,
  SHFT_FROM time not null,
  SHFT_TO time not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  SHFT_CODE) ,
  );

create table DBA.LAST_SHIFT(
  COM_CODE char(3) not null,
  SHFT_CODE char(2) null,
  LAST_SHFT_DATE date null,
  LAST_SHFT_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CASH_SERIAL integer not null,
  primary key( COM_CODE,
  CASH_SERIAL) ,
  );

create table DBA.SHIFTS_MONEY(
  COM_CODE char(3) not null,
  SHFT_CODE char(2) not null,
  SHFTMNY_DATE datetime not null,
  SHFTMNY_SERIAL double not null,
  SHFTMNY_USER_ID char(8) not null,
  SHFTMNY_MONEY_IN_OPEN_1 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_2 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_3 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_4 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_5 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_6 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_7 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_8 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_9 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_10 numeric(15,5) null,
  SHFTMNY_MONEY_IN_1 numeric(15,5) null,
  SHFTMNY_MONEY_IN_2 numeric(15,5) null,
  SHFTMNY_MONEY_IN_3 numeric(15,5) null,
  SHFTMNY_MONEY_IN_4 numeric(15,5) null,
  SHFTMNY_MONEY_IN_5 numeric(15,5) null,
  SHFTMNY_MONEY_IN_6 numeric(15,5) null,
  SHFTMNY_MONEY_IN_7 numeric(15,5) null,
  SHFTMNY_MONEY_IN_8 numeric(15,5) null,
  SHFTMNY_MONEY_IN_9 numeric(15,5) null,
  SHFTMNY_MONEY_IN_10 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_1 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_2 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_3 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_4 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_5 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_6 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_7 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_8 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_9 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_10 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_1 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_2 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_3 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_4 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_5 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_6 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_7 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_8 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_9 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_10 numeric(15,5) null,
  SHFTMNY_START datetime null,
  SHFTMNY_END datetime null,
  SHFTMNY_CLOSED char(1) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  SHFTMNY_ACTUAL_CASH numeric(15,5) null,
  SHFTMNY_ACTUAL_CREDIT numeric(15,5) null,
  SHFTMNY_ACTUAL_CARD numeric(15,5) null,
  CASH_SERIAL integer not null,
  SHFTMNY_MONEY_IN_OPEN_11 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_12 numeric(15,5) null,
  SHFTMNY_MONEY_IN_OPEN_13 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_11 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_12 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_OPEN_13 numeric(15,5) null,
  SHFTMNY_MONEY_IN_11 numeric(15,5) null,
  SHFTMNY_MONEY_IN_12 numeric(15,5) null,
  SHFTMNY_MONEY_IN_13 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_11 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_12 numeric(15,5) null,
  SHFTMNY_MONEY_OUT_13 numeric(15,5) null,
  SHFTMNY_HANDING char(1) null,
  shftmny_add1 numeric(15,5) null,
  shftmny_add2 numeric(15,5) null,
  shftmny_add3 numeric(15,5) null,
  shftmny_add4 numeric(15,5) null,
  shftmny_add5 numeric(15,5) null,
  shftmny_add6 numeric(15,5) null,
  primary key( COM_CODE,
  SHFT_CODE,SHFTMNY_DATE,SHFTMNY_SERIAL,CASH_SERIAL) ,
  );

create table DBA.COMPANY_SERIALS(
  COM_CODE char(3) not null,
  MOD_MODULE_ID char(10) not null,
  COS_TRANS_TYPE_1 char(2) not null,
  COS_TRANS_TYPE_2 char(2) not null,
  COS_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  COS_FISCAL_YEAR char(11) not null,
  primary key( COM_CODE,
  MOD_MODULE_ID,COS_TRANS_TYPE_1,COS_TRANS_TYPE_2,COS_FISCAL_YEAR) ,
  );

create table DBA.SECURITY_USERS(
  USER_CODE char(8) not null,
  USER_NAME char(50) null,
  USER_STATUS char(1) null,
  USER_TYPE char(1) null,
  PASS_WORD char(15) null,
  LANG char(3) null,
  primary key( USER_CODE) ,
  );

create table DBA.USER_COMPANY(
  COM_CODE char(3) not null,
  USER_CODE char(8) not null,
  sal_serial double null,
  primary key( COM_CODE,
  USER_CODE) ,
  );

create table DBA.SECURITY_GROUPINGS(
  USER_CODE char(8) not null,
  SEC_USER_CODE char(8) not null,
  primary key( USER_CODE,
  SEC_USER_CODE) ,
  );

create table DBA.RATR_TRANSACTION_ITEMS(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  TRANSACTION_TYPE_CODE_LEVEL1 char(2) not null,
  TRANSACTION_TYPE_CODE_LEVEL2 char(2) not null,
  TRANSACTION_NUMBER double not null,
  RATR_ITEM_SERIAL double not null,
  TRX_MEASURE_UNIT char(3) null,
  REQUESTED_UNIT char(3) null,
  VEN_SERIAL double null,
  ITM_SERIAL double null,
  EXPIRATION_DATE date null,
  TRX_QUANTITY numeric(15,5) null,
  REQUISTED_QUANTITY numeric(15,5) null,
  RATR_UNIT_PRICE numeric(15,5) null,
  RECEIVING_QUANTITY numeric(15,5) null,
  ADDITION_QUANTITY numeric(15,5) null,
  RETURN_QUANTITY numeric(15,5) null,
  DISCOUNT_ON_ITEM_FROM_RULE_VALUE numeric(15,5) null,
  DISCOUNT_ON_ITEM_FROM_DOCUMENT_VALUE numeric(15,5) null,
  TOTAL_CUSTOMS_VALUE numeric(15,5) null,
  OTHER_COST_VALUE numeric(15,5) null,
  ITEM_EXPENSE_DISTRIBUTION numeric(15,5) null,
  RATR_ITM_TAX_VALUE numeric(15,5) null,
  RATR_ITM_SALES_TAX_VALUE numeric(15,5) null,
  RATR_TOTAL_QUANTITY_ITEMS numeric(15,5) null,
  RATR_TOTAL_QUANTITY_PRICE numeric(15,5) null,
  RATR_FISICAL_YEAR char(11) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  OTHER_STO_CODE char(3) null,
  RATR_LAST_PUR_PRICE numeric(15,5) null,
  PO_SERIAL double null,
  PO_FISCAL_YEAR char(11) null,
  POI_ITEM_SERIAL double null,
  RATR_FACTOR numeric(15,5) null,
  RATR_SALES_PRICE numeric(15,5) null,
  RATR_NOTES varchar(500) null,
  itm_input_code varchar(30) null,
  itm_input_code_no integer null,
  previous_balance numeric(15,5) null default
  0,
  next_balance numeric(15,5) null default 0,
  ratr_other_bouns numeric(15,5) null default 0,
  primary key( COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_ITEM_SERIAL,RATR_FISICAL_YEAR) ,
  );

create table DBA.YEAR_COMPANY_VENDOR(
  VEN_SERIAL double not null,
  COM_CODE char(3) not null,
  FISCAL_YEAR char(11) not null,
  BALANCE_0 numeric(12,3) null,
  BALANCE_1 numeric(12,3) null,
  BALANCE_2 numeric(12,3) null,
  BALANCE_3 numeric(12,3) null,
  BALANCE_4 numeric(12,3) null,
  BALANCE_5 numeric(12,3) null,
  BALANCE_6 numeric(12,3) null,
  BALANCE_7 numeric(12,3) null,
  BALANCE_8 numeric(12,3) null,
  BALANCE_9 numeric(12,3) null,
  BALANCE_10 numeric(12,3) null,
  BALANCE_11 numeric(12,3) null,
  BALANCE_12 numeric(12,3) null,
  primary key( VEN_SERIAL,
  COM_CODE,FISCAL_YEAR) ,
  );

create table DBA.YEAR_ITEM_STORE_COMPANY(
  STO_CODE char(3) not null,
  COM_CODE char(3) not null,
  ITM_SERIAL double not null,
  YISC_FISCAL_YEAR char(11) not null,
  BALANCE_0 numeric(12,3) null,
  BALANCE_1 numeric(12,3) null,
  BALANCE_2 numeric(12,3) null,
  BALANCE_3 numeric(12,3) null,
  BALANCE_4 numeric(12,3) null,
  BALANCE_5 numeric(12,3) null,
  BALANCE_6 numeric(12,3) null,
  BALANCE_7 numeric(12,3) null,
  BALANCE_8 numeric(12,3) null,
  BALANCE_9 numeric(12,3) null,
  BALANCE_10 numeric(12,3) null,
  BALANCE_11 numeric(12,3) null,
  BALANCE_12 numeric(12,3) null,
  primary key( STO_CODE,
  COM_CODE,ITM_SERIAL,YISC_FISCAL_YEAR) ,
  );

create table DBA.YEAR_CUSTOMER_COMPANY(
  CUS_SERIAL double not null,
  COM_CODE char(3) not null,
  YCC_FISCAL_YEAR char(11) not null,
  BALANCE_0 numeric(12,3) null,
  BALANCE_1 numeric(12,3) null,
  BALANCE_2 numeric(12,3) null,
  BALANCE_3 numeric(12,3) null,
  BALANCE_4 numeric(12,3) null,
  BALANCE_5 numeric(12,3) null,
  BALANCE_6 numeric(12,3) null,
  BALANCE_7 numeric(12,3) null,
  BALANCE_8 numeric(12,3) null,
  BALANCE_9 numeric(12,3) null,
  BALANCE_10 numeric(12,3) null,
  BALANCE_11 numeric(12,3) null,
  BALANCE_12 numeric(12,3) null,
  primary key( CUS_SERIAL,
  COM_CODE,YCC_FISCAL_YEAR) ,
  );

create table DBA.CURRENT_SETTINGS(
  USER_CODE char(8) null,
  LAST_WORKING_DATE timestamp null,
  REP_STORE_TRANS_OFFSET double null,
  REP_OTHER_TRANS_OFFSET double null,
  REP_MASTER_OFFSET double null,
  REP_INSTALLED char(1) null,
  REP_HQ char(1) null,
  REP_STORECOMP char(1) null,
  REP_SITE_ID char(3) null,
  REP_SITE_SERIAL smallint null,
  REP_SITE_ID2 char(3) null,
  REP_SITE_ID3 char(3) null,
  REP_SITE_ID4 char(3) null,
  REP_SITE_ID5 char(3) null,
  last_backup_date timestamp null,
  backup_missed_counter integer null,
  );

create table DBA.ITEM_COMPANY(
  ITM_SERIAL double not null,
  COM_CODE char(3) not null,
  ITU_SMALL_ISSUE_CODE char(3) not null,
  ITU_STORED_ISSUE_CODE char(3) not null,
  ITU_PURCHASE_ISSUE_CODE char(3) not null,
  ITU_MEDIUM_ISSUE_CODE char(3) null,
  ITU_LARGE_ISSUE_CODE char(3) null,
  ITC_ALTERNATE_FLAG char(1) not null,
  ITC_REPLACEMENT_FLAG char(1) not null,
  ITC_EXPIRY_DATE_FLAG char(1) not null,
  ITC_INSPECTION_FLAG char(1) not null,
  ITC_PLANNING_FLAG char(1) not null,
  ITC_PURCHASE_TAX_PERCENT numeric(15,5) null,
  ITC_SALES_TAX_PERCENT numeric(6,4) null,
  ITC_OTHER_TAX_PERCENT numeric(6,4) null,
  ITC_CUSTOM_PERCENT numeric(6,4) null,
  ITC_LAST_PURCHASE_UNIT_PRICE numeric(15,5) null,
  ITC_LAST_SALES_UNIT_PRICE numeric(15,5) null,
  ITC_AVR_COST numeric(15,5) null,
  ITC_MAX_LEAD_TIME numeric(3) null,
  ITC_SHIPMENT_TIME numeric(3) null,
  ITC_OTHER_LEAD_TIME numeric(3) null,
  ITC_PASSWORD varchar(15) null,
  ITC_MAX_LIMIT numeric(15,5) null,
  ITC_MIN_LIMIT numeric(15,5) null,
  ITC_SAFETY_STOCK numeric(15,5) null,
  ITC_REORDER_POINT numeric(15,5) null,
  ITC_OPTIMUM_PURCHASE_QTY numeric(15,5) null,
  ITC_AVR_CONSUMPTION_DAY numeric(15,5) null,
  ITC_AVR_CONSUMPTION_MONTH numeric(15,5) null,
  ITC_AVR_CONSUMPTION_YEAR numeric(15,5) null,
  ITC_ISSUE_FACTOR_LARGE_TO_MEDIUM numeric(15,5) null,
  ITC_ISSUE_FACTOR_MEDIUM_TO_SMALL numeric(15,5) null,
  ITC_DISCOUNT_1 numeric(6,4) null,
  ITC_DISCOUNT_2 numeric(6,4) null,
  ITC_DISCOUNT_3 numeric(6,4) null,
  ITC_CURRENT_BALANCE numeric(15,5) null,
  ITC_AVR_CUSTOM_PRICE numeric(15,5) null,
  ITC_AVR_SALES_PRICE numeric(15,5) null,
  ITC_AVR_OTHER_PRICE numeric(15,5) null,
  ITC_AVR_GENERAL_PRICE numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ITC_FACTOR_PUR_TO_SMALL numeric(15,5) null,
  ITC_PO_QTY numeric(15,5) null,
  CHRT_SERIAL double null,
  STATUS_FLAG char(1) null,
  ITC_GL_CODE varchar(30) null,
  ITT_CODE char(3) null,
  ITC_TRANS_DONE char(1) null,
  ITC_PURCHASE_TAX_PERC numeric(6,4) null,
  ITC_SALES_TAX_AMOUNT numeric(15,5) null,
  itc_tax_value numeric(15,5) null,
  itc_count_cycle numeric(15,5) null,
  added_profit numeric(6,4) null,
  cash_disc numeric(6,4) null,
  primary key( ITM_SERIAL,
  COM_CODE) ,
  );

create table DBA.ITEM_TYPE(
  ITT_CODE char(3) not null,
  ISP_NAME_L1 varchar(60) not null,
  ISP_NAME_L2 varchar(60) null,
  ISP_REMARKS varchar(100) null,
  STOCKABLE_ITEM char(1) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( ITT_CODE) ,
  );

create table DBA.CUSTOMER_ITEM_GROUP_DISCOUNT(
  CUS_SERIAL double not null,
  COM_CODE char(3) not null,
  CIDG_DATE timestamp not null,
  MLV_CODE_L1 char(3) null,
  MLV_CODE_L2 char(3) null,
  MLV_CODE_L3 char(3) null,
  MLV_CODE_L4 char(3) null,
  MLV_CODE_L5 char(3) null,
  MLV_CODE_L6 char(3) null,
  PRT_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  OVER_QTY numeric(15,5) null,
  OVER_VALUE numeric(15,5) null,
  DISCOUNT_PERCENT numeric(4,2) null,
  DISCOUNT_VALUE numeric(15,5) null,
  primary key( CUS_SERIAL,
  COM_CODE,CIDG_DATE) ,
  );

create table DBA.GL_LABEL(
  GL_LANG char(3) not null,
  GL_LABEL_TYPE char(2) not null,
  GL_LABEL_CODE char(2) not null,
  GL_LABEL varchar(30) null,
  GL_CODE_REQUIRED char(1) null,
  GL_SHOW char(1) null,
  primary key( GL_LANG,
  GL_LABEL_TYPE,GL_LABEL_CODE) ,
  );

create table DBA.BANKS(
  BNK_CODE char(3) not null,
  BNK_NAME_L1 varchar(60) not null,
  BNK_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  BNK_FLAG char(1) null,
  primary key( BNK_CODE) ,
  );

create table DBA.BANK_ACCOUNT_TYPES(
  BAT_CODE char(3) not null,
  BAT_NAME_L1 varchar(60) not null,
  BAT_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  BAT_FLAG char(1) null,
  primary key( BAT_CODE) ,
  );

create table DBA.ACCOUNT_CHART_TREE(
  TREE_CODE_L1 char(3) not null,
  TREE_CODE_L2 char(3) not null,
  TREE_CODE_L3 char(3) not null,
  TREE_CODE_L4 char(3) not null,
  TREE_CODE_L5 char(3) not null,
  TREE_CODE_L6 char(3) not null,
  PARENT_TREE_CODE_L1 char(3) null,
  PARENT_TREE_CODE_L2 char(3) null,
  PARENT_TREE_CODE_L3 char(3) null,
  PARENT_TREE_CODE_L4 char(3) null,
  PARENT_TREE_CODE_L5 char(3) null,
  PARENT_TREE_CODE_L6 char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  USED_FLAG char(1) null,
  primary key( TREE_CODE_L1,
  TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6) ,
  );

create table DBA.COMPANY_COST_CENTERS(
  COM_CODE char(3) not null,
  CCC_COST_SERIAL double not null,
  CCC_COST_CODE char(30) not null,
  CCC_NAME1 varchar(60) null,
  CCC_NAME2 varchar(60) null,
  CCC_CASH_IN numeric(15,5) null,
  CCC_CASH_OUT numeric(15,5) null,
  CCC_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  USED_FLAG char(1) null,
  MLV_CODE_L1 char(3) not null,
  MLV_CODE_L2 char(3) not null,
  MLV_CODE_L3 char(3) not null,
  MLV_CODE_L4 char(3) not null,
  MLV_CODE_L5 char(3) not null,
  MLV_CODE_L6 char(3) not null,
  primary key( COM_CODE,
  CCC_COST_SERIAL) ,
  );

create table DBA.COMPANY_CHART_OF_ACCOUNT(
  COM_CODE char(3) not null,
  CHRT_SERIAL double not null,
  CMPCHRT_ACCOUNT_CODE char(30) not null,
  CMPCHRT_ACCOUNT_TYPE char(1) not null,
  CMPCHRT_ACCOUNT_NATURE char(1) not null,
  CMPCHRT_CASH_ACCOUNT char(1) null,
  CMPCHRT_ACCOUNT_IN_STATMENT_1 numeric(1) null,
  CMPCHRT_ACCOUNT_IN_STATMENT_2 numeric(1) null,
  CMPCHRT_BANK_ACCOUNT char(1) null,
  CMPCHRT_OVER_DRAFT_ACCOUNT char(1) null,
  CMPCHRT_ACCOUNT_IN_TRAIL_BAL numeric(3) null,
  TREE_CODE_L1 char(3) not null,
  TREE_CODE_L2 char(3) not null,
  TREE_CODE_L3 char(3) not null,
  TREE_CODE_L4 char(3) not null,
  TREE_CODE_L5 char(3) not null,
  TREE_CODE_L6 char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  USED_FLAG char(1) null,
  CCC_COST_SERIAL double null,
  COST_CODE_L1 char(3) null,
  COST_CODE_L2 char(3) null,
  COST_CODE_L3 char(3) null,
  COST_CODE_L4 char(3) null,
  COST_CODE_L5 char(3) null,
  COST_CODE_L6 char(3) null,
  CMPCHRT_MAIN_SUB_COST char(1) null,
  CUR_CODE char(3) not null,
  CASH_SERIAL integer null,
  CMPCHRT_SHOW char(1) null,
  primary key( COM_CODE,
  CHRT_SERIAL) ,
  );

create table DBA.COMPANY_ACCOUNT_CHART_TREE(
  COM_CODE char(3) not null,
  TREE_CODE_L1 char(3) not null,
  TREE_CODE_L2 char(3) not null,
  TREE_CODE_L3 char(3) not null,
  TREE_CODE_L4 char(3) not null,
  TREE_CODE_L5 char(3) not null,
  TREE_CODE_L6 char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  USED_FLAG char(1) null,
  primary key( COM_CODE,
  TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6) ,
  );

create table DBA.GL_JOURNAL_VOUCHER_HEADER(
  COM_CODE char(3) not null,
  JVH_DOC_FISCAL_YEAR char(11) not null,
  JVH_TRANS_TYPE1 char(2) not null,
  JVH_TRANS_TYPE2 char(2) not null,
  JVH_DOC_SERIAL double not null,
  PREV_JVH_DOC_FISCAL_YEAR char(11) null,
  PREV_JVH_TRANS_TYPE1 char(2) null,
  PREV_JVH_TRANS_TYPE2 char(2) null,
  PREV_JVH_DOC_SERIAL double null,
  NEXT_JVH_DOC_FISCAL_YEAR char(11) null,
  NEXT_JVH_TRANS_TYPE1 char(2) null,
  NEXT_JVH_TRANS_TYPE2 char(2) null,
  NEXT_JVH_DOC_SERIAL double null,
  CUR_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  JVH_DOC_DATE date null,
  JVH_PORTFOLIO_NO numeric(4) null,
  JVH_PORTFOLIO_DATE timestamp null,
  JVH_PORTFOLIO_FISCAL char(11) null,
  JVH_CUR_EXCHANGE_RATE numeric(16,6) null,
  JVH_TOTAL_DETAIL_VALUE numeric(15,5) null,
  JVH_DOCUMENT_NO numeric(10) null,
  JVH_PREVIOUS_FLAG char(1) null,
  JVH_NEXT_FLAG char(1) null,
  JVH_REMARKS varchar(60) null,
  JVH_POSTING_DATE timestamp null,
  JVH_GEN_MODULE_ID char(3) null,
  JVH_GEN_STO_CODE char(3) null,
  JVH_GEN_TRANS_TYPE1 char(2) null,
  JVH_GEN_TRANS_TYPE2 char(2) null,
  JVH_GEN_TRANS_NO double null,
  JVH_VEN_CUS_SERIAL double null,
  JVH_PREV_DOC_NO numeric(10) null,
  JVH_GEN_FISCAL_YEAR char(11) null,
  primary key( COM_CODE,
  JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL) ,
  );

create table DBA.GL_PAPAER(
  COM_CODE char(3) not null,
  P_FISCAL_YEAR char(11) not null,
  PAPER_TYPE char(2) not null,
  PAPER_IN_OUT char(1) not null,
  PAPER_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PAPER_NUMBER varchar(20) not null,
  ISSUE_DATE timestamp not null,
  DUE_DATE timestamp not null,
  PAY_DATE timestamp null,
  PAPER_AMOUNT numeric(15,5) null,
  AMOUNT_PAID numeric(15,5) null,
  PAPER_STATUS char(1) null,
  PAPER_LOCATION char(1) null,
  PAPER_FLAG_TYPE char(2) null,
  PAPER_FLAG char(2) null,
  PAPER_CODE_SERIAL double null,
  JVH_DOC_FISCAL_YEAR char(11) null,
  JVH_TRANS_TYPE1 char(2) null,
  JVH_TRANS_TYPE2 char(2) null,
  JVH_DOC_SERIAL double null,
  PAPER_ENDORSED char(1) null,
  PAPER_ORIGINAL_ORG varchar(50) null,
  CUR_CODE char(3) null,
  paid_ret_chq numeric(15,5) null,
  intrst_ret_chq numeric(15,5) null,
  flag1 char(1) null,
  flag2 char(1) null,
  flag3 char(1) null,
  num_col1 numeric(15,5) null,
  num_col2 numeric(15,5) null,
  num_col3 numeric(15,5) null,
  primary key( COM_CODE,
  P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL) ,
  );

create table DBA.GL_INTEGERATION_ACCOUNTS(
  COM_CODE char(3) not null,
  GIA_SERIAL integer not null,
  CHRT_SERIAL double null,
  GIA_NAME1 varchar(60) null,
  GIA_NAME2 varchar(60) null,
  MLV_CODE_L1 char(3) null,
  MLV_CODE_L2 char(3) null,
  MLV_CODE_L3 char(3) null,
  MLV_CODE_L4 char(3) null,
  MLV_CODE_L5 char(3) null,
  MLV_CODE_L6 char(3) null,
  GIA_USER_EDIT_FLAG char(1) null,
  GIA_SUB_GEN char(1) null,
  GIA_SHOW char(1) null,
  GIA_COUNTER integer null,
  primary key( COM_CODE,
  GIA_SERIAL) ,
  );

create table DBA.GL_COST_CENTER_SUMMERY(
  COM_CODE char(3) not null,
  GLCC_FISCAL_YEAR char(11) not null,
  GLCC_MONTH integer not null,
  CUR_CODE char(3) not null,
  CCC_COST_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GLCC_DEBIT_AMOUNT numeric(15,5) not null,
  GLCC_CREDIT_AMOUNT numeric(15,5) not null,
  CALENDAR_YEAR numeric(4) null,
  CALENDAR_MONTH numeric(2) null,
  DLCC_DEBIT_BASE_AMOUNT numeric(15,5) null,
  DLCC_CREDIT_BASE_AMOUNT numeric(15,5) null,
  primary key( COM_CODE,
  GLCC_FISCAL_YEAR,GLCC_MONTH,CUR_CODE,CCC_COST_SERIAL) ,
  );

create table DBA.CHART_OF_ACCOUNTS(
  CHRT_SERIAL double not null,
  CHRT_ACCOUNT_CODE char(30) not null,
  CHRT_ACCOUNT_NAME_1 varchar(60) null,
  CHRT_ACCOUNT_NAME_2 varchar(60) null,
  CHRT_ACCOUNT_TYPE char(1) null,
  CHRT_ACCOUNT_NATURE char(1) null,
  CHRT_CASH_ACCOUNT char(1) null,
  CHRT_ACCOUNT_IN_STATMENT_1 numeric(1) null,
  CHRT_ACCOUNT_IN_STATMENT_2 numeric(1) null,
  CHRT_BANK_ACCOUNT char(1) null,
  CHRT_OVER_DRAFT_ACCOUNT char(1) null,
  CHRT_ACCOUNT_IN_TRAIL_BAL numeric(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  TREE_CODE_L1 char(3) not null,
  TREE_CODE_L2 char(3) not null,
  TREE_CODE_L3 char(3) not null,
  TREE_CODE_L4 char(3) not null,
  TREE_CODE_L5 char(3) not null,
  TREE_CODE_L6 char(3) not null,
  USED_FLAG char(1) null,
  CUR_CODE char(3) not null,
  primary key( CHRT_SERIAL) ,
  );

create table DBA.GL_NOTES_MODIFICATIONS(
  COM_CODE char(3) not null,
  P_FISCAL_YEAR char(11) not null,
  PAPER_TYPE char(2) not null,
  PAPER_IN_OUT char(1) not null,
  PAPER_SERIAL double not null,
  GLNM_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GLNM_TODAY_DAY date null,
  GLNM_DOC_LOCATION char(10) null,
  GLNM_REFUSE_REASON char(1) null,
  primary key( COM_CODE,
  P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL,GLNM_SERIAL) ,
  );

create table DBA.GL_JV_SUMMERY(
  CHRT_SERIAL double not null,
  COM_CODE char(3) not null,
  CUR_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GLJV_FISCAL_YEAR char(11) not null,
  GLJV_MONTH integer not null,
  GLJV_DEBIT_AMOUNT numeric(15,5) not null,
  GLJV_CREDIT_AMOUNT numeric(15,5) not null,
  CALENDAR_YEAR numeric(4) null,
  CALENDAR_MONTH numeric(2) null,
  GLJV_BASE_DEBIT_AMOUNT numeric(15,5) null,
  GLJV_BASE_CREDIT_AMOUNT numeric(15,5) null,
  primary key( CHRT_SERIAL,
  COM_CODE,CUR_CODE,GLJV_FISCAL_YEAR,GLJV_MONTH) ,
  );

create table DBA.GL_COST_CENTER_DETAIL(
  COM_CODE char(3) not null,
  CUR_CODE char(3) not null,
  GLCC_FISCAL_YEAR char(11) not null,
  GLCC_MONTH integer not null,
  MOD_MODULE_ID char(10) not null,
  MTT_TRANS_TYPE_1 char(2) not null,
  MTT_TRANS_TYPE_2 char(2) not null,
  CCC_COST_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CCD_DEBIT_AMOUNT numeric(15,5) null,
  CCD_CREDIT_AMOUNT numeric(15,5) null,
  CALENDAR_YEAR numeric(4) null,
  CALENDAR_MONTH numeric(2) null,
  CCD_DEBIT_BASE_AMOUNT numeric(15,5) null,
  CCD_CREDIT_BASE_AMOUNT numeric(15,5) null,
  primary key( COM_CODE,
  CUR_CODE,GLCC_FISCAL_YEAR,GLCC_MONTH,MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2,CCC_COST_SERIAL) ,
  );

create table DBA.GL_PERIOD(
  COM_CODE char(3) not null,
  GLP_FISCAL_YEAR char(11) not null,
  GLP_MONTH integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GLP_STATUS char(1) null,
  primary key( COM_CODE,
  GLP_FISCAL_YEAR,GLP_MONTH) ,
  );

create table DBA.MODULE_TRANSACTIONS_GL_ACCOUNT(
  COM_CODE char(3) not null,
  MOD_MODULE_ID char(10) not null,
  MTT_TRANS_TYPE_1 char(2) not null,
  MTT_TRANS_TYPE_2 char(2) not null,
  MTGL_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRT_SERIAL double null,
  MTGL_DESCRIPTION varchar(50) null,
  MTGL_DESCRIPTION_2 varchar(50) null,
  MTGL_SUB_LEDGER char(1) null,
  MTGL_DEBIT_CREDIT char(1) null,
  MTGL_PERCENT numeric(5,2) null,
  GIA_SERIAL integer null,
  MTGL_DW_COL_NAME varchar(30) null,
  MLV_CODE_L1 char(3) null,
  MLV_CODE_L2 char(3) null,
  MLV_CODE_L3 char(3) null,
  MLV_CODE_L4 char(3) null,
  MLV_CODE_L5 char(3) null,
  MLV_CODE_L6 char(3) null,
  MTGL_USER_EDIT_FLAG char(1) null,
  MTGL_SUB_GEN char(1) null,
  MTGL_SHOW char(1) null,
  MTGL_USED_FLAG char(1) null,
  primary key( COM_CODE,
  MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2,MTGL_SERIAL) ,
  );

create table DBA.WORK_STATION_COMPANY(
  COM_CODE char(3) not null,
  CASH_SERIAL integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CASH_MC_TYPE char(1) null,
  CHRT_SERIAL double null,
  WS_STATUS char(1) null,
  primary key( COM_CODE,
  CASH_SERIAL) ,
  );

create table DBA.COMPANY_MODULES(
  MOD_MODULE_ID char(10) not null,
  COM_CODE char(3) not null,
  INSTALLED char(1) null,
  INTEGERATED char(1) null,
  primary key( MOD_MODULE_ID,
  COM_CODE) ,
  );

create table DBA.COMPANY_BANK_ACCOUNTS(
  COM_CODE char(3) not null,
  BAT_CODE char(3) not null,
  BNK_CODE char(3) not null,
  CUR_CODE char(3) not null,
  CHRT_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHB_BANK_ACCOUNT_NUMBER varchar(30) not null,
  primary key( COM_CODE,
  BAT_CODE,BNK_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER) ,
  );

create table DBA.BANK_ACCOUNT_TRANSACTION(
  COM_CODE char(3) not null,
  BAT_CODE char(3) not null,
  BNK_CODE char(3) not null,
  CUR_CODE char(3) not null,
  CHB_BANK_ACCOUNT_NUMBER varchar(30) not null,
  BNKTRN_TRANSACTION_DATE timestamp not null,
  BNKTRN_CASH_IN numeric(15,5) null,
  BNKTRN_CASH_OUT numeric(15,5) null,
  BNKTRN_PAPER_IN numeric(15,5) null,
  BNKTRN_PAPER_OUT numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CALENDAR_YEAR numeric(4) null,
  CALENDAR_MONTH numeric(2) null,
  primary key( COM_CODE,
  BAT_CODE,BNK_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER,BNKTRN_TRANSACTION_DATE) ,
  );

create table DBA.GL_BANK_DETAIL_SUMMARY(
  BAT_CODE char(3) not null,
  BNK_CODE char(3) not null,
  COM_CODE char(3) not null,
  CUR_CODE char(3) not null,
  CHB_BANK_ACCOUNT_NUMBER varchar(30) not null,
  GLBD_FISCAL_YEAR char(11) not null,
  GLBD_MONTH integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GLBD_CASH_IN numeric(15,5) null,
  GLBD_CASH_OUT numeric(15,5) null,
  GLBD_PAPER_IN numeric(15,5) null,
  GLBD_PAPER_OUT numeric(15,5) null,
  CALENDAR_YEAR numeric(4) null,
  CALENDAR_MONTH numeric(2) null,
  primary key( BAT_CODE,
  BNK_CODE,COM_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER,GLBD_FISCAL_YEAR,GLBD_MONTH) ,
  );

create table DBA.GL_JOURNAL_VOUCHER_DETAIL(
  COM_CODE char(3) not null,
  JVH_DOC_FISCAL_YEAR char(11) not null,
  JVH_TRANS_TYPE1 char(2) not null,
  JVH_TRANS_TYPE2 char(2) not null,
  JVH_DOC_SERIAL double not null,
  JVD_SERIAL integer not null,
  P_FISCAL_YEAR char(11) null,
  PAPER_TYPE char(2) null,
  PAPER_IN_OUT char(1) null,
  PAPER_SERIAL double null,
  DEBIT_CHRT_SERIAL double null,
  CREDIT_CHRT_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  JVD_DEBIT_FLAG_TYPE char(2) null,
  JVD_DEBIT_FLAG char(2) null,
  JVD_DEBIT_CODE_SERIAL double null,
  JVD_DEBIT_AMOUNT numeric(15,5) null,
  JVD_CREDIT_FLAG_TYPE char(2) null,
  JVD_CREDIT_FLAG char(2) null,
  JVD_CREDIT_CODE_SERIAL double null,
  JVD_CREDIT_AMOUNT numeric(15,5) null,
  JVD_PAPER_DEBIT_CREDIT char(1) null,
  JVD_PAPER_STATUS char(1) null,
  JVD_DETAIL_DIST char(1) null,
  CCC_COST_SERIAL double null,
  JVD_DIST_FLAG_TYPE char(2) null,
  JVD_DIST_FLAG char(2) null,
  OLD_CHRT_SERIAL double null,
  PAPER_NUMBER varchar(20) null,
  PAPER_ISSUE_DATE timestamp null,
  PAPER_DUE_DATE timestamp null,
  JVD_DEBIT_CODE varchar(30) null,
  JVD_CREDIT_CODE varchar(30) null,
  RIGHT_CCC_COST_SERIAL double null,
  JVD_OLD_FLAG_TYPE char(2) null,
  JVD_OLD_FLAG char(2) null,
  ORG_JVH_DOC_FISCAL_YEAR char(11) null,
  ORG_JVH_TRANS_TYPE1 char(2) null,
  ORG_JVH_TRANS_TYPE2 char(2) null,
  ORG_JVH_DOC_SERIAL double null,
  ORG_JVD_SERIAL integer null,
  JVD_NOTES varchar(500) null,
  primary key( COM_CODE,
  JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL) ,
  );

create table DBA.GL_VOUCHER_DETAIL_DIST(
  COM_CODE char(3) not null,
  JVH_DOC_FISCAL_YEAR char(11) not null,
  JVH_TRANS_TYPE1 char(2) not null,
  JVH_TRANS_TYPE2 char(2) not null,
  JVH_DOC_SERIAL double not null,
  JVD_SERIAL integer not null,
  VDD_SERIAL integer not null,
  VDD_FLAG char(2) null,
  VDD_MODULE_ID char(3) null,
  VDD_FISCAL_YEAR char(11) null,
  VDD_STO_CODE char(3) null,
  VDD_TRANS_TYPE1 char(2) null,
  VDD_TRANS_TYPE2 char(2) null,
  VDD_TRANS_NO double null,
  VDD_FLAG_TYPE char(2) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  VDD_DEBIT_CREDIT char(1) null,
  VDD_AMOUNT numeric(15,5) null,
  VDD_TRANS_DATE timestamp null,
  VDD_DROPPED char(1) null,
  vdd_dnpymnt numeric(15,5) null,
  vdd_dfrnc numeric(15,5) null,
  vdd_rsrv1 numeric(15,5) null,
  vdd_rsrv2 numeric(15,5) null,
  vdd_flag1 char(1) null,
  vdd_flag2 char(1) null,
  vdd_flag3 char(1) null,
  primary key( COM_CODE,
  JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL,VDD_SERIAL) ,
  );

create table DBA.CUR_FACILITY_TABLE(
  COM_CODE char(3) not null,
  CUS_SERIAL double not null,
  DOC_DATE date not null,
  SERIAL double null,
  FACILITY_PERIOD char(4) null,
  FACILITY_VOLUME numeric(15,5) null,
  GUARANTEE_TYPE char(1) null,
  GUARANTEE_DATA varchar(60) null,
  P_O_MANAGER1 varchar(60) null,
  P_O_MANAGER2 varchar(60) null,
  BANK1 varchar(60) null,
  BANK1_ADD varchar(60) null,
  BANK2_ADD varchar(60) null,
  BANK2 varchar(60) null,
  REF1_NAME varchar(60) null,
  REF1_ADD varchar(60) null,
  REF1_PHON char(15) null,
  REF2_NAME varchar(60) null,
  REF2_ADD varchar(60) null,
  REF2_PHON char(15) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PRT_CODE char(3) not null,
  PAID_PERCENT numeric(5,2) null,
  MAX_LIMIT numeric(15,5) null,
  QTY_DISCOUNT_LIMIT numeric(15,5) null,
  VALUE_DISCOUNT_LIMIT numeric(15,5) null,
  DISCOUNT_VALUE numeric(15,5) null,
  DISCOUNT_PERCENT numeric(6,4) null,
  TYPE_FLAG char(1) null,
  discount_percent2 numeric(6,4) null default
  0.0,
  discount_percent3 numeric(6,4) null default 0.0,
  primary key( COM_CODE,CUS_SERIAL,DOC_DATE) ,
  );

create table DBA.PROMOTION_HEADER(
  PRO_SERIAL integer not null,
  PRT_CODE char(3) not null,
  START_DATE date not null,
  END_DATE date not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  START_TIME time not null,
  END_TIME time not null,
  UPDATE_FLAG char(1) null,
  COM_CODE char(3) not null,
  STO_CODE char(3) null,
  TYPE_FLAG char(1) null,
  primary key( PRO_SERIAL,
  COM_CODE) ,
  );

create table DBA.FOOD(
  FOOD_CODE char(4) not null,
  FOOD_NAME1 varchar(60) null,
  FOOD_NAME2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( FOOD_CODE) ,
  );

create table DBA.REPLACEMENT_ITEM(
  COM_CODE char(3) not null,
  BASE_ITM_SERIAL double not null,
  REPLACMENT_ITM_SERIAL double not null,
  ITR_DATE timestamp null,
  ITR_REMARKS varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  BASE_ITM_SERIAL,REPLACMENT_ITM_SERIAL) ,
  );

create table DBA.SALES_TAX_TRANSACTION(
  COM_CODE char(3) not null,
  STT_DATE date not null,
  STT_SERIAL integer not null,
  TAX_AMOUNT numeric(15,5) null,
  DOCUMENT_AMOUNT numeric(15,5) null,
  CUS_VEN_SERIAL double null,
  STT_MODULE_ID char(6) null,
  STORE_CODE char(3) null,
  TRANS_TYPE_1 char(2) null,
  TRANS_TYPE_2 char(2) null,
  TRANS_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  STT_DATE,STT_SERIAL) ,
  );

create table DBA.FOOD_DRUG_INTERACTION(
  FOOD_CODE char(4) not null,
  ITM_SERIAL double not null,
  REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( FOOD_CODE,
  ITM_SERIAL) ,
  );

create table DBA.ITEM_CUSTOMER(
  COM_CODE char(3) not null,
  CUS_SERIAL double not null,
  ITM_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  CUS_SERIAL,ITM_SERIAL) ,
  );

create table DBA.ITEM_COMPANY_VENDOR_PRICE(
  COM_CODE char(3) not null,
  VEN_SERIAL double not null,
  ITM_SERIAL double not null,
  ICVP_PRICE_DATE timestamp not null,
  ICVP_SALES_TAX numeric(15,5) null,
  ICVP_SALES_TAX_PERCENT numeric(4,2) null,
  ICVP_DISCOUNT_1 numeric(4,2) null,
  ICVP_DISCOUNT_2 numeric(4,2) null,
  ICVP_DISCOUNT_3 numeric(4,2) null,
  LEAD_TIME numeric(5,2) null,
  SALES_PRICE numeric(15,5) null,
  SALES_TAX_2 numeric(4,2) null,
  ITU_CODE char(3) null,
  ICVP_FACTOR numeric(16,6) null,
  primary key( COM_CODE,
  VEN_SERIAL,ITM_SERIAL,ICVP_PRICE_DATE) ,
  );

create table DBA.ITEM_COMPANY_CUSTOMER_PRICE(
  COM_CODE char(3) not null,
  CUS_SERIAL double not null,
  ITM_SERIAL double not null,
  ICCP_PRICE_DATE timestamp not null,
  ICCP_PRICE numeric(15,5) null,
  ICCP_QTY numeric(15,5) null,
  ICCP_VALUE numeric(15,5) null,
  ICCP_DISCOUNT numeric(4,2) null,
  ICCP_DISCOUNT_VALUE numeric(15,5) null,
  ICCP_PRICE_FACTOR char(1) null,
  ICCP_SALES_TAX_2 numeric(4,2) null,
  USED_FLAG char(1) null,
  ISP_CODE char(3) null,
  ICCP_FACTOR numeric(16,4) null,
  primary key( COM_CODE,
  CUS_SERIAL,ITM_SERIAL,ICCP_PRICE_DATE) ,
  );

create table DBA.GROUP_CUSTOMER_PRICE(
  MLV_CODE_L1 char(3) not null,
  MLV_CODE_L2 char(3) not null,
  MLV_CODE_L3 char(3) not null,
  MLV_CODE_L4 char(3) not null,
  MLV_CODE_L5 char(3) not null,
  MLV_CODE_L6 char(3) not null,
  CUS_SERIAL double not null,
  COM_CODE char(3) not null,
  GCP_PRICE_DATE timestamp not null,
  GCP_PRICE numeric(15,5) null,
  GCP_QTY numeric(15,5) null,
  GCP_VALUE numeric(15,5) null,
  GCP_DISCOUNT numeric(4,2) null,
  GCP_DISCOUNT_VALUE numeric(15,5) null,
  ICCP_PRICE_FACTOR2 char(1) null,
  GCP_SALES_TAX_2 numeric(4,2) null,
  primary key( MLV_CODE_L1,
  MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6,CUS_SERIAL,COM_CODE,GCP_PRICE_DATE) ,
  );

create table DBA.PROMOTION_ITEMS_DETAIL(
  PRO_SERIAL integer not null,
  COM_CODE char(3) not null,
  ITM_SERIAL double not null,
  DISCOUNT_VALUE numeric(15,5) null,
  DISCOUNT_PERCENT numeric(4,2) null,
  QTY_DISCOUNT_LIMIT numeric(15,5) null,
  VALUE_DISCOUNT_LIMIT numeric(15,5) null,
  UPDATE_FLAG char(1) null,
  primary key( PRO_SERIAL,
  COM_CODE,ITM_SERIAL) ,
  );

create table DBA.PROMOTION_GROUB_DETAIL(
  COM_CODE char(3) not null,
  PRO_SERIAL integer not null,
  MLV_CODE_L1 char(3) not null,
  MLV_CODE_L2 char(3) not null,
  MLV_CODE_L3 char(3) not null,
  MLV_CODE_L4 char(3) not null,
  MLV_CODE_L5 char(3) not null,
  MLV_CODE_L6 char(3) not null,
  DISCOUNT_VALUE numeric(15,5) null,
  DISCOUNT_PERCENT numeric(4,2) null,
  QTY_DISCOUNT_LIMIT numeric(15,5) null,
  VALUE_DISCOUNT_LIMIT numeric(15,5) null,
  UPDATE_FLAG char(1) null,
  primary key( COM_CODE,
  PRO_SERIAL,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) ,
  );

create table DBA.CUR_FACILITY_ITEM_DISCOUNT(
  CUS_SERIAL double not null,
  DOC_DATE date not null,
  COM_CODE char(3) not null,
  ITM_SERIAL double not null,
  PRT_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CFID_QTY numeric(15,5) null,
  CFID_VALUE numeric(15,5) null,
  CFID_DISCOUNT_PERCENT numeric(6,4) null,
  CFID_DISCOUNT_VALUE numeric(15,5) null,
  UPDATE_FLAG char(1) null,
  primary key( CUS_SERIAL,
  DOC_DATE,COM_CODE,ITM_SERIAL) ,
  );

create table DBA.CUR_FACILITY_GROUP_DISCOUNT(
  CUS_SERIAL double not null,
  COM_CODE char(3) not null,
  DOC_DATE date not null,
  MLV_CODE_L1 char(3) not null,
  MLV_CODE_L2 char(3) not null,
  MLV_CODE_L3 char(3) not null,
  MLV_CODE_L4 char(3) not null,
  MLV_CODE_L5 char(3) not null,
  MLV_CODE_L6 char(3) not null,
  PRT_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CFGD_QTY numeric(15,5) null,
  CFGD_VALUE numeric(15,5) null,
  CFGD_DISCOUNT_PRECENT numeric(6,4) null,
  CFGD_DISCOUNT_VALUE numeric(15,5) null,
  UPDATE_FLAG char(1) null,
  primary key( CUS_SERIAL,
  COM_CODE,DOC_DATE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) ,
  );

create table DBA.CUSTOMER_OPEN_BAL(
  CUS_SERIAL double not null,
  COM_CODE char(3) not null,
  COB_DATE timestamp not null,
  CHRT_SERIAL double null,
  COB_DEBIT_AMOUNT numeric(15,5) null,
  COB_CREDIT_AMOUNT numeric(15,5) null,
  COB_BASE_DEBIT_AMOUNT numeric(15,5) null,
  COB_BASE_CREDIT_AMOUNT numeric(15,5) null,
  COB_POSTED_FLAG char(1) null,
  primary key( CUS_SERIAL,
  COM_CODE) ,
  );

create table DBA.VENDOR_OPEN_BAL(
  VEN_SERIAL double not null,
  COM_CODE char(3) not null,
  VOB_DATE timestamp not null,
  CHRT_SERIAL double null,
  VOB_DEBIT_AMOUNT numeric(15,5) null,
  VOB_CREDIT_AMOUNT numeric(15,5) null,
  VOB_BASE_DEBIT_AMOUNT numeric(15,5) null,
  VOB_BASE_CREDIT_AMOUNT numeric(15,5) null,
  VOB_POSTED_FLAG char(1) null,
  primary key( VEN_SERIAL,
  COM_CODE) ,
  );

create table DBA.CHART_OPEN_BAL(
  CHRT_SERIAL double not null,
  COM_CODE char(3) not null,
  CHOB_DATE timestamp not null,
  COB_DEBIT_AMOUNT numeric(15,5) null,
  COB_CREDIT_AMOUNT numeric(15,5) null,
  COB_BASE_DEBIT_AMOUNT numeric(15,5) null,
  COB_BASE_CREDIT_AMOUNT numeric(15,5) null,
  COB_POSTED_FLAG char(1) null,
  COB_UPDATE_FLAG char(1) null,
  primary key( CHRT_SERIAL,
  COM_CODE) ,
  );

create table DBA.EDUCATION_SEPC(
  EDU_CODE_L1 char(3) not null,
  EDU_CODE_L2 char(3) not null,
  EDU_CODE_L3 char(3) not null,
  EDU_CODE_L4 char(3) not null,
  EDU_CODE_L5 char(3) not null,
  EDU_CODE_L6 char(3) not null,
  EDU_PARENT_CODE_L1 char(3) null,
  EDU_PARENT_CODE_L2 char(3) null,
  EDU_PARENT_CODE_L3 char(3) null,
  EDU_PARENT_CODE_L4 char(3) null,
  EDU_PARENT_CODE_L5 char(3) null,
  EDU_PARENT_CODE_L6 char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  USED_FLAG char(1) null,
  primary key( EDU_CODE_L1,
  EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6) ,
  );

create table DBA.BENEFIT(
  B_CODE char(3) not null,
  B_NAME_L1 varchar(60) not null,
  B_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( B_CODE) ,
  );

create table DBA.JOB_TITLE(
  JT_CODE char(3) not null,
  JT_NAME_L1 varchar(60) not null,
  JT_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( JT_CODE) ,
  );

create table DBA.SOCIAL_STATUS(
  SS_CODE char(3) not null,
  SS_NAME_L1 varchar(60) not null,
  SS_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  SS_YEAR_EXEMPT_LIMIT numeric(15,5) null,
  SS_YEAR_RAISE numeric(15,5) null,
  primary key( SS_CODE) ,
  );

create table DBA.NATIONALITY(
  N_CODE char(3) not null,
  N_NAME_L1 varchar(60) not null,
  N_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( N_CODE) ,
  );

create table DBA.CAUSE(
  C_CODE char(3) not null,
  C_NAME_L1 varchar(60) not null,
  C_NAME_L2 varchar(60) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  TYPE char(1) null,
  primary key( C_CODE) ,
  );

create table DBA.ALLOWAN_DEDUC_GROUP(
  ADG_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ADG_NAME_L1 varchar(60) not null,
  ADG_NAME_L2 varchar(60) null,
  primary key( ADG_CODE) ,
  );

create table DBA.EMPLOYEE(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  EM_NAME_L1 varchar(60) not null,
  EM_NAME_L2 varchar(60) null,
  CCC_COST_SERIAL double null,
  SS_CODE char(3) null,
  N_CODE char(3) null,
  JT_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  EM_INSURE_NO varchar(30) null,
  EM_BIRTH_DATE timestamp null,
  EM_HIRE_DATE timestamp null,
  EM_RESIGNATION_DATE timestamp null,
  ORG_CODE_L1 char(3) not null,
  ORG_CODE_L2 char(3) not null,
  ORG_CODE_L3 char(3) not null,
  ORG_CODE_L4 char(3) not null,
  ORG_CODE_L5 char(3) not null,
  ORG_CODE_L6 char(3) not null,
  CUR_CODE char(3) null,
  EM_BORN_IN varchar(60) null,
  EM_ID_CODE_NO varchar(20) null,
  EM_ID_ISSUED_FROM varchar(60) null,
  EM_SUGGESTED_INCREASE numeric(15,5) null,
  EM_REMARKS varchar(100) null,
  EM_UNIT char(1) null,
  EM_DESERVE_OVER_TIME char(1) null,
  EM_TREATMENT_TYPE char(1) null,
  EM_SALARY_TIME char(1) null,
  EM_HEALTH_INSURE_NO varchar(20) null,
  EM_EMPLOYEE_TYPE char(1) null,
  EM_SALARY_PERIOD char(1) null,
  CHRM_CODE char(3) null,
  EM_HOLIDAY_BALANCE numeric(5,2) null,
  EM_HOLIDAY_YEAR numeric(5,2) null,
  EM_F_WORKING_YEAR integer null,
  EM_LAST_H_YEAR integer null,
  LC_CODE char(3) null,
  EM_HOLIDAY_OB numeric(5,2) null,
  GR_CODE char(3) null,
  IT_CODE char(3) null,
  EM_SALARY_FACTOR numeric(5,2) null,
  EM_ADDRESS_L1 varchar(100) null,
  EM_OFF_LOCATION_L1 varchar(100) null,
  EM_POLICE_ST_L1 varchar(50) null,
  EM_GOVERNERATE_L1 varchar(50) null,
  em_contract_period integer null,
  em_contract_date timestamp null,
  EM_ADDRESS_L2 varchar(100) null,
  EM_OFF_LOCATION_L2 varchar(100) null,
  EM_POLICE_ST_L2 varchar(100) null,
  EM_GOVERNERATE_L2 varchar(100) null,
  EDU_CODE_L1 char(3) null,
  EDU_CODE_L2 char(3) null,
  EDU_CODE_L3 char(3) null,
  EDU_CODE_L4 char(3) null,
  EDU_CODE_L5 char(3) null,
  EDU_CODE_L6 char(3) null,
  em_serial double null,
  em_sex char(1) null,
  em_insur_str_date timestamp null,
  em_insur_end_date timestamp null,
  EM_TELEPHONE varchar(40) null,
  EM_MAIL varchar(100) null,
  EM_FAX varchar(40) null,
  primary key( COM_CODE,
  EM_CODE) ,
  );

create table DBA.WORKING_CALENDER(
  COM_CODE char(3) not null,
  WC_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  WC_SAT_TYPE char(1) null,
  WC_SAT_START time null,
  WC_SAT_END time null,
  WC_SUN_TYPE char(1) null,
  WC_SUN_START time null,
  WC_SUN_END time null,
  WC_MON_TYPE char(1) null,
  WC_MON_START time null,
  WC_MON_END time null,
  WC_TUE_TYPE char(1) null,
  WC_TUE_START time null,
  WC_TUE_END time null,
  WC_WED_TYPE char(1) null,
  WC_WED_START time null,
  WC_WED_END time null,
  WC_THR_TYPE char(1) null,
  WC_THR_START time null,
  WC_THR_END time null,
  WC_FRI_TYPE char(1) null,
  WC_FRI_START time null,
  WC_FRI_END time null,
  primary key( COM_CODE,
  WC_CODE) ,
  );

create table DBA.ATTENDANCE_SHEET(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  C_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  AS_TIME_IN_OUT timestamp not null,
  AS_IN_OUT_FLAG char(1) null,
  AS_CONFIRM_FLAG char(1) null,
  AS_ADD_FLAG char(1) null,
  AS_DAY_TYPE char(1) null,
  AS_ALTER_DAY timestamp null,
  AS_OVER_TIME char(1) null,
  AS_START_TIME time null,
  AS_END_TIME time null,
  AS_NOTES varchar(100) null,
  as_in_margen decimal(5,3) null,
  as_out_margen decimal(5,3) null,
  primary key( COM_CODE,
  EM_CODE,AS_TIME_IN_OUT) ,
  );

create table DBA.ALLOWAN_DEDUCTION(
  COM_CODE char(3) not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  CHRT_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  AD_NAME_L1 varchar(60) not null,
  AD_NAME_L2 varchar(60) null,
  AD_TREATMENT_TYPE char(1) null,
  AD_YEAR_EXEMPT_LIMIT numeric(15,5) null,
  AD_ACCOUNT_CODE varchar(30) null,
  AD_PAYSLIP_FLAG char(1) null,
  AD_ALLOWN_INVOLVE char(1) null,
  AD_SIKNESS_INVOLVE char(1) null,
  AD_ABSENCE_INVOLVE char(1) null,
  AD_PENALITY_INVOLVE char(1) null,
  AD_OVERTIME_INVOLVE char(1) null,
  AD_TAXABLE char(1) null,
  ad_sign numeric(2) null default
  0.0,
  primary key( COM_CODE,ADG_CODE,AD_CODE) ,
  );

create table DBA.SALARY_TIME_EFFECT(
  ADG_CODE char(3) not null,
  COM_CODE char(3) not null,
  STE_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  STE_NAME_L1 varchar(60) not null,
  STE_NAME_L2 varchar(60) null,
  STE_TREATMENT_TYPE char(1) null,
  STE_DAY_HOUR_FLAG char(1) null,
  STE_PAYSLIP_FLAG char(1) null,
  STE_MULTIPLAY_FACTOR numeric(15,5) null,
  STE_V_TYPE_FLAG char(1) null,
  primary key( ADG_CODE,
  COM_CODE,STE_CODE) ,
  );

create table DBA.INSURANCE_TAX(
  COM_CODE char(3) not null,
  IT_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  IT_NAME_L1 varchar(60) not null,
  IT_NAME_L2 varchar(60) null,
  IT_BASIC_INSURE_MAX numeric(15,5) null,
  IT_COM_SHARE1_PERCENT numeric(5,2) null,
  IT_EMP_SHARE1_PRECENT numeric(5,2) null,
  IT_VARIABLE_INSURE_MAX numeric(15,5) null,
  IT_COM_SHARE2_PERCENT numeric(5,2) null,
  IT_EMP_SHARE2_PERCENT numeric(5,2) null,
  IT_INCOME_IN_RETURN numeric(15,5) null,
  IT_RESOURCE_TAX_PERCENT numeric(5,2) null,
  IT_GROWING_TAX_MAX numeric(15,5) null,
  IT_HEALTH_INSURE_PERCENT numeric(5,2) null,
  IT_HEALTH_INSURE_MAX numeric(15,5) null,
  IT_GENERAL_EXEMPT_MAX numeric(15,5) null,
  IT_TAX_SLICE1 numeric(15,5) null,
  IT_TAX_PECENT1 numeric(5,2) null,
  IT_TAX_SLICE2 numeric(15,5) null,
  IT_TAX_PECENT2 numeric(5,2) null,
  IT_TAX_SLICE3 numeric(15,5) null,
  IT_TAX_PERCENT3 numeric(5,2) null,
  IT_TAX_SLICE4 numeric(15,5) null,
  IT_TAX_PERCENT4 numeric(5,2) null,
  IT_TAX_SLICE5 numeric(15,5) null,
  IT_TAX_PRECENT5 numeric(5,2) null,
  primary key( COM_CODE,
  IT_CODE) ,
  );

create table DBA.GENERAL_RULE(
  COM_CODE char(3) not null,
  GR_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GR_NAME_L1 varchar(60) not null,
  GR_NAME_L2 varchar(60) null,
  GR_MONTH_NO_DAYS numeric(2) null,
  GR_MONTH_NO_HOURS numeric(4) null,
  GR_DAY_NO_HOURS numeric(2) null,
  GR_TRAINNING_PERIOD numeric(2) null,
  GR_OVER_TIME1 char(1) null,
  GR_NO_HOURS1 integer null,
  GR_OVER_TIME2 char(1) null,
  GR_NO_HOURS2 integer null,
  GR_OVER_TIME3 char(1) null,
  GR_NO_HOURS3 integer null,
  GR_MONTH_LAST_DAY integer null,
  GR_DELAY_TIME1 char(1) null,
  GR_DELAY_TIME2 char(1) null,
  GR_DELAY_TIME3 char(1) null,
  GR_DELAY_HOURS1 integer null,
  GR_DELAY_HOURS2 integer null,
  GR_DELAY_HOURS3 integer null,
  GR_OVER_FACTOR1 numeric(5,2) null,
  GR_OVER_FACTOR2 numeric(5,2) null,
  GR_OVER_FACTOR3 numeric(5,2) null,
  GR_DELAY_FACTOR1 numeric(5,2) null,
  GR_DELAY_FACTOR2 numeric(5,2) null,
  GR_DELAY_FACTOR3 numeric(5,2) null,
  GR_FLAG char(1) null,
  GR_FACTOR numeric(5,2) null,
  GR_TIME1 time null,
  GR_TIME2 time null,
  GR_NUMBER1 double null,
  GR_NUMBER2 double null,
  GR_NUMBER3 double null,
  GR_NUMBER4 double null,
  GR_NUMBER5 double null,
  GR_STR1 varchar(100) null,
  GR_STR2 varchar(100) null,
  GR_STR3 varchar(100) null,
  GR_STR4 varchar(100) null,
  GR_STR5 varchar(100) null,
  GR_STR6 varchar(100) null,
  GR_DATE1 timestamp null,
  GR_DATE2 timestamp null,
  GR_DEC1 numeric(15,5) null,
  GR_DEC2 numeric(15,5) null,
  GR_DEC3 numeric(15,5) null,
  GR_DEC4 numeric(15,5) null,
  GR_DEC5 numeric(15,5) null,
  GR_DEC6 numeric(15,5) null,
  GR_CHR1 char(1) null,
  GR_CHR2 char(1) null,
  GR_CHR3 char(1) null,
  primary key( COM_CODE,
  GR_CODE) ,
  );

create table DBA.HOLIDAY(
  COM_CODE char(3) not null,
  V_YEAR numeric(4) not null,
  V_START_DATE timestamp not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  V_END_DATE timestamp not null,
  V_NAME_L1 varchar(60) not null,
  V_NAME_L2 varchar(60) null,
  primary key( COM_CODE,
  V_YEAR,V_START_DATE) ,
  );

create table DBA.EMP_WORKING_CALENDER(
  COM_CODE char(3) not null,
  WC_CODE char(3) not null,
  EM_CODE char(6) not null,
  EWC_DATE timestamp not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  WC_CODE,EM_CODE,EWC_DATE) ,
  );

create table DBA.GL_BALANCE_SHEET_SETUP(
  COM_CODE char(3) not null,
  BSS_SERIAL integer not null,
  MLV_CODE_L1 char(3) null,
  MLV_CODE_L2 char(3) null,
  MLV_CODE_L3 char(3) null,
  MLV_CODE_L4 char(3) null,
  MLV_CODE_L5 char(3) null,
  MLV_CODE_L6 char(3) null,
  BSS_DESC_L1 varchar(60) null,
  BSS_DESC_L2 varchar(60) null,
  BSS_HEADER char(1) null,
  BSS_DISPLAYED char(1) null,
  BSS_DISPLAY_TOTAL char(1) null,
  BSS_COMPTUED char(1) null,
  BSS_PARENT_SERIAL integer null,
  BSS_PARENT_SERIAL6 integer null,
  BSS_PARENT_SERIAL5 integer null,
  BSS_PARENT_SERIAL4 integer null,
  BSS_PARENT_SERIAL3 integer null,
  BSS_PARENT_SERIAL2 integer null,
  BSS_PARENT_SERIAL1 integer null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  BSS_TYPE char(1) not null,
  BSS_ITEM_NO integer null,
  BSS_FROM_TREE char(1) null,
  BSS_D_C_FLAG char(1) null,
  BSS_TOTAL_FLAG char(1) null,
  bss_total_value_flag char(1) null,
  primary key( COM_CODE,
  BSS_SERIAL,BSS_TYPE) ,
  );

create table DBA.GL_BALANCE_SHEET_CALC(
  COM_CODE char(3) not null,
  BSS_SERIAL integer not null,
  BSC_COUNTER integer not null,
  MLV_CODE_L1 char(3) null,
  MLV_CODE_L2 char(3) null,
  MLV_CODE_L3 char(3) null,
  MLV_CODE_L4 char(3) null,
  MLV_CODE_L5 char(3) null,
  MLV_CODE_L6 char(3) null,
  BSC_OPERATOR char(1) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  BSS_TYPE char(1) not null,
  CHRT_SERIAL double null,
  primary key( COM_CODE,
  BSS_SERIAL,BSC_COUNTER,BSS_TYPE) ,
  );

create table DBA.ITEM_STORE_OPEN_BAL(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  ITM_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRT_SERIAL double null,
  ISP_CODE char(3) null,
  PRICE_ISP_CODE char(3) null,
  ISOB_FACTOR numeric(15,5) null,
  ISOB_POSTED_FLAG char(1) null,
  ISOB_AVERAGE_COST numeric(15,5) null,
  ISOB_EXPIRY_FLAG char(1) null,
  ISOB_QTY numeric(15,5) null,
  ISOB_SALES_PRICE numeric(15,5) null,
  ISOB_ORIGINAL_QTY numeric(15,5) null,
  primary key( COM_CODE,
  STO_CODE,ITM_SERIAL) ,
  );

create table DBA.MANUAL_IN_OUT(
  COM_CODE char(3) not null,
  IO_FLAG char(1) not null,
  IO_DATE timestamp not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CASH_SERIAL integer not null,
  primary key( COM_CODE,
  IO_FLAG,IO_DATE,CASH_SERIAL) ,
  );

create table DBA.COMP_HOLIDAY_RULE_MASTER(
  COM_CODE char(3) not null,
  CHRM_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRM_NAME_L1 varchar(60) null,
  CHRM_NAME_L2 varchar(60) null,
  primary key( COM_CODE,
  CHRM_CODE) ,
  );

create table DBA.COMP_HOLIDAY_RULE_DETAIL(
  COM_CODE char(3) not null,
  CHRM_CODE char(3) not null,
  CHRD_YEAR_NO integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CHRD_YEARLY numeric(5,2) null,
  CHRD_TOTAL numeric(5,2) null,
  CHRD_YEARLY_EXP numeric(5,2) null,
  primary key( COM_CODE,
  CHRM_CODE,CHRD_YEAR_NO) ,
  );

create table DBA.TIME_DESIGNATOR_DAILY(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  ADG_CODE char(3) not null,
  TDD_DATE timestamp not null,
  STE_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  TDD_DAYS_COUNT numeric(5,2) null,
  TDD_HOURS_COUNT numeric(5,2) null,
  TDD_CONFIRM_FLAG char(1) null,
  TDD_ALTER_DAY timestamp null,
  TDD_DAY_TYPE char(1) null,
  TDD_END_DATE timestamp null,
  primary key( COM_CODE,
  EM_CODE,ADG_CODE,TDD_DATE,STE_CODE) ,
  );

create table DBA.LIVELS_CODES(
  LC_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  LC_NAME_L1 varchar(60) not null,
  LC_NAME_L2 varchar(60) null,
  primary key( LC_CODE) ,
  );

create table DBA.GL_PAPER_COLLECTION_HEADER(
  COM_CODE char(3) not null,
  BNK_CODE char(3) not null,
  PCH_SERIAL integer not null,
  PCH_FROM_DATE timestamp null,
  PCH_TO_DATE timestamp null,
  PCH_TRANS_DATE timestamp null,
  PCH_COMMENTS varchar(60) null,
  PCH_BANK_DOC_NO varchar(20) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PCH_FISCAL_YEAR char(11) not null,
  primary key( COM_CODE,
  BNK_CODE,PCH_SERIAL,PCH_FISCAL_YEAR) ,
  );

create table DBA.GL_PAPER_COLLECTION_DETAIL(
  COM_CODE char(3) not null,
  BNK_CODE char(3) not null,
  P_FISCAL_YEAR char(11) not null,
  PAPER_TYPE char(2) not null,
  PAPER_IN_OUT char(1) not null,
  PAPER_SERIAL double not null,
  PCH_SERIAL integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GLNC_BANK_EXPANCESS numeric(15,5) null,
  GLNC_AMOUNT_COLLECTED numeric(15,5) null,
  PCD_BANK_CASH char(1) null,
  CHRT_SERIAL double null,
  EXPENS_CHRT_SERIAL double null,
  PCD_EXCHANGE_RATE numeric(16,6) null,
  PCH_FISCAL_YEAR char(11) not null,
  primary key( COM_CODE,
  BNK_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL,PCH_SERIAL,PCH_FISCAL_YEAR) ,
  );

create table DBA.EMP_HOLIDAY_BALANCE(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  YEAR_NO integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  BALANCE numeric(5,2) null,
  primary key( COM_CODE,
  EM_CODE,YEAR_NO) ,
  );

create table DBA.EMP_HOLIDAY_OB(
  EHO_SERIAL double not null,
  COM_CODE char(3) null,
  EM_CODE char(6) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  HOLIDAY_OB numeric(5,2) null,
  primary key( EHO_SERIAL) ,
  );

create table DBA.SECURITY_INFO(
  USER_CODE char(8) not null,
  COM_CODE char(3) not null,
  CONTROL varchar(64) not null,
  STATUS char(1) null,
  "WINDOW" varchar(64) not null,
  primary key( USER_CODE,
  COM_CODE,CONTROL,"WINDOW") ,
  );

create table DBA.SYSTEM_PARAMETER(
  COM_CODE char(3) not null,
  MODULE_ID char(3) not null,
  WINDOW_NAME char(60) not null,
  CONTROL_NAME char(25) not null,
  COLUMN_NAME char(30) not null,
  STATUS char(1) null,
  INITIAL_VALUE varchar(100) null,
  VALUE_1 varchar(50) null,
  VALUE_2 varchar(50) null,
  SP_COMMENT varchar(100) null,
  SP_SHOW char(1) null,
  Detail_Disc varchar(500) null,
  primary key( COM_CODE,
  MODULE_ID,WINDOW_NAME,CONTROL_NAME,COLUMN_NAME) ,
  );

create table DBA."WINDOW"(
  "WINDOW" varchar(64) not null,
  DESCRIPTION1 varchar(100) null,
  DESCRIPTION2 varchar(100) null,
  MOD_MODULE_ID char(10) null,
  primary key( "WINDOW") ,
  );

create table DBA.SECURITY_TEMPLATE(
  "WINDOW" varchar(64) not null,
  CONTROL varchar(64) not null,
  OBJECT_TYPE varchar(24) null,
  DESCRIPTION1 varchar(100) null,
  DESCRIPTION2 varchar(100) null,
  primary key( "WINDOW",
  CONTROL) ,
  );

create table DBA.ALLOWANCES_ACCUMULATION_HEADER(
  AAH_SERIAL double not null,
  AAH_DATE timestamp not null,
  ORG_CODE_L1 char(3) null,
  ORG_CODE_L2 char(3) null,
  ORG_CODE_L3 char(3) null,
  ORG_CODE_L4 char(3) null,
  ORG_CODE_L5 char(3) null,
  ORG_CODE_L6 char(3) null,
  COM_CODE char(3) null,
  EM_CODE char(6) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( AAH_SERIAL) ,
  );

create table DBA.GIFTS_AND_BONUS(
  COM_CODE char(3) not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  GAB_DATE timestamp not null,
  ORG_CODE_L1 char(3) null,
  ORG_CODE_L2 char(3) null,
  ORG_CODE_L3 char(3) null,
  ORG_CODE_L4 char(3) null,
  ORG_CODE_L5 char(3) null,
  ORG_CODE_L6 char(3) null,
  GAB_DAYS_COUNT integer null,
  GAB_MAX_LIMIT numeric(8,2) null,
  GAB_MIN_LIMIT numeric(8,2) null,
  GAB_BASIC_OR_TOTAL char(1) null,
  GAB_MONTH_COUNT integer null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  GAB_PAYSLIP_FLAG char(1) null,
  GAB_VALUE_DATES_FLAG char(1) null,
  GAB_VALUE numeric(15,5) null,
  primary key( COM_CODE,
  ADG_CODE,AD_CODE,GAB_DATE) ,
  );

create table DBA.TIME_SHEET_TRANSACTION(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  COC_CODE_L1 char(3) not null,
  COC_CODE_L2 char(3) not null,
  COC_CODE_L3 char(3) not null,
  COC_CODE_L4 char(3) not null,
  COC_CODE_L5 char(3) not null,
  COC_CODE_L6 char(3) not null,
  TST_DATE timestamp not null,
  TST_FROM_HOUR time null,
  TST_TO_HOUR time null,
  TST_DAY_TYPE char(1) null,
  TST_NORMAL_TIME numeric(4,2) null,
  TST_OVER_TIME1 numeric(4,2) null,
  TST_OVER_TIME2 numeric(4,2) null,
  TST_OVER_TIME3 numeric(4,2) null,
  TST_OVER_TIME4 numeric(4,2) null,
  TST_OVER_TIME5 numeric(4,2) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  TST_DATE_2 timestamp null,
  TST_FLAG_DATE_TIME char(1) null,
  primary key( COM_CODE,
  EM_CODE,COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6,TST_DATE) ,
  );

create table DBA.ALLOWANCES_ACCUMULATION_DETAIL(
  COM_CODE char(3) not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  AAH_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  AAD_MAX_VALUE numeric(8,2) null,
  primary key( COM_CODE,
  ADG_CODE,AD_CODE,AAH_SERIAL) ,
  );

create table DBA.EMP_ALL_DED(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  EAD_VALUE numeric(10,2) not null,
  primary key( COM_CODE,
  EM_CODE,ADG_CODE,AD_CODE) ,
  );

create table DBA.REPEATED_TRANSACTION(
  RT_SERIAL double not null,
  COM_CODE char(3) not null,
  ADG_CODE char(3) null,
  AD_CODE char(3) null,
  EM_CODE char(6) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  RT_DATE timestamp not null,
  RT_VALUE numeric(10,2) not null,
  RT_MOUNTH_COUNT integer null,
  RT_LIQUIDATE_DATE timestamp null,
  RT_LIQUIDATE_VALUE numeric(10,2) null,
  RT_PERSENT numeric(5,2) null,
  RT_MOUNTHS_COUNTER integer null,
  RT_LAST_CALC_DATE timestamp null,
  RT_TYPE char(1) null,
  primary key( RT_SERIAL,
  COM_CODE) ,
  );

create table DBA.EMP_ALL_DED_EDIT_VALUE(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  ADG_GROUP char(3) not null,
  AD_GROUP char(3) not null,
  EAD_DATE timestamp not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  EAD_VALUE numeric(10,2) null,
  primary key( COM_CODE,
  EM_CODE,ADG_GROUP,AD_GROUP,EAD_DATE) ,
  );

create table DBA.FIAT_TABLE(
  FT_VALUE numeric(7) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  FT_DESC varchar(20) null,
  FL_LANG char(3) null,
  primary key( FT_VALUE) ,
  );

create table DBA.EMP_BANKS(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  EB_SERIAL double not null,
  BNK_CODE char(3) not null,
  CUR_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  EB_FACTOR numeric(5,2) not null,
  EB_BANK_NO varchar(30) null,
  primary key( COM_CODE,
  EM_CODE,EB_SERIAL) ,
  );

create table DBA.EMP_BENEFITS(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  B_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  EB_GET_DATE timestamp null,
  EB_STATUS char(1) null,
  EB_RETURN_DATE timestamp null,
  primary key( COM_CODE,
  EM_CODE,B_CODE) ,
  );

create table DBA.EMP_TEMP_TABLE2(
  ETT_SERIAL double not null,
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  CUR_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ETT_NAME varchar(40) null,
  ETT_DIV varchar(60) null,
  ETT_DEP varchar(60) null,
  ETT_SEC varchar(60) null,
  ETT_CC varchar(60) null,
  ETT_IT_CODE char(3) null,
  ETT_PAY_PERCENT numeric(3) null,
  ETT_GR_CODE char(3) null,
  primary key( ETT_SERIAL) ,
  );

create table DBA.PAYSLIP_CALC_MONTH(
  COM_CODE char(3) not null,
  PC_YEAR integer not null,
  PC_MONTH integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PC_FLAG char(1) not null,
  PC_CALC_DATE timestamp not null,
  primary key( COM_CODE,
  PC_YEAR,PC_MONTH) ,
  );

create table DBA.PAYSLIP_MONTHLY(
  ADG_CODE char(3) not null,
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  PM_CODE char(3) not null,
  PM_YEAR integer not null,
  PM_MONTH integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PM_VALUE numeric(10,3) not null,
  primary key( ADG_CODE,
  COM_CODE,EM_CODE,PM_CODE,PM_YEAR,PM_MONTH) ,
  );

create table DBA.payslip_monthly_copy(
  ADG_CODE char(3) not null,
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  PMC_CODE char(3) not null,
  PMC_YEAR integer not null,
  PMC_MONTH integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PM_VALUE numeric(10,3) not null,
  org_code_l1 char(3) null default '000',
  org_code_l2 char(3) null default '000',
  org_code_l3 char(3) null default '000',
  org_code_l4 char(3) null default '000',
  org_code_l5 char(3) null default '000',
  org_code_l6 char(3) null default '000',
  primary key( ADG_CODE,
  COM_CODE,EM_CODE,PMC_CODE,PMC_YEAR,PMC_MONTH) ,
  );

create table DBA.PAYSLIP_REPORT_TEMP_TABLE(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  PRTT_TYPE_FLAG char(1) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PRTT_VAL1 numeric(15,2) null,
  PRTT_VAL2 numeric(15,2) null,
  PRTT_VAL3 numeric(15,2) null,
  PRTT_VAL4 numeric(15,2) null,
  PRTT_VAL5 numeric(15,2) null,
  PRTT_VAL6 numeric(15,2) null,
  PRTT_VAL7 numeric(15,2) null,
  PRTT_VAL8 numeric(15,2) null,
  PRTT_VAL9 numeric(15,2) null,
  PRTT_VAL10 numeric(15,2) null,
  PRTT_VAL11 numeric(15,2) null,
  PRTT_VAL12 numeric(15,2) null,
  PRTT_VAL13 numeric(15,2) null,
  PRTT_VAL14 numeric(15,2) null,
  PRTT_VAL15 numeric(15,2) null,
  PRTT_VAL16 numeric(15,2) null,
  PRTT_VAL17 numeric(15,2) null,
  PRTT_VAL18 numeric(15,2) null,
  PRTT_TOTAL numeric(15,2) null,
  primary key( COM_CODE,
  EM_CODE,PRTT_TYPE_FLAG) ,
  );

create table DBA.WORK_STATION(
  CASH_SERIAL integer not null,
  WS_NAME1 varchar(50) null,
  WS_NAME2 varchar(50) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( CASH_SERIAL) ,
  );

create table DBA.PAYSLIP_SHEET_SETUP(
  COM_CODE char(3) not null,
  PSSS_TYPE char(1) not null,
  PSSS_COL_NAME varchar(20) not null,
  ADG_CODE char(3) null,
  PSSS_CODE char(3) null,
  PSSS_TEXT varchar(60) null,
  PSSS_VISABLE char(1) null,
  PSSS_ORDER integer null,
  primary key( COM_CODE,
  PSSS_TYPE,PSSS_COL_NAME) ,
  );

create table DBA.ITEM_STORE_OPEN_BAL_DETAIL(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  ITM_SERIAL double not null,
  ISOD_LINE_SERIAL integer not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ISOD_EXPIRY_DATE timestamp null,
  ISOD_QTY numeric(15,5) null,
  ISOD_ORIGINAL_QTY numeric(15,5) null,
  primary key( COM_CODE,
  STO_CODE,ITM_SERIAL,ISOD_LINE_SERIAL) ,
  );

create table DBA.MEDICAL_INS_TREE(
  MI_CODE_L1 char(3) not null,
  MI_CODE_L2 char(3) not null,
  MI_CODE_L3 char(3) not null,
  MI_CODE_L4 char(3) not null,
  MI_CODE_L5 char(3) not null,
  MI_CODE_L6 char(3) not null,
  MI_PARENT_CODE_L1 char(3) null,
  MI_PARENT_CODE_L2 char(3) null,
  MI_PARENT_CODE_L3 char(3) null,
  MI_PARENT_CODE_L4 char(3) null,
  MI_PARENT_CODE_L5 char(3) null,
  MI_PARENT_CODE_L6 char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  MLV_NAME_L1 varchar(60) not null,
  MLV_NAME_L2 varchar(60) null,
  MLV_CHILDREN double not null,
  MLV_USER_CODE char(20) null,
  MLV_REMARKS varchar(100) null,
  USED_FLAG char(1) null,
  primary key( MI_CODE_L1,
  MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6) ,
  );

create table DBA.COM_MEDICAL_INS(
  COM_CODE char(3) not null,
  CMI_SERIAL double not null,
  MI_CODE_L1 char(3) not null,
  MI_CODE_L2 char(3) not null,
  MI_CODE_L3 char(3) not null,
  MI_CODE_L4 char(3) not null,
  MI_CODE_L5 char(3) not null,
  MI_CODE_L6 char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  CMI_CODE char(10) null,
  CMI_NAME1 varchar(60) not null,
  CMI_NAME2 varchar(60) null,
  CMI_REMARKS varchar(100) null,
  CMI_USED_FLAG char(1) null,
  CMI_DATE timestamp null,
  CMI_MAX_AMOUNT numeric(15,5) null,
  CMI_PREMIN numeric(15,5) null,
  primary key( COM_CODE,
  CMI_SERIAL) ,
  );

create table DBA.EMP_MEDICAL_INS(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  CMI_SERIAL double not null,
  EMI_DATE timestamp not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  EM_CODE,CMI_SERIAL,EMI_DATE) ,
  );

create table DBA.USER_COMPANY_STORE(
  COM_CODE char(3) not null,
  USER_CODE char(8) not null,
  STO_CODE char(3) not null,
  UCS_STATUS char(1) null,
  primary key( COM_CODE,
  USER_CODE,STO_CODE) ,
  );

create table DBA.payroll_jv_acc_header_setup(
  COM_CODE char(3) not null,
  PJVHS_SERIAL real not null,
  CCC_COST_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PJVHS_DESC_L1 char(60) not null,
  PJVHS_DESC_L2 char(60) not null,
  PJVHS_DISPLAYED char(1) null,
  PJVHS_D_C_FLAG char(1) null,
  PJVHS_TOTAL_FLAG char(1) null,
  PJVHS_NO integer null,
  PJVHS_ACC_NO varchar(60) null,
  PJVHS_COST_CENTER_FLAG char(1) null,
  primary key( COM_CODE,
  PJVHS_SERIAL) ,
  );

create table DBA.PAYROLL_JV_ACC_LINES_SETUP(
  COM_CODE char(3) not null,
  PJVHS_SERIAL real not null,
  PJVLS_COUNTER real not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PJVLS_OPERATOR char(1) not null,
  primary key( COM_CODE,
  PJVHS_SERIAL,PJVLS_COUNTER) ,
  );

create table DBA.OPEN_BAL_ITEM_COMPANY(
  COM_CODE char(3) not null,
  ITM_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PRICE numeric(15,5) not null,
  POSTED_FLAG char(1) not null,
  primary key( COM_CODE,
  ITM_SERIAL) ,
  );

create table DBA.GL_BUDGET(
  COM_CODE char(3) not null,
  CHRT_SERIAL double not null,
  B_FISCAL_YEAR char(11) not null,
  B_MONTH smallint not null,
  B_BUDGET_AMNT numeric(15,5) null,
  B_BUDGET_BASE_AMNT numeric(15,5) null,
  B_ACTUAL_AMNT numeric(15,5) null,
  B_ACTUAL_BASE_AMNT numeric(15,5) null,
  B_CALENDAR_YEAR numeric(4) null,
  B_CALENDAR_MONTH numeric(2) null,
  primary key( COM_CODE,
  CHRT_SERIAL,B_FISCAL_YEAR,B_MONTH) ,
  );

create table DBA.ITEM_PURCHASE_HIST(
  COM_CODE char(3) not null,
  ITM_SERIAL double not null,
  IPH_FISCAL_YEAR char(11) not null,
  IPH_SERIAL double not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  IPH_QTY numeric(15,5) null,
  IPH_AVG_COST numeric(15,5) null,
  IPH_AVG_CUSTOM numeric(15,5) null,
  IPH_AVG_SALES numeric(15,5) null,
  IPH_AVG_OTHER numeric(15,5) null,
  IPH_AVG_GENERAL numeric(15,5) null,
  primary key( COM_CODE,
  ITM_SERIAL,IPH_FISCAL_YEAR,IPH_SERIAL) ,
  );

create table DBA.PAY_SLIP_SETUP(
  COM_CODE char(3) not null,
  PSS_SERIAL double not null,
  PSS_TYPE char(1) not null,
  PSS_DESC_L1 varchar(60) null,
  PSS_DESC_L2 varchar(60) null,
  PSS_HEADER char(1) null,
  PSS_DISPLAYED char(1) null,
  PSS_COMPUTED char(1) null,
  PSS_ITEM_NO integer null,
  PSS_ADD_SUB_FLAG char(1) null,
  PSS_TOTAL_FLAG char(1) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  PSS_SERIAL,PSS_TYPE) ,
  );

create table DBA.YEARLY_INCREASE_HEADER(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  YIH_YEAR integer not null,
  YIH_BONUS numeric(15,5) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  YIH_INCREASE numeric(15,5) null,
  YIH_CONFIRM_BONUS char(1) null,
  YIH_CONFIRM_INCREASE char(1) null,
  primary key( COM_CODE,
  EM_CODE,YIH_YEAR) ,
  );

create table DBA.YEARLY_INCREASE_DETAIL(
  COM_CODE char(3) not null,
  EM_CODE char(6) not null,
  YIH_YEAR integer not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  YID_VALUE numeric(15,5) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  EM_CODE,YIH_YEAR,ADG_CODE,AD_CODE) ,
  );

create table DBA.PAY_SLIP_CALC(
  COM_CODE char(3) not null,
  PSS_SERIAL double not null,
  PSS_TYPE char(1) not null,
  PSC_COUNTER integer not null,
  PSC_OPERATOR char(1) not null,
  ADG_CODE char(3) not null,
  AD_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  primary key( COM_CODE,
  PSS_SERIAL,PSS_TYPE,PSC_COUNTER) ,
  );

create table DBA.PURCHASE_ORDER_STORE_ITEMS(
  COM_CODE char(3) not null,
  PO_SERIAL double not null,
  PO_FISCAL_YEAR char(11) not null,
  POI_ITEM_SERIAL double not null,
  STO_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  POSI_QTY numeric(15,5) not null,
  POSI_RECIEVED_QTY numeric(15,5) null,
  POSI_RETURN_QTY numeric(15,5) null,
  POSI_CURRENT_BALANCE numeric(15,5) null,
  POSI_REORDER_POINT numeric(15,5) null,
  POSI_PO_QTY numeric(15,5) null,
  POSI_CALC_QTY numeric(15,5) null,
  ITM_SERIAL double null,
  POSI_AVR_CONS_DAY numeric(15,5) null,
  ISP_CODE char(3) null,
  primary key( COM_CODE,
  PO_SERIAL,PO_FISCAL_YEAR,POI_ITEM_SERIAL,STO_CODE) ,
  );

create table DBA.CST_JOB_ORDER_HEADER(
  COM_CODE char(3) not null,
  JOH_FISCAL_YEAR char(11) not null,
  JOH_DOC_SERIAL double not null,
  ITM_SERIAL double not null,
  ISP_CODE char(3) null,
  JOH_REORDER_FISCAL_YEAR char(11) null,
  JOH_REORDER_DOC_SERIAL double null,
  CUS_SERIAL double null,
  CCC_COST_SERIAL double null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  JOH_USER_TRANS_NO char(10) null,
  JOH_JOB_ORDER_TYPE char(2) null,
  JOH_TRANS_DATE timestamp null,
  JOH_USER_DATE timestamp null,
  JOH_START_DATE timestamp null,
  JOH_FINISH_DATE timestamp null,
  JOH_CLOSE_DATE timestamp null,
  JOH_REORDER char(1) null,
  JOH_TOTAL_ITEMS_COST numeric(15,5) null,
  JOH_ORDERD_QTY numeric(15,5) null,
  JOH_ACTUAL_QTY numeric(15,5) null,
  JOH_RETURN_QTY numeric(15,5) null,
  JOH_BATCH_NO varchar(12) null,
  JOH_BATCH_YEAR numeric(4) null,
  JOH_TOTAL_LABOR_COST numeric(15,5) null,
  JOH_TOTAL_OTHER_COST numeric(15,5) null,
  JOH_RAW_STATUS char(1) null,
  JOH_PRODUCTION_STATUS char(1) null,
  JOH_STATUS char(1) null,
  JOH_DOC_SERIAL_CHAR varchar(15) not null,
  primary key( COM_CODE,
  JOH_FISCAL_YEAR,JOH_DOC_SERIAL) ,
  );

create table DBA.CST_JOB_ORDER_DETAIL(
  COM_CODE char(3) not null,
  JOH_FISCAL_YEAR char(11) not null,
  JOH_DOC_SERIAL double not null,
  JOD_SERIAL integer not null,
  ITM_SERIAL double not null,
  ISP_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  JOD_BOM_QTY numeric(15,5) not null,
  JOD_ACTUAL_QTY numeric(15,5) null,
  JOD_RETURN_QTY numeric(15,5) null,
  JOD_ITEM_COST numeric(15,5) null,
  JOD_LABOR_COST numeric(15,5) null,
  JOD_OTHER_COST numeric(15,5) null,
  primary key( COM_CODE,
  JOH_FISCAL_YEAR,JOH_DOC_SERIAL,JOD_SERIAL) ,
  );

create table DBA.ITEM_SEASON(
  IS_CODE char(20) not null,
  IS_NAME_L1 varchar(60) not null,
  IS_NAME_L2 varchar(60) null,
  IS_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  is_picture varchar(30) null,
  primary key( IS_CODE) ,
  );

create table DBA.ITEM_GENDER(
  IG_CODE char(20) not null,
  IG_NAME_L1 varchar(60) not null,
  IG_NAME_L2 varchar(60) null,
  IG_REMARKS varchar(200) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ig_picture varchar(30) null,
  primary key( IG_CODE) ,
  );

create table DBA.ITEM_CATEGORY(
  IC_CODE char(20) not null,
  IC_NAME_L1 varchar(60) not null,
  IC_NAME_L2 varchar(60) null,
  IC_REMARKS varchar(100) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  ic_picture varchar(30) null,
  primary key( IC_CODE) ,
  );

create table DBA.STORE_DATE_SERIAL(
  STO_CODE char(3) not null,
  COM_CODE char(3) not null,
  SDS_MODULE char(3) not null,
  SDS_TYPE1 char(2) not null,
  SDS_TYPE2 char(2) not null,
  SDS_DATE timestamp not null,
  SDS_SERIAL double null,
  primary key( STO_CODE,
  COM_CODE,SDS_MODULE,SDS_TYPE1,SDS_TYPE2,SDS_DATE) ,
  );

create table DBA.ITEM_COMPANY_STORE_PRICE(
  COM_CODE char(3) not null,
  STO_CODE char(3) not null,
  ITM_SERIAL double not null,
  PRT_CODE char(3) not null,
  ISP_PRICE_DATE timestamp not null,
  ISP_PRICE numeric(15,5) null,
  ISP_REMARKS varchar(100) null,
  ISP_QTY numeric(15,5) null,
  ISP_VALUE numeric(15,5) null,
  ISP_DISCOUNT numeric(6,4) null,
  ISP_DISCOUNT_VALUE numeric(15,5) null,
  ISP_PRICE_FACTOR char(1) null,
  ISP_SALES_TAX_2 numeric(4,2) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  SEC_UPDATE_UID varchar(8) null,
  primary key( COM_CODE,
  STO_CODE,ITM_SERIAL,PRT_CODE,ISP_PRICE_DATE) ,
  );

create table "backup".pbcattbl(
  pbt_tnam char(129) not null,
  pbt_tid integer null,
  pbt_ownr char(129) not null,
  pbd_fhgt smallint null,
  pbd_fwgt smallint null,
  pbd_fitl char(1) null,
  pbd_funl char(1) null,
  pbd_fchr smallint null,
  pbd_fptc smallint null,
  pbd_ffce char(18) null,
  pbh_fhgt smallint null,
  pbh_fwgt smallint null,
  pbh_fitl char(1) null,
  pbh_funl char(1) null,
  pbh_fchr smallint null,
  pbh_fptc smallint null,
  pbh_ffce char(18) null,
  pbl_fhgt smallint null,
  pbl_fwgt smallint null,
  pbl_fitl char(1) null,
  pbl_funl char(1) null,
  pbl_fchr smallint null,
  pbl_fptc smallint null,
  pbl_ffce char(18) null,
  pbt_cmnt char(254) null,
  );

create table "backup".pbcatcol(
  pbc_tnam char(129) not null,
  pbc_tid integer null,
  pbc_ownr char(129) not null,
  pbc_cnam char(129) not null,
  pbc_cid smallint null,
  pbc_labl char(254) null,
  pbc_lpos smallint null,
  pbc_hdr char(254) null,
  pbc_hpos smallint null,
  pbc_jtfy smallint null,
  pbc_mask char(31) null,
  pbc_case smallint null,
  pbc_hght smallint null,
  pbc_wdth smallint null,
  pbc_ptrn char(31) null,
  pbc_bmap char(1) null,
  pbc_init char(254) null,
  pbc_cmnt char(254) null,
  pbc_edit char(31) null,
  pbc_tag char(254) null,
  );

create table "backup".pbcatfmt(
  pbf_name char(30) not null,
  pbf_frmt char(254) null,
  pbf_type smallint null,
  pbf_cntr integer null,
  );

create table "backup".pbcatvld(
  pbv_name char(30) not null,
  pbv_vald char(254) null,
  pbv_type smallint null,
  pbv_cntr integer null,
  pbv_msg char(254) null,
  );

create table "backup".pbcatedt(
  pbe_name char(30) not null,
  pbe_edit char(254) null,
  pbe_type smallint null,
  pbe_cntr integer null,
  pbe_seqn smallint not null,
  pbe_flag integer null,
  pbe_work char(32) null,
  );

create table DBA.ITEM_BOUNS_HEADER(
  COM_CODE char(3) not null,
  IBH_BOUNS_CODE char(6) not null,
  ITM_SERIAL double null,
  ISP_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  IBH_STORE_COM_LEVEL char(1) null,
  IBH_DESCRIPTION varchar(100) null,
  IBH_VALID_FROM timestamp null,
  IBH_VALID_TO timestamp null,
  IBH_VALID_FLAG char(1) null,
  IBH_ITEM_AMOUNT_FLAG char(1) null,
  IBH_AMOUNT numeric(15,5) null,
  IBH_QTY numeric(15,5) null,
  STO_CODE char(3) null,
  IBH_AND_OR char(1) null,
  IBH_FACTOR double null,
  from_disc_range numeric(15,5) null default
  0.0,
  to_disc_range numeric(15,5) null default 0.0,
  disc_percent numeric(6,2) null default 0.0,
  primary key( COM_CODE,IBH_BOUNS_CODE) ,
  );

create table DBA.ITEM_BOUNS_DETAIL(
  IBH_BOUNS_CODE char(6) not null,
  COM_CODE char(3) not null,
  ITM_SERIAL double not null,
  ISP_CODE char(3) null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  IBD_QTY numeric(15,5) not null,
  IBD_AND_OR char(1) null,
  IBD_NEW_PRICE_PRCNT numeric(5,2) null,
  IBD_NEW_PRICE_VALUE numeric(15,5) null,
  IBD_FACTOR double null,
  primary key( IBH_BOUNS_CODE,
  COM_CODE,ITM_SERIAL) ,
  );

create table DBA.ISSUE_TRANS_HEADER_EXT(
  STO_CODE char(3) not null,
  COM_CODE char(3) not null,
  TRANS_TYPE_CODE_LEVEL1 char(2) not null,
  TRANS_TYPE_CODE_LEVEL2 char(2) not null,
  TRANS_NO double not null,
  FISICAL_YEAR char(11) not null,
  DEFAULT_SAL_SERIAL double null,
  ACTUAL_DIST_SERIAL double null,
  DEFAULT_DIST_SERIAL double null,
  iss_source_tax numeric(15,5) null,
  trans_type_code_level3 double null,
  model varchar(60) null,
  route_no varchar(60) null,
  last_counter_rd varchar(60) null,
  v_char1 varchar(60) null,
  v_char2 varchar(60) null,
  v_char3 varchar(60) null,
  v_char4 varchar(60) null,
  v_char5 varchar(60) null,
  first_rec_date timestamp null,
  last_visit_date timestamp null,
  date1 timestamp null,
  date2 timestamp null,
  date3 timestamp null,
  date4 timestamp null,
  date5 timestamp null,
  closed_flag char(1) null,
  num_col1 numeric(15,5) null,
  num_col2 numeric(15,5) null,
  num_col3 numeric(15,5) null,
  num_col4 numeric(15,5) null,
  num_col5 numeric(15,5) null,
  ret_fisical_year char(11) null,
  ret_trans_no double null,
  ithext_contract_flag char(1) null default
  0,
  net_alternat_items numeric(15,5) null default 0.0,
  ithe_cobon_value numeric(15,5) null default 0.0,
  ithe_pay_from_cobon numeric(15,5) null default 0,
  ithe_profet numeric(15,5) null default 0,
  primary key( STO_CODE,COM_CODE,TRANS_TYPE_CODE_LEVEL1,TRANS_TYPE_CODE_LEVEL2,TRANS_NO,FISICAL_YEAR) ,
  );

create table DBA.fa_asset_class(
  com_code char(3) not null,
  fa_serial double not null,
  fa_ascl_code char(30) not null,
  fa_ascl_name varchar(60) not null,
  fa_glasac_main_sub char(1) not null,
  fa_glasac_chart_serial double null,
  fa_glasac_tree_code_l1 char(3) null,
  fa_glasac_tree_code_l2 char(3) null,
  fa_glasac_tree_code_l3 char(3) null,
  fa_glasac_tree_code_l4 char(3) null,
  fa_glasac_tree_code_l5 char(3) null,
  fa_glasac_tree_code_l6 char(3) null,
  fa_cumdep_main_sub char(1) not null,
  fa_cumdep_chart_serial double null,
  fa_cumdep_tree_code_l1 char(3) null,
  fa_cumdep_tree_code_l2 char(3) null,
  fa_cumdep_tree_code_l3 char(3) null,
  fa_cumdep_tree_code_l4 char(3) null,
  fa_cumdep_tree_code_l5 char(3) null,
  fa_cumdep_tree_code_l6 char(3) null,
  fa_expdep_main_sub char(1) not null,
  fa_expdep_chart_serial double null,
  fa_expdep_tree_code_l1 char(3) null,
  fa_expdep_tree_code_l2 char(3) null,
  fa_expdep_tree_code_l3 char(3) null,
  fa_expdep_tree_code_l4 char(3) null,
  fa_expdep_tree_code_l5 char(3) null,
  fa_expdep_tree_code_l6 char(3) null,
  fa_place_main_sub char(1) not null,
  fa_place_chart_serial double null,
  fa_place_tree_code_l1 char(3) null,
  fa_place_tree_code_l2 char(3) null,
  fa_place_tree_code_l3 char(3) null,
  fa_place_tree_code_l4 char(3) null,
  fa_place_tree_code_l5 char(3) null,
  fa_place_tree_code_l6 char(3) null,
  fa_asscont_main_sub char(1) not null,
  fa_asscont_chart_serial double null,
  fa_asscont_tree_code_l1 char(3) null,
  fa_asscont_tree_code_l2 char(3) null,
  fa_asscont_tree_code_l3 char(3) null,
  fa_asscont_tree_code_l4 char(3) null,
  fa_asscont_tree_code_l5 char(3) null,
  fa_asscont_tree_code_l6 char(3) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  used_flag char(1) null,
  fa_ascl_name_2 varchar(60) null,
  flag_status char(1) null,
  primary key( com_code,
  fa_serial) ,
  );

create table DBA.fa_asset_card(
  com_code char(3) not null,
  fa_as_serial double not null,
  fa_as_code char(30) not null,
  fa_as_name_1 varchar(60) null,
  fa_as_name_2 varchar(60) null,
  fa_glasac_chart_serial double not null,
  fa_model varchar(30) null,
  fa_producer_name varchar(60) null,
  fa_producer_address varchar(60) null,
  fa_asset_life1 numeric(15,5) null,
  fa_prod_capacity varchar(30) null,
  fa_asset_life2 numeric(15,5) null,
  fa_ascl_serial double not null,
  fa_dep_months numeric(15,5) null,
  cur_code char(3) null,
  fa_as_value numeric(15,5) null,
  fa_as_dep_value numeric(15,5) null,
  fa_as_current_value numeric(15,5) null,
  fa_cumdep_chart_serial double not null,
  fa_expdep_chart_serial double not null,
  fa_place_chart_serial double not null,
  fa_asscont_chart_serial double not null,
  fa_cumdep_value numeric(15,5) null,
  fa_total_expenses numeric(15,5) null,
  fa_total_income numeric(15,5) null,
  used_flag char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  fa_as_subserial_serial double null,
  fa_purchase_tax_perc numeric(6,4) null,
  fa_sales_tax_perc numeric(6,4) null,
  fa_dep_perc numeric(6,4) null,
  primary key( com_code,
  fa_as_serial) ,
  );

create table DBA.fa_asset_serials(
  com_code char(3) not null,
  table_name varchar(30) not null,
  serial double not null,
  primary key( com_code,
  table_name) ,
  );

create table DBA.fa_asset_setup(
  com_code char(3) not null,
  year_days_no integer null,
  year_months_no integer null,
  month_days_no integer null,
  start_date_mode char(1) null,
  no_life_dep_perc numeric(6,4) null,
  allowed_before_days_no integer null,
  allowed_after_days_no integer null,
  current_dep_date timestamp null,
  last_as_subserial_value numeric(15,5) null,
  repeat_dep_mode char(1) null,
  dep_post_flag char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  supplier_asset double null,
  primary key( com_code) ,
  );

create table DBA.fa_asset_trans_header(
  com_code char(3) not null,
  store_code char(3) not null,
  fah_doc_fiscal_year char(11) not null,
  fah_trans_type1 char(2) not null,
  fah_trans_type2 char(2) not null,
  fah_doc_serial double not null,
  fah_trans_doc_no double not null,
  fah_trans_doc_date timestamp not null,
  fah_post_date timestamp null,
  fah_ven_serial double null,
  fah_cus_serial double null,
  fah_inv_no double null,
  fah_inv_date timestamp null,
  fah_return_fiscal_year char(11) null,
  cur_code char(3) null,
  exchange_rate numeric(16,6) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  store_code,fah_doc_fiscal_year,fah_trans_type1,fah_trans_type2,fah_doc_serial) ,
  );

create table DBA.fa_asset_trans_detail(
  com_code char(3) not null,
  store_code char(3) not null,
  fah_doc_fiscal_year char(11) not null,
  fah_trans_type1 char(2) not null,
  fah_trans_type2 char(2) not null,
  fah_doc_serial double not null,
  fad_serial double not null,
  fa_as_serial double not null,
  fa_as_subserial varchar(30) null,
  fad_trans_qty numeric(15,5) null,
  fad_unit_price numeric(15,5) null,
  fad_discount numeric(15,5) null,
  fad_sales_tax numeric(15,5) null,
  fad_other_tax numeric(15,5) null,
  fad_other_cost numeric(15,5) null,
  fad_custom numeric(15,5) null,
  fad_old_qty numeric(15,5) null,
  fad_old_unit_price numeric(15,5) null,
  fad_cost_value numeric(15,5) null,
  ccc_cost_serial double null,
  fa_as_subserial_qty_in numeric(15,5) null,
  fa_as_subserial_qty_out numeric(15,5) null,
  fa_as_subserial_status char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  fad_item_value numeric(15,5) null,
  fa_as_subserial_cumdep numeric(15,5) null,
  fa_as_subserial_d_asset_exp numeric(15,5) null,
  fa_as_subserial_c_asset_exp numeric(15,5) null,
  fa_as_subserial_d_other_exp numeric(15,5) null,
  fa_as_subserial_c_other_exp numeric(15,5) null,
  fa_from_last_cost_serial double null,
  fad_remarks varchar(60) null,
  fad_chart_serial double null,
  fa_as_subserial_dep_perc numeric(6,4) null,
  fa_as_subserial_exp_cumdep numeric(15,5) null,
  fa_as_subserial_start_date timestamp null,
  fa_as_subserial_last_price numeric(15,5) null,
  fa_as_subserial_asscont numeric(15,5) null,
  prev_store_code char(3) null,
  prev_fah_doc_fiscal_year char(11) null,
  prev_fah_trans_type1 char(2) null,
  prev_fah_trans_type2 char(2) null,
  prev_fah_doc_serial double null,
  prev_fad_serial double null,
  next_store_code char(3) null,
  next_fah_doc_fiscal_year char(11) null,
  next_fah_trans_type1 char(2) null,
  next_fah_trans_type2 char(2) null,
  next_fah_doc_serial double null,
  next_fad_serial double null,
  primary key( com_code,
  store_code,fah_doc_fiscal_year,fah_trans_type1,fah_trans_type2,fah_doc_serial,fad_serial) ,
  );

create table DBA.fa_dep_journal_voucher_detail(
  com_code char(3) not null,
  jvh_doc_fiscal_year char(11) not null,
  jvh_trans_type1 char(2) not null,
  jvh_trans_type2 char(2) not null,
  jvh_doc_serial double not null,
  jvd_serial integer not null,
  debit_chrt_serial double null,
  credit_chrt_serial double null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  jvd_debit_flag_type char(2) null,
  jvd_debit_flag char(2) null,
  jvd_debit_code_serial double null,
  jvd_debit_amount numeric(15,5) null,
  jvd_credit_flag_type char(2) null,
  jvd_credit_flag char(2) null,
  jvd_credit_code_serial double null,
  jvd_credit_amount numeric(15,5) null,
  ccc_cost_serial double null,
  jvd_debit_code varchar(30) null,
  jvd_credit_code varchar(30) null,
  right_ccc_cost_serial double null,
  jvd_notes varchar(500) null,
  primary key( com_code,
  jvh_doc_fiscal_year,jvh_trans_type1,jvh_trans_type2,jvh_doc_serial,jvd_serial) ,
  );

create table DBA.equation_in_parameters(
  com_code char(3) not null,
  mod_module_id char(10) not null,
  mtt_trans_type_1 char(2) not null,
  mtt_trans_type_2 char(2) not null,
  in_dwcol_name varchar(60) not null,
  in_name_1 varchar(60) null,
  in_name_2 varchar(60) null,
  trans_equation_dwobject varchar(60) not null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  in_serial double null,
  primary key( com_code,
  mod_module_id,mtt_trans_type_1,mtt_trans_type_2,in_dwcol_name,trans_equation_dwobject) ,
  );

create table DBA.equation_setup(
  com_code char(3) not null,
  mod_module_id char(10) not null,
  mtt_trans_type_1 char(2) not null,
  mtt_trans_type_2 char(2) not null,
  mtgl_serial double not null,
  equation_type char(1) not null,
  equation_expression varchar(1000) null,
  equation_name_1 varchar(60) null,
  equation_name_2 varchar(60) null,
  equation_show char(1) null,
  equation_dwcol_name varchar(60) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  equation_expression_name_1 varchar(1000) null,
  equation_expression_name_2 varchar(1000) null,
  gia_serial integer null,
  mtgl_calc_type char(1) null,
  primary key( com_code,
  mod_module_id,mtt_trans_type_1,mtt_trans_type_2,mtgl_serial,equation_type) ,
  );

create table DBA.equation_setup_journal(
  com_code char(3) not null,
  mod_module_id char(10) not null,
  mtt_trans_type_1 char(2) not null,
  mtt_trans_type_2 char(2) not null,
  equation_type char(1) not null,
  mtgl_serial double not null,
  setup_change_date timestamp not null,
  setup_change_description varchar(200) not null,
  setup_change_uid varchar(8) not null,
  sec_update_uid varchar(8) not null,
  sec_update_date timestamp not null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  old_equation_expression varchar(1000) null,
  primary key( com_code,
  mod_module_id,mtt_trans_type_1,mtt_trans_type_2,equation_type,mtgl_serial,setup_change_date,setup_change_uid) ,
  );

create table DBA.matrix_setup(
  mod_id char(10) not null,
  ms_type char(1) not null,
  ms_level double not null,
  ms_length integer not null,
  ms_name varchar(60) not null,
  ms_table_name varchar(60) not null,
  ms_field_name varchar(60) null,
  ms_dw_name varchar(60) null,
  ms_name1_length integer null,
  ms_name2_length integer null,
  ms_name1_gen_length integer null,
  ms_name2_gen_length integer null,
  ms_name1_gen_selected char(1) null,
  ms_name2_gen_selected char(1) null,
  ms_code_length integer null,
  ms_code_gen_length integer null,
  ms_code_gen_selected char(1) null,
  matrix char(1) null,
  ms_name_2 varchar(60) null,
  primary key( mod_id,
  ms_type,ms_level) ,
  );

create table DBA.gl_balance_sheet_setup_detail(
  com_code char(3) not null,
  bss_serial integer not null,
  bss_type char(1) not null,
  bssd_year integer not null,
  bssd_month integer not null,
  bssd_value numeric(15,5) null,
  primary key( com_code,
  bss_serial,bss_type,bssd_year,bssd_month) ,
  );

create table DBA.hire_type(
  ht_serial double not null,
  ht_name_l1 char(40) null,
  ht_name_l2 char(40) null,
  ht_notes varchar(80) null,
  primary key( ht_serial) ,
  );

create table DBA.ins_off_table(
  in_off_serial double not null,
  in_off_name_l1 char(40) null,
  in_off_name_l2 char(40) null,
  in_off_address varchar(80) null,
  cou_code_l1 char(3) null,
  cou_code_l2 char(3) null,
  cou_code_l3 char(3) null,
  cou_code_l4 char(3) null,
  cou_code_l5 char(3) null,
  cou_code_l6 char(3) null,
  primary key( in_off_serial) ,
  );

create table DBA.characteristic_def(
  chr_serial double not null,
  chr_name1 char(40) not null,
  chr_name2 char(40) null,
  chr_name3 char(40) null,
  chr_name4 char(40) null,
  chr_name5 char(40) null,
  chr_name6 char(40) null,
  chr_name7 char(40) null,
  chr_name8 char(40) null,
  chr_name9 char(40) null,
  chr_name10 char(40) null,
  primary key( chr_serial) ,
  );

create table DBA.balance_adjustment(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  ba_fiscal_year char(11) not null,
  ba_month smallint not null,
  ba_module_id char(10) not null,
  ba_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,ba_fiscal_year,ba_month,ba_module_id,ba_trans_type2) ,
  );

create table DBA.balance_issue_rm(
  com_code char(3) not null,
  brm_fiscal_year char(11) not null,
  brm_module_id char(10) not null,
  brm_trans_type2 char(2) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  brm_month smallint not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  brm_fiscal_year,brm_module_id,brm_trans_type2,sto_code,itm_serial,brm_month) ,
  );

create table DBA.balance_issue(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  bi_fiscal_year char(11) not null,
  bi_month smallint not null,
  bi_module_id char(10) not null,
  bi_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,bi_fiscal_year,bi_month,bi_module_id,bi_trans_type2) ,
  );

create table DBA.balance_recieve(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  br_fiscal_year char(11) not null,
  br_month smallint not null,
  br_module_id char(10) not null,
  br_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,br_fiscal_year,br_month,br_module_id,br_trans_type2) ,
  );

create table DBA.balance_ret_issue(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  bri_fiscal_year char(11) not null,
  bri_month smallint not null,
  bri_module_id char(10) not null,
  bri_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,bri_fiscal_year,bri_month,bri_module_id,bri_trans_type2) ,
  );

create table DBA.balance_ret_rec(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  brr_fiscal_year char(11) not null,
  brr_month smallint not null,
  brr_module_id char(10) not null,
  brr_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,brr_fiscal_year,brr_month,brr_module_id,brr_trans_type2) ,
  );

create table DBA.balance_transf_in(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  bti_fiscal_year char(11) not null,
  bti_month smallint not null,
  bti_module_id char(10) not null,
  bti_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,bti_fiscal_year,bti_month,bti_module_id,bti_trans_type2) ,
  );

create table DBA.balance_transf_out(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  bto_fiscal_year char(11) not null,
  bto_month smallint not null,
  bto_module_id char(10) not null,
  bto_trans_type2 char(2) not null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  sto_code,itm_serial,bto_fiscal_year,bto_month,bto_module_id,bto_trans_type2) ,
  );

create table DBA.system_balance(
  mod_module_id char(10) not null,
  mtt_trans_type_1 char(2) not null,
  mtt_trans_type_2 char(2) not null,
  com_code char(3) not null,
  st_fiscal_year char(11) not null,
  code_serial double not null,
  st_month smallint not null,
  itm_serial double null,
  cus_serial double null,
  ven_serial double null,
  st_counter integer null,
  st_qty numeric(20,5) null,
  st_sales_value numeric(20,5) null,
  st_cost_value numeric(20,5) null,
  st_open_balance numeric(20,5) null,
  st_debit_cash numeric(20,5) null,
  st_credit_cash numeric(20,5) null,
  st_debit_note numeric(20,5) null,
  st_cerdit_note numeric(20,5) null,
  st_balance_1 numeric(20,5) null,
  st_balance_2 numeric(20,5) null,
  st_balance_3 numeric(20,5) null,
  st_balance_4 numeric(20,5) null,
  st_balance_5 numeric(20,5) null,
  st_balance_6 numeric(20,5) null,
  st_balance_7 numeric(20,5) null,
  st_balance_8 numeric(20,5) null,
  st_balance_9 numeric(20,5) null,
  st_balance_10 numeric(20,5) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  st_store_code char(3) not null,
  sto_code char(3) null,
  calendar_month numeric(2) null,
  calendar_year numeric(4) null,
  sal_serial double null,
  primary key( mod_module_id,
  mtt_trans_type_1,mtt_trans_type_2,com_code,st_fiscal_year,code_serial,st_month,st_store_code) ,
  );

create table DBA.issue_trans_header(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  trans_no double not null,
  cus_serial double null,
  return_trans_type_code_level1 char(2) null,
  return_trans_type_code_level2 char(2) null,
  return_trans_no double null,
  sal_serial double null,
  fisical_year char(11) not null,
  trans_user_no char(10) not null,
  trans_date date null,
  job_order_no char(10) null,
  invoice_no char(20) null,
  issue_on_request_no char(6) null,
  return_on_issue_no char(6) null,
  iss_total_number_of_items integer null,
  total_discount_on_document numeric(15,5) null,
  total_document_value numeric(15,5) null,
  total_sales_tax_value numeric(15,5) null,
  total_other_cost_value numeric(15,5) null,
  iss_remarks varchar(100) null,
  iss_post_flag char(1) null,
  issue_type integer null,
  credit_card_no char(20) null,
  credit_card_expiry_date date null,
  received_by varchar(60) null,
  amount_paied numeric(15,5) null,
  iss_phone char(15) null,
  return_fisical_year char(11) null,
  car_number varchar(20) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  iss_posting_date timestamp null,
  ccc_cost_serial double null,
  job_order_fiscal_year char(11) null,
  cur_code char(3) null,
  exchange_rate numeric(16,6) null,
  delivery_date timestamp null,
  notes varchar(60) null,
  issue_net_amount numeric(15,5) null,
  issue_gross_amount numeric(15,5) null,
  issue_dropped varchar(1) null,
  issue_total_returns numeric(15,5) null,
  issue_extra_type char(1) null,
  paper_count integer null default
  0,
  contract_discount numeric(15,5) null default 0.0,
  iss_contract_flag char(1) null default '0',
  discount_cus_per numeric(5,2) null default 0.0,
  ih_cont_total_cus numeric(15,5) null default 0,
  ih_cont_total_ho_cus numeric(15,5) null default 0,
  total_replace_doc_value numeric(15,5) null default 0.0,
  total_replace_sales_tax_value numeric(15,5) null default 0.0,
  total_replace_discount numeric(15,5) null default 0.0,
  ithe_cobon_value numeric(15,5) null default 0,
  cash_from_cobon numeric(15,5) null default 0,
  cash_cobon numeric(15,5) null default 0,
  pay_cobon numeric(15,5) null default 0,
  primary key( com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year) ,
  );

create table DBA.issue_transaction_items(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  trans_no double not null,
  iss_item_serial double not null,
  isp_code char(3) not null,
  itm_serial double null,
  trans_qty numeric(15,5) not null,
  unit_sales_price numeric(15,5) null,
  discount_value_for_item numeric(15,5) null,
  discount_value_for_header numeric(15,5) null,
  return_qty numeric(15,5) null,
  average_cost numeric(15,5) null,
  sales_tax_value numeric(15,5) null,
  expiry_date date null,
  post_flag char(1) null,
  remarks varchar(100) null,
  fisical_year char(11) not null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  sal_serial double null,
  price_flag char(1) null,
  theortical_qty numeric(15,5) null,
  notes varchar(200) null,
  before_disc_price numeric(15,5) null,
  bonus_itm_serial double null,
  discount_limit_qty numeric(15,5) null,
  discount_limit_amount numeric(15,5) null,
  itm_input_code varchar(30) null,
  itm_input_code_no integer null,
  previous_balance numeric(15,5) null default
  0,
  next_balance numeric(15,5) null default 0,
  iti_cont_total_cus numeric(15,5) null default 0,
  iti_cont_total_ho_cus numeric(15,5) null default 0,
  isc_disc_with_bouns numeric(6,2) null default 0,
  primary key( com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,iss_item_serial,fisical_year) ,
  );

create table DBA.account_autogenerator_case(
  com_code char(3) not null,
  mod_module_id char(10) not null,
  mtt_trans_type_1 char(2) not null,
  mtt_trans_type_2 char(2) not null,
  gia_serial integer not null,
  case_name varchar(30) not null,
  case_multirow char(1) null,
  case_chrtserial_start_from_mtgl char(1) null,
  primary key( com_code,
  mod_module_id,mtt_trans_type_1,mtt_trans_type_2,gia_serial) ,
  );

create table DBA.balance_issue1(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  bi_fiscal_year char(11) not null,
  bi_month smallint not null,
  bi_module_id char(10) not null,
  bi_trans_type2 char(2) not null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  st_sales_tax numeric(15,5) null,
  st_tax_value numeric(15,5) null,
  st_extra_tax1 numeric(15,5) null,
  st_extra_tax2 numeric(15,5) null,
  st_disc_on_item numeric(15,5) null,
  st_disc_on_doc numeric(15,5) null,
  st_extra_disc1 numeric(15,5) null,
  st_extra_disc2 numeric(15,5) null,
  primary key( com_code,
  sto_code,itm_serial,bi_fiscal_year,bi_month,bi_module_id,bi_trans_type2) ,
  );

create table DBA.balance_recieve1(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  br_fiscal_year char(11) not null,
  br_month smallint not null,
  br_module_id char(10) not null,
  br_trans_type2 char(2) not null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  st_sales_tax numeric(15,5) null,
  st_tax_value numeric(15,5) null,
  st_extra_tax1 numeric(15,5) null,
  st_extra_tax2 numeric(15,5) null,
  st_disc_on_item numeric(15,5) null,
  st_disc_on_doc numeric(15,5) null,
  st_extra_disc1 numeric(15,5) null,
  st_extra_disc2 numeric(15,5) null,
  primary key( com_code,
  sto_code,itm_serial,br_fiscal_year,br_month,br_module_id,br_trans_type2) ,
  );

create table DBA.balance_ret_issue1(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  bri_fiscal_year char(11) not null,
  bri_month smallint not null,
  bri_module_id char(10) not null,
  bri_trans_type2 char(2) not null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  st_sales_tax numeric(15,5) null,
  st_tax_value numeric(15,5) null,
  st_extra_tax1 numeric(15,5) null,
  st_extra_tax2 numeric(15,5) null,
  st_disc_on_item numeric(15,5) null,
  st_disc_on_doc numeric(15,5) null,
  st_extra_disc1 numeric(15,5) null,
  st_extra_disc2 numeric(15,5) null,
  primary key( com_code,
  sto_code,itm_serial,bri_fiscal_year,bri_month,bri_module_id,bri_trans_type2) ,
  );

create table DBA.balance_ret_rec1(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  brr_fiscal_year char(11) not null,
  brr_month smallint not null,
  brr_module_id char(10) not null,
  brr_trans_type2 char(2) not null,
  calendar_year numeric(4) null,
  calendar_month numeric(2) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  st_sales_tax numeric(15,5) null,
  st_tax_value numeric(15,5) null,
  st_extra_tax1 numeric(15,5) null,
  st_extra_tax2 numeric(15,5) null,
  st_disc_on_item numeric(15,5) null,
  st_disc_on_doc numeric(15,5) null,
  st_extra_disc1 numeric(15,5) null,
  st_extra_disc2 numeric(15,5) null,
  primary key( com_code,
  sto_code,itm_serial,brr_fiscal_year,brr_month,brr_module_id,brr_trans_type2) ,
  );

create table DBA.issue_trans_items_ext(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  trans_no double not null,
  iss_item_serial double not null,
  fisical_year char(11) not null,
  source_tax numeric(15,5) null,
  number1 numeric(15,5) null,
  number2 numeric(15,5) null,
  number3 numeric(15,5) null,
  string1 varchar(60) null,
  string2 varchar(60) null,
  flag1 char(1) null,
  flag2 char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  ret_fisical_year char(11) null,
  ret_trans_no double null,
  so_line_serial double null,
  so_item_serial double null,
  so_cus_serial double null,
  inv_qty numeric(15,5) null default
  0.0,
  main_alternate_flag char(1) null default '1',
  from_store_flag char(1) null default '1',
  replace_discount_value_for_item numeric(15,5) null default 0.0,
  replace_sales_tax_value numeric(15,5) null default 0.0,
  primary key( com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,iss_item_serial,fisical_year) ,
  );

create table DBA.store_date_serial_ext(
  sto_code char(3) not null,
  com_code char(3) not null,
  sds_module char(3) not null,
  sds_type1 char(2) not null,
  sds_type2 char(2) not null,
  sds_type3 double not null,
  sds_life_flag char(1) not null,
  sds_date timestamp not null,
  sds_serial double not null,
  primary key( sto_code,
  com_code,sds_module,sds_type1,sds_type2,sds_type3,sds_life_flag,sds_date) ,
  );

create table DBA.issue_types(
  x5 integer not null,
  x1 varchar(200) null,
  x2 varchar(200) null,
  x3 timestamp null,
  x4 integer null,
  primary key( x5) ,
  );

create table DBA.company_trans_type3(
  com_code char(3) not null,
  ctt3_serial double not null,
  ctt3_code char(30) not null,
  ctt3_name1 varchar(60) not null,
  ctt3_name2 varchar(60) null,
  ctt3_dec1 numeric(15,5) null,
  ctt3_dec2 numeric(15,5) null,
  ctt3_dec3 numeric(15,5) null,
  ctt3_chr1 char(1) null,
  ctt3_chr2 char(1) null,
  ctt3_chr3 char(1) null,
  ctt3_str1 varchar(50) null,
  ctt3_str2 varchar(50) null,
  ctt3_str3 varchar(50) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( com_code,
  ctt3_serial) ,
  );

create table DBA.characteristic_def_table(
  com_code char(3) not null,
  lng_id char(3) not null,
  cdt_serial double not null,
  cdt_name varchar(60) not null,
  primary key( com_code,
  lng_id,cdt_serial) ,
  );

create table DBA.Future_menus(
  fum_code_l1 char(3) not null,
  fum_code_l2 char(3) not null,
  fum_code_l3 char(3) not null,
  fum_code_l4 char(3) not null,
  fum_code_l5 char(3) not null,
  fum_code_l6 char(3) not null,
  fum_parent_code_l1 char(3) null,
  fum_parent_code_l2 char(3) null,
  fum_parent_code_l3 char(3) null,
  fum_parent_code_l4 char(3) null,
  fum_parent_code_l5 char(3) null,
  fum_parent_code_l6 char(3) null,
  mlv_name_l1 varchar(60) not null,
  mlv_name_l2 varchar(60) null,
  mlv_children double not null,
  mlv_user_code char(20) null,
  mlv_remarks varchar(100) null,
  mlv_remarks1 varchar(100) null,
  mlv_remarks2 varchar(100) null,
  mlv_remarks3 varchar(100) null,
  mlv_flag1 char(1) null,
  mlv_flag2 char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  primary key( fum_code_l1,
  fum_code_l2,fum_code_l3,fum_code_l4,fum_code_l5,fum_code_l6) ,
  );

create table DBA.vendor_b2b(
  ven_b2b_serial double not null,
  ven_serial double not null,
  ven_name varchar(60) not null,
  primary key( ven_b2b_serial) ,
  );

create table DBA.item_new(
  id double not null,
  ven_serial double not null,
  name1 varchar(60) not null,
  name2 varchar(60) not null,
  price numeric(15,5) not null,
  status char(1) not null default 'N',
  uid varchar(8) not null,
  discount1 numeric(15,5) not null,
  discount2 numeric(15,5) not null,
  discount3 numeric(15,5) not null,
  priced char(1) not null,
  selltax numeric(15,5) not null,
  factor char(3) not null,
  company varchar(100) null,
  ven_item_code varchar(30) null,
  download_time timestamp null default
  current timestamp,
  download_uid varchar(10) null,
  date1 date null,
  "time" timestamp null,
  primary key( id) ,
  );

create table DBA.updated_items(
  id double not null,
  ven_serial double not null,
  is_name1 varchar(60) not null,
  nprice numeric(15,5) not null,
  status char(1) not null default 'N',
  "time" timestamp not null default
  current timestamp,
  uid varchar(8) not null,
  discount1 numeric(15,5) not null,
  discount2 numeric(15,5) not null,
  discount3 numeric(15,5) not null,
  selltax numeric(15,5) not null,
  factor char(3) not null,
  sec_insert_uid varchar(8) not null,
  date1 date not null,
  sec_insert_date timestamp not null default current timestamp,
  primary key( id) ,
  );

create table DBA.manufactures(
  manuf_serial double not null default
  autoincrement,
  manuf_name_l1 varchar(60) not null,
  manuf_name_l2 varchar(60) null,
  manuf_address varchar(100) null,
  manuf_telephone varchar(15) null,
  primary key( manuf_serial) ,
  );

create table DBA.item_matched(
  item_serial double not null,
  motahida_code char(10) not null,
  shirka double not null,
  name char(60) null,
  primary key( item_serial) ,
  );

create table DBA.ITEM_COMPANY_VENDOR_1(
  VEN_SERIAL double not null,
  ITM_SERIAL double not null,
  ITV_LEAD_TIME numeric(5,2) null,
  COM_CODE char(3) not null,
  SEC_UPDATE_UID varchar(8) null,
  SEC_UPDATE_DATE timestamp null,
  SEC_INSERT_UID varchar(8) null,
  SEC_INSERT_DATE timestamp null,
  PURCHASE_PRICE numeric(15,5) null,
  DISCOUNT_1 numeric(15,5) null,
  DISCOUNT_2 numeric(15,5) null,
  DISCOUNT_3 numeric(15,5) null,
  ITU_CODE char(3) null,
  ITV_FACTOR_PUR_TO_SMALL numeric(15,5) null,
  primary key( VEN_SERIAL,
  ITM_SERIAL,COM_CODE) ,
  );

create table DBA.characteristic_rep_form_h(
  com_code char(3) not null,
  form_number integer not null,
  form_col1 double null,
  form_col2 double null,
  form_row1 double null,
  form_remark varchar(100) null,
  sec_insert_uid varchar(8) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  update_flag char(1) not null,
  sec_insert_date timestamp null,
  primary key( com_code,
  form_number) ,
  );

create table DBA.characteristic_rep_form_i(
  itm_serial double not null,
  form_number integer not null,
  com_code char(3) not null,
  form_col1_data_l1 varchar(60) null,
  form_col1_data_l2 varchar(60) null,
  form_col2_data_l1 varchar(60) null,
  form_col2_data_l2 varchar(60) null,
  form_row1_data_l1 varchar(60) null,
  form_row1_data_l2 varchar(60) null,
  primary key( itm_serial,
  form_number,com_code) ,
  );

create table DBA.purchase_order_send(
  com_code varchar(10) not null,
  po_serial varchar(10) not null,
  user_id varchar(10) not null,
  primary key( com_code,
  po_serial,user_id) ,
  );

create table DBA.shortcut_setup(
  window_lang char(3) not null,
  user_id char(8) not null,
  window_name varchar(64) not null,
  window_desc varchar(100) null,
  window_parameter varchar(30) not null,
  show_flag char(1) null,
  button_order integer null,
  button_color double null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null default
  timestamp,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null default timestamp,
  primary key( window_lang,user_id,window_name,window_parameter) ,
  );

create table DBA.customer_ext(
  cus_serial double not null,
  birth_date date null,
  address_2 varchar(100) null,
  address_3 varchar(100) null,
  address_4 varchar(100) null,
  title varchar(40) null,
  gender char(1) null,
  social_status char(1) null,
  marriage_date date null,
  class char(2) null,
  pref_sub char(3) null,
  notes varchar(100) null,
  last_contact timestamp null,
  main_cust_relation char(2) null,
  sec_insert_uid char(8) null,
  sec_insert_date timestamp null,
  sec_update_uid char(8) null,
  sec_update_date timestamp null,
  jt_code char(3) not null,
  cus_email varchar(100) null,
  deal_start_date date null,
  primary key( cus_serial) ,
  );

create table DBA.diseases(
  dis_serial double not null,
  dis_code char(8) null,
  dis_name_1 varchar(60) null,
  dis_name_2 varchar(60) null,
  dis_type char(1) null,
  dis_notes varchar(100) null,
  sec_insert_uid char(8) null,
  sec_insert_date timestamp null,
  sec_update_uid char(8) null,
  sec_update_date timestamp null,
  primary key( dis_serial) ,
  );

create table DBA.cus_diseases(
  cus_serial double not null,
  dis_serial double not null,
  cdt_date date not null,
  cdt_note varchar(100) null,
  cdt_doctor varchar(100) null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  primary key( cus_serial,
  dis_serial,cdt_date) ,
  );

create table DBA.class(
  class char(2) not null,
  primary key( class) ,
  );

create table DBA.script_status(
  code integer not null,
  datto date null,
  status varchar(3) null,
  tex_error varchar(200) null,
  primary key( code) ,
  );

create table DBA.sales_order_header(
  com_code char(3) not null,
  so_serial double not null,
  cus_serial double not null,
  so_fiscal_year char(11) not null,
  so_type char(1) not null,
  so_date date not null,
  so_document_no char(10) not null,
  dlv_sto_code char(3) not null,
  so_address varchar(60) null,
  so_remarks varchar(100) null,
  so_total_value numeric(15,5) not null default
  0,
  so_items_status char(1) not null default 'N',
  so_web_status char(1) not null default 'N',
  so_total_number_items double not null,
  sec_update_uid varchar(8) not null,
  sec_update_date timestamp not null,
  sec_insert_date timestamp not null,
  sec_insert_uid varchar(8) not null,
  so_posting_date timestamp not null,
  creation_type char(1) null,
  so_total_issue numeric(15,5) null default 0,
  so_total_return numeric(15,5) null default 0,
  job_fiscal_year char(11) null,
  job_serial double null,
  primary key( com_code,so_serial,so_fiscal_year) ,
  );

create table DBA.sales_order_items(
  com_code char(3) not null,
  so_serial double not null,
  so_fiscal_year char(11) not null,
  so_item_serial double not null,
  itm_serial double not null,
  expiry_date date null,
  isp_code char(3) not null,
  so_qty numeric(15,5) not null default
  0,
  dlv_sto_code char(3) not null,
  actual_sto_code char(3) not null,
  item_price numeric(15,5) not null,
  waiting_flag char(1) not null default 0,
  so_received_qty numeric(15,5) not null default 0,
  so_return_qty numeric(15,5) not null default 0,
  item_cus_serial double not null,
  item_status char(1) not null default 'N',
  primary key( com_code,so_serial,so_fiscal_year,so_item_serial) ,
  );

create table DBA.customer_complain_inquire(
  com_code char(3) not null,
  doc_type char(1) not null,
  doc_serial double not null,
  cus_serial double not null,
  doc_date date not null,
  doc_category char(3) null,
  doc_subject varchar(100) null,
  doc_action varchar(100) null,
  doc_status char(1) null default 'N',
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  creation_type char(1) null,
  primary key( com_code,
  doc_type,doc_serial) ,
  );

create table DBA.b2b_settings(
  id double not null,
  branch varchar(255) not null,
  primary key( id) ,
  );

create table DBA.branch_items(
  id double not null,
  ucp_code varchar(10) not null,
  itm_unit integer not null,
  ven_serial double not null,
  sto_code char(3) not null,
  sec_insert_uid varchar(60) not null,
  sec_insert_date timestamp not null default
  current timestamp,
  );

create table DBA.branch_items_temp(
  id double not null,
  ucp_code varchar(10) not null,
  ven_serial double not null,
  sec_insert_uid varchar(60) not null,
  sec_insert_date timestamp not null default
  current timestamp,
  );

create table DBA.ip_settings(
  id double not null,
  ip varchar(20) not null,
  primary key( id) ,
  );

create table DBA.lupdate(
  id integer not null,
  lupdate varchar(20) not null,
  count1 integer not null,
  des varchar(10) not null,
  );

create table DBA.newcodes(
  id double not null,
  ven_serial double not null,
  old_code varchar(30) not null,
  new_code varchar(30) not null,
  sec_insert_uid varchar(30) not null,
  sec_insert_date timestamp not null default
  current timestamp,
  );

create table DBA.promotion(
  id double not null,
  ven_serial double not null,
  itm_serial double null,
  itm_name_l1 varchar(60) null,
  itm_name_l2 varchar(60) null,
  itm_code varchar(60) null,
  pro_des long varchar null,
  is_name varchar(60) not null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null default
  timestamp,
  pro_qty numeric(15,5) not null,
  itm_unit char(3) not null,
  primary key( id) ,
  );

create table DBA.promotion_temp(
  id double not null,
  ven_b2b_serial double not null,
  itm_name_l1 varchar(60) null,
  itm_name_l2 varchar(60) null,
  pro_des long varchar null,
  is_name varchar(60) not null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null default
  timestamp,
  pro_qty numeric(15,5) not null,
  primary key( id) ,
  );

create table DBA.quta(
  ucp_code varchar(10) not null,
  itm_code varchar(20) null,
  itm_name_l1 varchar(60) null,
  itm_name_l2 varchar(60) null,
  itm_unit integer not null,
  sec_insert_uid varchar(60) not null,
  sec_insert_date timestamp not null default
  current timestamp,
  id double not null,
  ven_serial double not null,
  itm_serial double null,
  quta_no double not null,
  sto_code char(3) not null,
  );

create table DBA.item_store_comp_ven_followup(
  com_code char(3) not null,
  sto_code char(3) not null,
  ven_serial double not null,
  itm_serial double not null,
  iscvf_year integer not null,
  iscvf_month integer not null,
  iscvf_total_po_qty numeric(15,5) not null default
  0,
  iscvf_total_rec_qty numeric(15,5) not null default 0,
  iscvf_total_ret_rec_qty numeric(15,5) not null default 0,
  primary key( com_code,sto_code,ven_serial,itm_serial,iscvf_year,iscvf_month) ,
  );

create table DBA.item_vendor_dowload(
  com_code char(3) not null,
  br_serial double not null,
  item_serial double not null,
  ven_serial double not null,
  prom1_qty varchar(15) null,
  bonus1_qty varchar(15) null,
  prom2_qty varchar(15) null,
  bonus2_qty varchar(15) null,
  prom3_qty varchar(15) null,
  bonus3_qty varchar(15) null,
  prom4_qty varchar(15) null,
  bonus4_qty varchar(15) null,
  prom5_qty varchar(15) null,
  bonus5_qty varchar(15) null,
  prom6_qty varchar(15) null,
  bonus6_qty varchar(15) null,
  prom7_qty varchar(15) null,
  bonus7_qty varchar(15) null,
  prom8_qty varchar(15) null,
  bonus8_qty varchar(15) null,
  prom9_qty varchar(15) null,
  bonus9_qty varchar(15) null,
  prom10_qty varchar(15) null,
  bonus10_qty varchar(15) null,
  ivd_quota numeric(15,5) null,
  ivd_itm_unit char(3) null,
  ivd_promotion_flag char(1) null,
  ivd_quota_flag char(1) null,
  ivd_stocked_flag char(1) null,
  ivd_new_flag char(1) null,
  sec_insert_date timestamp null,
  sec_insert_uid varchar(10) null,
  sec_update_date timestamp null,
  sec_update_uid varchar(10) null,
  );

create table DBA.branches(
  br_serial double not null,
  branch_id char(3) not null,
  br_name_l1 varchar(60) null,
  br_name_l2 varchar(60) null,
  br_address varchar(100) null,
  primary key( br_serial) ,
  );

create table DBA.sales_order_followup(
  com_code char(3) not null,
  so_serial double not null,
  so_fiscal_year char(11) not null,
  dlv_sto_code char(3) not null,
  cus_serial double not null,
  create_date datetime null,
  create_uid varchar(8) null,
  first_send_date datetime null,
  first_send_uid varchar(8) null,
  first_accept_date datetime null,
  first_accept_uid varchar(8) null,
  last_send_date datetime null,
  last_send_uid varchar(8) null,
  last_accept_date datetime null,
  last_accept_uid varchar(8) null,
  save_no_post_date datetime null,
  save_no_post_uid varchar(8) null,
  save_post_date datetime null,
  save_post_uid varchar(8) null,
  dlv_date datetime null,
  dlv_uid varchar(8) null,
  primary key( com_code,
  so_serial,so_fiscal_year) ,
  );

create table DBA.item_vendor_dowload_temp(
  com_code char(3) not null,
  br_serial double not null,
  item_serial double not null,
  ven_serial double not null,
  prom1_qty varchar(15) null,
  bonus1_qty varchar(15) null,
  prom2_qty varchar(15) null,
  bonus2_qty varchar(15) null,
  prom3_qty varchar(15) null,
  bonus3_qty varchar(15) null,
  prom4_qty varchar(15) null,
  bonus4_qty varchar(15) null,
  prom5_qty varchar(15) null,
  bonus5_qty varchar(15) null,
  prom6_qty varchar(15) null,
  bonus6_qty varchar(15) null,
  prom7_qty varchar(15) null,
  bonus7_qty varchar(15) null,
  prom8_qty varchar(15) null,
  bonus8_qty varchar(15) null,
  prom9_qty varchar(15) null,
  bonus9_qty varchar(15) null,
  prom10_qty varchar(15) null,
  bonus10_qty varchar(15) null,
  ivd_quota numeric(15,5) null,
  ivd_itm_unit char(3) null,
  ivd_promotion_flag char(1) null,
  ivd_quota_flag char(1) null,
  ivd_stocked_flag char(1) null,
  ivd_new_flag char(1) null,
  sec_insert_date timestamp null,
  sec_insert_uid varchar(10) null,
  sec_update_date timestamp null,
  sec_update_uid varchar(10) null,
  );

create table DBA.item_cus_issue_hist(
  com_code char(3) not null,
  itm_serial double not null,
  cus_serial double not null,
  fiscal_year char(11) not null,
  first_issue_date timestamp null,
  last_issue_date timestamp null,
  last_return_date timestamp null,
  total_issue numeric(15,5) null,
  total_return numeric(15,5) null,
  last_issue_qty numeric(15,5) null,
  primary key( com_code,
  itm_serial,cus_serial,fiscal_year) ,
  );

create table DBA.datawindow_character(
  dw_name char(64) not null,
  dw_user_id char(8) not null,
  dw_col_name char(64) not null,
  dw_col_order real null default
  0,
  dw_col_width real null default 0,
  dw_col_alignment char(1) null,
  dw_col_height real null default 0,
  dw_font_height real null default 0,
  dw_col_visible char(1) not null,
  dw_col_required char(1) not null,
  dw_col_text_color real null default 0,
  dw_col_back_color real null default 0,
  dw_font_weight real null default 0,
  dw_col_row_no real null default 0,
  dw_col_y real null default 0,
  dw_col_x real null default 0,
  primary key( dw_name,dw_user_id,dw_col_name) ,
  );

create table DBA.contract_master(
  cont_serial double not null,
  mi_code_l1 char(3) not null,
  mi_code_l2 char(3) not null,
  mi_code_l3 char(3) not null,
  mi_code_l4 char(3) not null,
  mi_code_l5 char(3) not null,
  mi_code_l6 char(3) not null,
  cont_state char(1) not null default
  0,
  cont_name_l1 varchar(60) null,
  cont_name_l2 varchar(60) null,
  cont_disc_percent numeric(5,3) null default 0.0,
  cont_disc_percent_flag char(1) null default 0,
  cont_holding_cus_percent numeric(6,3) null default 0.0,
  cont_holding_cus_max_value numeric(15,5) null default 0.0,
  cont_cus_percent numeric(6,3) null default 0.0,
  cont_cus_max_value numeric(15,5) null default 0.0,
  cont_paied_value_flag char(1) not null default 0,
  cont_cus_max_month_value numeric(15,5) null default 0.0,
  cont_cus_max_year_value numeric(15,5) null default 0.0,
  cont_holding_cus_max_month_value numeric(15,5) null default 0.0,
  cont_holding_cus_max_year_value numeric(15,5) null default 0.0,
  sec_insert_date timestamp null,
  sec_insert_uid varchar(10) null,
  sec_update_date timestamp null,
  sec_update_uid varchar(10) null,
  cont_disc_flag_from char(1) null default 1,
  primary key( cont_serial) ,
  );

create table DBA.contract_detail(
  cont_serial double not null,
  cont_detail_serial double not null,
  itg_code_l1 char(3) null,
  itg_code_l2 char(3) null,
  itg_code_l3 char(3) null,
  itg_code_l4 char(3) null,
  itg_code_l5 char(3) null,
  itg_code_l6 char(3) null,
  ic_code char(20) null,
  ig_code char(20) null,
  imo_code char(20) null,
  is_code char(20) null,
  itc_code char(20) null,
  its_code char(20) null,
  cont_disc_percent numeric(5,3) null default
  0.0,
  cont_holding_cus_percent numeric(6,3) null default 0.0,
  cont_holding_cus_max_value numeric(15,5) null default 0.0,
  cont_cus_percent numeric(6,3) null default 0.0,
  cont_cus_max_value numeric(15,5) null default 0.0,
  sec_insert_date timestamp null,
  sec_insert_uid varchar(10) null,
  sec_update_date timestamp null,
  sec_update_uid varchar(10) null,
  primary key( cont_serial,cont_detail_serial) ,
  );

create table DBA.cus_contract(
  com_code char(3) not null,
  cus_contract_serial double not null,
  cont_serial double not null,
  cus_serial double not null,
  con_date_from timestamp null,
  con_date_to timestamp null,
  con_state char(1) null default '1',
  con_disc varchar(60) null,
  sec_insert_date timestamp null,
  sec_insert_uid varchar(10) null,
  sec_update_date timestamp null,
  sec_update_uid varchar(10) null,
  start_month integer null default
  1,
  start_year integer null default 1,
  primary key( com_code,cus_contract_serial) ,
  );

create table DBA.item_lacks(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  il_qty numeric(15,5) null,
  il_received_flag char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  ven_serial double null,
  last_pur_price decimal(15,5) null,
  last_pur_date timestamp null,
  marked char(1) null default '0',
  primary key( com_code,
  sto_code,itm_serial) ,
  );

create table DBA.foad(
  food_code char(4) not null,
  food_name1 varchar(60) null,
  food_name2 varchar(60) null,
  sec_update_uid char(4) null,
  sec_update_date integer null,
  SEC_INSERT_UID char(4) null,
  sec_insert_date integer null,
  x1 integer not null,
  x2 integer null,
  primary key( food_code) ,
  );

create table DBA.trans_details(
  id integer not null,
  name varchar(18) null,
  action_date timestamp null,
  flg varchar(5) null,
  id_pw varchar(12) null,
  );

create table DBA.t_db(
  t_name char(18) not null,
  t_p char(12) not null,
  );

create table DBA.apsent_dates(
  com_code char(3) not null,
  emp_code char(6) not null,
  apsent_date date not null,
  primary key( com_code,
  emp_code,apsent_date) ,
  );

create table DBA.salary_transaction_header(
  st_serial double not null,
  com_code char(3) not null,
  st_fiscal_year char(11) not null,
  st_trans_type1 char(2) not null,
  st_trans_type2 char(2) not null,
  st_date timestamp not null,
  bnk_code char(3) null,
  st_trans_type char(1) not null default
  0,
  st_month integer not null,
  st_year integer not null,
  sec_update_uid varchar(10) not null,
  sec_update_date timestamp not null,
  sec_insert_date timestamp not null,
  sec_insert_uid varchar(10) not null,
  primary key( st_serial,com_code,st_fiscal_year,st_trans_type1,st_trans_type2) ,
  );

create table DBA.salary_transaction_detail(
  st_serial double not null,
  com_code char(3) not null,
  st_fiscal_year char(11) not null,
  st_trans_type1 char(2) not null,
  st_trans_type2 char(2) not null,
  st_line_serial double not null,
  em_code char(6) not null,
  eb_serial double not null,
  eb_bank_no varchar(30) not null,
  st_total_salary numeric(10,3) not null,
  st_value numeric(10,3) not null,
  sec_update_uid varchar(10) not null,
  sec_update_date timestamp not null,
  sec_insert_date timestamp not null,
  sec_insert_uid varchar(10) not null,
  primary key( st_serial,
  com_code,st_fiscal_year,st_trans_type1,st_trans_type2,st_line_serial) ,
  );

create table DBA.item_lacks_local(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  il_qty numeric(15,5) null,
  il_received_flag char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  marked char(1) null default '0',
  primary key( com_code,
  sto_code,itm_serial) ,
  );

create table DBA.item_chek_qty(
  com_code char(3) not null,
  sto_code char(3) not null,
  itm_serial double not null,
  il_qty numeric(15,5) null,
  il_received_flag char(1) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  marked char(1) null default '0',
  primary key( com_code,
  sto_code,itm_serial) ,
  );

create table DBA.update_item_balance(
  com_code char(3) not null,
  station_id char(3) not null,
  function_name char(200) not null,
  update_done_flag char(1) not null,
  sec_insert_uid char(50) not null,
  sec_update_uid char(50) not null,
  sec_insert_date timestamp not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  function_name) ,
  );

create table DBA.isc_from_transaction(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  itm_serial double not null,
  trans_qty numeric(20,5) not null,
  trans_type_sign integer not null,
  calendar_year numeric(4) not null,
  calendar_month numeric(2) not null,
  sec_insert_uid char(50) not null,
  sec_update_uid char(50) not null,
  sec_insert_date timestamp not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  sto_code,trans_type_code_level1,itm_serial,calendar_year,calendar_month) ,
  );

create table DBA.item_exp_errors_from_issue_and_ratr(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  fiscal_year char(11) not null,
  trans_number double not null,
  itm_serial double not null,
  trans_quantity decimal(16,5) not null,
  iss_ratr_item_serial double not null,
  sec_insert_uid char(50) not null,
  sec_insert_date timestamp not null,
  primary key( com_code,
  sto_code,trans_type_code_level1,trans_type_code_level2,fiscal_year,trans_number,itm_serial,iss_ratr_item_serial) ,
  );

create table DBA.isc_exp_from_transaction(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  itm_serial double not null,
  trans_qty numeric(20,5) not null,
  expiry_date date not null,
  trans_type_sign integer not null,
  calendar_year numeric(4) not null,
  calendar_month numeric(2) not null,
  sec_insert_uid char(50) not null,
  sec_update_uid char(50) not null,
  sec_insert_date timestamp not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  sto_code,trans_type_code_level1,itm_serial,expiry_date,calendar_year,calendar_month) ,
  );

create table DBA.item_errors_from_issue_and_ratr(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  fiscal_year char(11) not null,
  trans_number double not null,
  itm_serial double not null,
  trans_quantity decimal(16,5) not null,
  expiry_date date not null,
  iss_ratr_item_serial double not null,
  sec_insert_uid char(50) not null,
  sec_insert_date timestamp not null,
  primary key( com_code,
  sto_code,trans_type_code_level1,trans_type_code_level2,fiscal_year,trans_number,itm_serial,expiry_date,iss_ratr_item_serial) ,
  );

create table DBA.licenses_modules(
  lm_serial char(3) not null,
  module_id char(10) not null,
  volume_inf varchar(100) not null,
  station_id char(3) not null,
  rep_site_id char(3) not null,
  insert_date timestamp not null,
  update_date timestamp not null,
  activate_flag char(1) not null default
  0,
  primary key( module_id,volume_inf) ,
  );

create table DBA.reference_for_transfer_between_branches(
  com_code varchar(3) not null,
  sto_to_code varchar(3) not null,
  sto_from_code varchar(3) not null,
  trans_number double not null,
  fiscal_year varchar(10) not null,
  trans_update_date timestamp not null,
  number_of_items double not null,
  sent_flag char(1) not null,
  request_flag char(1) not null,
  received_flag char(1) not null,
  sec_insert_uid varchar(50) not null,
  sec_update_uid varchar(50) not null,
  sec_insert_date timestamp not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  sto_to_code,sto_from_code,trans_number,fiscal_year) ,
  );

create table DBA.ratr_transaction_header_temp(
  com_code char(3) not null,
  sto_code char(3) not null,
  transaction_type_code_level1 char(2) not null,
  transaction_type_code_level2 char(2) not null,
  transaction_number double not null,
  return_transaction_type_code_level1 char(2) null,
  return_transaction_type_code_level2 char(2) null,
  return_transaction_number double null,
  ven_serial double null,
  ratr_fisical_year char(11) not null,
  transaction_date date not null,
  invoice_number char(10) null,
  invoice_date date null,
  shippment_number char(10) null,
  total_items_value numeric(15,5) null,
  total_tax_value numeric(15,5) null,
  total_discount_value numeric(15,5) null,
  total_custom_value numeric(15,5) null,
  total_other_value numeric(15,5) null,
  closed_flag char(1) null,
  accept_items_value numeric(15,5) null,
  accept_tax_value numeric(15,5) null,
  accept_sales_tax_value numeric(15,5) null,
  accept_custom_value numeric(15,5) null,
  accept_other_value numeric(15,5) null,
  transaction_user_number char(10) null,
  ratr_total_number_of_items numeric(4) null,
  ratr_post_flag char(1) null,
  ratr_remarks varchar(100) null,
  ratr_total_sales_tax_value numeric(15,5) null,
  ratr_phone char(15) null,
  return_fisical_year char(11) null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  ratr_posting_date timestamp null,
  ratr_paid_amount numeric(15,5) null,
  job_order_fiscal_year char(11) null,
  job_order_no char(10) null,
  cur_code char(3) null,
  exchange_rate numeric(16,6) null,
  ratr_dropped varchar(1) null,
  ratr_return_store char(3) null,
  paper_count integer null default
  0,
  other_tax numeric(15,5) null default 0,
  primary key( com_code,sto_code,transaction_type_code_level1,transaction_type_code_level2,transaction_number,ratr_fisical_year) ,
  );

create table DBA.ratr_transaction_items_temp(
  com_code char(3) not null,
  sto_code char(3) not null,
  transaction_type_code_level1 char(2) not null,
  transaction_type_code_level2 char(2) not null,
  transaction_number double not null,
  ratr_item_serial double not null,
  trx_measure_unit char(3) null,
  requested_unit char(3) null,
  ven_serial double null,
  itm_serial double null,
  expiration_date date null,
  trx_quantity numeric(15,5) null,
  requisted_quantity numeric(15,5) null,
  ratr_unit_price numeric(15,5) null,
  receiving_quantity numeric(15,5) not null default
  0,
  addition_quantity numeric(15,5) null,
  return_quantity numeric(15,5) null,
  discount_on_item_from_rule_value numeric(15,5) null,
  discount_on_item_from_document_value numeric(15,5) null,
  total_customs_value numeric(15,5) null,
  other_cost_value numeric(15,5) null,
  item_expense_distribution numeric(15,5) null,
  ratr_itm_tax_value numeric(15,5) null,
  ratr_itm_sales_tax_value numeric(15,5) null,
  ratr_total_quantity_items numeric(15,5) null,
  ratr_total_quantity_price numeric(15,5) null,
  ratr_fisical_year char(11) not null,
  sec_update_uid varchar(8) null,
  sec_update_date timestamp null,
  sec_insert_uid varchar(8) null,
  sec_insert_date timestamp null,
  other_sto_code char(3) null,
  ratr_last_pur_price numeric(15,5) null,
  po_serial double null,
  po_fiscal_year char(11) null,
  poi_item_serial double null,
  ratr_factor numeric(15,5) null,
  ratr_sales_price numeric(15,5) null,
  ratr_notes varchar(500) null,
  itm_input_code varchar(30) null,
  itm_input_code_no integer null,
  previous_balance numeric(15,5) null default 0,
  next_balance numeric(15,5) null default 0,
  ratr_other_bouns numeric(15,5) null default 0,
  primary key( com_code,sto_code,transaction_type_code_level1,transaction_type_code_level2,transaction_number,ratr_item_serial,ratr_fisical_year) ,
  );

create table DBA.sysuserperm(
  user_id real null,
  user_name char(128) null,
  resourceauth char(1) null,
  dbaauth char(1) null,
  scheduleauth char(1) null,
  publishauth char(1) null,
  remotedbaauth char(1) null,
  user_group char(1) null,
  );

create table DBA.organize_follow_up_transfers(
  com_code char(3) not null,
  sto_code char(3) not null,
  station_id integer not null,
  occupied_flag char(1) not null,
  sec_insert_uid char(50) not null,
  sec_update_uid char(50) not null,
  sec_insert_date timestamp not null,
  sec_update_date timestamp not null,
  primary key( com_code) ,
  );

create table DBA.bal_trace(
  com_code char(3) null,
  sto_code char(3) null,
  itm_serial double null,
  exp_date date null,
  expiry_date_flag char(1) null,
  itt_code char(3) null,
  table_name varchar(30) null,
  old_balance numeric(15,5) null,
  new_balance numeric(15,5) null,
  sec_update_uid varchar(10) null,
  sec_update_date timestamp null,
  event char(1) null,
  );

create table DBA.print_foter_txt(
  foter_name char(10) not null,
  foter_txt1 varchar(200) null,
  foter_txt2 varchar(200) null,
  foter_txt3 varchar(200) null,
  foter_txt4 varchar(200) null,
  primary key( foter_name) ,
  );

create table DBA.financial_claim_setup(
  com_code char(3) not null,
  fcs_serial double not null,
  fcs_code varchar(50) not null,
  fcs_name_l1 varchar(50) not null,
  fcs_name_l2 varchar(50) null,
  fcs_end_of_month integer not null,
  fcs_method1_name varchar(50) not null,
  fcs_method1_sign integer not null,
  fcs_method1_percent decimal(6,2) not null,
  fcs_method2_name varchar(50) null,
  fcs_method2_sign integer null,
  fcs_method2_percent decimal(6,2) null,
  fcs_method3_name varchar(50) null,
  fcs_method3_sign integer null,
  fcs_method3_percent decimal(6,2) null,
  fcs_method4_name varchar(50) null,
  fcs_method4_sign integer null,
  fcs_method4_percent decimal(6,2) null,
  fcs_method5_name varchar(50) null,
  fcs_method5_sign integer null,
  fcs_method5_percent decimal(6,2) null,
  fcs_method6_name varchar(50) null,
  fcs_method6_sign integer null,
  fcs_method6_percent decimal(6,2) null,
  fcs_deactivate_flag char(1) null,
  sec_insert_date timestamp not null,
  sec_insert_uid varchar(8) not null,
  sec_update_date timestamp not null,
  sec_update_uid varchar(8) not null,
  primary key( fcs_serial) ,
  );

create table DBA.claim_header(
  com_code char(3) not null,
  ch_year numeric(4) not null,
  ch_serial double not null,
  ch_month numeric(2) not null,
  cus_serial double not null,
  fcs_serial double not null,
  ch_no_of_invoices integer not null,
  ch_no_of_returns integer null,
  ch_total_amount numeric(15,5) not null,
  ch_total_amount_paid numeric(15,5) null,
  ch_total_returns numeric(15,5) null,
  ch_method_percent decimal(6,2) null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  sec_update_uid varchar(8) not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  ch_year,ch_serial) ,
  );

create table DBA.claim_detail(
  com_code char(3) not null,
  ch_year numeric(4) not null,
  ch_serial double not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  trans_no double not null,
  fiscal_year char(11) not null,
  cd_trans_date timestamp not null,
  cd_no_of_items integer not null,
  cd_return_trans_no double null,
  cd_return_fiscal_year char(11) null,
  cd_net_amount numeric(15,5) not null,
  "cd_total amount paid" numeric(15,5) null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  sec_update_uid varchar(8) not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  ch_year,ch_serial,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fiscal_year) ,
  );

create table DBA.prepare_claim(
  com_code char(3) not null,
  pc_year numeric(4) not null,
  pc_month numeric(2) not null,
  fcs_serial double not null,
  pc_no_of_customers integer not null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  sec_update_uid varchar(8) not null,
  sec_update_date timestamp not null,
  primary key( com_code,
  pc_year,pc_month,fcs_serial) ,
  );

create table DBA.organize_prepare_claim(
  com_code char(3) not null,
  station_id integer not null,
  occupied_flag char(1) not null,
  sec_insert_uid varchar(8) not null,
  sec_update_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  sec_update_date timestamp not null,
  primary key( com_code) ,
  );

create table DBA.menus_tabes(
  tab_code char(2) not null,
  tab_name_l1 varchar(60) not null,
  itm_name_l2 varchar(60) null,
  primary key( tab_code) ,
  );

create table DBA.claim_print_followup(
  com_code char(3) not null,
  ch_year numeric(4) not null,
  ch_serial double not null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  primary key( com_code,
  ch_year,ch_serial,sec_insert_date) ,
  );

create table DBA.iss_header_print_followup(
  com_code char(3) not null,
  sto_code char(3) not null,
  trans_type_code_level1 char(2) not null,
  trans_type_code_level2 char(2) not null,
  trans_no double not null,
  fisical_year char(11) not null,
  sec_insert_uid varchar(8) not null,
  sec_insert_date timestamp not null,
  primary key( com_code,
  sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year,sec_insert_date) ,
  );

create table DBA.com_job(
  com_code char(3) not null,
  job_serial double not null,
  job_no char(10) not null,
  job_fiscal_year char(11) not null,
  job_disc varchar(100) null,
  cus_serial double not null,
  ven_serial double not null,
  job_date date not null,
  job_sal_tax numeric(6,2) not null,
  pr_validity_date date not null,
  delivery_time varchar(100) null,
  delivery_place varchar(100) null,
  terms_of_pay varchar(100) null,
  manufacturer varchar(100) null,
  country_of_origin varchar(100) null,
  primary key( com_code,
  job_serial,job_fiscal_year) ,
  );

create table DBA.trans_items(
  itm_serial double not null,
  itm_code char(30) null,
  primary key( itm_serial) ,
  );

create table DBA.alico(
  sto_code char(3) null,
  cus_serial double null,
  car_number varchar(20) null,
  TRANS_DATE date null,
  TRANS_NO double null,
  FISICAL_YEAR char(11) null,
  ISS_PHONE char(15) null,
  );

create table DBA.credit_report(
  shift_serial double not null default
  autoincrement,
  user_code char(15) null,
  d_start timestamp null,
  d_end timestamp null,
  flag char(1) null,
  );

create table DBA.shift_report(
  shift_serial double null default
  autoincrement,
  user_code char(15) null,
  d_start timestamp null,
  d_end timestamp null,
  cash numeric(15,5) null,
  credit numeric(15,5) null,
  visa numeric(15,5) null,
  actual_cash numeric(15,5) null,
  actual_credit numeric(15,5) null,
  actual_visa numeric(15,5) null,
  sto_code char(3) null,
  new_user_code char(15) null,
  );

create unique index pbcatt_x on -------------------------------------------------;

create unique index pbcatc_x on DBA.pbcatcol(pbc_tnam asc,pbc_ownr asc,pbc_cnam asc);

create unique index pbcatf_x on DBA.pbcatfmt(pbf_name asc);

create unique index pbcatv_x on DBA.pbcatvld(pbv_name asc);

create unique index pbcate_x on DBA.pbcatedt(pbe_name asc,pbe_seqn asc);

create unique index DW_SPECS_PK on DBA.DW_SPECS(DS_DWO_NAME asc);

create unique index CHOICE_TYPES_PK on DBA.CHOICE_TYPES(CHT_TYPE_NAME asc);

alter table DBA.CHOICE_SPECS add
  DW_SPECS foreign key(DS_DWO_NAME) references
  DBA.DW_SPECS(DS_DWO_NAME);

alter table DBA.CHOICE_SPECS add
  CHOICE_TYPES foreign key(CHT_TYPE_NAME) references
  DBA.CHOICE_TYPES(CHT_TYPE_NAME);

create unique index CHOICE_SPECS_PK on DBA.CHOICE_SPECS(DS_DWO_NAME asc,CHS_CHOICE_CODE asc);

create index RELATION_69_FK on DBA.CHOICE_SPECS(CHT_TYPE_NAME asc);

alter table DBA.DW_COLUMN_SPECS add
  DW_SPECS foreign key(DS_DWO_NAME) references
  DBA.DW_SPECS(DS_DWO_NAME);

alter table DBA.DW_COLUMN_SPECS add
  CHOICE_SPECS foreign key(CHO_DS_DWO_NAME,CHS_CHOICE_CODE) references
  DBA.CHOICE_SPECS(DS_DWO_NAME,CHS_CHOICE_CODE);

create unique index DW_COLUMN_SPECS_PK on DBA.DW_COLUMN_SPECS(DS_DWO_NAME asc,DCS_COLUMN_NAME asc);

create index RELATION_43_FK on DBA.DW_COLUMN_SPECS(CHO_DS_DWO_NAME asc,CHS_CHOICE_CODE asc);

alter table DBA.CHOICE_DWO add
  CHOICE_SPECS foreign key(DS_DWO_NAME,CHS_CHOICE_CODE) references
  DBA.CHOICE_SPECS(DS_DWO_NAME,CHS_CHOICE_CODE);

create unique index CHOICE_DWO_PK on DBA.CHOICE_DWO(DS_DWO_NAME asc,CHS_CHOICE_CODE asc,CDW_DWO_NAME asc);

alter table DBA.CHOICE_MODIFIED_COLUMNS add
  CHOICE_SPECS foreign key(DS_DWO_NAME,CHS_CHOICE_CODE) references
  DBA.CHOICE_SPECS(DS_DWO_NAME,CHS_CHOICE_CODE);

alter table DBA.CHOICE_MODIFIED_COLUMNS add
  CHOICE_DWO foreign key(CHO_DS_DWO_NAME,CHO_CHS_CHOICE_CODE,CDW_DWO_NAME) references
  DBA.CHOICE_DWO(DS_DWO_NAME,CHS_CHOICE_CODE,CDW_DWO_NAME);

create unique index CHOICE_MODIFIED_COLUMNS_PK on DBA.CHOICE_MODIFIED_COLUMNS(CMC_COLUMN_NAME asc);

create index RELATION_58_FK on DBA.CHOICE_MODIFIED_COLUMNS(DS_DWO_NAME asc,CHS_CHOICE_CODE asc);

create index RELATION_63_FK on DBA.CHOICE_MODIFIED_COLUMNS(CHO_DS_DWO_NAME asc,CHO_CHS_CHOICE_CODE asc,CDW_DWO_NAME asc);

alter table DBA.COLUMN_DEPENDENCIES add
  DW_COLUMN_SPECS foreign key(DS_DWO_NAME,DCS_COLUMN_NAME) references
  DBA.DW_COLUMN_SPECS(DS_DWO_NAME,DCS_COLUMN_NAME);

alter table DBA.COLUMN_DEPENDENCIES add
  DW_COLUMN_SPECS001 foreign key(DW__DS_DWO_NAME,DW__DCS_COLUMN_NAME) references
  DBA.DW_COLUMN_SPECS(DS_DWO_NAME,DCS_COLUMN_NAME);

create unique index COLUMN_DEPENDENCIES_PK on DBA.COLUMN_DEPENDENCIES(DW__DS_DWO_NAME asc,DW__DCS_COLUMN_NAME asc,DS_DWO_NAME asc,DCS_COLUMN_NAME asc);

alter table DBA.COUNTRY add
  fk_relation_301 foreign key(COU_PARENT_CODE_L1,COU_PARENT_CODE_L2,COU_PARENT_CODE_L3,COU_PARENT_CODE_L4,COU_PARENT_CODE_L5,COU_PARENT_CODE_L6) references
  DBA.COUNTRY(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6);

alter table DBA.ITEM_GROUPS add
  fk_relation_300 foreign key(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.COST_CENTERS add
  FK_RELATION_299 foreign key(COC_PARENT_CODE_L1,COC_PARENT_CODE_L2,COC_PARENT_CODE_L3,COC_PARENT_CODE_L4,COC_PARENT_CODE_L5,COC_PARENT_CODE_L6) references
  DBA.COST_CENTERS(COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6);

alter table DBA.ORGANIZATION_CHART add
  FK_RELATION_4080 foreign key(ORG_PARENT_CODE_L1,ORG_PARENT_CODE_L2,ORG_PARENT_CODE_L3,ORG_PARENT_CODE_L4,ORG_PARENT_CODE_L5,ORG_PARENT_CODE_L6) references
  DBA.ORGANIZATION_CHART(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6);

alter table DBA.STORES add
  FK_RELATION_68 foreign key(STT_CODE) references
  DBA.STORE_TYPES(STT_CODE);

alter table DBA.STORES add
  FK_RELATION_525 foreign key(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6) references
  DBA.COUNTRY(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6);

alter table DBA.STORES add
  FK_STORE_CHART foreign key(CHRT_SERIAL) references
  DBA.CHART_OF_ACCOUNTS(CHRT_SERIAL);

alter table DBA.STORES add
  fk_store_branch foreign key(br_serial) references
  DBA.branches(br_serial);

alter table DBA.VENDOR add
  FK_RELATION_2227 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.VENDOR add
  FK_RELATION_2226 foreign key(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6) references
  DBA.COUNTRY(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6);

alter table DBA.VENDOR add
  FK_RELATION_8765 foreign key(HOLDING_VEN_SERIAL) references
  DBA.VENDOR(VEN_SERIAL);

alter table DBA.VENDOR add
  FK_RELATION_116320 foreign key(CHRT_SERIAL) references
  DBA.CHART_OF_ACCOUNTS(CHRT_SERIAL);

create unique index indx_ven_code on DBA.VENDOR(VEN_CODE asc);

alter table DBA.COMPANY add
  FK_RELATION_452 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.COMPANY add
  FK_RELATION_321 foreign key(CTY_CODE) references
  DBA.COMPANY_TYPE(CTY_CODE);

alter table DBA.COMPANY add
  FK_RELATION_320 foreign key(CNA_CODE) references
  DBA.COMPANY_NATURE(CNA_CODE);

alter table DBA.COMPANY add
  FK_HOLDING_401 foreign key(COM_HOLDING_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_STORES add
  FK_RELATION_482 foreign key(STO_CODE) references
  DBA.STORES(STO_CODE);

alter table DBA.COMPANY_STORES add
  FK_RELATION_481 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_STORES add
  FK_COMPANY_STORES_COST_CENTER foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.COMPANY_STORES add
  FK_SAFE_STORE_CHART_ACCOUNT foreign key(COM_CODE,SAFE_CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.COMPANY_STORES add
  fk_company_chart_store foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.COMPANY_STORES add
  fk_comp_store_items foreign key(m_change_item) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.COMPANY_VENDORS add
  fk_relation_100058 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.COMPANY_VENDORS add
  FK_RELATION_2583 foreign key(VEN_SERIAL) references
  DBA.VENDOR(VEN_SERIAL);

alter table DBA.COMPANY_VENDORS add
  FK_RELATION_2584 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_VENDORS add
  FK_RELATION_86353 foreign key(COM_CODE,CUS_SERIAL) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.CUSTOMER_COMAPNY add
  FK_RELATION_19856 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.CUSTOMER_COMAPNY add
  FK_RELATION_86354 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.CUSTOMER_COMAPNY add
  FK_RELATION_19819 foreign key(CUS_SERIAL) references
  DBA.CUSTOMER(CUS_SERIAL);

alter table DBA.CUSTOMER_COMAPNY add
  FK_CUSTOMER_SALES_MAN foreign key(SAL_SAL_SERIAL,COM_CODE) references
  DBA.SALESMAN(SAL_SERIAL,COM_CODE);

alter table DBA.CUSTOMER_COMAPNY add
  FK_CUSTOMER_DIST_MAN foreign key(DIST_SAL_SERIAL,COM_CODE) references
  DBA.SALESMAN(SAL_SERIAL,COM_CODE);

alter table DBA.CUSTOMER_COMAPNY add
  fk_relation_100057 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.COMPANY_SALESMAN add
  FK_RELATION_19872 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ITEM_STORE_COMPANY add
  FK_RELATION_1736 foreign key(COM_CODE,STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.ITEM_STORE_COMPANY add
  fk_relation_695 foreign key(ITM_SERIAL,COM_CODE) references
  DBA.ITEM_COMPANY(ITM_SERIAL,COM_CODE);

alter table DBA.ITEM_STORE_COMPANY add
  FK_ITEM_STORE_TYPE foreign key(ITT_CODE) references
  DBA.ITEM_TYPE(ITT_CODE);

alter table DBA.ITEM_STORE_COMPANY add
  FK_RELATION_84986 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.ITEM_COMPANY_VENDOR add
  FK_RELATION_2586 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.ITEM_COMPANY_VENDOR add
  fk_relation_2587 foreign key(ITM_SERIAL,COM_CODE) references
  DBA.ITEM_COMPANY(ITM_SERIAL,COM_CODE);

alter table DBA.ITEM_COMPANY_VENDOR add
  FK_RELATION_116323 foreign key(ITU_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_MASTER add
  FK_RELATION_621 foreign key(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.ITEM_MASTER add
  FK_PURCHASE_3207 foreign key(ITU_PURCHASE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_MASTER add
  FK_STORED_3208 foreign key(ITU_STORED_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_MASTER add
  FK_SMALL_ISSUE_3209 foreign key(ITU_SMALL_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_MASTER add
  FK_MEDIUM_3210 foreign key(ITU_MEDIUM_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_MASTER add
  FK_LARGE_ISSUE_3211 foreign key(ITU_LARGE_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_MASTER add
  FK_NATURE_623 foreign key(ITN_CODE) references
  DBA.ITEM_NATURE(ITN_CODE);

alter table DBA.ITEM_MASTER add
  FK_MODEL_624 foreign key(IMO_CODE) references
  DBA.ITEM_MODEL(IMO_CODE);

alter table DBA.ITEM_MASTER add
  FK_COLOR_625 foreign key(ITC_CODE) references
  DBA.ITEM_COLOR(ITC_CODE);

alter table DBA.ITEM_MASTER add
  FK_SIZE_626 foreign key(ITS_CODE) references
  DBA.ITEM_SIZE(ITS_CODE);

alter table DBA.ITEM_MASTER add
  fk_type_622 foreign key(ITT_CODE) references
  DBA.ITEM_TYPE(ITT_CODE);

alter table DBA.ITEM_MASTER add
  FK_RELATION_114797 foreign key(CHRT_SERIAL) references
  DBA.CHART_OF_ACCOUNTS(CHRT_SERIAL);

alter table DBA.ITEM_MASTER add
  FK_ITEM_SEASON_MASTER foreign key(IS_CODE) references
  DBA.ITEM_SEASON(IS_CODE);

alter table DBA.ITEM_MASTER add
  FK_ITEM_GENDER_MASTER foreign key(IG_CODE) references
  DBA.ITEM_GENDER(IG_CODE);

alter table DBA.ITEM_MASTER add
  FK_ITEM_CATEGORY_MASTER foreign key(IC_CODE) references
  DBA.ITEM_CATEGORY(IC_CODE);

create unique index indx_item_code on DBA.ITEM_MASTER(ITM_CODE asc);

create index idx_b2b_key on DBA.ITEM_MASTER(ITM_SCIENTIFIC_NAME_L2 asc);

alter table DBA.CUSTOMER add
  FK_RELATION_9861 foreign key(CUR_CODE_2) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.CUSTOMER add
  FK_RELATION_9862 foreign key(CUR_CODE_3) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.CUSTOMER add
  FK_RELATION_9860 foreign key(CUR_CODE_1) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.CUSTOMER add
  FK_RELATION_8763 foreign key(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6) references
  DBA.COUNTRY(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6);

alter table DBA.CUSTOMER add
  FK_RELATION_8753 foreign key(INDUSTRY_CODE) references
  DBA.INDUSTRY(INDUSTRY_CODE);

alter table DBA.CUSTOMER add
  FK_RELATION_8754 foreign key(SECTOR_CODE) references
  DBA.SECTORS(SECTOR_CODE);

alter table DBA.CUSTOMER add
  FK_RELATION_8764 foreign key(CUS_HOLDING_SERIAL) references
  DBA.CUSTOMER(CUS_SERIAL);

alter table DBA.CUSTOMER add
  FK_RELATION_116319 foreign key(CHRT_SERIAL) references
  DBA.CHART_OF_ACCOUNTS(CHRT_SERIAL);

create unique index indx_cus_code on DBA.CUSTOMER(CUS_CODE asc);

alter table DBA.CURRENCY_EXCHANGE add
  FK_CURRENCY1_100 foreign key(CUR_EXCHANGE_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.CURRENCY_EXCHANGE add
  FK_CURRENCY2_1737 foreign key(CUR_BASE_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.COMPANY_COST_CENTERS_ORG add
  FK_RELATION_491 foreign key(COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6) references
  DBA.ORGANIZATION_CHART(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6);

alter table DBA.ITEM_UNITS_CONVERSION add
  FK_UNIT2_523 foreign key(ITU_CONVERSION_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_UNITS_CONVERSION add
  FK_UNIT1_524 foreign key(ITU_BASE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY_PRICE add
  fk_relation_944 foreign key(ITM_SERIAL,COM_CODE) references
  DBA.ITEM_COMPANY(ITM_SERIAL,COM_CODE);

alter table DBA.ITEM_COMPANY_PRICE add
  FK_RELATION_945 foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.ALTERNATE_ITEM add
  FK_ITEM2_9652 foreign key(ITM_ALTERNATE_SERIAL) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.ALTERNATE_ITEM add
  FK_ITEM1_9662 foreign key(ITM_BASE_SERIAL) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.DRUG_INTERACTION_ITEM add
  FK_ITEM2_9653 foreign key(ITM_INTERACTION_SERIAL) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.DRUG_INTERACTION_ITEM add
  FK_ITEM1_9663 foreign key(ITM_BASE_SERIAL) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.CUR_DETAIL_TABLE add
  FK_RELATION_9213 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.SYSTEM_MESSAGES add
  FK_RELATION_18252 foreign key(LNG_ID) references
  DBA.LANGUAGE(LNG_ID);

alter table DBA.SALESMAN add
  fk_relation_126108 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.SALESMAN add
  FK_RELATION_24498 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.SALESMAN add
  FK_RELATION_9296 foreign key(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6) references
  DBA.COUNTRY(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6);

alter table DBA.TABLE_COLUMNS_SPECS add
  FK_RELATION_25373 foreign key(TS_TABLE_NAME) references
  DBA.TABLE_SPECS(TS_TABLE_NAME);

alter table DBA.UNIQUE_COLUMNS add
  FK_RELATION_25365 foreign key(TS_TABLE_NAME) references
  DBA.TABLE_SPECS(TS_TABLE_NAME);

alter table DBA.UNIQUE_COLUMNS add
  FK_RELATION_25374 foreign key(TAB_TS_TABLE_NAME,TCS_COLUMN_NAME) references
  DBA.TABLE_COLUMNS_SPECS(TS_TABLE_NAME,TCS_COLUMN_NAME);

alter table DBA.ORDERS_HEADER_TABEL add
  FK_RELATION_19857 foreign key(COM_CODE,CUS_SERIAL) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.ORDERS_HEADER_TABEL add
  FK_RELATION_20739 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ORDERS_HEADER_TABEL add
  FK_RELATION_24500 foreign key(SAL_SERIAL,SAL_COM_CODE) references
  DBA.SALESMAN(SAL_SERIAL,COM_CODE);

alter table DBA.ORDER_LINES_TABLE add
  FK_RELATION_21343 foreign key(ORD_SERIAL,COM_CODE) references
  DBA.ORDERS_HEADER_TABEL(ORD_SERIAL,COM_CODE);

alter table DBA.ORDER_LINES_TABLE add
  fk_relation_9333 foreign key(ITM_SERIAL,COM_CODE) references
  DBA.ITEM_COMPANY(ITM_SERIAL,COM_CODE);

alter table DBA.ITEM_STORE_COMPANY_EXPIRY add
  FK_RELATION_19817 foreign key(COM_CODE,STO_CODE,ITM_SERIAL) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.REQUEST_FOR_QUOTATION add
  FK_RELATION_2900 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.REQUEST_FOR_QUOTATION add
  FK_RELATION_5848 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.VENDOR_QUOTATION add
  FK_RELATION_5826 foreign key(COM_CODE,RFQ_SERIAL,RFQ_FISCAL_YEAR) references
  DBA.REQUEST_FOR_QUOTATION(COM_CODE,RFQ_SERIAL,RFQ_FISCAL_YEAR);

alter table DBA.VENDOR_QUOTATION add
  FK_RELATION_5831 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.VENDOR_QUOTATION add
  FK_RELATION_6768 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.REQUISITION_HEADER add
  FK_RELATION_7043 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.REQUISITION_HEADER add
  FK_RELATION_7044 foreign key(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6) references
  DBA.ORGANIZATION_CHART(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6);

alter table DBA.PURCHASE_ORDER_HEADER add
  FK_RELATION_7448 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.PURCHASE_ORDER_HEADER add
  FK_RELATION_7449 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.PURCHASE_ORDER_HEADER add
  FK_COMPANY_STORE_PO_HEADER foreign key(COM_CODE,STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.DEMAND_REPORT_HEADER add
  FK_RELATION_8255 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ITEM_RFQ add
  FK_RELATION_4897 foreign key(COM_CODE,VEN_SERIAL,ITM_SERIAL) references
  DBA.ITEM_COMPANY_VENDOR(COM_CODE,VEN_SERIAL,ITM_SERIAL);

alter table DBA.ITEM_RFQ add
  FK_RELATION_4898 foreign key(RFQ_SERIAL,COM_CODE,RFQ_FISCAL_YEAR) references
  DBA.REQUEST_FOR_QUOTATION(RFQ_SERIAL,COM_CODE,RFQ_FISCAL_YEAR);

alter table DBA.VENDOR_QUOTATION_ITEMS add
  FK_RELATION_5834 foreign key(COM_CODE,VEQ_SERIAL,VEQ_FISCAL_YEAR) references
  DBA.VENDOR_QUOTATION(COM_CODE,VEQ_SERIAL,VEQ_FISCAL_YEAR);

alter table DBA.VENDOR_QUOTATION_ITEMS add
  FK_RELATION_5835 foreign key(COM_CODE,VEN_SERIAL,ITM_SERIAL) references
  DBA.ITEM_COMPANY_VENDOR(COM_CODE,VEN_SERIAL,ITM_SERIAL);

alter table DBA.REQUISITION_ITEMS add
  FK_RELATION_7071 foreign key(COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR) references
  DBA.REQUISITION_HEADER(COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR);

alter table DBA.REQUISITION_ITEMS add
  fk_relation_7072 foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.PURCHASE_ORDER_ITEMS add
  FK_RELATION_7453 foreign key(COM_CODE,PO_SERIAL,PO_FISCAL_YEAR) references
  DBA.PURCHASE_ORDER_HEADER(COM_CODE,PO_SERIAL,PO_FISCAL_YEAR);

alter table DBA.PURCHASE_ORDER_ITEMS add
  FK_RELATION_7456 foreign key(VEN_SERIAL,ITM_SERIAL,COM_CODE) references
  DBA.ITEM_COMPANY_VENDOR(VEN_SERIAL,ITM_SERIAL,COM_CODE);

alter table DBA.PURCHASE_ORDER_ITEMS add
  FK_ITEM_PURCHASE_ORDER_ITEM foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.DEMAND_REPORT_VENDORS add
  FK_RELATION_8284 foreign key(COM_CODE,PO_SERIAL,PO_FISCAL_YEAR) references
  DBA.PURCHASE_ORDER_HEADER(COM_CODE,PO_SERIAL,PO_FISCAL_YEAR);

alter table DBA.DEMAND_REPORT_VENDORS add
  FK_RELATION_8278 foreign key(COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR) references
  DBA.DEMAND_REPORT_HEADER(COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR);

alter table DBA.DEMAND_REPORT_VENDORS add
  FK_RELATION_8280 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.DEMAND_REPORT_REQ add
  FK_RELATION_8282 foreign key(COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR) references
  DBA.DEMAND_REPORT_HEADER(COM_CODE,DEM_DEMAND_SERIAL,DEM_FISCAL_YEAR);

alter table DBA.DEMAND_REPORT_REQ add
  FK_RELATION_8283 foreign key(COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR) references
  DBA.REQUISITION_HEADER(COM_CODE,REQ_SERIAL,REQ_FISICAL_YEAR);

alter table DBA.DEMAND_REPORT_ITEMS add
  FK_RELATION_8257 foreign key(DEM_DEMAND_SERIAL,COM_CODE,DEM_FISCAL_YEAR) references
  DBA.DEMAND_REPORT_HEADER(DEM_DEMAND_SERIAL,COM_CODE,DEM_FISCAL_YEAR);

alter table DBA.DEMAND_REPORT_ITEMS add
  fk_relation_8258 foreign key(ITM_SERIAL,COM_CODE) references
  DBA.ITEM_COMPANY(ITM_SERIAL,COM_CODE);

alter table DBA.MODULE_LANGUAGE add
  FK_RELATION_18256 foreign key(MOD_MODULE_ID) references
  DBA.MODULES(MOD_MODULE_ID);

alter table DBA.MODULE_LANGUAGE add
  FK_RELATION_18258 foreign key(LNG_ID) references
  DBA.LANGUAGE(LNG_ID);

alter table DBA.MODULE_LANG_TRAN_TYPE_1 add
  FK_RELATION_18266 foreign key(LNG_ID,MOD_MODULE_ID) references
  DBA.MODULE_LANGUAGE(LNG_ID,MOD_MODULE_ID);

alter table DBA.MODULE_TRANSACTIONS add
  FK_RELATION_25375 foreign key(TS_TABLE_NAME,TCS_COLUMN_NAME) references
  DBA.TABLE_COLUMNS_SPECS(TS_TABLE_NAME,TCS_COLUMN_NAME);

alter table DBA.MODULE_TRANSACTIONS add
  FK_RELATION_17511 foreign key(MOD_MODULE_ID) references
  DBA.MODULES(MOD_MODULE_ID);

alter table DBA.MODULE_LANG_TRAN_TYPE_2 add
  FK_RELATION_18272 foreign key(LNG_ID,MOD_MODULE_ID,MLTT1_TYPE_1) references
  DBA.MODULE_LANG_TRAN_TYPE_1(LNG_ID,MOD_MODULE_ID,MLTT1_TYPE_1);

alter table DBA.RATR_TRANSACTION_HEADER add
  FK_RELATION_104202 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.RATR_TRANSACTION_HEADER add
  FK_RELATION_11528 foreign key(COM_CODE,STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.RATR_TRANSACTION_HEADER add
  FK_RELATION_11530 foreign key(COM_CODE,VEN_SERIAL) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.RATR_TRANSACTION_HEADER add
  FK_RELATION_11527 foreign key(COM_CODE,STO_CODE,RETURN_TRANSACTION_TYPE_CODE_LEVEL1,RETURN_TRANSACTION_TYPE_CODE_LEVEL2,RETURN_TRANSACTION_NUMBER,RETURN_FISICAL_YEAR) references
  DBA.RATR_TRANSACTION_HEADER(COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR);

alter table DBA.RATR_TRANSACTION_HEADER_PO add
  FK_RELATION_11548 foreign key(STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR,COM_CODE) references
  DBA.RATR_TRANSACTION_HEADER(STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR,COM_CODE);

alter table DBA.RATR_TRANSACTION_HEADER_PO add
  FK_RELATION_11549 foreign key(PO_SERIAL,PO_FISCAL_YEAR,COM_CODE) references
  DBA.PURCHASE_ORDER_HEADER(PO_SERIAL,PO_FISCAL_YEAR,COM_CODE);

alter table DBA.RATR_TRANSACTION_HEADER_COST add
  FK_RELATION_12897 foreign key(COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR) references
  DBA.RATR_TRANSACTION_HEADER(COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR);

alter table DBA.RATR_TRANSACTION_HEADER_COST add
  FK_RELATION_119044 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.SHIFTS add
  FK_RELATION_28073 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.LAST_SHIFT add
  FK_RELATION_28754 foreign key(COM_CODE,SHFT_CODE) references
  DBA.SHIFTS(COM_CODE,SHFT_CODE);

alter table DBA.LAST_SHIFT add
  FK_RELATION_28755 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.LAST_SHIFT add
  FK_WORK_STATION_LAST_SHIFT foreign key(COM_CODE,CASH_SERIAL) references
  DBA.WORK_STATION_COMPANY(COM_CODE,CASH_SERIAL);

alter table DBA.SHIFTS_MONEY add
  FK_RELATION_27172 foreign key(COM_CODE,SHFT_CODE) references
  DBA.SHIFTS(COM_CODE,SHFT_CODE);

alter table DBA.SHIFTS_MONEY add
  FK_WORK_STATION_SHIFTS_MONEY foreign key(COM_CODE,CASH_SERIAL) references
  DBA.WORK_STATION_COMPANY(COM_CODE,CASH_SERIAL);

alter table DBA.COMPANY_SERIALS add
  FK_RELATION_29662 foreign key(MOD_MODULE_ID) references
  DBA.MODULES(MOD_MODULE_ID);

alter table DBA.COMPANY_SERIALS add
  FK_RELATION_29663 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.USER_COMPANY add
  FK_RELATION_33407 foreign key(USER_CODE) references
  DBA.SECURITY_USERS(USER_CODE);

alter table DBA.USER_COMPANY add
  FK_RELATION_33408 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.USER_COMPANY add
  fk_user_sal foreign key(COM_CODE,sal_serial) references
  DBA.SALESMAN(COM_CODE,SAL_SERIAL);

alter table DBA.SECURITY_GROUPINGS add
  FK_SECURITY_GROUPINGS_GROUP foreign key(USER_CODE) references
  DBA.SECURITY_USERS(USER_CODE);

alter table DBA.SECURITY_GROUPINGS add
  FK_SECURITY_GROUPINGS_USER foreign key(SEC_USER_CODE) references
  DBA.SECURITY_USERS(USER_CODE);

alter table DBA.RATR_TRANSACTION_ITEMS add
  FK_RELATION_11588 foreign key(TRX_MEASURE_UNIT) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.RATR_TRANSACTION_ITEMS add
  FK_RELATION_11589 foreign key(REQUESTED_UNIT) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.RATR_TRANSACTION_ITEMS add
  FK_ITEMS_STORE foreign key(COM_CODE,OTHER_STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.RATR_TRANSACTION_ITEMS add
  FK_ratr_transaction_store foreign key(STO_CODE,ITM_SERIAL,COM_CODE) references
  DBA.ITEM_STORE_COMPANY(STO_CODE,ITM_SERIAL,COM_CODE);

alter table DBA.RATR_TRANSACTION_ITEMS add
  FK_PURCHASE_OEDER_ITEM_RATR_IT foreign key(COM_CODE,PO_SERIAL,POI_ITEM_SERIAL,PO_FISCAL_YEAR) references
  DBA.PURCHASE_ORDER_ITEMS(COM_CODE,PO_SERIAL,POI_ITEM_SERIAL,PO_FISCAL_YEAR);

alter table DBA.RATR_TRANSACTION_ITEMS add
  FK_RELATION_11553 foreign key(COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR) references
  DBA.RATR_TRANSACTION_HEADER(COM_CODE,STO_CODE,TRANSACTION_TYPE_CODE_LEVEL1,TRANSACTION_TYPE_CODE_LEVEL2,TRANSACTION_NUMBER,RATR_FISICAL_YEAR);

create index index_1 on DBA.RATR_TRANSACTION_ITEMS(COM_CODE asc,ITM_SERIAL asc,TRANSACTION_TYPE_CODE_LEVEL1 asc,TRANSACTION_TYPE_CODE_LEVEL2 asc,SEC_UPDATE_DATE asc);

alter table DBA.YEAR_COMPANY_VENDOR add
  FK_RELATION_35337 foreign key(VEN_SERIAL,COM_CODE) references
  DBA.COMPANY_VENDORS(VEN_SERIAL,COM_CODE);

alter table DBA.YEAR_ITEM_STORE_COMPANY add
  FK_RELATION_35356 foreign key(STO_CODE,COM_CODE,ITM_SERIAL) references
  DBA.ITEM_STORE_COMPANY(STO_CODE,COM_CODE,ITM_SERIAL);

alter table DBA.YEAR_CUSTOMER_COMPANY add
  FK_RELATION_35373 foreign key(CUS_SERIAL,COM_CODE) references
  DBA.CUSTOMER_COMAPNY(CUS_SERIAL,COM_CODE);

alter table DBA.CURRENT_SETTINGS add
  FK_RELATION_36359 foreign key(USER_CODE) references
  DBA.SECURITY_USERS(USER_CODE);

alter table DBA.ITEM_COMPANY add
  FK_RELATION_680 foreign key(ITM_SERIAL) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.ITEM_COMPANY add
  FK_RELATION_679 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ITEM_COMPANY add
  FK_RELATION_84976 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.ITEM_COMPANY add
  FK_SMALL_918 foreign key(ITU_SMALL_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY add
  FK_STORED_919 foreign key(ITU_STORED_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY add
  FK_MEDIUM_920 foreign key(ITU_PURCHASE_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY add
  FK_LARGE_921 foreign key(ITU_MEDIUM_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY add
  FK_PURCHASE_922 foreign key(ITU_LARGE_ISSUE_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY add
  FK_ITEM_TYPE_COMPANY foreign key(ITT_CODE) references
  DBA.ITEM_TYPE(ITT_CODE);

alter table DBA.CUSTOMER_ITEM_GROUP_DISCOUNT add
  FK_RELATION_46740 foreign key(MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.CUSTOMER_ITEM_GROUP_DISCOUNT add
  FK_RELATION_46739 foreign key(CUS_SERIAL,COM_CODE) references
  DBA.CUSTOMER_COMAPNY(CUS_SERIAL,COM_CODE);

alter table DBA.CUSTOMER_ITEM_GROUP_DISCOUNT add
  FK_RELATION_46741 foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.ACCOUNT_CHART_TREE add
  fk_relation_57831 foreign key(PARENT_TREE_CODE_L1,PARENT_TREE_CODE_L2,PARENT_TREE_CODE_L3,PARENT_TREE_CODE_L4,PARENT_TREE_CODE_L5,PARENT_TREE_CODE_L6) references
  DBA.ACCOUNT_CHART_TREE(TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.COMPANY_COST_CENTERS add
  FK_RELATION_4079 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_COST_CENTERS add
  FK_RELATION_83601 foreign key(MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.COST_CENTERS(COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_RELATION_88452 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_RELATION_83609 foreign key(COST_CODE_L1,COST_CODE_L2,COST_CODE_L3,COST_CODE_L4,COST_CODE_L5,COST_CODE_L6) references
  DBA.COST_CENTERS(COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_RELATION_15419 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_COMP_COST_CENTER_CHART foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_RELATION_81516 foreign key(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_RELATION_24494 foreign key(CHRT_SERIAL) references
  DBA.CHART_OF_ACCOUNTS(CHRT_SERIAL);

alter table DBA.COMPANY_CHART_OF_ACCOUNT add
  FK_RELATION_93326 foreign key(COM_CODE,CASH_SERIAL) references
  DBA.WORK_STATION_COMPANY(COM_CODE,CASH_SERIAL);

alter table DBA.COMPANY_ACCOUNT_CHART_TREE add
  FK_RELATION_60365 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_ACCOUNT_CHART_TREE add
  FK_CHART_TREE_COMP foreign key(TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6) references
  DBA.ACCOUNT_CHART_TREE(TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.GL_JOURNAL_VOUCHER_HEADER add
  FK_RELATION_75090 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.GL_JOURNAL_VOUCHER_HEADER add
  FK_RELATION_63001 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.GL_JOURNAL_VOUCHER_HEADER add
  FK_VOUCHER_HEADER_PREVIOUS foreign key(COM_CODE,PREV_JVH_DOC_FISCAL_YEAR,PREV_JVH_TRANS_TYPE1,PREV_JVH_TRANS_TYPE2,PREV_JVH_DOC_SERIAL) references
  DBA.GL_JOURNAL_VOUCHER_HEADER(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_HEADER add
  FK_RELATION_45282 foreign key(COM_CODE,NEXT_JVH_DOC_FISCAL_YEAR,NEXT_JVH_TRANS_TYPE1,NEXT_JVH_TRANS_TYPE2,NEXT_JVH_DOC_SERIAL) references
  DBA.GL_JOURNAL_VOUCHER_HEADER(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL);

create index doc_id_777 on DBA.GL_JOURNAL_VOUCHER_HEADER(COM_CODE asc,JVH_TRANS_TYPE1 asc,JVH_TRANS_TYPE2 asc,JVH_DOCUMENT_NO asc);

alter table DBA.GL_PAPAER add
  FK_RELATION_64348 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.GL_PAPAER add
  FK_RELATION_64356 foreign key(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL) references
  DBA.GL_JOURNAL_VOUCHER_HEADER(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL);

alter table DBA.GL_PAPAER add
  FK_CURRENCY_PAPER foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.GL_INTEGERATION_ACCOUNTS add
  FK_RELATION_90549 foreign key(COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.GL_INTEGERATION_ACCOUNTS add
  FK_RELATION_83606 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.GL_INTEGERATION_ACCOUNTS add
  FK_RELATION_83607 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_COST_CENTER_SUMMERY add
  FK_RELATION_45460 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.GL_COST_CENTER_SUMMERY add
  FK_RELATION_68427 foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.CHART_OF_ACCOUNTS add
  FK_ACCOUNT_TREE foreign key(TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6) references
  DBA.ACCOUNT_CHART_TREE(TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.CHART_OF_ACCOUNTS add
  FK_RELATION_89500 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.GL_NOTES_MODIFICATIONS add
  FK_RELATION_73751 foreign key(COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL) references
  DBA.GL_PAPAER(COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL);

alter table DBA.GL_JV_SUMMERY add
  FK_RELATION_69783 foreign key(CHRT_SERIAL,COM_CODE) references
  DBA.COMPANY_CHART_OF_ACCOUNT(CHRT_SERIAL,COM_CODE);

alter table DBA.GL_JV_SUMMERY add
  FK_RELATION_69784 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.GL_COST_CENTER_DETAIL add
  FK_RELATION_68445 foreign key(MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2) references
  DBA.MODULE_TRANSACTIONS(MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2);

alter table DBA.GL_COST_CENTER_DETAIL add
  FK_RELATION_76428 foreign key(COM_CODE,CUR_CODE,GLCC_FISCAL_YEAR,GLCC_MONTH,CCC_COST_SERIAL) references
  DBA.GL_COST_CENTER_SUMMERY(COM_CODE,CUR_CODE,GLCC_FISCAL_YEAR,GLCC_MONTH,CCC_COST_SERIAL);

alter table DBA.GL_PERIOD add
  FK_RELATION_77780 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.MODULE_TRANSACTIONS_GL_ACCOUNT add
  FK_RELATION_80478 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.MODULE_TRANSACTIONS_GL_ACCOUNT add
  FK_RELATION_87404 foreign key(MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2) references
  DBA.MODULE_TRANSACTIONS(MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2);

alter table DBA.MODULE_TRANSACTIONS_GL_ACCOUNT add
  FK_COMP_CHART_MODULE_TRANS_GL foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.MODULE_TRANSACTIONS_GL_ACCOUNT add
  FK_RELATION_90548 foreign key(COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.MODULE_TRANSACTIONS_GL_ACCOUNT add
  FK_RELATION_83608 foreign key(COM_CODE,GIA_SERIAL) references
  DBA.GL_INTEGERATION_ACCOUNTS(COM_CODE,GIA_SERIAL);

alter table DBA.WORK_STATION_COMPANY add
  FK_RELATION_91942 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.WORK_STATION_COMPANY add
  FK_WORK_STATION_COMPANY foreign key(CASH_SERIAL) references
  DBA.WORK_STATION(CASH_SERIAL);

alter table DBA.WORK_STATION_COMPANY add
  FK_COMPANY_CHART_WORK_STATION foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.COMPANY_MODULES add
  FK_RELATION_94385 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_MODULES add
  FK_RELATION_94386 foreign key(MOD_MODULE_ID) references
  DBA.MODULES(MOD_MODULE_ID);

alter table DBA.COMPANY_BANK_ACCOUNTS add
  FK_RELATION_59037 foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.COMPANY_BANK_ACCOUNTS add
  FK_RELATION_68446 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMPANY_BANK_ACCOUNTS add
  FK_RELATION_59036 foreign key(BNK_CODE) references
  DBA.BANKS(BNK_CODE);

alter table DBA.COMPANY_BANK_ACCOUNTS add
  FK_RELATION_59038 foreign key(BAT_CODE) references
  DBA.BANK_ACCOUNT_TYPES(BAT_CODE);

alter table DBA.COMPANY_BANK_ACCOUNTS add
  fk_relation_75066 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.BANK_ACCOUNT_TRANSACTION add
  FK_RELATION_82555 foreign key(COM_CODE,BAT_CODE,BNK_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER) references
  DBA.COMPANY_BANK_ACCOUNTS(COM_CODE,BAT_CODE,BNK_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER);

alter table DBA.GL_BANK_DETAIL_SUMMARY add
  FK_RELATION_68460 foreign key(BAT_CODE,BNK_CODE,COM_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER) references
  DBA.COMPANY_BANK_ACCOUNTS(BAT_CODE,BNK_CODE,COM_CODE,CUR_CODE,CHB_BANK_ACCOUNT_NUMBER);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_RELATION_83602 foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_RELATION_117869 foreign key(COM_CODE,RIGHT_CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_DEBIT_CHART_ACCOUNT foreign key(COM_CODE,DEBIT_CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_CREDIT_CHART_ACCOUNT foreign key(COM_CODE,CREDIT_CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_RELATION_102706 foreign key(COM_CODE,OLD_CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_RELATION_45316 foreign key(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL) references
  DBA.GL_JOURNAL_VOUCHER_HEADER(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_DEBIT_GL_PAPER_DETAIL foreign key(COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL) references
  DBA.GL_PAPAER(COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL);

alter table DBA.GL_JOURNAL_VOUCHER_DETAIL add
  FK_GL_JOURNAL_VOUCHER_SELF foreign key(COM_CODE,ORG_JVH_DOC_FISCAL_YEAR,ORG_JVH_TRANS_TYPE1,ORG_JVH_TRANS_TYPE2,ORG_JVH_DOC_SERIAL,ORG_JVD_SERIAL) references
  DBA.GL_JOURNAL_VOUCHER_DETAIL(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL);

alter table DBA.GL_VOUCHER_DETAIL_DIST add
  FK_GL_DETAIL_DIST foreign key(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL) references
  DBA.GL_JOURNAL_VOUCHER_DETAIL(COM_CODE,JVH_DOC_FISCAL_YEAR,JVH_TRANS_TYPE1,JVH_TRANS_TYPE2,JVH_DOC_SERIAL,JVD_SERIAL);

alter table DBA.CUR_FACILITY_TABLE add
  FK_RELATION_40616 foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.CUR_FACILITY_TABLE add
  FK_RELATION_29688 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.CUR_FACILITY_TABLE add
  fk_cus_com foreign key(COM_CODE,CUS_SERIAL) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.CUR_FACILITY_TABLE add
  FK_RELATION_9899 foreign key(CUS_SERIAL) references
  DBA.CUSTOMER(CUS_SERIAL);

alter table DBA.PROMOTION_HEADER add
  FK_RELATION_121765 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.PROMOTION_HEADER add
  FK_RELATION_41765 foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.PROMOTION_HEADER add
  FK_RELATION_121766 foreign key(COM_CODE,STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.REPLACEMENT_ITEM add
  FK_RELATION_97280 foreign key(COM_CODE,BASE_ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.REPLACEMENT_ITEM add
  FK_RELATION_97281 foreign key(COM_CODE,REPLACMENT_ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.SALES_TAX_TRANSACTION add
  FK_RELATION_97238 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.FOOD_DRUG_INTERACTION add
  FK_RELATION_97248 foreign key(ITM_SERIAL) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.FOOD_DRUG_INTERACTION add
  FK_RELATION_97256 foreign key(FOOD_CODE) references
  DBA.FOOD(FOOD_CODE);

alter table DBA.ITEM_CUSTOMER add
  FK_RELATION_98721 foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.ITEM_CUSTOMER add
  FK_RELATION_98720 foreign key(COM_CODE,CUS_SERIAL) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.ITEM_COMPANY_VENDOR_PRICE add
  FK_RELATION_116324 foreign key(ITU_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_COMPANY_VENDOR_PRICE add
  FK_RELATION_101175 foreign key(COM_CODE,VEN_SERIAL,ITM_SERIAL) references
  DBA.ITEM_COMPANY_VENDOR(COM_CODE,VEN_SERIAL,ITM_SERIAL);

alter table DBA.ITEM_COMPANY_CUSTOMER_PRICE add
  FK_RELATION_101203 foreign key(COM_CODE,CUS_SERIAL,ITM_SERIAL) references
  DBA.ITEM_CUSTOMER(COM_CODE,CUS_SERIAL,ITM_SERIAL);

alter table DBA.ITEM_COMPANY_CUSTOMER_PRICE add
  FK_RELATION_126113 foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.GROUP_CUSTOMER_PRICE add
  FK_RELATION_111761 foreign key(CUS_SERIAL,COM_CODE) references
  DBA.CUSTOMER_COMAPNY(CUS_SERIAL,COM_CODE);

alter table DBA.GROUP_CUSTOMER_PRICE add
  FK_RELATION_111762 foreign key(MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.PROMOTION_ITEMS_DETAIL add
  FK_RELATION_116330 foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.PROMOTION_GROUB_DETAIL add
  FK_RELATION_116338 foreign key(MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.CUR_FACILITY_ITEM_DISCOUNT add
  FK_RELATION_122946 foreign key(CUS_SERIAL,DOC_DATE,COM_CODE) references
  DBA.CUR_FACILITY_TABLE(CUS_SERIAL,DOC_DATE,COM_CODE);

alter table DBA.CUR_FACILITY_ITEM_DISCOUNT add
  FK_RELATION_122947 foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.CUR_FACILITY_ITEM_DISCOUNT add
  FK_RELATION_122951 foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.CUR_FACILITY_GROUP_DISCOUNT add
  FK_RELATION_122949 foreign key(CUS_SERIAL,COM_CODE,DOC_DATE) references
  DBA.CUR_FACILITY_TABLE(CUS_SERIAL,COM_CODE,DOC_DATE);

alter table DBA.CUR_FACILITY_GROUP_DISCOUNT add
  FK_RELATION_122950 foreign key(MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.CUR_FACILITY_GROUP_DISCOUNT add
  FK_RELATION_122952 foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.CUSTOMER_OPEN_BAL add
  fk_relation_126122 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.CUSTOMER_OPEN_BAL add
  FK_RELATION_126121 foreign key(CUS_SERIAL,COM_CODE) references
  DBA.CUSTOMER_COMAPNY(CUS_SERIAL,COM_CODE);

alter table DBA.VENDOR_OPEN_BAL add
  FK_RELATION_126130 foreign key(VEN_SERIAL,COM_CODE) references
  DBA.COMPANY_VENDORS(VEN_SERIAL,COM_CODE);

alter table DBA.VENDOR_OPEN_BAL add
  fk_relation_126131 foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.CHART_OPEN_BAL add
  FK_RELATION_126133 foreign key(CHRT_SERIAL,COM_CODE) references
  DBA.COMPANY_CHART_OF_ACCOUNT(CHRT_SERIAL,COM_CODE);

alter table DBA.EDUCATION_SEPC add
  FK_RELATION_129313 foreign key(EDU_PARENT_CODE_L1,EDU_PARENT_CODE_L2,EDU_PARENT_CODE_L3,EDU_PARENT_CODE_L4,EDU_PARENT_CODE_L5,EDU_PARENT_CODE_L6) references
  DBA.EDUCATION_SEPC(EDU_CODE_L1,EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6);

alter table DBA.EMPLOYEE add
  FK_CURRENCY_EMPLOYEE foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.EMPLOYEE add
  FK_ORGANIZATION_EMPLOYEE foreign key(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6) references
  DBA.ORGANIZATION_CHART(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6);

alter table DBA.EMPLOYEE add
  FK_COMPANY_EMPLOYEE foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.EMPLOYEE add
  FK_COMP_COST_CENTER_EMPLOYEE foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.EMPLOYEE add
  FK_EDUCATION_EMPLOYEE foreign key(EDU_CODE_L1,EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6) references
  DBA.EDUCATION_SEPC(EDU_CODE_L1,EDU_CODE_L2,EDU_CODE_L3,EDU_CODE_L4,EDU_CODE_L5,EDU_CODE_L6);

alter table DBA.EMPLOYEE add
  FK_JOB_EMPLOYEE foreign key(JT_CODE) references
  DBA.JOB_TITLE(JT_CODE);

alter table DBA.EMPLOYEE add
  FK_SOCIAL_EMPLOYEE foreign key(SS_CODE) references
  DBA.SOCIAL_STATUS(SS_CODE);

alter table DBA.EMPLOYEE add
  FK_NATIONALITY_EMPLOYEE foreign key(N_CODE) references
  DBA.NATIONALITY(N_CODE);

alter table DBA.EMPLOYEE add
  FK_INSURANCE_TAX_EMPLOYEE foreign key(COM_CODE,IT_CODE) references
  DBA.INSURANCE_TAX(COM_CODE,IT_CODE);

alter table DBA.EMPLOYEE add
  FK_GENERAL_RULE_EMPLOYEE foreign key(COM_CODE,GR_CODE) references
  DBA.GENERAL_RULE(COM_CODE,GR_CODE);

alter table DBA.EMPLOYEE add
  FK_COMP_HOLIDAY_EMP foreign key(COM_CODE,CHRM_CODE) references
  DBA.COMP_HOLIDAY_RULE_MASTER(COM_CODE,CHRM_CODE);

alter table DBA.EMPLOYEE add
  FK_LIVELS_CODE_EMPLOYEE foreign key(LC_CODE) references
  DBA.LIVELS_CODES(LC_CODE);

alter table DBA.WORKING_CALENDER add
  FK_COMPANY_WORKING_CALENDER foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ATTENDANCE_SHEET add
  FK_EMPLOYEE_ATTENDANCE foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.ATTENDANCE_SHEET add
  FK_CAUSE_ATTENDNACE foreign key(C_CODE) references
  DBA.CAUSE(C_CODE);

alter table DBA.ALLOWAN_DEDUCTION add
  FK_ALLOW_DEDUC_GRUOP_ALLOW foreign key(ADG_CODE) references
  DBA.ALLOWAN_DEDUC_GROUP(ADG_CODE);

alter table DBA.ALLOWAN_DEDUCTION add
  FK_RELATION_134809 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ALLOWAN_DEDUCTION add
  FK_COMP_CHART_ALLOWAN_DEDUC foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.SALARY_TIME_EFFECT add
  FK_ALLOWN_DEDUC_GR_SALARY_TIME foreign key(ADG_CODE) references
  DBA.ALLOWAN_DEDUC_GROUP(ADG_CODE);

alter table DBA.SALARY_TIME_EFFECT add
  FK_COMPANY_SALARY_TIME foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.INSURANCE_TAX add
  FK_COMPANY_INSURANCE_TAX foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.GENERAL_RULE add
  FK_COMPANY_GENERAL_RULES foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.HOLIDAY add
  FK_COMPANY_HOLDAY foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.EMP_WORKING_CALENDER add
  FK_EMPLOYEE_WORKING_CALENDER foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_WORKING_CALENDER add
  FK_WORKING_CALENDER_EMP_WORK foreign key(COM_CODE,WC_CODE) references
  DBA.WORKING_CALENDER(COM_CODE,WC_CODE);

alter table DBA.GL_BALANCE_SHEET_SETUP add
  FK_COMPANY_GL_BALANCE foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.GL_BALANCE_SHEET_SETUP add
  FK_COMPANY_ACCOUNT_CHART_BALAN foreign key(COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.GL_BALANCE_SHEET_CALC add
  FK_GL_BALANCE_SHEET_CALC_CHART foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_BALANCE_SHEET_CALC add
  FK_RELATION_140310 foreign key(COM_CODE,BSS_SERIAL,BSS_TYPE) references
  DBA.GL_BALANCE_SHEET_SETUP(COM_CODE,BSS_SERIAL,BSS_TYPE);

alter table DBA.GL_BALANCE_SHEET_CALC add
  FK_RELATION_140315 foreign key(COM_CODE,MLV_CODE_L1,MLV_CODE_L2,MLV_CODE_L3,MLV_CODE_L4,MLV_CODE_L5,MLV_CODE_L6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.ITEM_STORE_OPEN_BAL add
  fk_item_store_chart_of_acc foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.ITEM_STORE_OPEN_BAL add
  FK_ITEM_STORE_ITEM_UNIT foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_STORE_OPEN_BAL add
  FK_ITEM_STORE_OPEN_BAL_UNIT foreign key(PRICE_ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_STORE_OPEN_BAL add
  FK_ITEM_STORE_OPEN_BAL foreign key(COM_CODE,STO_CODE,ITM_SERIAL) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.MANUAL_IN_OUT add
  FK_COMPANY_MANUAL_IN_OUT foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.MANUAL_IN_OUT add
  FK_CASHIER_MANUAL_IN_OUT foreign key(COM_CODE,CASH_SERIAL) references
  DBA.WORK_STATION_COMPANY(COM_CODE,CASH_SERIAL);

alter table DBA.COMP_HOLIDAY_RULE_MASTER add
  FK_COMP_HOLIDAY_RULE foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COMP_HOLIDAY_RULE_DETAIL add
  FK_COMP_HOLIDAY_RULE_MASTER_DE foreign key(COM_CODE,CHRM_CODE) references
  DBA.COMP_HOLIDAY_RULE_MASTER(COM_CODE,CHRM_CODE);

alter table DBA.TIME_DESIGNATOR_DAILY add
  FK_RELATION_155937 foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.TIME_DESIGNATOR_DAILY add
  FK_SALARY_TIME_DESIGNATOR foreign key(COM_CODE,ADG_CODE,STE_CODE) references
  DBA.SALARY_TIME_EFFECT(COM_CODE,ADG_CODE,STE_CODE);

alter table DBA.GL_PAPER_COLLECTION_HEADER add
  FK_PAPER_COLLEC_HED_BANK foreign key(BNK_CODE) references
  DBA.BANKS(BNK_CODE);

alter table DBA.GL_PAPER_COLLECTION_HEADER add
  FK_RELATION_163489 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.GL_PAPER_COLLECTION_DETAIL add
  FK_PAPER_COLLEC_COLEC_CHART foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_PAPER_COLLECTION_DETAIL add
  FK_PAPER_COLLEC_EXPENS_CHART_ foreign key(COM_CODE,EXPENS_CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.GL_PAPER_COLLECTION_DETAIL add
  FK_PAPER_COLLECTION_PAPER foreign key(COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL) references
  DBA.GL_PAPAER(COM_CODE,P_FISCAL_YEAR,PAPER_TYPE,PAPER_IN_OUT,PAPER_SERIAL);

alter table DBA.GL_PAPER_COLLECTION_DETAIL add
  FK_PAPER_COLLECTIO_HED_DET foreign key(COM_CODE,BNK_CODE,PCH_SERIAL,PCH_FISCAL_YEAR) references
  DBA.GL_PAPER_COLLECTION_HEADER(COM_CODE,BNK_CODE,PCH_SERIAL,PCH_FISCAL_YEAR);

alter table DBA.EMP_HOLIDAY_BALANCE add
  FK_EMPLOYEE_HOLIDAY_BALANCE foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_HOLIDAY_OB add
  FK_EMPLOYEE_HOLIDAY_OB foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.SECURITY_INFO add
  FK_RELATION_34362 foreign key(USER_CODE,COM_CODE) references
  DBA.USER_COMPANY(USER_CODE,COM_CODE);

alter table DBA.SYSTEM_PARAMETER add
  FK_COMPANY_PARAMETER foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA."WINDOW" add
  FK_RELATION_176423 foreign key(MOD_MODULE_ID) references
  DBA.MODULES(MOD_MODULE_ID);

alter table DBA.SECURITY_TEMPLATE add
  FK_RELATION_176421 foreign key("WINDOW") references
  DBA."WINDOW"("WINDOW");

alter table DBA.ALLOWANCES_ACCUMULATION_HEADER add
  FK_EMPLOYEE_ALLOWANC foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.ALLOWANCES_ACCUMULATION_HEADER add
  FK_RELATION_178373 foreign key(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6) references
  DBA.ORGANIZATION_CHART(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6);

alter table DBA.GIFTS_AND_BONUS add
  FK_ALLOWAN_DEDUC_GIFTS foreign key(COM_CODE,ADG_CODE,AD_CODE) references
  DBA.ALLOWAN_DEDUCTION(COM_CODE,ADG_CODE,AD_CODE);

alter table DBA.GIFTS_AND_BONUS add
  FK_ORGANIZATION_GIFTS foreign key(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6) references
  DBA.ORGANIZATION_CHART(ORG_CODE_L1,ORG_CODE_L2,ORG_CODE_L3,ORG_CODE_L4,ORG_CODE_L5,ORG_CODE_L6);

alter table DBA.TIME_SHEET_TRANSACTION add
  FK_EMPLOYEE_TIME_SHEET foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.TIME_SHEET_TRANSACTION add
  FK_COST_CENTERS_TIME_SHEET foreign key(COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6) references
  DBA.COST_CENTERS(COC_CODE_L1,COC_CODE_L2,COC_CODE_L3,COC_CODE_L4,COC_CODE_L5,COC_CODE_L6);

alter table DBA.ALLOWANCES_ACCUMULATION_DETAIL add
  FK_ALLOWAN_DEDUCTION_DET foreign key(COM_CODE,ADG_CODE,AD_CODE) references
  DBA.ALLOWAN_DEDUCTION(COM_CODE,ADG_CODE,AD_CODE);

alter table DBA.ALLOWANCES_ACCUMULATION_DETAIL add
  FK_ALLOWANCES_ACCUM foreign key(AAH_SERIAL) references
  DBA.ALLOWANCES_ACCUMULATION_HEADER(AAH_SERIAL);

alter table DBA.EMP_ALL_DED add
  FK_ALLOWAN_DEDUCTION foreign key(COM_CODE,ADG_CODE,AD_CODE) references
  DBA.ALLOWAN_DEDUCTION(COM_CODE,ADG_CODE,AD_CODE);

alter table DBA.EMP_ALL_DED add
  FK_EMP_ALL_DED_EMP foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.REPEATED_TRANSACTION add
  fk_employee_repated_trans foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.REPEATED_TRANSACTION add
  FK_COMPANY_REPEATED_TRANS foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.REPEATED_TRANSACTION add
  fk_allowan_deduction_repated foreign key(COM_CODE,ADG_CODE,AD_CODE) references
  DBA.ALLOWAN_DEDUCTION(COM_CODE,ADG_CODE,AD_CODE);

alter table DBA.EMP_ALL_DED_EDIT_VALUE add
  FK_EMPLYEE_EMP_ALL_DED_EDIT foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_BANKS add
  FK_EMPLOYEE_BANKS foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_BANKS add
  FK_EMP_BANKS foreign key(BNK_CODE) references
  DBA.BANKS(BNK_CODE);

alter table DBA.EMP_BANKS add
  FK_CURRENCY_BANKS foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.EMP_BENEFITS add
  FK_EMPLOYEE_BENEFITS foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_BENEFITS add
  FK_BENEFIT_EMPLOYEE foreign key(B_CODE) references
  DBA.BENEFIT(B_CODE);

alter table DBA.EMP_TEMP_TABLE2 add
  FK_EMPLOYEE_TEMP2 foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_TEMP_TABLE2 add
  FK_CURRENCY_EMP_TEMP foreign key(CUR_CODE) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.PAYSLIP_CALC_MONTH add
  FK_RELATION_188399 foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.PAYSLIP_MONTHLY add
  FK_EMPLOYEE_PAYSLIP_MONTH foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.PAYSLIP_MONTHLY add
  FK_ALLOWAN_DEDUC_GROUP_PAYSLIP foreign key(ADG_CODE) references
  DBA.ALLOWAN_DEDUC_GROUP(ADG_CODE);

alter table DBA.payslip_monthly_copy add
  FK_EMPLOYEE_PAYSLIP_MONTH_COP foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.payslip_monthly_copy add
  FK_ALLOWAN_DEDUC_GROUP_PAYSLIP foreign key(ADG_CODE) references
  DBA.ALLOWAN_DEDUC_GROUP(ADG_CODE);

alter table DBA.PAYSLIP_REPORT_TEMP_TABLE add
  FK_EMPLOYEE_REPORT_TEMP foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.PAYSLIP_SHEET_SETUP add
  FK_COMPANY_PAYSLIP_SHEET_SETUP foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.PAYSLIP_SHEET_SETUP add
  FK_ALLOWAN_DEDUC_GROUP_SHEET_S foreign key(ADG_CODE) references
  DBA.ALLOWAN_DEDUC_GROUP(ADG_CODE);

alter table DBA.ITEM_STORE_OPEN_BAL_DETAIL add
  FK_ITEM_STORE_OPEN_HED_DET foreign key(COM_CODE,STO_CODE,ITM_SERIAL) references
  DBA.ITEM_STORE_OPEN_BAL(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.MEDICAL_INS_TREE add
  FK_PARENT_SELF_MEDICAL foreign key(MI_PARENT_CODE_L1,MI_PARENT_CODE_L2,MI_PARENT_CODE_L3,MI_PARENT_CODE_L4,MI_PARENT_CODE_L5,MI_PARENT_CODE_L6) references
  DBA.MEDICAL_INS_TREE(MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6);

alter table DBA.COM_MEDICAL_INS add
  FK_COMPANY_MEDICAL_INS foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.COM_MEDICAL_INS add
  FK_COM_MEDICAL_TREE foreign key(MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6) references
  DBA.MEDICAL_INS_TREE(MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6);

alter table DBA.EMP_MEDICAL_INS add
  FK_EMPLOYEE_MEDICAL_INS foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.EMP_MEDICAL_INS add
  FK_COM_MEDICAL_EMP foreign key(COM_CODE,CMI_SERIAL) references
  DBA.COM_MEDICAL_INS(COM_CODE,CMI_SERIAL);

alter table DBA.USER_COMPANY_STORE add
  FK_USER_COMPANY_ foreign key(COM_CODE,USER_CODE) references
  DBA.USER_COMPANY(COM_CODE,USER_CODE);

alter table DBA.USER_COMPANY_STORE add
  FK_COMPANY_STORE_USER_COMP foreign key(COM_CODE,STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.payroll_jv_acc_header_setup add
  FK_PAYROLL_JV_COMPANY foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.payroll_jv_acc_header_setup add
  FK_PAYROLL_JV_COST_CENTER foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.PAYROLL_JV_ACC_LINES_SETUP add
  FK_PAYROLL_JV_HEADER_LINES_ foreign key(COM_CODE,PJVHS_SERIAL) references
  DBA.payroll_jv_acc_header_setup(COM_CODE,PJVHS_SERIAL);

alter table DBA.OPEN_BAL_ITEM_COMPANY add
  FK_OPEN_BAL_ITEM_COMPANY foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.GL_BUDGET add
  FK_COMPANY_CHART_BUDGET foreign key(COM_CODE,CHRT_SERIAL) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.ITEM_PURCHASE_HIST add
  FK_ITEM_COMPANY_PURCHASE_HIST foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.PAY_SLIP_SETUP add
  FK_COMPANY_PAY_SLIP_SETUP foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.YEARLY_INCREASE_HEADER add
  FK_YEARLY_INCREASE_EMPLOYEE foreign key(COM_CODE,EM_CODE) references
  DBA.EMPLOYEE(COM_CODE,EM_CODE);

alter table DBA.YEARLY_INCREASE_DETAIL add
  FK_YEARLY_INCREASE_HEADER_DETA foreign key(COM_CODE,EM_CODE,YIH_YEAR) references
  DBA.YEARLY_INCREASE_HEADER(COM_CODE,EM_CODE,YIH_YEAR);

alter table DBA.YEARLY_INCREASE_DETAIL add
  FK_ALLOWAN_DEDUC_YEARLY_INCR foreign key(COM_CODE,ADG_CODE,AD_CODE) references
  DBA.ALLOWAN_DEDUCTION(COM_CODE,ADG_CODE,AD_CODE);

alter table DBA.PAY_SLIP_CALC add
  FK_PAY_SLIP_SETUP_CALC foreign key(COM_CODE,PSS_SERIAL,PSS_TYPE) references
  DBA.PAY_SLIP_SETUP(COM_CODE,PSS_SERIAL,PSS_TYPE);

alter table DBA.PURCHASE_ORDER_STORE_ITEMS add
  FK_PURCHASE_ORDER_ITEM_STORE foreign key(COM_CODE,PO_SERIAL,PO_FISCAL_YEAR,POI_ITEM_SERIAL) references
  DBA.PURCHASE_ORDER_ITEMS(COM_CODE,PO_SERIAL,PO_FISCAL_YEAR,POI_ITEM_SERIAL);

alter table DBA.PURCHASE_ORDER_STORE_ITEMS add
  FK_STORES_PO_STORE_ITEMS foreign key(STO_CODE) references
  DBA.STORES(STO_CODE);

alter table DBA.PURCHASE_ORDER_STORE_ITEMS add
  FK_ITEM_COMPANY_PO_STORE_ITEM foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.PURCHASE_ORDER_STORE_ITEMS add
  FK_RELATION_287503 foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.CST_JOB_ORDER_HEADER add
  FK_COMPANY_JOB_ORDER_HEADER foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.CST_JOB_ORDER_HEADER add
  FK_ITEM_COMPANY_JOB_ORDER foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.CST_JOB_ORDER_HEADER add
  FK_ITEM_UNIT_JOB_ORDER_HEADER foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.CST_JOB_ORDER_HEADER add
  FK_JOB_ORDER_HEADER_HEADER foreign key(COM_CODE,JOH_REORDER_FISCAL_YEAR,JOH_REORDER_DOC_SERIAL) references
  DBA.CST_JOB_ORDER_HEADER(COM_CODE,JOH_FISCAL_YEAR,JOH_DOC_SERIAL);

alter table DBA.CST_JOB_ORDER_HEADER add
  FK_CUSTOMER_JOB_ORDER_HEADER foreign key(COM_CODE,CUS_SERIAL) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.CST_JOB_ORDER_HEADER add
  FK_COST_CENTER_JOB_ORDER foreign key(COM_CODE,CCC_COST_SERIAL) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.CST_JOB_ORDER_DETAIL add
  FK_JOB_ORDER_HEADER_DETAIL foreign key(COM_CODE,JOH_FISCAL_YEAR,JOH_DOC_SERIAL) references
  DBA.CST_JOB_ORDER_HEADER(COM_CODE,JOH_FISCAL_YEAR,JOH_DOC_SERIAL);

alter table DBA.CST_JOB_ORDER_DETAIL add
  FK_ITEM_COMPANY_JOB_ORDER_DETA foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.CST_JOB_ORDER_DETAIL add
  FK_ITEM_UNIT_JOB_ORDER_DETAIL foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.STORE_DATE_SERIAL add
  FK_COMPANY_STORES_DATE foreign key(STO_CODE,COM_CODE) references
  DBA.COMPANY_STORES(STO_CODE,COM_CODE);

alter table DBA.ITEM_COMPANY_STORE_PRICE add
  FK_PRICE_TYPE_ITEM_STORE_PRICE foreign key(PRT_CODE) references
  DBA.PRICE_TYPE(PRT_CODE);

alter table DBA.ITEM_COMPANY_STORE_PRICE add
  FK_ITEM_STORE_COMPAY_PRICE foreign key(COM_CODE,STO_CODE,ITM_SERIAL) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

create unique index pbcatt_x on "backup".pbcattbl(pbt_tnam asc,pbt_ownr asc);

create unique index pbcatc_x on "backup".pbcatcol(pbc_tnam asc,pbc_ownr asc,pbc_cnam asc);

create unique index pbcatf_x on "backup".pbcatfmt(pbf_name asc);

create unique index pbcatv_x on "backup".pbcatvld(pbv_name asc);

create unique index pbcate_x on "backup".pbcatedt(pbe_name asc,pbe_seqn asc);

alter table DBA.ITEM_BOUNS_HEADER add
  FK_COMPANY_ITEM_BOUNS foreign key(COM_CODE) references
  DBA.COMPANY(COM_CODE);

alter table DBA.ITEM_BOUNS_HEADER add
  FK_ITEM_COMPANY_BOUNS foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.ITEM_BOUNS_HEADER add
  FK_RELATION_HEAD foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ITEM_BOUNS_HEADER add
  FK_COMPANY_STORE_ITEM_BOUNS foreign key(COM_CODE,STO_CODE) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.ITEM_BOUNS_DETAIL add
  FK_ITEM_BOUNS_HEADER_DETAIL foreign key(IBH_BOUNS_CODE,COM_CODE) references
  DBA.ITEM_BOUNS_HEADER(IBH_BOUNS_CODE,COM_CODE);

alter table DBA.ITEM_BOUNS_DETAIL add
  FK_ITEM_COMPANY_BOUNS_DETAIL foreign key(COM_CODE,ITM_SERIAL) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.ITEM_BOUNS_DETAIL add
  FK_ITEM_UNIT_BOUNS_DET foreign key(ISP_CODE) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.ISSUE_TRANS_HEADER_EXT add
  FK_ISSUE_DEFAULT_SALES foreign key(COM_CODE,DEFAULT_SAL_SERIAL) references
  DBA.SALESMAN(COM_CODE,SAL_SERIAL);

alter table DBA.ISSUE_TRANS_HEADER_EXT add
  FK_ISSUE_ACTUAL_DIST foreign key(COM_CODE,ACTUAL_DIST_SERIAL) references
  DBA.SALESMAN(COM_CODE,SAL_SERIAL);

alter table DBA.ISSUE_TRANS_HEADER_EXT add
  FK_ISSUE_DEFAULT_DIST foreign key(COM_CODE,DEFAULT_DIST_SERIAL) references
  DBA.SALESMAN(COM_CODE,SAL_SERIAL);

alter table DBA.fa_asset_class add
  fk_fa_asset_class11 foreign key(com_code,fa_glasac_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_class add
  fk_fa_asset_class1 foreign key(com_code,fa_glasac_tree_code_l1,fa_glasac_tree_code_l2,fa_glasac_tree_code_l3,fa_glasac_tree_code_l4,fa_glasac_tree_code_l5,fa_glasac_tree_code_l6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.fa_asset_class add
  fk_fa_asset_class2 foreign key(com_code,fa_cumdep_tree_code_l1,fa_cumdep_tree_code_l2,fa_cumdep_tree_code_l3,fa_cumdep_tree_code_l4,fa_cumdep_tree_code_l5,fa_cumdep_tree_code_l6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.fa_asset_class add
  fk_fa_asset_class3 foreign key(com_code,fa_expdep_tree_code_l1,fa_expdep_tree_code_l2,fa_expdep_tree_code_l3,fa_expdep_tree_code_l4,fa_expdep_tree_code_l5,fa_expdep_tree_code_l6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.fa_asset_class add
  fk_fa_asset_class4 foreign key(com_code,fa_place_tree_code_l1,fa_place_tree_code_l2,fa_place_tree_code_l3,fa_place_tree_code_l4,fa_place_tree_code_l5,fa_place_tree_code_l6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.fa_asset_class add
  fk_fa_asset_class5 foreign key(com_code,fa_asscont_tree_code_l1,fa_asscont_tree_code_l2,fa_asscont_tree_code_l3,fa_asscont_tree_code_l4,fa_asscont_tree_code_l5,fa_asscont_tree_code_l6) references
  DBA.COMPANY_ACCOUNT_CHART_TREE(COM_CODE,TREE_CODE_L1,TREE_CODE_L2,TREE_CODE_L3,TREE_CODE_L4,TREE_CODE_L5,TREE_CODE_L6);

alter table DBA.fa_asset_class add
  fk_fa_asset_class22 foreign key(com_code,fa_cumdep_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_class add
  fk_fa_asset_class33 foreign key(com_code,fa_expdep_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_class add
  fk_fa_asset_class44 foreign key(com_code,fa_place_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_class add
  fk_fa_asset_class55 foreign key(com_code,fa_asscont_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_card add
  fk_company_chart_of_account1 foreign key(com_code,fa_glasac_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_card add
  fk_company_chart_of_account2 foreign key(com_code,fa_cumdep_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_card add
  fk_company_chart_of_account3 foreign key(com_code,fa_expdep_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_card add
  fk_company_chart_of_account4 foreign key(com_code,fa_place_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_card add
  fk_company_chart_of_account5 foreign key(com_code,fa_asscont_chart_serial) references
  DBA.COMPANY_CHART_OF_ACCOUNT(COM_CODE,CHRT_SERIAL);

alter table DBA.fa_asset_card add
  fk_currency foreign key(cur_code) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.fa_asset_card add
  fk_fa_asset_class foreign key(com_code,fa_ascl_serial) references
  DBA.fa_asset_class(com_code,fa_serial);

create unique index idx_fa_asset_trans_header_1 on DBA.fa_asset_trans_header(com_code asc,store_code asc,fah_doc_fiscal_year asc,fah_trans_type1 asc,fah_trans_type2 asc,fah_trans_doc_no asc);

alter table DBA.fa_asset_trans_detail add
  fk_company_cost_centers foreign key(com_code,ccc_cost_serial) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.fa_asset_trans_detail add
  fk_fa_asset_card1 foreign key(com_code,fa_as_serial) references
  DBA.fa_asset_card(com_code,fa_as_serial);

create index idx_fa_trans_detail1 on DBA.fa_asset_trans_detail(com_code asc,fa_as_serial asc,fa_as_subserial asc,fah_trans_type1 asc);

alter table DBA.gl_balance_sheet_setup_detail add
  f1 foreign key(com_code,bss_serial,bss_type) references
  DBA.GL_BALANCE_SHEET_SETUP(COM_CODE,BSS_SERIAL,BSS_TYPE);

alter table DBA.ins_off_table add
  f1 foreign key(cou_code_l1,cou_code_l2,cou_code_l3,cou_code_l4,cou_code_l5,cou_code_l6) references
  DBA.COUNTRY(COU_CODE_L1,COU_CODE_L2,COU_CODE_L3,COU_CODE_L4,COU_CODE_L5,COU_CODE_L6);

alter table DBA.balance_adjustment add
  fk_item_store_adjustment foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_issue_rm add
  fk_item_store_balance_issue_rm foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_issue add
  fk_item_store_issue foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_recieve add
  fk_item_store_recieve foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_ret_issue add
  fk_item_store_ret_issue foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_ret_rec add
  fk_item_store_ret_rec foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_transf_in add
  fk_item_store_transf_in foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_transf_out add
  fk_item_store_transf_out foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.system_balance add
  fk_relation_105720 foreign key(com_code,sal_serial) references
  DBA.SALESMAN(COM_CODE,SAL_SERIAL);

alter table DBA.system_balance add
  fk_relation_41760 foreign key(com_code) references
  DBA.COMPANY(COM_CODE);

alter table DBA.system_balance add
  fk_relation_40620 foreign key(com_code,ven_serial) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

alter table DBA.system_balance add
  fk_relation_40619 foreign key(com_code,cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.system_balance add
  fk_relation_49021 foreign key(com_code,itm_serial,sto_code) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,ITM_SERIAL,STO_CODE);

alter table DBA.system_balance add
  fk_relation_40575 foreign key(mod_module_id,mtt_trans_type_1,mtt_trans_type_2) references
  DBA.MODULE_TRANSACTIONS(MOD_MODULE_ID,MTT_TRANS_TYPE_1,MTT_TRANS_TYPE_2);

create unique index index_1 on DBA.system_balance(mod_module_id asc,mtt_trans_type_1 asc,mtt_trans_type_2 asc,com_code asc,st_store_code asc,code_serial asc,calendar_year asc,calendar_month asc);

alter table DBA.issue_trans_header add
  fk_relation_11529 foreign key(com_code,sto_code,return_trans_type_code_level1,return_trans_type_code_level2,return_trans_no,return_fisical_year) references
  DBA.issue_trans_header(com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year);

alter table DBA.issue_trans_header add
  fk_relation_13547 foreign key(sal_serial,com_code) references
  DBA.SALESMAN(SAL_SERIAL,COM_CODE);

alter table DBA.issue_trans_header add
  fk_relation_84983 foreign key(com_code,ccc_cost_serial) references
  DBA.COMPANY_COST_CENTERS(COM_CODE,CCC_COST_SERIAL);

alter table DBA.issue_trans_header add
  fk_relation_11448 foreign key(com_code,sto_code) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.issue_trans_header add
  fk_relation_104201 foreign key(cur_code) references
  DBA.CURRENCY(CUR_CODE);

alter table DBA.issue_trans_header add
  fk_relation_11447 foreign key(cus_serial) references
  DBA.CUSTOMER(CUS_SERIAL);

alter table DBA.issue_trans_header add
  fk_cus_com foreign key(com_code,cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

create index doc_no_post_date on DBA.issue_trans_header(trans_user_no asc,iss_posting_date asc);

create index idx_trans_userno on DBA.issue_trans_header(trans_user_no asc);

alter table DBA.issue_transaction_items add
  fk_relation_11475 foreign key(isp_code) references
  DBA.ITEM_UNIT(ITU_CODE);

alter table DBA.issue_transaction_items add
  fk_bonus_item_store_issue foreign key(com_code,sto_code,bonus_itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.issue_transaction_items add
  fk_relation_13546 foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.issue_transaction_items add
  fk_relation_48021 foreign key(com_code,sal_serial) references
  DBA.SALESMAN(COM_CODE,SAL_SERIAL);

alter table DBA.issue_transaction_items add
  fk_relation_11474 foreign key(com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year) references
  DBA.issue_trans_header(com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,fisical_year);

alter table DBA.balance_issue1 add
  fk_item_store_issue foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_recieve1 add
  fk_item_store_recieve foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_ret_issue1 add
  fk_item_store_ret_issue foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.balance_ret_rec1 add
  fk_item_store_ret_rec foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.issue_trans_items_ext add
  one_to_one foreign key(com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,iss_item_serial,fisical_year) references
  DBA.issue_transaction_items(com_code,sto_code,trans_type_code_level1,trans_type_code_level2,trans_no,iss_item_serial,fisical_year) on delete cascade;

alter table DBA.Future_menus add
  fk_relation_301 foreign key(fum_parent_code_l1,fum_parent_code_l2,fum_parent_code_l3,fum_parent_code_l4,fum_parent_code_l5,fum_parent_code_l6) references
  DBA.Future_menus(fum_code_l1,fum_code_l2,fum_code_l3,fum_code_l4,fum_code_l5,fum_code_l6);

alter table DBA.characteristic_rep_form_i add
  characteristic_rep_form_h foreign key(form_number,com_code) references
  DBA.characteristic_rep_form_h(form_number,com_code);

alter table DBA.characteristic_rep_form_i add
  item_master foreign key(itm_serial) references
  DBA.ITEM_MASTER(ITM_SERIAL);

alter table DBA.customer_ext add
  fk_cus_ser foreign key(cus_serial) references
  DBA.CUSTOMER(CUS_SERIAL);

alter table DBA.customer_ext add
  fk_job_title foreign key(jt_code) references
  DBA.JOB_TITLE(JT_CODE);

alter table DBA.sales_order_header add
  fk_soh_customer_company foreign key(com_code,cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.sales_order_header add
  fk_soh_company_stores foreign key(com_code,dlv_sto_code) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.sales_order_items add
  fk_soi_actual_company_stores foreign key(com_code,actual_sto_code) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.sales_order_items add
  fk_soi_dlv_company_stores foreign key(com_code,dlv_sto_code) references
  DBA.COMPANY_STORES(COM_CODE,STO_CODE);

alter table DBA.sales_order_items add
  fk_soi_customer_company foreign key(com_code,item_cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.sales_order_items add
  fk_soi_item_company foreign key(com_code,itm_serial) references
  DBA.ITEM_COMPANY(COM_CODE,ITM_SERIAL);

alter table DBA.sales_order_items add
  fk_soi_sales_order_header foreign key(com_code,so_serial,so_fiscal_year) references
  DBA.sales_order_header(com_code,so_serial,so_fiscal_year);

alter table DBA.customer_complain_inquire add
  fk_customer_company foreign key(com_code,cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.item_store_comp_ven_followup add
  fk_item_store_com_foll foreign key(com_code,sto_code,itm_serial) references
  DBA.ITEM_STORE_COMPANY(COM_CODE,STO_CODE,ITM_SERIAL);

alter table DBA.item_store_comp_ven_followup add
  fk_item_ven_foll foreign key(com_code,ven_serial,itm_serial) references
  DBA.ITEM_COMPANY_VENDOR(COM_CODE,VEN_SERIAL,ITM_SERIAL);

alter table DBA.sales_order_followup add
  fk_sales_order_header foreign key(com_code,so_serial,so_fiscal_year) references
  DBA.sales_order_header(com_code,so_serial,so_fiscal_year);

alter table DBA.contract_master add
  fk_contract_master_tree foreign key(mi_code_l1,mi_code_l2,mi_code_l3,mi_code_l4,mi_code_l5,mi_code_l6) references
  DBA.MEDICAL_INS_TREE(MI_CODE_L1,MI_CODE_L2,MI_CODE_L3,MI_CODE_L4,MI_CODE_L5,MI_CODE_L6);

alter table DBA.contract_detail add
  fk_contract_master_detail foreign key(cont_serial) references
  DBA.contract_master(cont_serial);

alter table DBA.contract_detail add
  fk_contract_detail_itg foreign key(itg_code_l1,itg_code_l2,itg_code_l3,itg_code_l4,itg_code_l5,itg_code_l6) references
  DBA.ITEM_GROUPS(ITG_CODE_L1,ITG_CODE_L2,ITG_CODE_L3,ITG_CODE_L4,ITG_CODE_L5,ITG_CODE_L6);

alter table DBA.contract_detail add
  fk_contract_detail_itm_color foreign key(itc_code) references
  DBA.ITEM_COLOR(ITC_CODE);

alter table DBA.contract_detail add
  fk_contract_detail_itm_category foreign key(ic_code) references
  DBA.ITEM_CATEGORY(IC_CODE);

alter table DBA.contract_detail add
  fk_contract_detail_itm_gender foreign key(ig_code) references
  DBA.ITEM_GENDER(IG_CODE);

alter table DBA.contract_detail add
  fk_contract_detail_itm_model foreign key(imo_code) references
  DBA.ITEM_MODEL(IMO_CODE);

alter table DBA.contract_detail add
  fk_contract_detail_itm_season foreign key(is_code) references
  DBA.ITEM_SEASON(IS_CODE);

alter table DBA.contract_detail add
  fk_contract_detail_itm_size foreign key(its_code) references
  DBA.ITEM_SIZE(ITS_CODE);

alter table DBA.cus_contract add
  fk_cus_contract_company foreign key(com_code) references
  DBA.COMPANY(COM_CODE);

alter table DBA.cus_contract add
  fk_cus_contract_contract foreign key(cont_serial) references
  DBA.contract_master(cont_serial);

alter table DBA.cus_contract add
  fk_cus_contract_customer foreign key(com_code,cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.salary_transaction_detail add
  fk_sal_tran_em_bank foreign key(com_code,em_code,eb_serial) references
  DBA.EMP_BANKS(COM_CODE,EM_CODE,EB_SERIAL);

create index index_1 on DBA.isc_from_transaction(com_code asc,sto_code asc,itm_serial asc);

create index index_2 on DBA.isc_from_transaction(com_code asc,sto_code asc,itm_serial asc,calendar_year asc,calendar_month asc);

create index index_1 on DBA.isc_exp_from_transaction(com_code asc,sto_code asc,itm_serial asc,expiry_date asc);

create index index_2 on DBA.isc_exp_from_transaction(com_code asc,sto_code asc,itm_serial asc,calendar_year asc,calendar_month asc);

alter table DBA.com_job add
  fk_company_com_job foreign key(com_code) references
  DBA.COMPANY(COM_CODE);

alter table DBA.com_job add
  fk_com_job_customer foreign key(com_code,cus_serial) references
  DBA.CUSTOMER_COMAPNY(COM_CODE,CUS_SERIAL);

alter table DBA.com_job add
  fk_com_job_vendors foreign key(com_code,ven_serial) references
  DBA.COMPANY_VENDORS(COM_CODE,VEN_SERIAL);

create view DBA.promotion_view;


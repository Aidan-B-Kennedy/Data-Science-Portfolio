select  f.MASTER_ACCOUNT
        ,f.ACCOUNT
        ,listagg(f.RECORD, ',') WITHIN GROUP (ORDER BY f.RECORD) as RECORD
        --,f.RECORD
        ,f.ACCT_REGISTRATION_LINE_1
        ,f.ACCT_REGISTRATION_LINE_2
        ,f.ADDRESS
        ,f.CITY
        ,f.STATE
        ,f.ZIP
        ,f.COUNTRY
 
from (
--select Pershing holdings
Select Distinct
        b.MASTER_MNEMONIC as MASTER_ACCOUNT
        ,a.ACCT_NBR as ACCOUNT
        ,Case
            WHEN a.ACCT_NBR is null then 'N/A'
            else 'Held'
        END as Record
        ,b.ACCT_REGISTRATION_LINE_1
        ,b.ACCT_REGISTRATION_LINE_2
        ,b.ADDRESS_LINE1 as ADDRESS
        ,b.CITY
        ,b.STATE
        ,SUBSTR(b.ZIP,1,5) as ZIP
        ,b.COUNTRY_CD as COUNTRY
from PERSHING_TPS_CUSTOM.ACCOUNT_SECURITY_HOLDER_VW_H a left join
        pershing_tps_custom.ACCOUNT_MAIN_VW b on a.ACCT_NBR = b.ACCT_NBR
where  a.SD_QTY > '0'
        and a.acct_nbr not like 'X%'
        and a.CUSIP = '45200FBC2'
        and a.ETL_EFF_DT between '01-APR-20' and '01-APR-20'
       
UNION
 
--search Broadridge holdings
select  c.ms_br_account_top_cd as MASTER_ACCOUNT
        ,a.BR_ACCOUNT_CD as ACCOUNT
        ,Case
            WHEN a.BR_ACCOUNT_CD is null then 'N/A'
            else 'Held'
        END as Record
        ,c.NA_LINE_TXT_1
        ,c.ms_account_hldr_nm
        ,c.STREET_NM
        ,c.CITY_NM
        ,c.STATE_CD
        ,case
            when c.ZIP5_CD IS NULL then c.ZIP_FOREIGN_CD
            else c.ZIP5_CD
        end as ZIP
        ,c.COUNTRY_FOREIGN_NM
from BPSA_CUSTOM.TACCOUNT_SEC_HLDR_H a left join
        INBOUND.ACCT_NBR_XREF b on a.BR_ACCOUNT_CD = b.ACCT_NBR left join
        BPSA_CUSTOM.ACCOUNT_VW c on a.BR_ACCOUNT_CD = c.BR_ACCOUNT_CD     
where  a.Settlement_Dt_Qty > '0'
        and a.br_account_cd not like '0%'
        and a.br_account_cd not like '1%'
        and a.CUSIP_INTRL_Nbr like concat('00972810','%')
        and a.Asof_Business_Date between '03-NOV-16' and '08-JAN-19'
UNION
 
--Search Pershing Trades
Select Distinct
        b.MASTER_MNEMONIC as MASTER_ACCOUNT
        ,a.ACCT_NBR as ACCOUNT
       ,Case
            WHEN a.ACCT_NBR is null then 'N/A'
            else 'Purchased'
        END as Record
        ,b.ACCT_REGISTRATION_LINE_1
        ,b.ACCT_REGISTRATION_LINE_2
        ,b.ADDRESS_LINE1 as ADDRESS
        ,b.CITY
        ,b.STATE
        ,SUBSTR(b.ZIP,1,5) as ZIP
        ,b.COUNTRY_CD as COUNTRY
from(
select  ACCT_NBR
        , BUY_SELL_CD
        , TRD_DT
        , NET_AMT
        , QTY
        , CUSIP
        , PRIMARY_EXEC_REP
from    PERSHING_TPS_CUSTOM.TRANS_VW_H
where   ACCT_NBR like 'T%'
        or ACCT_NBR like 'R%'
        ) a left join
    pershing_tps_custom.ACCOUNT_MAIN_VW b on a.ACCT_NBR = b.ACCT_NBR
where a.buy_sell_cd = 'B'
      and a.CUSIP = '78442GRA6'
      and a.TRD_DT between '23-APR-20' and '23-APR-20'
--order by  b.MASTER_MNEMONIC
 
UNION
 
--Search Broadridge Trades
select  c.ms_br_account_top_cd as MASTER_ACCOUNT
        ,a.BR_ACCOUNT_CD as ACCOUNT
        ,Case
            WHEN a.BR_ACCOUNT_CD is null then 'N/A'
            else 'Purchased'
        END as Record
        ,c.c.NA_LINE_TXT_1
        ,c.ms_account_hldr_nm
        ,c.STREET_NM
        ,c.CITY_NM
        ,c.STATE_CD
        ,case
            when c.ZIP5_CD IS NULL then c.ZIP_FOREIGN_CD
            else c.ZIP5_CD
        end as ZIP
        ,c.COUNTRY_FOREIGN_NM
from    BPSA_CUSTOM.TPRCHS_SALE_TRANS_H a left join
        BPSA_CUSTOM.ACCOUNT_VW c on a.BR_ACCOUNT_CD = c.BR_ACCOUNT_CD    
where   a.br_account_cd > '19999999'
        and a.trans_acct_hist_cd = 'A'
        and a.Debit_Credit_Cd = 'D'
        and a.CUSIP_9 = '009728106'
        and a.TRADE_DT between '03-NOV-2016' and'08-JAN-2019'
 
order by  MASTER_ACCOUNT
    ) f
group by f.MASTER_ACCOUNT
        ,f.ACCOUNT
        --,f.RECORD
        ,f.ACCT_REGISTRATION_LINE_1
        ,f.ACCT_REGISTRATION_LINE_2
        ,f.ADDRESS
        ,f.CITY
        ,f.STATE
       ,f.ZIP
        ,f.COUNTRY
order by f.master_account
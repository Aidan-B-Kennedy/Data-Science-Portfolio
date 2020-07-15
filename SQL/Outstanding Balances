
select  n.INSTITUTION_NAME
        , m.ACCT_NBR
        , n.REP_NBR
        , n.CLEARING_AGENT_NBR
        , m.CUSIP_1A
        , m.SETTLE_DT_1A
        , m.BROKER_1A
        , m.REC_DEL_CD_1A
   
        
from    PERSHING_TPS_CUSTOM.RECEIVE_DELIVER_VW m inner join
        PERSHING_TPS_CUSTOM.ACCOUNT_STTLMNT_INST_VW n on m.ACCT_NBR = n.ACCT_NBR
        
where   (n.CLEARING_AGENT_NBR is null or m.BROKER_1A = '0000')
        and m.SETTLE_METHOD_2A = 'DTC'
        and m.REC_DEL_CD_1A = 'D'
 

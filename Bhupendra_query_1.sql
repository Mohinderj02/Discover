--Insert test cases

SET DEFINE OFF;
Insert into DQ_STG.STG_QA_TEST_CASE_SUITE
   (PROJ_CD, FUNC_AREA_NAME, TEST_SUITE_NAME, ACTN_TO_PERF) --<-- inserts test suite
 Values
   ('PHX', 'LOANS', 'TS_ALN_LOAN_PHX_STG_ALN_ACCT_LOAN_POLICY_CRITICAL', 'TS_INSRT');
Insert into DQ_STG.STG_QA_TEST_CASE_SUITE
   (PROJ_CD, FUNC_AREA_NAME, TEST_SUITE_NAME, TEST_CASE_NAME, ACTN_TO_PERF)
 Values
   ('PHX', 'LOANS', 'TS_ALN_LOAN_PHX_STG_ALN_ACCT_LOAN_POLICY_CRITICAL', 'TC_SRCE_SYS_NOT_NULL_CNSTRT_CHK', 'TC_INSRT');
Insert into DQ_STG.STG_QA_TEST_CASE_SUITE
   (PROJ_CD, FUNC_AREA_NAME, TEST_SUITE_NAME, TEST_CASE_NAME, ACTN_TO_PERF)
 Values
   ('PHX', 'LOANS', 'TS_ALN_LOAN_PHX_STG_ALN_ACCT_LOAN_POLICY_CRITICAL', 'TC_SRCE_SBSYS_NOT_NULL_CNSTRT_CHK', 'TC_INSRT');
   
--Disable test case   
   
Insert into DQ_STG.STG_QA_TEST_CASE_SUITE
  (PROJ_CD, FUNC_AREA_NAME, TEST_SUITE_NAME, TEST_CASE_NAME, ACTN_TO_PERF, COL_TO_UPDT,NEW_VAL )
Values
  ('PHX', 'LOANS', 'TS_LP_LP_PHX_OWNER_S_CTRCT_LOAN_LP_NONCRITICAL', 'TC_ACCRL_BASIS_MTH_DAY_CNT_COMPARE_CHK' ,'TC_UPDT', 'RUN_FLAG', 'N');
  COMMIT;   

--Queries to check the test cases

SELECT r.test_run_key
,TS.TEST_SUITE_KEY
     ,ts.test_suite_name
     ,tc.test_case_name
     ,TC.RUN_FLAG
     ,r.obj_tested
     ,r.tot_rec_cnt
     ,r.expct_val
     ,TRIM(r.cond) AS cond
     ,r.nbr_fail
     ,r.nbr_pass
     ,r.pass_flag
     ,r.run_dt
     ,r.rslt_msg
     ,B.DAY_ID
     ,B.PROC_ID
     ,B.TEST_ENVT
 FROM dq_owner.fact_run_rslt r
   JOIN dq_owner.dim_dq_test_case tc
      ON r.test_case_key = tc.test_case_key
   JOIN dq_owner.lkp_dq_test_suite ts
      ON ts.test_suite_key = tc.test_suite_key
   JOIN (select TEST_RUN_KEY,
    max(decode(PARM_NAME,'DAY_ID',PARM_VAL,NULL)) DAY_ID,
    max(decode(PARM_NAME,'PROC_ID',PARM_VAL,NULL)) PROC_ID,
    max(decode(PARM_NAME,'ENV',PARM_VAL,'ENVIRONMENT TESTED',PARM_VAL,NULL)) TEST_ENVT
    from DQ_OWNER.FACT_RUN_PARM
    group by TEST_RUN_KEY
    ) B
    ON R.TEST_RUN_KEY = B.TEST_RUN_KEY
WHERE  ts.test_suite_name IN ( 'TS_PRSPR_PRSPR_PHX_OWNER_S_CTRCT_STATIC_IND_CRITICAL', 'TS_PRSPR_PRSPR_PHX_OWNER_S_CTRCT_STATIC_IND_NONCRITICAL') -- change to test suite name to extract  -- change to test casee name to extract
  and (ts.test_suite_name,R.TEST_RUN_KEY)  IN (select TS.TEST_SUITE_NAME,max(test_run_key) FROM dq_owner.fact_run_rslt r
   JOIN dq_owner.dim_dq_test_case tc
      ON r.test_case_key = tc.test_case_key
   JOIN dq_owner.lkp_dq_test_suite ts
      ON ts.test_suite_key = tc.test_suite_key
      where TS.TEST_SUITE_NAME IN ('TS_PRSPR_PRSPR_PHX_OWNER_S_CTRCT_STATIC_IND_CRITICAL', 'TS_PRSPR_PRSPR_PHX_OWNER_S_CTRCT_STATIC_IND_NONCRITICAL')
      GROUP BY TS.TEST_SUITE_NAME )   -- change to test tsuite  name to extract
--and r.pass_flag = 'N' --Uncomment to limit to only failed cases
ORDER BY ts.test_suite_name, tc.test_case_name, r.run_dt DESC;

select * from DQ_OWNER.LKP_DQ_TEST_SUITE ts,
DQ_OWNER.DIM_DQ_TEST_CASE tc
where ts.test_suite_key = tc.test_suite_key
and ts.test_suite_name IN ('TS_PRSPR_PRSPR_PHX_OWNER_S_CTRCT_STATIC_IND_CRITICAL', 'TS_PRSPR_PRSPR_PHX_OWNER_S_CTRCT_STATIC_IND_NONCRITICAL') --<-- change test suite
AND TC.RUN_FLAG = 'Y';

select TS.TEST_SUITE_NAME, TC.TEST_CASE_NAME, TC.RUN_FLAG from DQ_OWNER.LKP_DQ_TEST_SUITE ts,
DQ_OWNER.DIM_DQ_TEST_CASE tc
where ts.test_suite_key = tc.test_suite_key
AND TC.RUN_FLAG = 'N';
----------------------

select TS.TEST_SUITE_NAME, TC.TEST_CASE_NAME, TC.RUN_FLAG from DQ_OWNER.LKP_DQ_TEST_SUITE ts,
DQ_OWNER.DIM_DQ_TEST_CASE tc
where ts.test_suite_key = tc.test_suite_key
AND TC.RUN_FLAG = 'N'
and ts.test_suite_name IN ('TS_WFEX_FRAUD_ENGINE_FRD_STG_TWFEXIOV_STG_CRITICAL', 'TS_WFEX_FRAUD_ENGINE_FRD_STG_TWFEXIOV_STG_NONCRITICAL'); --<-- change test suite
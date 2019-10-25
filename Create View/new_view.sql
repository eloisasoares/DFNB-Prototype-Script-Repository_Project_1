SELECT af.[acct_id], 
       ad.acct_open_date AS loan_date, 
       ad.[loan_amt], 
       af.[as_of_date] AS balance_date, 
       ROW_NUMBER() OVER(PARTITION BY af.[acct_id], 
                                      ad.[loan_amt]
       ORDER BY af.[acct_id], 
                af.[as_of_date], 
                af.[cur_balance] DESC) AS period,
       CASE
           WHEN(LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                                          ORDER BY af.[acct_id], 
                                                   af.[as_of_date], 
                                                   af.[cur_balance] DESC) IS NULL)
           THEN ad.[loan_amt]
           ELSE LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
           ORDER BY af.[acct_id], 
                    af.[as_of_date], 
                    af.[cur_balance] DESC)
       END AS previous_balance, 
       af.[cur_balance] AS current_balance, 
       af.[cur_balance] - (CASE
                               WHEN(LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                           ORDER BY af.[acct_id], 
                                    af.[as_of_date], 
                                    af.[cur_balance] DESC) IS NULL)
                               THEN ad.[loan_amt]
                               ELSE LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                               ORDER BY af.[acct_id], 
                                        af.[as_of_date], 
                                        af.[cur_balance] DESC)
                           END) AS payment,
       CASE
           WHEN(CASE
                    WHEN(LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                ORDER BY af.[acct_id], 
                         af.[as_of_date], 
                         af.[cur_balance] DESC) IS NULL)
                    THEN ad.[loan_amt]
                    ELSE LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                    ORDER BY af.[acct_id], 
                             af.[as_of_date], 
                             af.[cur_balance] DESC)
                END) not like '-%'
           THEN 'INTEREST CHARGED'
           WHEN(CASE
                    WHEN(LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                ORDER BY af.[acct_id], 
                         af.[as_of_date], 
                         af.[cur_balance] DESC) IS NULL)
                    THEN ad.[loan_amt]
                    ELSE LAG(af.[cur_balance], 1) OVER(PARTITION BY af.[acct_id]
                    ORDER BY af.[acct_id], 
                             af.[as_of_date], 
                             af.[cur_balance] DESC)
                END) like '-%'
           THEN 'PAYMENT DONE'
           ELSE 'NO PAYMENT IN THE PERIOD'
       END AS Payment_Status
FROM [dbo].[t_account_fact] AS af
     JOIN [dbo].[t_account_dim] AS ad ON ad.[acct_id] = af.[acct_id]
WHERE af.[acct_id] < '14'
ORDER BY af.[acct_id], 
         af.[as_of_date], 
         af.[cur_balance] DESC;

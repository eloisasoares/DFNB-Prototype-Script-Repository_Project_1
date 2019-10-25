/********************************************************************************************
NAME: [dbo].[v_balance]
PURPOSE: Create the view [dbo].[v_balance]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to create the view [dbo].[v_balance].
1.1	 10/25/2019  ESOARES   1. Changed the decimal places for the money amounts from 4 to 0.

RUNTIME: 
0 min

NOTES: 
(...)

LICENSE: 
This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.

********************************************************************************************/

USE DFNB2;
DROP VIEW dbo.v_balance;
GO
CREATE VIEW v_balance
AS
     SELECT af.acct_id, 
            ad.acct_open_date AS loan_date, 
            CONVERT(DECIMAL(10, 0), ad.loan_amt) AS loan_amt, 
            af.as_of_date AS balance_date, 
            ROW_NUMBER() OVER(PARTITION BY af.acct_id, 
                                           ad.loan_amt
            ORDER BY af.acct_id, 
                     af.as_of_date, 
                     af.cur_balance DESC) AS period, 
            CONVERT(DECIMAL(10, 0), (CASE
                                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                     ORDER BY af.acct_id, 
                                              af.as_of_date, 
                                              af.cur_balance DESC) IS NULL
                                         THEN ad.loan_amt
                                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                         ORDER BY af.acct_id, 
                                                  af.as_of_date, 
                                                  af.cur_balance DESC)
                                     END)) AS previous_balance, 
            CONVERT(DECIMAL(10, 0), af.cur_balance - CASE
                                                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                                     ORDER BY af.acct_id, 
                                                              af.as_of_date, 
                                                              af.cur_balance DESC) IS NULL
                                                         THEN ad.loan_amt
                                                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                                                         ORDER BY af.acct_id, 
                                                                  af.as_of_date, 
                                                                  af.cur_balance DESC)
                                                     END) AS payment, 
            CONVERT(DECIMAL(10, 0), af.cur_balance) AS current_balance,
            CASE
                WHEN CASE
                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                     ORDER BY af.acct_id, 
                              af.as_of_date, 
                              af.cur_balance DESC) IS NULL
                         THEN ad.loan_amt
                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                         ORDER BY af.acct_id, 
                                  af.as_of_date, 
                                  af.cur_balance DESC)
                     END < af.[cur_balance]
                THEN 'MORE CHARGES ADDED'
                WHEN CASE
                         WHEN LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                     ORDER BY af.acct_id, 
                              af.as_of_date, 
                              af.cur_balance DESC) IS NULL
                         THEN ad.loan_amt
                         ELSE LAG(af.cur_balance, 1) OVER(PARTITION BY af.acct_id
                         ORDER BY af.acct_id, 
                                  af.as_of_date, 
                                  af.cur_balance DESC)
                     END > af.[cur_balance]
                THEN 'PAYMENT DONE'
                ELSE 'NO PAYMENT IN THE PERIOD'
            END AS Payment_Status
     FROM dbo.t_account_fact AS af
          JOIN dbo.t_account_dim AS ad ON ad.acct_id = af.acct_id;
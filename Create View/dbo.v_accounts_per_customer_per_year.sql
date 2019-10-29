/********************************************************************************************
NAME: [dbo].[v_accounts_per_customer_per_year]
PURPOSE: Create the view [dbo].[v_accounts_per_customer_per_year]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/27/2019  ESOARES   1. Built this script to create the view [dbo].[v_accounts_per_customer_per_year].

RUNTIME: 
1 min

NOTES: 
(...)

LICENSE: 
This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.

********************************************************************************************/

DROP VIEW IF EXISTS [dbo].[v_accounts_per_customer_per_year];
GO
CREATE VIEW [v_accounts_per_customer_per_year]
AS
select DATEPART(YEAR, cd.[cust_since_date]) AS year
		,cd.[cust_id]
		,cad.cust_role_id
		,COUNT(cad.[acct_id]) as accounts
		,cd.[relationship_id]
		,CONVERT(DECIMAL(10, 0),SUM(ad.loan_amt)) as loans
from [dbo].[t_customer_dim] as cd
join [dbo].[t_customer_account_dim] as cad on cd.[cust_id] = cad.cust_id
join [dbo].[t_account_dim] as ad on ad.acct_id = cad.acct_id
group by DATEPART(YEAR, cd.[cust_since_date])
,cd.[cust_id]
,cad.cust_role_id
,cd.[relationship_id];
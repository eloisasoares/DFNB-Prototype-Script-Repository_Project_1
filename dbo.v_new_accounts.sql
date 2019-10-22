/********************************************************************************************
NAME: [dbo].[v_new_accounts]
PURPOSE: Create the view [dbo].[v_new_accounts]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to create the view [dbo].[v_new_accounts].

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

DROP VIEW [dbo].[v_new_accounts];
GO
CREATE VIEW v_new_accounts
AS
     SELECT DATEPART(YEAR, ad.[acct_open_date]) AS Year, 
            bd.[branch_code] AS Branch, 
            bd.[region_id] AS Region, 
            bd.[area_id] AS Area, 
            COUNT(af.[acct_id]) AS Total_New_Accounts
     FROM [dbo].[t_account_dim] AS ad
          JOIN [dbo].[t_account_fact] AS af ON ad.[acct_id] = af.[acct_id]
          JOIN [dbo].[t_branch_dim] AS bd ON bd.[branch_id] = ad.[branch_id]
          JOIN [dbo].[t_customer_dim] AS cd ON cd.[cust_id] = ad.[primary_cust_id]
     GROUP BY DATEPART(YEAR, ad.[acct_open_date]), 
              bd.[branch_code], 
              bd.[region_id], 
              bd.[area_id];
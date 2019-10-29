/********************************************************************************************
NAME: DataOutput
PURPOSE: Output data to create reports

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to output data and create reports.

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

USE [DFNB2]
SELECT *
FROM [dbo].[v_new_accounts]
ORDER BY 2,1 DESC

/*******************************************************************************************/

USE [DFNB2]
SELECT *
FROM [dbo].[v_new_customers]
ORDER BY 2,1 DESC

/*******************************************************************************************/

USE [DFNB2]
SELECT *
FROM [dbo].[v_new_loans]
ORDER BY 4,1 DESC,3 DESC

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_balance]
ORDER BY 1, 4, 8 DESC;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_accounts_per_customer_per_year]
ORDER BY 5,1,2;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_customers_per_client]
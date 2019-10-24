/********************************************************************************************
NAME: [dbo].[t_account_fact]
PURPOSE: Create the table [dbo].[t_account_fact]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to create the table [dbo].[t_account_fact].

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

USE [DFNB2];

DROP TABLE t_account_fact;

CREATE TABLE t_account_fact ( 
             as_of_date  DATE NOT NULL , 
             acct_id     INT NOT NULL , 
             cur_balance DECIMAL(20 , 4) NOT NULL
                            );
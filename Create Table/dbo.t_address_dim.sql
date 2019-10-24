/********************************************************************************************
NAME: [dbo].[t_address_dim]
PURPOSE: Create the table [dbo].[t_address_dim]

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to create the table [dbo].[t_address_dim].
1.1	 10/23/2019  ESOARES   1. Changed the statement that adds the Primary Key to determine its name.

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

DROP TABLE t_address_dim;

CREATE TABLE t_address_dim ( 
             address_id   INT NOT NULL , 
             address_type VARCHAR(1) NOT NULL , 
             latitude     DECIMAL(16 , 12) NOT NULL , 
             longitude    DECIMAL(16 , 12) NOT NULL CONSTRAINT PK_t_address_dim PRIMARY KEY CLUSTERED(address_id ASC)
                           );
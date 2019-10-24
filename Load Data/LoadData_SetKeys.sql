/********************************************************************************************
NAME: LoadData_SetKeys
PURPOSE: Load the normalized tables in the DFNB2 database

SUPPORT: Eloisa Soares
	    esoares2@ldsbc.edu
	    eloisa_mariano@yahoo.com.br

MODIFICATION LOG:
Ver   Date        Author    Description
----  ----------  -------   -----------------------------------------------------------------
1.0   10/22/2019  ESOARES   1. Built this script to load the tables in DFNB2 database and set PKs and FKs.

RUNTIME: 
4 min

NOTES: 
(...)

LICENSE: 
This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.

********************************************************************************************/

TRUNCATE TABLE t_account_dim
INSERT INTO t_account_dim
(acct_id, 
 acct_open_date, 
 acct_close_date, 
 acct_open_close_code, 
 loan_amt, 
 primary_cust_id, 
 branch_id, 
 product_id
)
       SELECT [acct_id], 
              [open_date], 
              [close_date], 
              [open_close_code], 
              [loan_amt], 
              [pri_cust_id], 
              [acct_branch_id], 
              [prod_id]
       FROM [dbo].[stg_p1]
       GROUP BY [acct_id], 
                [open_date], 
                [close_date], 
                [open_close_code], 
                [loan_amt], 
                [pri_cust_id], 
                [acct_branch_id], 
                [prod_id]
       ORDER BY 1, 
                6, 
                7, 
                8;

/*******************************************************************************************/

TRUNCATE TABLE t_account_fact
INSERT INTO t_account_fact
(as_of_date, 
 acct_id, 
 cur_balance
)
       SELECT [as_of_date], 
              [acct_id], 
              [cur_bal]
       FROM [dbo].[stg_p1]
       GROUP BY [as_of_date], 
                [acct_id], 
                [cur_bal]
       ORDER BY 2, 
                1;

/*******************************************************************************************/

TRUNCATE TABLE t_address_dim
INSERT INTO t_address_dim
(address_id, 
 address_type, 
 latitude, 
 longitude
)
       SELECT [cust_add_id], 
              [cust_add_type], 
              [cust_add_lat], 
              [cust_add_lon]
       FROM [dbo].[stg_p1]
       GROUP BY [cust_add_id], 
                [cust_add_type], 
                [cust_add_lat], 
                [cust_add_lon]
       ORDER BY 1;

INSERT INTO t_address_dim
(address_id, 
 address_type, 
 latitude, 
 longitude
)
       SELECT [acct_branch_add_id], 
              [acct_branch_add_type], 
              [acct_branch_add_lat], 
              [acct_branch_add_lon]
       FROM [dbo].[stg_p1]
       GROUP BY [acct_branch_add_id], 
                [acct_branch_add_type], 
                [acct_branch_add_lat], 
                [acct_branch_add_lon]
       ORDER BY 1;

/*******************************************************************************************/

TRUNCATE TABLE t_area_dim
INSERT INTO t_area_dim(area_id)
       SELECT DISTINCT 
              [acct_area_id]
       FROM [dbo].[stg_p1]
       ORDER BY 1;

/*******************************************************************************************/

TRUNCATE TABLE t_branch_dim
INSERT INTO t_branch_dim
(branch_id, 
 branch_code, 
 branch_description, 
 address_id, 
 region_id, 
 area_id
)
       SELECT [branch_id], 
              [acct_branch_code], 
              [acct_branch_desc], 
              [acct_branch_add_id], 
              [acct_region_id], 
              [acct_area_id]
       FROM [dbo].[stg_p1]
       GROUP BY [branch_id], 
                [acct_branch_code], 
                [acct_branch_desc], 
                [acct_branch_add_id], 
                [acct_region_id], 
                [acct_area_id]
       ORDER BY 1, 
                4, 
                5, 
                6;

/*******************************************************************************************/

TRUNCATE TABLE t_customer_account_dim
INSERT INTO t_customer_account_dim
(cust_id, 
 acct_id, 
 cust_role_id
)
       SELECT [cust_id], 
              [acct_id], 
              [acct_cust_role_id]
       FROM [dbo].[stg_p1]
       GROUP BY [cust_id], 
                [acct_id], 
                [acct_cust_role_id]
       ORDER BY 1, 
                2, 
                3;

/*******************************************************************************************/

TRUNCATE TABLE dbo.t_customer_dim
INSERT INTO dbo.t_customer_dim
(cust_id, 
 cust_last_name, 
 cust_first_name, 
 cust_gender, 
 cust_birth_date, 
 cust_since_date, 
 cust_pri_branch_dist, 
 relationship_id, 
 address_id, 
 primary_branch_id
)
       SELECT [cust_id], 
              [last_name], 
              [first_name], 
              [gender], 
              [birth_date], 
              [cust_since_date], 
              [cust_pri_branch_dist], 
              [acct_rel_id], 
              [cust_add_id], 
              [pri_branch_id]
       FROM [dbo].[stg_p1]
       GROUP BY [cust_id], 
                [last_name], 
                [first_name], 
                [gender], 
                [birth_date], 
                [cust_since_date], 
                [cust_pri_branch_dist], 
                [acct_rel_id], 
                [cust_add_id], 
                [pri_branch_id]
       ORDER BY 1, 
                8, 
                9, 
                10;

/*******************************************************************************************/

TRUNCATE TABLE t_customer_role_dim
INSERT INTO t_customer_role_dim(cust_role_id)
       SELECT DISTINCT
              ([acct_cust_role_id])
       FROM [dbo].[stg_p1]
       ORDER BY 1;
UPDATE t_customer_role_dim
  SET 
      cust_role_description = CASE
                                  WHEN [cust_role_id] = '1'
                                  THEN 'Primary Customer'
                                  ELSE 'Secondary Customer'
                              END;

/*******************************************************************************************/

TRUNCATE TABLE t_product_dim
INSERT INTO t_product_dim(product_id)
       SELECT DISTINCT 
              [prod_id]
       FROM [dbo].[stg_p1]
	  ORDER BY 1;

/*******************************************************************************************/

TRUNCATE TABLE t_region_dim
INSERT INTO t_region_dim(region_id)
       SELECT DISTINCT 
              [acct_region_id]
       FROM [dbo].[stg_p1]
	  ORDER BY 1;

/*******************************************************************************************/
--KEYS

ALTER TABLE t_account_dim
ADD CONSTRAINT FK_t_account_dim_t_customer_dim
FOREIGN KEY( primary_cust_id ) REFERENCES t_customer_dim( cust_id );

ALTER TABLE t_account_dim
ADD CONSTRAINT FK_t_account_dim_t_branch_dim
FOREIGN KEY( branch_id ) REFERENCES t_branch_dim( branch_id );

ALTER TABLE t_account_dim
ADD CONSTRAINT FK_t_account_dim_t_product_dim
FOREIGN KEY( product_id ) REFERENCES t_product_dim( product_id );

/*******************************************************************************************/

ALTER TABLE t_account_fact
ADD CONSTRAINT FK_t_account_fact_t_account_dim
FOREIGN KEY( acct_id ) REFERENCES t_account_dim( acct_id );

/*******************************************************************************************/

ALTER TABLE t_branch_dim
ADD CONSTRAINT FK_t_branch_dim_t_address_dim
FOREIGN KEY( address_id ) REFERENCES t_address_dim( address_id );

ALTER TABLE t_branch_dim
ADD CONSTRAINT FK_t_branch_dim_t_region_dim
FOREIGN KEY( region_id ) REFERENCES t_region_dim( region_id );

ALTER TABLE t_branch_dim
ADD CONSTRAINT FK_t_branch_dim_t_area_dim
FOREIGN KEY( area_id ) REFERENCES t_area_dim( area_id );

/*******************************************************************************************/

ALTER TABLE t_customer_account_dim
ADD CONSTRAINT FK_t_customer_account_dim_t_customer_dim
FOREIGN KEY( cust_id ) REFERENCES t_customer_dim( cust_id );

ALTER TABLE t_customer_account_dim
ADD CONSTRAINT FK_t_customer_account_dim_t_account_dim
FOREIGN KEY( acct_id ) REFERENCES t_account_dim( acct_id );

ALTER TABLE t_customer_account_dim
ADD CONSTRAINT FK_t_customer_account_dim_t_customer_role_dim
FOREIGN KEY( cust_role_id ) REFERENCES t_customer_role_dim( cust_role_id );

/*******************************************************************************************/

ALTER TABLE t_customer_dim
ADD CONSTRAINT FK_t_customer_dim_t_address_dim
FOREIGN KEY( address_id ) REFERENCES t_address_dim( address_id );

ALTER TABLE t_customer_dim
ADD CONSTRAINT FK_t_customer_dim_t_branch_dim
FOREIGN KEY( primary_branch_id ) REFERENCES t_branch_dim( branch_id );
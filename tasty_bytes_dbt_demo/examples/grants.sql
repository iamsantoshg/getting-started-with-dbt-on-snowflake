-- ==========================================
-- 1. CREATE ROLE
-- ==========================================
CREATE ROLE IF NOT EXISTS dbt_project_role;

GRANT ROLE dbt_project_role TO USER "ashutosh.uniyal@jetstar.com" ;
GRANT ROLE dbt_project_role TO USER "venkatasantosh.govindarajul@jetstar.com" ;
GRANT ROLE dbt_project_role TO USER "chippy.sebastian@jetstar.com" ;
SHOW USERS;
-- ==========================================
-- 2. WAREHOUSE ACCESS
-- ==========================================
GRANT USAGE ON WAREHOUSE TASTY_BYTES_DBT_WH TO ROLE dbt_project_role;
GRANT OPERATE ON WAREHOUSE TASTY_BYTES_DBT_WH TO ROLE dbt_project_role;

-- ==========================================
-- 3. DATABASE & SCHEMA ACCESS (TARGET)
-- ==========================================
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;

GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT USAGE ON SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;

-- ==========================================
-- 4. CREATE PRIVILEGES (FOR DBT MODELS)
-- ==========================================
GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT CREATE STAGE ON SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT CREATE FILE FORMAT ON SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;

GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT CREATE STAGE ON SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT CREATE FILE FORMAT ON SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;

GRANT CREATE TABLE ON SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;
GRANT CREATE VIEW ON SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;
GRANT CREATE STAGE ON SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;
GRANT CREATE FILE FORMAT ON SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;
-- Optional but common for dbt operations
GRANT CREATE TEMPORARY TABLE ON SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT CREATE TEMPORARY TABLE ON SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT CREATE TEMPORARY TABLE ON SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;
-- ==========================================
-- 5. FUTURE OBJECT PRIVILEGES (TARGET)
-- ==========================================
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.dev TO ROLE dbt_project_role;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.integrations TO ROLE dbt_project_role;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN SCHEMA tasty_bytes_dbt_db.prod TO ROLE dbt_project_role;

-- ==========================================
-- 6. SOURCE DATA ACCESS (READ ONLY)
-- Replace <source_db> and <source_schema>
-- ==========================================
GRANT USAGE ON DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;

GRANT SELECT ON ALL TABLES IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;
GRANT SELECT ON FUTURE TABLES IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;

GRANT SELECT ON ALL VIEWS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;
GRANT SELECT ON FUTURE VIEWS IN DATABASE tasty_bytes_dbt_db TO ROLE dbt_project_role;

-- ==========================================
-- 7. DBT PROJECT PRIVILEGES
-- ==========================================

-- Allow creation of DBT project in schema
GRANT CREATE DBT PROJECT 
  ON SCHEMA tasty_bytes_dbt_db.dev 
  TO ROLE dbt_project_role;

-- Grant privileges on the project
-- NOTE: OWNERSHIP already includes all privileges
GRANT OWNERSHIP 
  ON DBT PROJECT tasty_bytes_dbt_project 
  TO ROLE dbt_project_role;




-- ==========================================
-- (Optional) If NOT using OWNERSHIP, use instead:
-- ==========================================
-- GRANT USAGE ON DBT PROJECT tasty_bytes_dbt_project TO ROLE dbt_project_role;
-- GRANT MONITOR ON DBT PROJECT tasty_bytes_dbt_project TO ROLE dbt_project_role;

-- ==========================================
-- 8. (OPTIONAL) GRANT ROLE TO USER
-- ==========================================
-- GRANT ROLE dbt_project_role TO USER <dbt_user>;

-- ==========================================
-- 9. (OPTIONAL) CHANGE OWNERSHIP for ALL objects created
-- ==========================================
-- Use Snowflake Scripting
BEGIN
    -- =========================
    -- Grant ownership on DEV schema
    -- =========================

    -- Tables in DEV
    FOR rec IN 
        (SELECT TABLE_NAME 
         FROM TASTY_BYTES_DBT_DB.INFORMATION_SCHEMA.TABLES
         WHERE TABLE_SCHEMA = 'DEV' 
           AND TABLE_TYPE = 'BASE TABLE')
    DO
        EXECUTE IMMEDIATE 
        'GRANT OWNERSHIP ON TABLE TASTY_BYTES_DBT_DB.DEV.' || rec.TABLE_NAME ||
        ' TO ROLE DBT_PROJECT_ROLE REVOKE CURRENT GRANTS';
    END FOR;

    -- Views in DEV
    FOR rec IN 
        (SELECT TABLE_NAME 
         FROM TASTY_BYTES_DBT_DB.INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_SCHEMA = 'DEV')
    DO
        EXECUTE IMMEDIATE 
        'GRANT OWNERSHIP ON VIEW TASTY_BYTES_DBT_DB.DEV.' || rec.TABLE_NAME ||
        ' TO ROLE DBT_PROJECT_ROLE REVOKE CURRENT GRANTS';
    END FOR;


    -- =========================
    -- Grant ownership on RAW schema
    -- =========================

    -- Tables in RAW
    FOR rec IN 
        (SELECT TABLE_NAME 
         FROM TASTY_BYTES_DBT_DB.INFORMATION_SCHEMA.TABLES
         WHERE TABLE_SCHEMA = 'RAW' 
           AND TABLE_TYPE = 'BASE TABLE')
    DO
        EXECUTE IMMEDIATE 
        'GRANT OWNERSHIP ON TABLE TASTY_BYTES_DBT_DB.RAW.' || rec.TABLE_NAME ||
        ' TO ROLE DBT_PROJECT_ROLE REVOKE CURRENT GRANTS';
    END FOR;

    -- Views in RAW
    FOR rec IN 
        (SELECT TABLE_NAME 
         FROM TASTY_BYTES_DBT_DB.INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_SCHEMA = 'RAW')
    DO
        EXECUTE IMMEDIATE 
        'GRANT OWNERSHIP ON VIEW TASTY_BYTES_DBT_DB.RAW.' || rec.TABLE_NAME ||
        ' TO ROLE DBT_PROJECT_ROLE REVOKE CURRENT GRANTS';
    END FOR;

END;

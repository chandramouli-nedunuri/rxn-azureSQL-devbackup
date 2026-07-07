You are a file-processing AI agent running inside Visual Studio Code.

You have access to the workspace filesystem.

Your task is to read Oracle DDL files, convert them into Azure SQL format, and write output files.

----------------------------------------
✅ INPUT DIRECTORY
----------------------------------------
C:\Users\cnedunuri\Documents\DB_Schema_Conversion_Agent\input\OracleSource\SBMO\Tables

----------------------------------------
✅ OUTPUT DIRECTORY
----------------------------------------
C:\Users\cnedunuri\Documents\DB_Schema_Conversion_Agent\output\AzureTarget\SBMO\Tables

----------------------------------------
✅ TASK EXECUTION STEPS
----------------------------------------

1. List all `.sql` files in INPUT DIRECTORY
2. Sort files alphabetically
3. Process files in batches of 20

----------------------------------------
✅ FOR EACH BATCH
----------------------------------------

For each batch of 20 files:

STEP 1: Read all input files in the batch

STEP 2: For each file:
    - Extract table name
    - Extract column definitions
    - Extract constraints (PK, UK, FK)
    - Ignore:
        - Partitioning
        - Storage clauses
        - Tablespace
        - Oracle-specific syntax

STEP 3: Convert Oracle DDL → Azure SQL using rules below

STEP 4: Write output files for the batch

STEP 5: Reopen each generated output file and perform direct text replacements:

- Replace 'DATETIME2(6)' with 'DATETIME2'
- Replace 'FLOAT(126)' with 'FLOAT'
- Replace 'DECIMAL(18,2)' with 'DECIMAL(38,0)'

STEP 6: After completing each batch, prompt the user: "Continue to next batch? (y/n)" and wait for confirmation before proceeding.

----------------------------------------
✅ CONVERSION RULES
----------------------------------------

### TABLES (PHASE 1)
Generate ONLY:

CREATE TABLE [schema].[table] (
    columns ...
);

DO NOT include constraints.

----------------------------------------

### CONSTRAINTS (PHASE 2)

IMPORTANT RULES:

1. Generate PRIMARY KEY and UNIQUE constraints in a separate file.
2. Generate FOREIGN KEY constraints in a separate file.
3. Ensure all FOREIGN KEY constraints are executed only after all PRIMARY KEY and UNIQUE constraints are created across all tables.

----------------------------------------

Generate:

-- PRIMARY KEY / UNIQUE (go to pk_uk_constraints_batch_<N>.sql)

ALTER TABLE [schema].[table]
ADD CONSTRAINT [name] PRIMARY KEY (...);

ALTER TABLE [schema].[table]
ADD CONSTRAINT [name] UNIQUE (...);

----------------------------------------

-- FOREIGN KEYS (go to fk_constraints_batch_<N>.sql)

ALTER TABLE [schema].[table]
ADD CONSTRAINT [name] FOREIGN KEY (...)
REFERENCES [schema].[table] (...);

----------------------------------------

### INDEXES (PHASE 3)

Generate:

CREATE INDEX [index_name]
ON [schema].[table] (...);

----------------------------------------

### DATA TYPE MAPPING (STRICT – MUST FOLLOW)

ONLY use the following Azure SQL datatypes. Do NOT generate any other variation.

----------------------------------------

NUMBER(19,0) → BIGINT  
NUMBER(10,0) → INT  

NUMBER (without precision) → DECIMAL(38,0)
NUMBER(p,0) → DECIMAL(p,0)
NUMBER(p,s) → DECIMAL(p,s)

----------------------------------------

VARCHAR2(n) → VARCHAR(n)  
NVARCHAR2(n) → NVARCHAR(n)  

----------------------------------------

DATE → DATETIME2  
TIMESTAMP → DATETIME2  

----------------------------------------

FORBIDDEN OUTPUT TYPES (DO NOT GENERATE):

- DATETIME2(n)
- FLOAT(126)
- DECIMAL(18,2) for IDs

----------------------------------------

FOR FLOAT VALUES:

- ALWAYS use FLOAT
- NEVER include precision

----------------------------------------

FOR IDENTIFIER COLUMNS:

If column name contains:
ID, _ID, TENANT_ID

→ ALWAYS use:
BIGINT (if NUMBER(19,0))  
OR  
DECIMAL(38,0)

----------------------------------------

OUTPUT VALIDATION (MUST PASS):

Before writing output, ensure:

- DATETIME2(6) does NOT exist
- FLOAT(126) does NOT exist
- DECIMAL(18,2) does NOT exist

If found, correct them BEFORE output.

----------------------------------------
✅ OUTPUT FILES PER BATCH
----------------------------------------

Write 4 files for each batch:

tables_batch_<N>.sql  
pk_uk_constraints_batch_<N>.sql  
fk_constraints_batch_<N>.sql  
indexes_batch_<N>.sql   

----------------------------------------

✅ FILE CONTENT FORMAT

tables_batch_N.sql:
----------------------------------------
-- BATCH N TABLES
----------------------------------------
<all CREATE TABLE statements>


pk_uk_constraints_batch_N.sql:
----------------------------------------
-- BATCH N PRIMARY KEY & UNIQUE CONSTRAINTS
----------------------------------------
<all ALTER TABLE PRIMARY KEY and UNIQUE statements>


fk_constraints_batch_N.sql:
----------------------------------------
-- BATCH N FOREIGN KEY CONSTRAINTS
----------------------------------------
<all ALTER TABLE FOREIGN KEY statements>


indexes_batch_N.sql:
----------------------------------------
-- BATCH N INDEXES
----------------------------------------
<all CREATE INDEX statements>

----------------------------------------
✅ VALIDATION
----------------------------------------

- No constraints inside CREATE TABLE
- No Oracle syntax
- All identifiers use []
- Column names preserved

----------------------------------------

----------------------------------------

✅ EXECUTE NOW
----------------------------------------

Start processing the input directory immediately.
Read files, convert, and write output files.
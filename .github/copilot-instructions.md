# Copilot Instructions for AI Coding Agents

## Project Overview
This codebase appears to be a Data Warehouse (DW) project for Inceptez, with SQL DDLs and architectural diagrams. The main focus is on staging and structuring data for analytics and reporting.

## Key Files & Structure
- `1_ddls_staging.sql`: Contains SQL DDL statements for staging tables. This is the starting point for understanding data structures and flows.
- `DWH_Inceptez.drawio`: Visual diagram of the DW architecture. Use this to understand major components, data flows, and service boundaries.
- `LICENSE`: Project licensing information.

## Essential Knowledge for AI Agents
- **Data Flow**: Data is ingested into staging tables as defined in `1_ddls_staging.sql`. The diagram in `DWH_Inceptez.drawio` provides the big-picture view of how data moves through the warehouse.
- **Architecture**: The project is structured around SQL-based data warehousing. There are no obvious application code or scripts; focus is on database schema and design.
- **Developer Workflow**:
  - To update or extend the warehouse, modify `1_ddls_staging.sql` and update the diagram as needed.
  - There are no build or test scripts present; changes are likely validated by running SQL directly against a database instance.
- **Conventions**:
  - Table and column naming conventions should match those in `1_ddls_staging.sql`.
  - Keep the diagram (`DWH_Inceptez.drawio`) in sync with schema changes.
- **Integration Points**:
  - External dependencies are not explicitly defined; integration is likely via database connections and ETL tools (not present in this repo).

## Actionable Guidance
- When adding new tables or modifying schema, update both the SQL file and the diagram.
- Document any new conventions or patterns in this file for future agents.
- If adding scripts or automation, place them in clearly named directories and update this guide.

## Example Pattern
```sql
-- Example: Staging table definition
CREATE TABLE staging_customer (
    customer_id INT,
    name VARCHAR(100),
    created_at DATE
);
```

## Feedback
If any section is unclear or incomplete, please provide feedback so this guide can be improved for future AI agents.

# PL/SQL Master Collection: Financial & Banking Systems

This repository is a comprehensive collection of database schemas, procedural logic, and business automation rules developed in **PL/SQL**. It covers multiple financial domains, showcasing robust backend engineering and data integrity practices.

## 📁 Project Portfolio

### 1. Insurance Management System
*   **Domain:** Insurance / Claims Processing
*   **Key Features:** Automated deductible (franquia) calculations, indemnity limits, and claim validation.
*   **Status:** ✅ Completed

### 2. Banking & Transactions (Coming Soon)
*   **Domain:** Retail Banking
*   **Target Logic:** Interest rate calculations, transaction auditing, and balance integrity checks.

### 3. Financial Reporting (Planned)
*   **Domain:** Corporate Finance
*   **Target Logic:** Tax automation and end-of-period reporting procedures.

---

## 🏗️ General Project Structure
Each project within this repository follows a standardized modular architecture:

*   **`/schema`**: Table definitions, constraints, and indexes.
*   **`/data`**: Seed scripts and mock data for testing.
*   **`/functions`**: Computational logic and reusable formulas.
*   **`/procedures`**: Complex business processes and workflow automation.
*   **`/triggers`**: Auditing, logging, and data consistency rules.
*   **`/tests`**: Systematic validation suites (Setup, Execution, Reversion).

---

## 🚀 How to Use (Standard Deployment)

To deploy any project from this collection, follow this execution order:

1. **Database Schema:** 
   Run `[Project-Folder]/schema/createTables.sql` to build the structure.
2. **Seed Data:** 
   Run `[Project-Folder]/data/insertData.sql` to populate test records.
3. **Core Logic:** 
   Run `[Project-Folder]/functions/all_functions.sql` then `[Project-Folder]/procedures/all_procedures.sql`.
4. **Validation:** 
   Execute the validation suite in order:
   * `tests/creation.sql`: Prepares the test environment.
   * `tests/execution-tests.sql`: Runs business logic tests.
   * `tests/reversion.sql`: Cleans up (Rollback/Cleanup).

---

## 🛠️ Tech Stack & Requirements
*   **Database:** Oracle Database (Compatible with 12c, 19c, 21c)
*   **Tooling:** Tested on [FreeSQL.com](https://freesql.com) and Oracle SQL Developer.
*   **Standard:** ANSI SQL & PL/SQL.

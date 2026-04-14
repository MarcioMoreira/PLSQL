# PLSQL
Procedural logic and database management for an Insurance System. Includes schema definitions, seed data, and PL/SQL functions/procedures for claims processing and business rule automation.

# Insurance Management System - PL/SQL

This repository contains the backend logic and database architecture for a comprehensive Insurance Management System.

## 🏛️ Project Structure
The project is organized to facilitate deployment and maintenance:
* **`/schema`**: DDL scripts for table structures (Clients, Policies, Claims).
* **`/data`**: DML scripts with seed data for testing environments.
* **`/functions`**: Reusable logic for calculations (deductibles, limits).
* **`/procedures`**: Business processes (validations, claim processing).
* **`/triggers`**: Automation and auditing rules.
* **`/tests`**: Manual test blocks (DECLARE/BEGIN/END) for validation.

## 🏛️ Database Schema
The project uses an Oracle-based schema consisting of:
* **CLIENTES:** Master record for policyholders.
* **APOLICES:** Insurance policy details and coverage values.
* **SINISTROS:** Claims tracking and status management.
* **PAGAMENTOS:** Financial records of approved claims.
* **HISTORICO_SINISTROS:** Aggregated data for risk analysis.

## ⚙️ Key Features
* **Automated Calculations:** Functions to determine deductibles (franquias) and indemnity limits based on claim types.
* **Validation Engine:** Procedures that verify policy status and coverage eligibility.
* **Data Integrity:** Robust exception handling and history tracking for claims.

## 🚀 How to Use

Follow this execution order to set up the environment correctly:

1. **Database Schema:** 
   Run `schema/createTables.sql` to create the tables and constraints.
2. **Seed Data:** 
   Run `data/insertData.sql` to populate the tables with testing data.
3. **Functions:** 
   Run `functions/all_functions.sql` to compile the calculation logic.
4. **Procedures:** 
   Run `procedures/all_procedures.sql` to compile the business rules.
5. **Triggers (Optional):** 
   Run `triggers/all_triggers.sql` for automated audit rules.
6. **Validation:** 
   Execute the validation suite in order:
   * `tests/01-criacao.sql`: Prepares the test environment.
   * `tests/02-execucao-testes.sql`: Runs the main business logic tests.
   * `tests/03-reversao.sql`: Cleans up test data (Rollback).

Tested on **Oracle Database / FreeSQL.com**.


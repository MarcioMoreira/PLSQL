# PLSQL
Procedural logic and database management for an Insurance System. Includes schema definitions, seed data, and PL/SQL functions/procedures for claims processing and business rule automation.

# Insurance Management System - PL/SQL

This repository contains the backend logic and database architecture for a comprehensive Insurance Management System.

## 🏛️ Project Structure
The project is organized to facilitate deployment and maintenance:
* **`/schema`**: DDL scripts for table structures (Clients, Policies, Claims).
* **`/data`**: DML scripts with seed data for testing environments.
* **`/logic`**: Procedural code including Functions and Procedures for business rules.

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
1. Execute the scripts in the `schema/` folder to build the tables.
2. Load the testing data from the `data/` folder.
3. Compile the PL/SQL objects in the `logic/` folder.

Tested on **Oracle Database / FreeSQL.com**.


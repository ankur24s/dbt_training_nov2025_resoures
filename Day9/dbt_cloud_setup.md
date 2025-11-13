# 🚀 End-to-End Setup: Migrating dbt-Core Project to dbt Cloud with 3 Environments

This document provides a complete step-by-step guide for migrating a dbt-core project from a local setup to **dbt Cloud**, integrating it with **GitHub**, and configuring three deployment environments (**Development**, **UAT**, and **Production**) in **Snowflake**.

---

## 🧭 Overview

This setup enables:
- Multi-branch Git workflow (`dev`, `uat`, `main`)
- Separate Snowflake databases for each environment
- dbt Cloud jobs for automation and CI/CD
- Safe promotion of code from `dev → uat → main`

---

## 🧰 Prerequisites

- A working **dbt-core** project in GitHub  
- Three Git branches:
  - `dev` → development work  
  - `uat` → testing & QA  
  - `main` → production release  
- A **Snowflake** account with databases:
  - `DEV`, `UAT`, `PROD`
- A user with **ACCOUNTADMIN** or equivalent privileges
- A dbt Cloud account: [https://cloud.getdbt.com](https://cloud.getdbt.com)

---

## 🧱 Local dbt-core Setup (Reference)

Example `profiles.yml`:

```yaml
dbt_training_nov_2025:
  outputs:
    dev:
      type: snowflake
      account: NFOEJFM-EU85002
      user: asahu
      password: Ankur@12345678
      role: TRANSFORM
      database: DEV
      schema: BRONZE_AIRBNB
      warehouse: COMPUTE_WH
      threads: 1
    uat:
      type: snowflake
      account: NFOEJFM-EU85002
      user: dbt
      password: dbtPassword123
      role: TRANSFORM
      database: UAT
      schema: BRONZE_AIRBNB
      warehouse: COMPUTE_WH
      threads: 1
    prod:
      type: snowflake
      account: NFOEJFM-EU85002
      user: dbt
      password: dbtPassword123
      role: TRANSFORM
      database: PROD
      schema: BRONZE_AIRBNB
      warehouse: COMPUTE_WH
      threads: 1
  target: "{{ env_var('DBT_TARGET', 'dev') }}"


## 🧱 Step 1: Connect GitHub to dbt Cloud

1. Sign in to [dbt Cloud](https://cloud.getdbt.com)
2. Create a **new project**
3. In **Project Settings → Repository**, choose:
   - **GitHub (OAuth)** connection type  
   - Authorize dbt Cloud GitHub App  
   - Select your repository  
   - Set **Default branch:** `main`
4. Save repository configuration

---

## ⚙️ Step 2: Create Snowflake Connection

1. Go to **Orchestration → Connections**
2. Click **+ New Connection**
3. Select **Snowflake**
4. Fill in Snowflake connection details:
   - Account
   - User
   - Password
   - Role
   - Warehouse
   - Database (for testing: `DEV`)
5. Click **Test Connection → Save**

---

## 🧩 Step 3: Create Development Environment

1. Go to **Orchestration → Environments → + New Environment**
2. Fill in:
   - **Name:** `Development`
   - **Type:** `Development`
   - **Default to custom branch:** ✅ Checked
   - **Custom branch:** `dev`
   - **Connection:** Select your Snowflake connection
   - **Database:** `DEV`
   - **Schema:** `BRONZE_AIRBNB`
   - **Warehouse:** `COMPUTE_WH`
3. **Test Connection → Save**

This environment powers the dbt Cloud IDE (**Studio**).

---

## 🧑‍💻 Step 4: Set Developer Credentials

Each user sets personal Snowflake credentials for Studio runs.

1. Go to **Settings → Profile → Credentials**
2. Click **Add Credentials**
3. Fill Snowflake details for `DEV` database
4. **Test Connection → Save**

---

## 💻 Step 5: Use dbt Cloud Studio for Development

1. Open **Studio** in the sidebar
2. Verify:
   - Repo files appear
   - Branch dropdown shows (`dev`, `uat`, `main`)
3. To create a new branch:
   - Click **New Branch** → `feature/add_new_model`
   - Base branch: `dev`
4. Edit models (`.sql`, `.yml`) and **Save**
5. Click **Commit → Commit to a new branch**
6. Add message → **Commit and Push**
7. Open GitHub → Create PR → Merge into `dev`

---

## 🧱 Step 6: Create UAT and Production Environments

| Environment | Type | Branch | Snowflake DB |
|--------------|------|---------|---------------|
| UAT | Deployment | `uat` | `UAT` |
| Production | Deployment | `main` | `PROD` |

Steps:
1. **Orchestration → Environments → + New Environment**
2. Fill in:
   - **Name:** `UAT` or `Production`
   - **Type:** `Deployment`
   - **Connection:** same Snowflake connection
   - **Database:** `UAT` or `PROD`
   - **Branch:** `uat` or `main`
3. **Test Connection → Save**

---

## 🧱 Step 7: Create Jobs for Each Environment

1. Go to **Orchestration → Jobs → + New Job**
2. Fill the details:

| Job | Environment | Commands | Schedule |
|------|--------------|-----------|-----------|
| DEV Run | Development | `dbt run`, `dbt test` | Manual |
| UAT Run | UAT | `dbt run`, `dbt test` | On merge to `uat` or nightly |
| PROD Run | Production | `dbt run`, `dbt test` | On merge to `main` or nightly |

### Optional Environment Variable:
Set `DBT_TARGET` in each environment:
| Variable | Value |
|-----------|--------|
| `DBT_TARGET` | `dev` / `uat` / `prod` |

---

## 🧪 Step 8: Verify & Test

1. Trigger each job manually
2. Check data in Snowflake:
   - `DEV` database for Development
   - `UAT` database for UAT
   - `PROD` database for Production

---

## 🔄 Step 9: CI/CD Workflow (Recommended)

| Action | Result |
|---------|--------|
| Create feature branch | `feature/...` |
| Merge PR → `dev` | Deploys to DEV |
| Merge `dev` → `uat` | Deploys to UAT |
| Merge `uat` → `main` | Deploys to PROD |

### GitHub Branch Protection:
1. Go to **GitHub → Repo → Settings → Branches**
2. Protect `main` and `uat`
3. Require:
   - PR approvals  
   - Passing dbt Cloud job checks

---

## 🧱 Step 10: Final Architecture

🧠 10. Final Architecture
GitHub Repository
 ├── dev branch   → dbt Cloud Development Env → Snowflake DEV
 ├── uat branch   → dbt Cloud UAT Env         → Snowflake UAT
 └── main branch  → dbt Cloud Production Env  → Snowflake PROD


Promotion flow:

(feature/*) → dev → uat → main


## ✅ Result

You now have:
- GitHub-integrated dbt Cloud project  
- Three-environment Snowflake deployment (Dev, UAT, Prod)  
- Jobs configured for automation  
- Safe, review-based promotion flow  

---

## 🏁 Summary of Key Steps

1. Connect GitHub repo to dbt Cloud  
2. Create Snowflake connection  
3. Set up Development environment  
4. Configure developer credentials  
5. Develop in Studio  
6. Create UAT & Production environments  
7. Add jobs for each environment  
8. Verify runs and outputs in Snowflake  
9. Enable branch protection and CI/CD  
10. Promote changes via PRs (`dev → uat → main`)

---

✨ **Enjoy automated dbt deployments with multi-environment CI/CD!**

🧩 Author & Notes

Setup validated for: dbt Cloud (Gen 2 UI) and Snowflake

Repository structure supports team development and CI/CD.

Recommended: keep credentials secure using service users for UAT/Prod.
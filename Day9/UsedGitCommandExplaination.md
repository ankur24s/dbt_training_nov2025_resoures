🧩 Picture the setup

Let’s say you have a dbt project on your local machine and a remote GitHub repo.

🖥️ Local machine (your VS Code)
[main] ← your local main branch
[uat]  ← your local uat branch
[dev]  ← your local dev branch

☁️ GitHub remote (called “origin”)
origin/main
origin/uat
origin/dev


Each of your local branches usually “tracks” a corresponding branch on GitHub.

🔄 How everything connects visually
        ┌──────────────────────────────┐
        │         GitHub (origin)      │
        │ ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
        │ │ origin/main │  │ origin/uat  │  │ origin/dev  │ │
        │ └──────┬──────┘  └──────┬──────┘  └──────┬──────┘ │
        └────────┼───────────────┼───────────────┼──────────┘
                 │               │               │
          git push/pull    git push/pull   git push/pull
                 │               │               │
        ┌────────▼────────┐  ┌───▼────────┐  ┌───▼────────┐
        │  main (local)   │  │ uat (local)│  │ dev (local)│
        └─────────────────┘  └────────────┘  └────────────┘

🧭 Typical flow
1️⃣ Start from main

You start on your main branch (production-ready code):

git checkout main

2️⃣ Create dev branch for your changes
git checkout -b dev


That creates a new local branch named dev (copied from main).

Then push it to GitHub:

git push origin dev


Now GitHub has a remote branch origin/dev.

3️⃣ Work locally on dev

You make and commit changes:

git add .
git commit -m "Build new dbt model for review"


Then push your commits up:

git push


Your local branch → remote origin/dev stays synced.

4️⃣ Test and merge into UAT

When ready to test, switch:

git checkout uat
git merge dev
git push


Now UAT gets your latest work.

5️⃣ Approve and merge to main

Once validated, you merge UAT into main:

git checkout main
git merge uat
git push


🎉 Now origin/main is production-ready.

⚙️ Git commands mapped visually
Command	What happens	Direction
git checkout branch	Switch local branch	—
git checkout -b branch	Create new local branch	—
git push origin branch	Upload local → GitHub	⬆️
git pull origin branch	Download GitHub → local	⬇️
git merge branch	Merge another local branch into current	🔄
🧠 Think of it like this:

Local branches = your working copies

Remote (origin/branch) = GitHub’s versions

Push = send updates to GitHub

Pull = fetch updates from GitHub

Checkout = switch which branch you’re “looking at” locally

⚡ Example in dbt context
Branch	DBT_TARGET	Purpose
dev	dev	sandbox development
uat	uat	QA / testing
main	prod	production deployment

You switch branches with:

git checkout dev
set DBT_TARGET=dev
dbt run


and push/pull updates accordingly.
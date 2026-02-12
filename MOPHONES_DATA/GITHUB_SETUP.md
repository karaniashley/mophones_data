# Using a Different GitHub Profile for MOPHONES_DATA

Use this guide to use a **separate GitHub account** for this repository (identity, remotes, and auth).

---

## 1. Set Git identity for this repo only

From the **MOPHONES_DATA** folder, run (replace with your other profile’s name and email):

```bash
cd /path/to/MOPHONES_DATA

git config user.name "Your Other GitHub Username"
git config user.email "your-other-account@example.com"
```

This only affects this repo, not your global Git config.

---

## 2. Use that account when talking to GitHub

### Option A: GitHub CLI (`gh`)

1. Log in with the other account:
   ```bash
   gh auth login
   ```
2. Choose the account and complete the browser login.
3. Create the repo and push from this folder:
   ```bash
   gh repo create MOPHONES_DATA --private --source=. --push
   ```
   Or use `--public` for a public repo.

### Option B: SSH with a different key

1. Generate a key for the other account (e.g. `~/.ssh/id_ed25519_mophones`):
   ```bash
   ssh-keygen -t ed25519 -C "your-other-account@example.com" -f ~/.ssh/id_ed25519_mophones
   ```
2. Add the public key to the **other** GitHub account: GitHub → Settings → SSH and GPG keys.
3. In `~/.ssh/config` add:
   ```
   Host github.com-mophones
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519_mophones
   ```
4. When adding the remote, use this host so Git uses that key:
   ```bash
   git remote add origin git@github.com-mophones:OTHER_USERNAME/MOPHONES_DATA.git
   ```

### Option C: HTTPS with a different user

Use the other account’s username (and password or personal access token when prompted):

```bash
git remote add origin https://github.com/OTHER_USERNAME/MOPHONES_DATA.git
```

---

## 3. Create the repo and branches (STAG, QA, PROD)

After the repo exists and `origin` points to the **other** profile’s repo:

```bash
# Create and push main (or your default branch)
git checkout -b main   # or: git branch -M main
git add .
git commit -m "Initial commit: MoPhones data and models"
git push -u origin main

# Create and push STAG, QA, PROD (same content as main)
git branch STAG && git push -u origin STAG
git branch QA   && git push -u origin QA
git branch PROD && git push -u origin PROD
```

---

## Quick checklist

- [ ] Set `user.name` and `user.email` in this repo (step 1).
- [ ] Use the other account: `gh auth login` **or** SSH config **or** HTTPS with other username.
- [ ] Create **MOPHONES_DATA** on GitHub under that account.
- [ ] Add `origin` pointing to that repo (step 2).
- [ ] Push `main`, then create and push **STAG**, **QA**, **PROD** (step 3).

If you tell me the **other profile’s username** (and whether you prefer SSH or HTTPS), I can give you exact commands with that username filled in.

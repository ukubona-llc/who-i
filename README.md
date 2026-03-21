Please visit `ukhona/docs` for context

Three commands in your terminal, that's it:

**Step 1 — Install Homebrew** (if you don't have it already)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
It will ask for your Mac password. Type it — nothing shows on screen, that's normal. Takes 2–3 minutes.

**Step 2 — Install Node.js**
```bash
brew install node
```

**Step 3 — Verify**
```bash
node --version
```
You should see something like `v22.x.x`. That's it — you're ready to run `deploy.sh`.

---

If Homebrew is already installed (you've used it before), skip straight to Step 2. You can check by running `brew --version` — if it prints a version number, Homebrew is there.
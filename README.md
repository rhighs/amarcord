# amarcord

> *"amarcord"* — Romagnolo dialect for "I remember." Fellini's film about memory. Also a tool that makes opencode remember what it learned.

---

Every coding session, your AI agent figures out something non-obvious. A workaround. A debugging technique. The real root cause of a cryptic error. Then the session ends and it forgets all of it.

**amarcord fixes this.** At the end of a session, run `/amarcord`. The agent reviews what it just did, extracts the valuable parts, and writes them as new command files. Next session, that knowledge is already there.

---

## How It Works

```
session ends
    ↓
/amarcord
    ↓
agent reviews: "what was non-obvious? what required trial and error?"
    ↓
writes ~/.config/opencode/commands/what-it-learned.md
    ↓
next session: that command file is available
```

The saved commands follow a simple format — problem, solution, why it works, gotchas. Enough to immediately apply the fix next time without re-investigating.

---

## Install

One command:

```bash
curl -fsSL https://raw.githubusercontent.com/rhighs/amarcord/main/install.sh | bash
```

Or manually:

```bash
mkdir -p ~/.config/opencode/commands
curl -fsSL https://raw.githubusercontent.com/rhighs/amarcord/main/opencode-command/amarcord.md \
  -o ~/.config/opencode/commands/amarcord.md
```

That's it. No config, no setup, no dependencies.

---

## Usage

At the end of any session where you debugged something, found a workaround, or had to figure out something non-obvious:

```
/amarcord
```

The agent will review the session and either:
- Extract 1–3 commands and tell you what it saved
- Say "nothing worth extracting" if the session was routine

### Manual hint

If you know something specific is worth saving:

```
/amarcord "the MPS dtype issue we just fixed"
```

---

## What Gets Saved

**Yes:**
- Solution required >10 min of investigation
- Error message was misleading (root cause wasn't obvious)
- Workaround found through trial and error
- Project-specific pattern not in any docs
- Tool integration knowledge the docs don't cover

**No:**
- Standard stuff you'd find in the official docs in 30 seconds
- One-off hacks with zero reuse potential
- Secrets, credentials, anything sensitive

---

## Where Saved Commands Live

```
~/.config/opencode/commands/
├── amarcord.md                    ← this tool
├── mps-dtype-mismatch.md          ← extracted from a PyTorch session
├── opencode-cwd-not-inherited.md  ← extracted from an opencode debugging session
└── ...                            ← everything amarcord has learned
```

Each file is just markdown. You can read them, edit them, delete them. They're yours.

---

## Example Extracted Command

After a session debugging PyTorch on Apple Silicon, amarcord might save:

```markdown
---
description: Fix device mismatch errors when using PyTorch on Apple Silicon MPS.
Use when you get "Expected all tensors to be on the same device."
---

# PyTorch MPS Device Mismatch

## Problem
RuntimeError: Expected all tensors to be on the same device

## Solution
Always pass device= explicitly when creating tensors:

    device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
    model = model.to(device)
    token = torch.tensor([[id]], device=device)   # ← explicit device

When loading checkpoints:
    ckpt = torch.load(path, map_location=device)  # ← not map_location="cpu"

## Why It Works
MPS and CPU tensors can't interact. map_location="cpu" silently loads to CPU
even when MPS is available.

## Watch Out For
numpy() requires .cpu() first: tensor.cpu().numpy()
```

---

## Credit

Port of [Claudeception](https://github.com/blader/Claudeception) by [@blader](https://github.com/blader), adapted for [opencode](https://opencode.ai).

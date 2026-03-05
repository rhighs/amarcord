---
description: Fix "Expected all tensors to be on the same device" or dtype mismatch errors when using PyTorch on Apple Silicon MPS. Use when model runs on CPU but tensors end up on MPS or vice versa.
---

# PyTorch MPS Device Mismatch

## Problem
`RuntimeError: Expected all tensors to be on the same device` or silent wrong results
when mixing CPU and MPS tensors on Apple Silicon.

## Solution

Always pass `device` explicitly when creating tensors, and move the model first:

```python
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
model = model.to(device)

# When creating new tensors mid-computation:
token = torch.tensor([[token_id]], device=device)   # explicit, not just torch.tensor([...])
state = [s.to(device) for s in state]               # move loaded state to correct device
```

When loading from checkpoint:
```python
ckpt = torch.load(path, map_location=device)        # map directly, not map_location="cpu"
```

## Why It Works
MPS tensors and CPU tensors cannot interact. `map_location=device` ensures the
checkpoint loads onto the right device immediately instead of defaulting to CPU.

## Watch Out For
- `numpy()` calls: MPS tensors must be moved to CPU first: `tensor.cpu().numpy()`
- `np.savez` / `np.load`: always `.cpu().numpy()` before saving state
- Mixed precision: MPS doesn't support float64 — use float32

import os
import subprocess

projects = [
    {"name": "defect_manage", "path": r"D:\Workspace\defect_manage"},
    {"name": "defect_manage2", "path": r"D:\Workspace\defect_manage2"},
    {"name": "n8n_defect_automation", "path": r"D:\Workspace\n8n-defect-automation"},
    {"name": "makeyourtoday", "path": r"D:\Workspace\makeyourtoday"},
    {"name": "trinity_room", "path": r"D:\Workspace\trinity_room"},
    {"name": "jina_writer", "path": r"D:\Workspace\jina_writer"},
    {"name": "ui_code_helper", "path": r"D:\Workspace\ui_code_helper"},
    {"name": "unit_test", "path": r"D:\Workspace\unit_test"},
    {"name": "project_control", "path": r"D:\Workspace\project_control"},
    {"name": "archive_store", "path": r"D:\Workspace\archive_store"},
    {"name": "personal_memo", "path": r"D:\Workspace\personalMemo"},
    {"name": "token_tracker", "path": r"D:\Workspace\token_tracker"},
    {"name": "cinetube", "path": r"D:\Workspace\cinetube"},
    {"name": "bloom", "path": r"D:\workspace\bloom_universe"},
    {"name": "jian_soul", "path": r"D:\Bloom"},
]

results = []

for p in projects:
    path = p["path"]
    name = p["name"]
    if not os.path.exists(path):
        results.append({"name": name, "status": "skipped", "reason": "Path does not exist"})
        continue
    
    # Check if git repo
    if not os.path.exists(os.path.join(path, ".git")):
        results.append({"name": name, "status": "skipped", "reason": "Not a Git repository"})
        continue
        
    try:
        # Check if dirty
        status_proc = subprocess.run(["git", "status", "--porcelain"], cwd=path, capture_output=True, text=True, check=True)
        is_dirty = len(status_proc.stdout.strip()) > 0
        
        # Fetch remote
        subprocess.run(["git", "fetch"], cwd=path, capture_output=True, text=True, timeout=15)
        
        # Compare local vs remote
        rev_proc = subprocess.run(["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=path, capture_output=True, text=True, check=True)
        branch = rev_proc.stdout.strip()
        
        # Check tracking branch
        tracking_proc = subprocess.run(["git", "rev-parse", "--abbrev-ref", "@{u}"], cwd=path, capture_output=True, text=True)
        if tracking_proc.returncode != 0:
            results.append({"name": name, "status": "skipped", "reason": "No upstream tracking branch"})
            continue
            
        tracking = tracking_proc.stdout.strip()
        
        # Get diff status
        diff_proc = subprocess.run(["git", "rev-list", "--left-right", f"{branch}...{tracking}"], cwd=path, capture_output=True, text=True)
        diffs = diff_proc.stdout.strip().split('\n') if diff_proc.stdout.strip() else []
        
        behind = 0
        ahead = 0
        for d in diffs:
            if d.startswith('>'):
                behind += 1
            elif d.startswith('<'):
                ahead += 1
                
        if behind > 0 and ahead == 0 and not is_dirty:
            # Can fast-forward
            merge_proc = subprocess.run(["git", "merge", "--ff-only"], cwd=path, capture_output=True, text=True)
            if merge_proc.returncode == 0:
                results.append({"name": name, "status": "updated", "reason": f"Fast-forwarded {behind} commits"})
            else:
                results.append({"name": name, "status": "skipped", "reason": f"Behind {behind} commits, fast-forward failed"})
        elif behind > 0 and (ahead > 0 or is_dirty):
            results.append({"name": name, "status": "skipped", "reason": f"Behind {behind} commits but local is dirty or ahead ({ahead} commits)"})
        elif behind == 0 and ahead > 0:
            results.append({"name": name, "status": "current", "reason": f"Local is ahead by {ahead} commits"})
        elif is_dirty:
            results.append({"name": name, "status": "current", "reason": "Already current but local is dirty"})
        else:
            results.append({"name": name, "status": "current", "reason": "Already current"})
            
    except Exception as e:
        results.append({"name": name, "status": "error", "reason": str(e)})

import json
print(json.dumps(results, indent=2, ensure_ascii=False))

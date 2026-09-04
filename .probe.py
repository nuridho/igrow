import sys, tempfile, json, shutil
from pathlib import Path
sys.path.insert(0, 'hermes-home/igrow/project-skills/scripts')
import confidence_calc as cc

tmp = Path(tempfile.mkdtemp(prefix="probe"))
cc.TESTS = tmp
cc.CACHE = tmp / "_index.json"
(tmp / "linux").mkdir(exist_ok=True)
(tmp / "linux" / "aaa-iowait-2026-08-01.md").write_text(
    "---\ntopic: iowait\nscore: 1\ndate: 2026-08-01\nlast_increment_date: 2026-08-01\n---\n", encoding="utf-8")
(tmp / "linux" / "zzz-iowait-2026-08-05.md").write_text(
    "---\ntopic: iowait\nscore: 4\ndate: 2026-08-05\nlast_increment_date: 2026-08-05\n---\n", encoding="utf-8")
(tmp / "linux" / "load-average-2026-08-06.md").write_text(
    "---\ntopic: load average\nscore: 3\ndate: 2026-08-06\nlast_increment_date: 2026-08-06\n---\n", encoding="utf-8")
print("scan hasil:", json.dumps(cc.scan(**{}), indent=1))
shutil.rmtree(tmp, ignore_errors=True)

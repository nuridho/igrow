import sys, tempfile, json, shutil
from pathlib import Path
sys.path.insert(0, 'hermes-home/igrow/project-skills/scripts')
import confidence_calc as cc

tmp = Path(tempfile.mkdtemp(prefix="probe2"))
cc.TESTS = tmp
cc.CACHE = tmp / "_index.json"
(tmp / "linux").mkdir(exist_ok=True)
(tmp / "linux" / "iowait-2026-08-05.md").write_text(
    "---\ntopic: iowait\nscore: 4\ndate: 2026-08-05\nlast_increment_date: 2026-08-05\n---\n", encoding="utf-8")
# cache kosong '{}' seperti yang ke-commit sekarang
cc.CACHE.write_text("{}", encoding="utf-8")
print("load() dgn cache '{}' padahal ada 1 file test:", json.dumps(cc.load(**{})))
sys.argv = ["x", "--topic", "iowait", "--result", "correct", "--date", "2026-08-06"]
cc.main(**{})
print("cache setelah run:", cc.CACHE.read_text(encoding="utf-8"))
shutil.rmtree(tmp, ignore_errors=True)

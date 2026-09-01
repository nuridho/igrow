#!/usr/bin/env python
"""Confidence score iGROW UC2/UC6. Satu angka running per topik.
+1 benar, -1 salah (floor 0), max +1/topik/hari, mastered >= 5.
State: igrow/wiki/tests/** frontmatter. Cache: tests/_index.json (turunan, aman dihapus).

Usage: confidence_calc.py --topic iowait --result correct|wrong --date YYYY-MM-DD
Output: baris frontmatter siap tempel (topic, score, mastered, last_increment_date).
"""
import argparse, json, re, sys
from pathlib import Path

MASTERED = 5
TESTS = Path(__file__).resolve().parents[2] / "wiki" / "tests"
CACHE = TESTS / "_index.json"


def scan():
    state = {}
    if not TESTS.is_dir():
        return state
    for f in TESTS.rglob("*.md"):
        if f.name.startswith("_"):
            continue
        head = f.read_text(encoding="utf-8", errors="replace")[:2000]
        m = re.search(r"^topic:\s*(\S+)", head, re.M)
        s = re.search(r"^score:\s*(\d+)", head, re.M)
        d = re.search(r"^date:\s*(\d{4}-\d{2}-\d{2})", head, re.M)
        li = re.search(r"^last_increment_date:\s*(\d{4}-\d{2}-\d{2})", head, re.M)
        if m:
            state[m.group(1)] = {
                "score": int(s.group(1)) if s else 0,
                "last_increment_date": li.group(1) if li else (d.group(1) if d else None),
            }
    return state


def load():
    if CACHE.is_file():
        try:
            return json.loads(CACHE.read_text(encoding="utf-8"))
        except Exception:
            pass  # cache busuk -> rebuild dari markdown (sumber kebenaran)
    st = scan()
    TESTS.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(json.dumps(st, indent=1), encoding="utf-8")
    return st


def dump_all(index: dict):
    rows = [{"topic": t, "score": e["score"], "last_increment_date": e["last_increment_date"]}
            for t, e in sorted(index.items())]
    print(json.dumps(rows, ensure_ascii=False))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--topic")
    ap.add_argument("--result", choices=["correct", "wrong"])
    ap.add_argument("--date")
    ap.add_argument("--all", action="store_true", help="dump semua topik (untuk career review)")
    args = ap.parse_args()

    index = load()
    if args.all:
        dump_all(index)
        return
    if not (args.topic and args.result and args.date):
        ap.error("--topic/--result/--date wajib (atau pakai --all)")
    e = index.get(args.topic, {"score": 0, "last_increment_date": None})

    if args.result == "correct":
        if e["last_increment_date"] == args.date:
            pass  # max +1/topik/hari — sudah naik hari ini, skip
        else:
            e["score"] += 1
            e["last_increment_date"] = args.date
    else:
        e["score"] = max(0, e["score"] - 1)

    index[args.topic] = e
    CACHE.write_text(json.dumps(index, indent=1), encoding="utf-8")

    print(f"topic: {args.topic}")
    print(f"score: {e['score']}")
    print(f"mastered: {str(e['score'] >= MASTERED).lower()}")
    print(f"last_increment_date: {e['last_increment_date']}")


def _demo():
    import tempfile, shutil, contextlib, io
    global TESTS, CACHE
    orig_t, orig_c = TESTS, CACHE
    tmp = Path(tempfile.mkdtemp())
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            TESTS = tmp
            CACHE = tmp / "_index.json"
            (tmp / "linux").mkdir()
            (tmp / "linux" / "iowait-2026-08-01.md").write_text(
                "---\ntopic: iowait\nscore: 4\ndate: 2026-08-01\nlast_increment_date: 2026-08-01\n---\n",
                encoding="utf-8")
            assert load()["iowait"]["score"] == 4
            sys.argv = ["x", "--topic", "iowait", "--result", "correct", "--date", "2026-08-01"]
            main()
            assert load()["iowait"]["score"] == 4, "max +1/hari dilanggar"
            sys.argv = ["x", "--topic", "iowait", "--result", "correct", "--date", "2026-08-02"]
            main()
            assert load()["iowait"]["score"] == 5, "harusnya mastered"
            sys.argv = ["x", "--topic", "iowait", "--result", "wrong", "--date", "2026-08-03"]
            main()
            assert load()["iowait"]["score"] == 4
            for i in range(6):
                sys.argv = ["x", "--topic", "iowait", "--result", "wrong", "--date", f"2026-08-1{i}"]
                main()
            assert load()["iowait"]["score"] == 0, "floor 0 dilanggar"
            sys.argv = ["x", "--all"]
            with contextlib.redirect_stdout(io.StringIO()) as buf:
                main()
            rows = json.loads(buf.getvalue())
            assert rows == [{"topic": "iowait", "score": 0,
                             "last_increment_date": "2026-08-02"}]
        print("demo OK")
    finally:
        TESTS, CACHE = orig_t, orig_c
        shutil.rmtree(tmp)


if __name__ == "__main__":
    main()

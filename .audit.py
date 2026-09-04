import re, os, sys

root = os.path.dirname(os.path.abspath(__file__))
files = []
for dp, dn, fn in os.walk(root):
    if '.git' in dp or '__pycache__' in dp:
        continue
    for f in fn:
        if f.endswith(('.md', '.py', '.sh', '.html', '.json')):
            files.append(os.path.join(dp, f))

txt = {}
for f in files:
    fh = open(f, encoding='utf-8', errors='replace')
    txt[f] = fh.read(50_000_000)
    fh.close

pats = sys.argv[1:]
for p in pats:
    print("=== " + p)
    for f in sorted(txt):
        hits = [i + 1 for i, l in enumerate(txt[f].split("\n")) if re.search(p, l)]
        if hits:
            print("    %s %s n=%d" % (os.path.relpath(f, root), hits[:15], len(hits)))

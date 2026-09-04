import re, difflib

def rd(p):
    fh = open(p, encoding='utf-8')
    t = fh.read(50000000)
    return t.replace('\r\n', '\n').strip(' \n')

A = rd('hermes-home/AGENTS.md')
for p in ('iGROW_FINAL.md', 'build.md'):
    t = rd(p)
    m = re.search(r'```markdown\n(# iGROW — Aturan Inti.*?screenshot yang belum di-redact\.)\n```', t, re.S)
    b = m.group(1).strip(' \n') if m else None
    print(p, 'FOUND' if b else 'NOT-FOUND', '| identik:', b == A)
    if b and b != A:
        for l in difflib.unified_diff(A.split('\n'), b.split('\n'), 'AGENTS.md', p, lineterm='', n=1):
            print('   ', l)

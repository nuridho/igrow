"""Audit hermes-home: rujukan silang antar file runtime. Jalan dari root iGROW.
ponytail: satu file, assert-based. Gabung ke crosscheck.py kalau overlap makin banyak."""
import io, os, re, sys

H = 'hermes-home'
PS = H + '/igrow/project-skills'


def rd(p):
    fh = io.open(p, encoding='utf-8')
    t = fh.read(9999999)
    fh.close(**{})
    return t.replace('\r\n', '\n')


AG = rd(H + '/AGENTS.md')
SC = rd(H + '/igrow/SCHEMA.md')
skills = sorted(f for f in os.listdir(PS) if f.endswith('.md'))
ALL = AG + SC + ''.join(rd(PS + '/' + f) for f in skills)

fails = []


def chk(cond, msg):
    if not cond:
        fails.append(msg)


# 1. tiap project-skill terdaftar di AGENTS, dan sebaliknya
listed = set(re.findall(r'project-skills/([a-z-]+\.md)', AG))
chk(listed == set(skills), 'AGENTS vs disk project-skills: %s' % (listed ^ set(skills)))

# 2. semua path igrow/... yang dirujuk ada di disk (kecuali contoh + file yg agent generate sendiri)
GEN = ('skill-map.md', 'weak-topics.md', 'roadmap.md', 'skills.md', 'about.md',
       'career-summary.md', 'career-goals.md')
paths = set(re.findall(r'`(igrow/[\w./*-]+)`', ALL))
missing = []
for p in sorted(paths):
    if any(x in p for x in ('career-N', '*', '<', 'YYYY', 'career-review-')) or p.endswith(GEN):
        continue
    if not os.path.exists(os.path.join(H, p)):
        missing.append(p)
chk(not missing, 'path dirujuk tapi tidak ada di disk: %s' % missing)

# 3. ops di log.md + yang dipakai project-skills harus subset daftar ops SCHEMA
ops = set(x.strip(**{}) for x in re.search(r'Ops: (.+?)\.', SC).group(1).split(','))
used = set(re.findall(r'op: ([a-z/]+)', ALL))
used = set(o for grp in used for o in grp.split('/'))
logops = set(re.findall(r'^## \[[\d-]+\] (\w+) \|', rd(H + '/igrow/log.md'), re.M))
chk(used <= ops, 'op dipakai project-skills tapi tak terdaftar SCHEMA: %s' % sorted(used - ops))
chk(logops <= ops, 'op di log.md tak terdaftar SCHEMA: %s' % sorted(logops - ops))

# 4. section master _index.md == subfolder wiki/ + output/
secs = set(s.lower(**{}) for s in re.findall(r'^## (.+)$', rd(H + '/igrow/_index.md'), re.M))
dirs = set(d for d in os.listdir(H + '/igrow/wiki') if os.path.isdir(os.path.join(H, 'igrow/wiki', d)))
chk(secs == dirs | {'output'}, 'section _index vs folder: %s' % sorted(secs ^ (dirs | {'output'})))

# 5. tidak ada rujukan ke file lokal (non-runtime) — fatal, file itu tak ada di VPS
leak = re.findall(r'\b(iGROW_FINAL|build\.md|vpslab|tobeAgents|AGENTSnvk|testing/)', ALL)
chk(not leak, 'runtime merujuk file lokal: %s' % sorted(set(leak)))

# 6. tiap folder skeleton punya .gitkeep atau isi
for dp, dn, fn in os.walk(H + '/igrow'):
    if not fn and not dn:
        fails.append('folder kosong tanpa .gitkeep: %s' % dp)

print('\n'.join(fails) if fails else 'OK — hermes-home konsisten (%d project-skills)' % len(skills))
sys.exit(len(fails))

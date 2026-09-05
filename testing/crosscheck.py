"""Crosscheck FIN tree vs aturan runtime hermes-home. Jalankan dari root iGROW.
ponytail: regex-based, cukup buat 5 aturan yg pernah drift (W9-W14). Tambah aturan kalau ada drift baru."""
import io, re, sys

def rd(p):
    fh = io.open(p, encoding='utf-8')
    t = fh.read(9999999)
    fh.close(**{})
    return t

FIN = rd('iGROW_FINAL.md')
SCHEMA = rd('hermes-home/igrow/SCHEMA.md')
AGENTS = rd('hermes-home/AGENTS.md')
CAP = rd('hermes-home/igrow/project-skills/capture-experience.md')
TAX = re.search(r'## Tag taxonomy.*?\n(.+)', SCHEMA).group(1)
TAGS = [t.strip(**{}) for t in TAX.split(',')]

fails = []

def chk(cond, msg):
    if not cond:
        fails.append(msg)

# W9 knowledge/ FLAT — tree FIN tidak boleh punya subfolder topik di bawah knowledge/
tree = re.search(r'```text\n(igrow-hermes/hermes-home/.*?)\n```', FIN, re.S).group(1)
kn = re.search(r'(knowledge/.*?)lessons-learned', tree, re.S).group(1)
subs = [s for s in re.findall(r'([a-z-]+)/', kn) if s != 'knowledge']
chk(subs == ['incidents'], 'W9: subfolder di knowledge/ selain incidents/: %s' % subs)
chk('JANGAN' in kn or 'FLAT' in kn, 'W9: tree tidak menyebut aturan FLAT')
chk('JANGAN bikin subfolder per topik' in CAP, 'W9: capture-experience kehilangan aturan FLAT')

# W10 .processed/ mati total
chk('.processed' not in FIN, 'W10: .processed masih ada di FIN')
chk('.processed' not in SCHEMA + AGENTS, 'W10: .processed masih ada di runtime')

# W11 subfolder tests/ harus tag taxonomy — UC2 ditunda ke Phase 5, tree FIN ditandai
chk('PHASE 5' in re.search(r'tests/.*', tree).group(0), 'W11: tree tests/ belum ditandai Phase 5')
chk(not [p for p in ('test-me', 'confidence_calc', 'wiki/tests', 'source_type', 'mastered')
         if p in SCHEMA + AGENTS + CAP + rd('hermes-home/igrow/project-skills/mentor.md')
         + rd('hermes-home/igrow/project-skills/career-review.md')
         + rd('hermes-home/igrow/project-skills/lint.md')],
    'W11/UC2: hermes-home masih ada jejak UC2')

# W12 raw/assets/ ada di tree
chk('assets/' in tree, 'W12: raw/assets/ tidak ada di tree FIN')

# W13 lint.md di tabel + tree FIN; project-skills FIN (minus yg ditandai Phase 5) == AGENTS
chk(FIN.count('lint.md') >= 2, 'W13: lint.md belum di tabel + tree FIN')
ps_blk = re.search(r'project-skills/.*?\n(.*?)scripts/', tree, re.S).group(1)
ps_fin = set(re.findall(r'([a-z-]+\.md)', re.sub(r'.*PHASE 5.*', '', ps_blk)))
ps_ag = set(re.findall(r'project-skills/([a-z-]+\.md)', AGENTS))
chk(ps_fin == ps_ag, 'W13: project-skills FIN vs AGENTS beda: %s' % (ps_fin ^ ps_ag))

# W14 type: data masuk enum, dan tidak ada `date:` di contoh data file
enum = re.search(r'^type: (.+)$', SCHEMA, re.M).group(1)
chk('data' in [x.strip(**{}) for x in enum.split('|')], 'W14: type data belum di enum SCHEMA')
chk('test' not in [x.strip(**{}) for x in enum.split('|')], 'W14/UC2: type test masih di enum')
chk(not re.search(r'type: data\ndate:', FIN), 'W14: contoh data file FIN masih pakai date:')

# W15 sources: selalu prefix igrow/raw/
RUNTIME = SCHEMA + AGENTS + CAP + rd('hermes-home/igrow/project-skills/study.md')
bad_src = re.findall(r'sources: \[(?!\]|igrow/)[^\]]+\]', RUNTIME + FIN)
chk(not bad_src, 'W15: sources: tanpa prefix igrow/: %s' % bad_src)

# W16 jumlah field wajib konsisten: SCHEMA == lint.md == check.sh
LINT = rd('hermes-home/igrow/project-skills/lint.md')
CHECK = rd('testing/check.sh')
fm = re.search(r'```yaml\n---\n(.*?)\n---\n```', SCHEMA, re.S).group(1)
req = [l.split(':')[0] for l in fm.split('\n') if ':' in l and 'contradictions' not in l]
chk(('%d field' % len(req)) in LINT, 'W16: lint.md tidak bilang %d field' % len(req))
cs = re.search(r'for field in (.+?); do', CHECK).group(1).split(**{})
chk(set(cs) == set(req), 'W16: check.sh field beda dari SCHEMA: %s' % (set(cs) ^ set(req)))

# W17 UC5 tidak boleh pakai field pra-nvk
chk('What I learned' not in FIN, 'W17: FIN masih pakai field pra-nvk (What I learned)')

# W18 satu jawaban soal confidence_calc: tidak ada lagi "bukan script terpisah" / TODO
chk('bukan script terpisah' not in FIN, 'W18: FIN masih bilang counting-bukan-script')
chk('confidence_calc.py` → hitung otomatis' not in FIN, 'W18: TODO confidence_calc masih ada')

# W19 blok verbatim: AGENTS.md byte-identik di FIN & build.md (test-me: UC2 ditunda, blok FIN = rancangan)
BUILD = rd('build.md')
want = AGENTS.replace('\r\n', '\n').strip(' \n')
for tgt, txt in [('FIN', FIN), ('build.md', BUILD)]:
    m = re.search(r'```markdown\n(# iGROW — Aturan Inti.*?screenshot yang belum di-redact\.)\n```',
                  txt.replace('\r\n', '\n'), re.S)
    chk(m and m.group(1).strip(' \n') == want, 'W19: blok AGENTS.md di %s tidak identik' % tgt)

# W20 master _index.md section = folder wiki/ + output/
IDX = rd('hermes-home/igrow/_index.md')
secs = set(s.lower(**{}) for s in re.findall(r'^## (.+)$', IDX, re.M))
chk(secs == {'careers', 'self-development', 'roadmap', 'profile', 'output'},
    'W20: section master _index.md: %s' % sorted(secs))

print('\n'.join(fails) if fails else 'OK — W9-W20 konsisten')
sys.exit(len(fails))

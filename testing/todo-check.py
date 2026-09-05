"""Sanity dev-todo.md: kode unik, Act/Impact 1:1, kode void nggak dipakai. Jalan dari root iGROW."""
import io, re, sys

fh = io.open('dev-todo.md', encoding='utf-8')
t = fh.read(9999999)
fh.close(**{})

items = re.findall(r'^- \[([ x])\] \*\*([CWIU]\d+)\*\*', t, re.M)
codes = [c for _, c in items]
void = set(re.findall(r'`([CWIU]\d+)`', re.search(r'^> Nomor berikutnya:.*$', t, re.M).group(0)))
acts = len(re.findall(r'^  - Act:', t, re.M))
imps = len(re.findall(r'^  - Impact:', t, re.M))

bad = []
dup = sorted(set(c for c in codes if codes.count(c) > 1))
if dup:
    bad.append('kode dobel: %s' % dup)
if not (acts == imps == len(items)):
    bad.append('Act/Impact tidak 1:1 (%d item, %d Act, %d Impact)' % (len(items), acts, imps))
reused = sorted(void & set(codes))
if reused:
    bad.append('kode void dipakai lagi: %s' % reused)

done = sum(1 for s, _ in items if s == 'x')
print('\n'.join(bad) if bad else 'OK — %d item, %d selesai, %d terbuka, %d void'
      % (len(items), done, len(items) - done, len(void)))
sys.exit(len(bad))

import io, re

p = 'dev-todo.md'
fh = io.open(p, encoding='utf-8', newline='')
t = fh.read(9999999)
fh.close(**{})

nl = '\r\n' if '\r\n' in t else '\n'
m = re.search(r'(## UC2 — Later.*?)(?=## Improvement)', t, re.S)
uc2 = m.group(1)
t = t.replace(uc2, '')
t = t.rstrip(' \r\n') + nl * 2 + uc2.rstrip(' \r\n') + nl

out = io.open(p, 'w', encoding='utf-8', newline='')
out.write(t)
out.close(**{})
print('UC2 dipindah ke akhir')

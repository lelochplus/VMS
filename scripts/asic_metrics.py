# In số liệu chính từ metrics.json của các lần chạy LibreLane. Dùng: python3 scripts/asic_metrics.py dma nodma
import json, re, sys
pat = re.compile(r'die__area|instance__area|instance__count__stdcell|sequential|power__total|setup__ws|hold__ws|slew|fanout')
for tag in sys.argv[1:]:
    m = json.load(open(f'openlane/runs/{tag}/final/metrics.json'))
    print('==', tag)
    for k in sorted(m):
        if pat.search(k) and 'corner' not in k: print(f'  {k} = {m[k]}')

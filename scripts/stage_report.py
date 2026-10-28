#!/usr/bin/env python3
# Báo cáo một giai đoạn của luồng LibreLane chạy theo từng bước.
# Dùng: python3 scripts/stage_report.py openlane/runs/step "2. Floorplan va PDN"
# In các chỉ số mà những step vừa chạy đã thêm/đổi (so với lần báo cáo trước) và lưu vào docs/flow/.
import glob, json, os, re, sys

run, stage = sys.argv[1], sys.argv[2]
KEEP = re.compile(
    r'instance__count|instance__area|die__area|core__area|utilization|'
    r'timing__(setup|hold)__(ws|tns|wns)|clock__skew|max_(slew|cap|fanout)_violation__count|'
    r'power__|wirelength|route__drc_errors|antenna|lvs__|drc__|magic__|klayout__|ir__drop|'
    r'latch|unmapped|check_error|disconnected|xor_difference', re.I)
CORNERS = ('nom_tt_025C_1v80', 'max_ss_100C_1v60')   # corner điển hình và corner xấu nhất
# Kiểm tra tự động: (mẫu tên chỉ số, nội dung, điều kiện đạt); chỉ áp cho chỉ số giai đoạn này tạo ra
RULES = [
    (r'latch__count$', 'Không có latch', lambda v: v == 0),
    (r'unmapped__count$', 'Không có cell chưa ánh xạ', lambda v: v == 0),
    (r'^timing__setup__ws$', 'Setup slack ≥ 0 ở corner xấu nhất', lambda v: v >= 0),
    (r'^timing__hold__ws$', 'Hold slack ≥ 0 ở corner xấu nhất', lambda v: v >= 0),
    (r'drc_errors?(__count)?$', 'Không có lỗi DRC', lambda v: v == 0),
    (r'lvs.*error.*count$', 'Không có lỗi LVS', lambda v: v == 0),
    (r'antenna.*(violat|net)', 'Không có vi phạm antenna', lambda v: v == 0),
    (r'^design__max_slew_violation__count$', 'Không vi phạm max slew (ràng buộc 0,75 ns)', lambda v: v == 0),
    (r'^design__max_cap_violation__count$', 'Không vi phạm max capacitance', lambda v: v == 0),
    (r'^design__max_fanout_violation__count$', 'Không vi phạm max fanout', lambda v: v == 0),
    (r'disconnected.*count$', 'Không có chân bị hở', lambda v: v == 0),
    (r'xor_difference__count$', 'GDS của Magic và KLayout trùng nhau', lambda v: v == 0),
]


def wanted(k):
    if '__iter:' in k or not KEEP.search(k):
        return False
    return '__corner:' not in k or any(c in k for c in CORNERS)


def fmt(v):
    if isinstance(v, float):
        return f'{v:.4g}' if abs(v) < 1e4 else f'{v:,.0f}'.replace(',', '.')
    return str(v)


num = lambda d: int(os.path.basename(d).split('-')[0])
steps = sorted((d for d in glob.glob(os.path.join(run, '[0-9]*-*')) if os.path.isfile(os.path.join(d, 'state_out.json'))), key=num)
if not steps:
    sys.exit(f'chua co step nao xong trong {run}')
mark = os.path.join(run, '.stage_report_last')
last = int(open(mark).read()) if os.path.exists(mark) else 0

prev, rows, files, final = {}, [], [], {}
for d in steps:
    m = json.load(open(os.path.join(d, 'state_out.json'))).get('metrics', {})
    if num(d) > last:
        name = os.path.basename(d)
        for k in sorted(m):
            if wanted(k) and prev.get(k) != m[k]:
                rows.append((name, k, fmt(m[k]))); final[k] = m[k]
        files += [os.path.relpath(f, run) for f in sorted(glob.glob(os.path.join(d, '*.rpt')) + glob.glob(os.path.join(d, 'reports', '*')))]
    prev = m

checks = []
for pat, text, ok in RULES:
    for k, v in final.items():
        if re.search(pat, k) and isinstance(v, (int, float)):
            checks.append(('ĐẠT' if ok(v) else 'KHÔNG ĐẠT', text, k, fmt(v)))

new = [os.path.basename(d) for d in steps if num(d) > last]
lines = [f'# {stage}', '', f'Run `{run}`, {len(new)} step: {new[0] if new else "-"} → {new[-1] if new else "-"}', '']
if checks:
    lines += ['## Kiểm tra tự động', '', '| Kết quả | Tiêu chí | Chỉ số | Giá trị |', '|---|---|---|---|']
    lines += [f'| {r} | {t} | `{k}` | {v} |' for r, t, k, v in checks] + ['']
lines += ['## Chỉ số', '', '| Step | Chỉ số | Giá trị |', '|---|---|---|'] + [f'| {s} | `{k}` | {v} |' for s, k, v in rows]
lines += ['', '## Báo cáo chi tiết của LibreLane', ''] + [f'- `{f}`' for f in files]
lines += ['', '## Đánh giá', '', '(điền sau khi xem các số liệu trên)']
os.makedirs('docs/flow', exist_ok=True)
out = os.path.join('docs/flow', re.sub(r'[^0-9A-Za-z]+', '_', stage).strip('_') + '.md')
open(out, 'w').write('\n'.join(lines) + '\n')
open(mark, 'w').write(str(num(steps[-1])))

w = max([len(k) for _, k, _ in rows] or [10])
cur = None
for s, k, v in rows:
    if s != cur:
        print(f'-- {s}'); cur = s
    print(f'   {k:<{w}}  {v}')
if checks:
    print('\nKiem tra tu dong:')
    for r, t, k, v in checks:
        print(f'   [{r}] {t}: {k} = {v}')
print(f'\n{len(rows)} chi so, {len(files)} file bao cao; da luu {out}')

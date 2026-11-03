#!/usr/bin/env python3
# Chạy luồng LibreLane Classic TỪNG STEP MỘT (mỗi lần gọi chạy đúng 1 step) và báo cáo sau mỗi step.
# Cần: source .venv/bin/activate (có librelane), Docker; KLayout để xem layout.
#
#   python3 scripts/step.py              chạy step kế tiếp, in báo cáo, ghi docs/steps/<step>.md
#   python3 scripts/step.py list         danh sách step: đã chạy / bị tắt / step kế tiếp
#   python3 scripts/step.py view [N]     mở layout sau step N (mặc định: step mới nhất) trong KLayout
#   python3 scripts/step.py report [N]   in lại báo cáo của step N
#
# Đổi cấu hình hoặc tên run:  CFG=openlane/soc_core.json TAG=thu2 python3 scripts/step.py
# Chạy lại từ đầu:            rm -rf openlane/runs/tungbuoc docs/steps
import glob, json, os, re, shlex, subprocess, sys

try:
    import librelane
    from librelane.flows.classic import Classic
except ImportError:
    sys.exit('Chua co librelane: chay "source .venv/bin/activate" truoc')

CFG = os.environ.get('CFG', 'openlane/soc_core_fix3.json')
TAG = os.environ.get('TAG', 'tungbuoc')
RUN = os.path.join(os.path.dirname(CFG) or '.', 'runs', TAG)
OUT = 'docs/steps' if TAG == 'tungbuoc' else 'docs/steps_' + TAG
IDS = [s.id for s in Classic.Steps]
NEXT_FILE = os.path.join(RUN, '.next_step')
SUMMARY = os.path.join(RUN, '.step_summary.json')

DESC = {
    'Verilator.Lint': 'Kiểm tra RTL bằng Verilator (lint)',
    'Checker.LintTimingConstructs': 'Kiểm tra RTL không có cấu trúc trễ không tổng hợp được',
    'Checker.LintErrors': 'Báo lỗi nếu lint có lỗi',
    'Checker.LintWarnings': 'Báo số cảnh báo lint',
    'Yosys.JsonHeader': 'Ghi mô tả cổng của module top (JSON)',
    'Yosys.Synthesis': 'Tổng hợp RTL thành netlist cell sky130',
    'Checker.YosysUnmappedCells': 'Kiểm tra không còn cell chưa ánh xạ',
    'Checker.YosysSynthChecks': 'Kiểm tra lỗi tổng hợp (lệnh check của Yosys)',
    'Checker.NetlistAssignStatements': 'Kiểm tra netlist không còn lệnh assign',
    'OpenROAD.CheckSDCFiles': 'Kiểm tra file ràng buộc thời gian SDC',
    'OpenROAD.CheckMacroInstances': 'Kiểm tra các macro khai báo có trong netlist',
    'OpenROAD.STAPrePNR': 'STA trước đặt cell (clock lý tưởng, chưa có dây)',
    'OpenROAD.Floorplan': 'Tạo die, vùng core và các hàng cell (layout đầu tiên)',
    'OpenROAD.DumpRCValues': 'Ghi điện trở, điện dung của các lớp kim loại',
    'Odb.CheckMacroAntennaProperties': 'Kiểm tra thuộc tính antenna của macro',
    'Odb.SetPowerConnections': 'Nối chân nguồn VPWR/VGND của cell',
    'Odb.ManualMacroPlacement': 'Đặt macro theo cấu hình (không có macro thì không làm gì)',
    'OpenROAD.CutRows': 'Cắt hàng cell quanh macro và vật cản',
    'OpenROAD.TapEndcapInsertion': 'Chèn tap cell và endcap',
    'Odb.AddPDNObstructions': 'Thêm vùng cấm cho lưới nguồn (nếu có)',
    'OpenROAD.GeneratePDN': 'Tạo lưới nguồn VPWR/VGND',
    'Odb.RemovePDNObstructions': 'Gỡ vùng cấm lưới nguồn',
    'Odb.AddRoutingObstructions': 'Thêm vùng cấm đi dây (nếu có)',
    'OpenROAD.GlobalPlacementSkipIO': 'Đặt cell sơ bộ để tìm vị trí chân IO',
    'OpenROAD.IOPlacement': 'Đặt chân IO quanh die',
    'Odb.CustomIOPlacement': 'Đặt chân IO theo file cấu hình (nếu có)',
    'Odb.ApplyDEFTemplate': 'Áp template DEF (nếu có)',
    'OpenROAD.GlobalPlacement': 'Đặt cell toàn cục',
    'Odb.WriteVerilogHeader': 'Ghi header Verilog có chân nguồn',
    'Checker.PowerGridViolations': 'Kiểm tra lưới nguồn nối đủ',
    'OpenROAD.STAMidPNR': 'STA sau global placement',
    'OpenROAD.RepairDesignPostGPL': 'Chèn buffer, đổi cỡ cell để sửa slew, cap, fanout',
    'Odb.ManualGlobalPlacement': 'Đặt tay cell theo cấu hình (nếu có)',
    'OpenROAD.DetailedPlacement': 'Đặt chi tiết: đưa cell vào đúng hàng, không chồng nhau',
    'OpenROAD.CTS': 'Tổng hợp cây clock',
    'OpenROAD.STAMidPNR-1': 'STA sau CTS',
    'OpenROAD.ResizerTimingPostCTS': 'Sửa setup/hold sau CTS',
    'OpenROAD.STAMidPNR-2': 'STA sau khi sửa timing',
    'OpenROAD.GlobalRouting': 'Định tuyến toàn cục',
    'OpenROAD.CheckAntennas': 'Kiểm tra antenna sau global routing',
    'OpenROAD.RepairDesignPostGRT': 'Sửa slew, cap sau global routing',
    'Odb.DiodesOnPorts': 'Chèn diode ở chân IO (nếu bật)',
    'Odb.HeuristicDiodeInsertion': 'Chèn diode theo heuristic (nếu bật)',
    'OpenROAD.RepairAntennas': 'Chèn diode sửa vi phạm antenna',
    'OpenROAD.ResizerTimingPostGRT': 'Sửa timing sau global routing (nếu bật)',
    'OpenROAD.STAMidPNR-3': 'STA sau global routing',
    'OpenROAD.DetailedRouting': 'Định tuyến chi tiết',
    'Odb.RemoveRoutingObstructions': 'Gỡ vùng cấm đi dây',
    'OpenROAD.CheckAntennas-1': 'Kiểm tra antenna sau định tuyến chi tiết',
    'Checker.TrDRC': 'Báo lỗi DRC của bộ định tuyến',
    'Odb.ReportDisconnectedPins': 'Báo các chân bị hở',
    'Checker.DisconnectedPins': 'Báo lỗi nếu chân quan trọng bị hở',
    'Odb.ReportWireLength': 'Báo chiều dài dây',
    'Checker.WireLength': 'Cảnh báo dây quá dài',
    'OpenROAD.FillInsertion': 'Chèn cell fill lấp chỗ trống',
    'Odb.CellFrequencyTables': 'Thống kê số cell theo loại',
    'OpenROAD.RCX': 'Trích xuất RC ký sinh (SPEF)',
    'OpenROAD.STAPostPNR': 'STA signoff ở 9 corner',
    'OpenROAD.IRDropReport': 'Phân tích sụt áp lưới nguồn',
    'Magic.StreamOut': 'Xuất GDS bằng Magic',
    'KLayout.StreamOut': 'Xuất GDS bằng KLayout',
    'KLayout.Render': 'Vẽ ảnh PNG của layout',
    'Magic.WriteLEF': 'Xuất LEF của khối',
    'Odb.CheckDesignAntennaProperties': 'Kiểm tra thuộc tính antenna của khối',
    'KLayout.XOR': 'So GDS của Magic với GDS của KLayout',
    'Checker.XOR': 'Báo lỗi nếu hai GDS khác nhau',
    'Magic.DRC': 'DRC bằng Magic',
    'KLayout.DRC': 'DRC bằng KLayout',
    'Checker.MagicDRC': 'Báo lỗi nếu Magic có lỗi DRC',
    'Checker.KLayoutDRC': 'Báo lỗi nếu KLayout có lỗi DRC',
    'Magic.SpiceExtraction': 'Trích netlist SPICE từ layout',
    'Checker.IllegalOverlap': 'Kiểm tra chồng lấn bất hợp lệ',
    'Netgen.LVS': 'So layout với netlist (LVS)',
    'Checker.LVS': 'Báo lỗi nếu LVS không khớp',
    'Yosys.EQY': 'Kiểm tra tương đương hình thức (nếu bật)',
    'Checker.SetupViolations': 'Báo vi phạm setup',
    'Checker.HoldViolations': 'Báo vi phạm hold',
    'Checker.MaxSlewViolations': 'Báo vi phạm max slew',
    'Checker.MaxCapViolations': 'Báo vi phạm max capacitance',
    'Misc.ReportManufacturability': 'Tóm tắt khả năng chế tạo: DRC, LVS, antenna',
}
STAGES = [('OpenROAD.Floorplan', '1. Tổng hợp'), ('Odb.RemovePDNObstructions', '2. Floorplan + PDN'),
          ('OpenROAD.CTS', '3. Placement'), ('OpenROAD.GlobalRouting', '4. CTS'),
          ('OpenROAD.FillInsertion', '5. Routing'), (None, '6. Signoff')]
KEEP = re.compile(
    r'instance__count|instance__area|die__area|core__area|utilization|'
    r'timing__(setup|hold)__(ws|tns|wns)|clock__skew|max_(slew|cap|fanout)_violation__count|'
    r'power__|wirelength|route__drc_errors|antenna|lvs__|drc__|magic__|klayout__|ir__drop|'
    r'latch|unmapped|check_error|disconnected|xor_difference|lint', re.I)
CORNERS = ('nom_tt_025C_1v80', 'max_ss_100C_1v60')   # corner điển hình và corner xấu nhất
RULES = [   # (mẫu tên chỉ số, tiêu chí, điều kiện đạt)
    (r'latch__count$', 'Không có latch', lambda v: v == 0),
    (r'unmapped__count$', 'Không có cell chưa ánh xạ', lambda v: v == 0),
    (r'lint_errors?__count$', 'Không có lỗi lint', lambda v: v == 0),
    (r'^timing__setup__ws$', 'Setup slack ≥ 0 ở corner xấu nhất', lambda v: v >= 0),
    (r'^timing__hold__ws$', 'Hold slack ≥ 0 ở corner xấu nhất', lambda v: v >= 0),
    (r'drc_errors?(__count)?$', 'Không có lỗi DRC', lambda v: v == 0),
    (r'lvs.*error.*count$', 'Không có lỗi LVS', lambda v: v == 0),
    (r'antenna.*(violat|net)', 'Không có vi phạm antenna', lambda v: v == 0),
    (r'^design__max_slew_violation__count$', 'Không vi phạm max slew', lambda v: v == 0),
    (r'^design__max_cap_violation__count$', 'Không vi phạm max capacitance', lambda v: v == 0),
    (r'^design__max_fanout_violation__count$', 'Không vi phạm max fanout', lambda v: v == 0),
    (r'critical_disconnected.*count$', 'Không có chân quan trọng bị hở', lambda v: v == 0),
    (r'xor_difference__count$', 'GDS của Magic và KLayout trùng nhau', lambda v: v == 0),
]
VIEWS = {'nl': 'netlist', 'pnl': 'netlist có chân nguồn', 'def': 'DEF (layout)', 'odb': 'ODB (layout)',
         'gds': 'GDS', 'klayout_gds': 'GDS (KLayout)', 'mag': 'Magic', 'lef': 'LEF', 'sdc': 'SDC',
         'spef': 'SPEF', 'sdf': 'SDF', 'lib': 'Liberty', 'spice': 'SPICE', 'json_h': 'JSON header', 'vh': 'Verilog header'}


def slug(sid):
    return re.sub(r'[^a-z0-9]+', '-', sid.lower()).strip('-')


def stage_of(sid):
    i = IDS.index(sid)
    for until, name in STAGES:
        if until is None or i < IDS.index(until):
            return name


def step_dirs():
    out = []
    for d in glob.glob(os.path.join(RUN, '[0-9]*-*')):
        m = re.match(r'(\d+)-(.+)$', os.path.basename(d))
        if m and os.path.isdir(d):
            out.append((int(m.group(1)), d))
    return sorted(out)


def load(path):
    try:
        return json.load(open(path))
    except (OSError, ValueError):
        return {}


def fmt(v):
    if isinstance(v, float):
        return f'{v:.4g}' if abs(v) < 1e4 else f'{v:.0f}'
    return str(v)


def wanted(k):
    if '__iter:' in k or not KEEP.search(k):
        return False
    return '__corner:' not in k or any(c in k for c in CORNERS)


def read_next():
    try:
        return int(open(NEXT_FILE).read())
    except (OSError, ValueError):
        return 0


def write_next(i):
    os.makedirs(RUN, exist_ok=True)
    open(NEXT_FILE, 'w').write(str(i))


def report(d, sid=None, quiet=False):
    """In và ghi báo cáo cho thư mục step d."""
    name = os.path.basename(d)
    ords = [o for o, _ in step_dirs()]
    o = int(name.split('-')[0])
    if sid is None:   # tìm ID từ tên thư mục
        sid = next((s for s in IDS if slug(s) == name.split('-', 1)[1]), name)
    st_out = load(os.path.join(d, 'state_out.json'))
    st_in = load(os.path.join(d, 'state_in.json'))
    if not st_in:   # không có state_in: dùng state_out của step trước
        prev = [p for q, p in step_dirs() if q < o]
        st_in = load(os.path.join(prev[-1], 'state_out.json')) if prev else {}
    m_in, m_out = st_in.get('metrics', {}), st_out.get('metrics', {})
    rows = [(k, fmt(m_out[k]), fmt(m_in[k]) if k in m_in else '–')
            for k in sorted(m_out) if wanted(k) and m_in.get(k) != m_out[k]]
    checks = []
    for pat, text, ok in RULES:
        for k in sorted(m_out):
            v = m_out[k]
            if re.search(pat, k) and isinstance(v, (int, float)) and m_in.get(k) != v:
                checks.append(('ĐẠT' if ok(v) else 'KHÔNG ĐẠT', text, k, fmt(v)))
    views = [VIEWS.get(k, k) for k, v in st_out.items()
             if k != 'metrics' and v and v != st_in.get(k)]
    rt = open(os.path.join(d, 'runtime.txt')).read().strip() if os.path.exists(os.path.join(d, 'runtime.txt')) else '?'
    files = sorted(os.path.relpath(f, d) for f in glob.glob(os.path.join(d, '*.rpt')) + glob.glob(os.path.join(d, '**', '*.rpt'), recursive=True)
                   + glob.glob(os.path.join(d, 'reports', '*')) + glob.glob(os.path.join(d, '*.log')))
    files = sorted(set(files))
    has_layout = any(k in st_out for k in ('def', 'gds'))
    verdict = 'Cần xem lại' if any(c[0] != 'ĐẠT' for c in checks) else ('Đạt' if checks else '–')

    L = [f'# Step {o}: {sid}', '', f'{DESC.get(sid, "")}. Giai đoạn: {stage_of(sid) if sid in IDS else "?"}. '
         f'Thời gian chạy: {rt}. Thư mục: `{d}`', '']
    if views:
        L += ['Step này tạo hoặc thay đổi: ' + ', '.join(views) + '.', '']
    if checks:
        L += ['## Kiểm tra tự động', '', '| Kết quả | Tiêu chí | Chỉ số | Giá trị |', '|---|---|---|---|']
        L += [f'| {r} | {t} | `{k}` | {v} |' for r, t, k, v in checks] + ['']
    L += ['## Chỉ số thay đổi', '']
    L += (['| Chỉ số | Trước | Sau |', '|---|---|---|'] + [f'| `{k}` | {b} | {a} |' for k, a, b in rows]) if rows else ['Không có chỉ số nào thay đổi.']
    L += ['', '## File báo cáo của LibreLane', ''] + ([f'- `{f}`' for f in files] or ['(không có)'])
    if has_layout:
        L += ['', f'Xem layout sau step này: `python3 scripts/step.py view {o}`']
    L += ['', '## Đánh giá', '', '(điền sau khi xem số liệu)']
    os.makedirs(OUT, exist_ok=True)
    open(os.path.join(OUT, name + '.md'), 'w').write('\n'.join(L) + '\n')

    summ = load(SUMMARY)
    summ[name] = {'id': sid, 'desc': DESC.get(sid, ''), 'runtime': rt, 'verdict': verdict}
    json.dump(summ, open(SUMMARY, 'w'), ensure_ascii=False, indent=1)
    idx = ['# Báo cáo từng step', '', f'Cấu hình `{CFG}`, run `{RUN}`.', '',
           '| Step | ID | Nội dung | Thời gian | Kết luận |', '|---|---|---|---|---|']
    for n in sorted(summ, key=lambda s: int(s.split('-')[0])):
        x = summ[n]
        idx.append(f'| [{n.split("-")[0]}]({n}.md) | `{x["id"]}` | {x["desc"]} | {x["runtime"]} | {x["verdict"]} |')
    open(os.path.join(OUT, 'README.md'), 'w').write('\n'.join(idx) + '\n')

    if quiet:
        return
    print(f'\n===== Step {o}: {sid} ({rt}) =====')
    print(DESC.get(sid, ''))
    if views:
        print('Tạo/thay đổi: ' + ', '.join(views))
    w = max([len(k) for k, _, _ in rows] or [10])
    for k, a, b in rows:
        print(f'   {k:<{w}}  {b} -> {a}')
    for r, t, k, v in checks:
        print(f'   [{r}] {t}: {k} = {v}')
    print(f'Báo cáo: {OUT}/{name}.md')
    if has_layout:
        print(f'Xem layout: python3 scripts/step.py view {o}')
def run_next():
    i = read_next()
    while i < len(IDS):
        sid = IDS[i]
        before = {d for _, d in step_dirs()}
        print(f'\n>>> [{i + 1}/{len(IDS)}] {sid}: {DESC.get(sid, "")}', flush=True)
        r = subprocess.run(['librelane', '--dockerized', '--run-tag', TAG, '--only', sid, CFG])
        new = [d for _, d in step_dirs() if d not in before and os.path.exists(os.path.join(d, 'state_out.json'))]
        if r.returncode != 0 and not new:
            sys.exit(f'\nStep {sid} bị lỗi (mã {r.returncode}), chưa chuyển sang step sau. '
                     f'Xem log ở trên, sửa xong chạy lại lệnh này để chạy lại step đó.')
        i += 1
        write_next(i)
        if new:
            report(new[-1], sid)
            if r.returncode != 0:
                print(f'\nCHÚ Ý: {sid} báo lỗi nhưng vẫn ghi kết quả; xem log trong {new[-1]}.')
            if i < len(IDS):
                print(f'\nStep kế tiếp: {IDS[i]}. Chạy tiếp: python3 scripts/step.py')
            return
        print(f'    Bỏ qua: {sid} bị tắt trong cấu hình. Chuyển sang step kế tiếp.')
    print(f'\nĐã chạy hết {len(IDS)} step. GDS cuối: {RUN}/final/gds/. Xem: python3 scripts/step.py view')


def show_list():
    nxt = read_next()
    done = {d.split('-', 1)[1]: o for o, d in ((o, os.path.basename(p)) for o, p in step_dirs())}
    cur = None
    for i, sid in enumerate(IDS):
        if stage_of(sid) != cur:
            cur = stage_of(sid)
            print(f'\n{cur}')
        if slug(sid) in done:
            mark = f'xong  {done[slug(sid)]:>3}'
        elif i < nxt:
            mark = 'tắt      '
        elif i == nxt:
            mark = '--> TIẾP '
        else:
            mark = '         '
        print(f'  {i + 1:>2}. [{mark}] {sid:<34} {DESC.get(sid, "")}')


def pick_dir(n):
    ds = step_dirs()
    if not ds:
        sys.exit('Chưa có step nào chạy xong.')
    if n is None:
        return ds[-1][1]
    for o, d in ds:
        if o == n:
            return d
    sys.exit(f'Không có step số {n} trong {RUN}')


def view(n):
    d = pick_dir(n)
    o = int(os.path.basename(d).split('-')[0])
    st = {}
    for q, p in reversed(step_dirs()):   # step mới nhất (≤ n) có layout
        if q <= o:
            st = load(os.path.join(p, 'state_out.json'))
            if st.get('gds') or st.get('def'):
                d = p
                break
    lay = st.get('gds') or st.get('def')
    if not lay:
        sys.exit('Chưa có layout: layout bắt đầu có từ step OpenROAD.Floorplan.')
    c = load(os.path.join(RUN, 'resolved.json'))
    tl = c['TECH_LEFS']
    tech_lef = tl.get('nom_*') or next(iter(tl.values())) if isinstance(tl, dict) else tl
    lefs = [tech_lef] + list(c.get('CELL_LEFS') or []) + list(c.get('EXTRA_LEFS') or [])
    for m in (c.get('MACROS') or {}).values():   # LEF cua macro (vd. SRAM)
        lefs += list(m.get('lef') or [])
    args = [lay, '--lyp', c['KLAYOUT_PROPERTIES'], '--lyt', c['KLAYOUT_TECH'], '--lym', c['KLAYOUT_DEF_LAYER_MAP']]
    for f in lefs:
        args += ['--input-lef', f]
    script = os.path.join(os.path.dirname(librelane.__file__), 'scripts', 'klayout', 'open_design.py')
    print(f'Mở {lay} (sau step {os.path.basename(d)}) trong KLayout...')
    subprocess.run(['klayout', '-rm', script], env=dict(os.environ, KLAYOUT_ARGV=shlex.join(args)))


if __name__ == '__main__':
    a = sys.argv[1:]
    num = int(a[1]) if len(a) > 1 else None
    if not a:
        run_next()
    elif a[0] == 'list':
        show_list()
    elif a[0] == 'view':
        view(num)
    elif a[0] == 'report':
        report(pick_dir(num))
    else:
        sys.exit(__doc__ or 'Dùng: python3 scripts/step.py [list | view [N] | report [N]]')

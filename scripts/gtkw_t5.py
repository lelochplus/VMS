#!/usr/bin/env python3
# Tạo t5.gtkw cho GTKWave: tín hiệu của ca T5 (DMA chép 4 word có ngắt) trong tb_dma,
# đã nhóm, đặt định dạng, đổi giá trị FSM/địa chỉ thanh ghi thành tên, zoom đúng đoạn T5.
# Dùng: python3 scripts/gtkw_t5.py dump.vcd && gtkwave -r scripts/gtkwave_light.rc t5.gtkw
import math, os, sys

vcd = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else 'dump.vcd')

# ---- đọc phần khai báo: id -> tên đầy đủ (kèm [msb:lsb]) ----
ids, scope, unit = {}, [], 1e-12
with open(vcd) as f:
    for line in f:
        t = line.split()
        if not t: continue
        if t[0] == '$timescale':
            ts = ''.join(t[1:]).replace('$end', '') or next(f).strip()
            num = ''.join(c for c in ts if c.isdigit()) or '1'
            unit = int(num) * {'s': 1, 'ms': 1e-3, 'us': 1e-6, 'ns': 1e-9, 'ps': 1e-12, 'fs': 1e-15}[ts.lstrip('0123456789')]
        elif t[0] == '$scope': scope.append(t[2])
        elif t[0] == '$upscope': scope.pop()
        elif t[0] == '$var':
            name = t[4] + (t[5] if len(t) > 6 and t[5].startswith('[') else '')
            ids.setdefault(t[3], []).append('.'.join(scope + [name]))
        elif t[0] == '$enddefinitions': break
    names = {n: i for i, ns in ids.items() for n in ns}

    def full(short):   # 'dut.st' -> 'TOP.tb_dma.dut.st[2:0]' (Verilator) hoặc 'tb_dma.dut.st[2:0]' (Icarus)
        for n in names:
            base = n.split('[')[0]
            if base.endswith('tb_dma.' + short): return n
        sys.exit('khong thay tin hieu ' + short)

    # ---- quét giá trị: lần duy nhất CPU ghi CTRL = 0xF (ca T5), rồi irq hạ ----
    id_dat, id_irq = names[full('s_dat_i')], names[full('irq')]
    now, t_ctrl, t_irq0 = 0, None, None
    for line in f:
        if line[0] == '#': now = int(line[1:]); continue
        if line[0] == 'b':
            v, i = line[1:].split()
            if i == id_dat and t_ctrl is None and v.lstrip('0') == '1111': t_ctrl = now
        elif line[0] in '01' and line[1:].strip() == id_irq and t_ctrl is not None and line[0] == '0':
            t_irq0 = now; break
if t_ctrl is None or t_irq0 is None: sys.exit('khong tim thay ca T5 trong ' + vcd)

P = round(20e-9 / unit)                       # 1 chu kỳ clock 20 ns theo đơn vị của VCD
t0, t1 = t_ctrl - 7 * P, t_irq0 + 3 * P
zoom = 2.59 - math.log2(t1 - t0)             # hệ số đo từ GTKWave 3.3: cả đoạn vừa khung sóng ở cửa sổ 1800 px

# ---- bộ lọc đổi giá trị thành tên ----
st_f = os.path.abspath('fsm_state.txt'); reg_f = os.path.abspath('dma_reg.txt')
open(st_f, 'w').write('0 IDLE\n1 RD_REQ\n2 RD_WAIT\n3 WR_REQ\n4 WR_WAIT\n')
open(reg_f, 'w').write('0 CTRL\n1 STATUS\n2 SRC\n3 DST\n4 LEN\n')

BIT, HEX, DEC, NAMED, NOTE = '@28', '@22', '@24', '@2022', '@200'
rows = [
    (NOTE, '-CPU cau hinh DMA (cong slave)'),
    (BIT, 'clk'), (BIT, 's_cyc'), (BIT, 's_we'), (NAMED, 's_adr', reg_f), (HEX, 's_dat_i'), (BIT, 's_ack'),
    (NOTE, '-DMA truy cap bo nho (cong master)'),
    (BIT, 'dut.busy'), (NAMED, 'dut.st', st_f), (BIT, 'm_cyc'), (BIT, 'm_we'), (HEX, 'm_adr'), (BIT, 'm_ack'),
    (DEC, 'dut.len'),
    (NOTE, '-Ket thuc va ngat'),
    (BIT, 'dut.done'), (BIT, 'irq'),
]
with open('t5.gtkw', 'w') as g:
    g.write(f'[dumpfile] "{vcd}"\n[timestart] {t0}\n[size] 1800 900\n[pos] -1 -1\n')
    g.write(f'*{zoom:.6f} {t_ctrl} ' + ' '.join(['-1'] * 26) + '\n')
    for r in rows:
        g.write(r[0] + '\n')
        if r[0] == NOTE: g.write(r[1] + '\n'); continue
        if len(r) == 3: g.write(f'^1 {r[2]}\n')
        g.write(full(r[1]) + '\n')
print(f't5.gtkw: T5 tu {t0} den {t1} (don vi {unit:g} s), marker o lenh ghi CTRL tai {t_ctrl}')

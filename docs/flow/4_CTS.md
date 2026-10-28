# 4. CTS

Run `openlane/runs/step`, 4 step: 36-openroad-cts → 39-openroad-stamidpnr-2

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 15.48 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.2868 |
| ĐẠT | Không vi phạm max slew (ràng buộc 0,75 ns) | `design__max_slew_violation__count` | 0 |
| ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 0 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 67 |

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 36-openroad-cts | `design__instance__area` | 135240 |
| 36-openroad-cts | `design__instance__area__class:clock_buffer` | 4606 |
| 36-openroad-cts | `design__instance__area__class:clock_inverter` | 478 |
| 36-openroad-cts | `design__instance__area__stdcell` | 133903 |
| 36-openroad-cts | `design__instance__count` | 14367 |
| 36-openroad-cts | `design__instance__count__class:clock_buffer` | 319 |
| 36-openroad-cts | `design__instance__count__class:clock_inverter` | 40 |
| 36-openroad-cts | `design__instance__count__stdcell` | 14011 |
| 36-openroad-cts | `design__instance__utilization` | 0.5715 |
| 36-openroad-cts | `design__instance__utilization__stdcell` | 0.5715 |
| 36-openroad-cts | `route__wirelength__estimated` | 418996 |
| 37-openroad-stamidpnr-1 | `clock__skew__worst_hold` | -0.4362 |
| 37-openroad-stamidpnr-1 | `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -0.4362 |
| 37-openroad-stamidpnr-1 | `clock__skew__worst_setup` | 0.3207 |
| 37-openroad-stamidpnr-1 | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.3207 |
| 37-openroad-stamidpnr-1 | `design__max_cap_violation__count` | 0 |
| 37-openroad-stamidpnr-1 | `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 0 |
| 37-openroad-stamidpnr-1 | `design__max_fanout_violation__count` | 67 |
| 37-openroad-stamidpnr-1 | `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 67 |
| 37-openroad-stamidpnr-1 | `design__max_slew_violation__count` | 0 |
| 37-openroad-stamidpnr-1 | `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 0 |
| 37-openroad-stamidpnr-1 | `power__internal__total` | 0.006317 |
| 37-openroad-stamidpnr-1 | `power__leakage__total` | 5.927e-08 |
| 37-openroad-stamidpnr-1 | `power__switching__total` | 0.002731 |
| 37-openroad-stamidpnr-1 | `power__total` | 0.009048 |
| 37-openroad-stamidpnr-1 | `timing__hold__tns` | 0 |
| 37-openroad-stamidpnr-1 | `timing__hold__tns__corner:nom_tt_025C_1v80` | 0 |
| 37-openroad-stamidpnr-1 | `timing__hold__wns` | 0 |
| 37-openroad-stamidpnr-1 | `timing__hold__wns__corner:nom_tt_025C_1v80` | 0 |
| 37-openroad-stamidpnr-1 | `timing__hold__ws` | 0.125 |
| 37-openroad-stamidpnr-1 | `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.125 |
| 37-openroad-stamidpnr-1 | `timing__setup__tns` | 0 |
| 37-openroad-stamidpnr-1 | `timing__setup__tns__corner:nom_tt_025C_1v80` | 0 |
| 37-openroad-stamidpnr-1 | `timing__setup__wns` | 0 |
| 37-openroad-stamidpnr-1 | `timing__setup__wns__corner:nom_tt_025C_1v80` | 0 |
| 37-openroad-stamidpnr-1 | `timing__setup__ws` | 15.5 |
| 37-openroad-stamidpnr-1 | `timing__setup__ws__corner:nom_tt_025C_1v80` | 15.5 |
| 38-openroad-resizertimingpostcts | `design__instance__area` | 147957 |
| 38-openroad-resizertimingpostcts | `design__instance__area__class:timing_repair_buffer` | 20034 |
| 38-openroad-resizertimingpostcts | `design__instance__area__stdcell` | 146621 |
| 38-openroad-resizertimingpostcts | `design__instance__count` | 17755 |
| 38-openroad-resizertimingpostcts | `design__instance__count__class:timing_repair_buffer` | 4630 |
| 38-openroad-resizertimingpostcts | `design__instance__count__hold_buffer` | 3388 |
| 38-openroad-resizertimingpostcts | `design__instance__count__setup_buffer` | 0 |
| 38-openroad-resizertimingpostcts | `design__instance__count__stdcell` | 17399 |
| 38-openroad-resizertimingpostcts | `design__instance__utilization` | 0.6258 |
| 38-openroad-resizertimingpostcts | `design__instance__utilization__stdcell` | 0.6258 |
| 38-openroad-resizertimingpostcts | `route__wirelength__estimated` | 439614 |
| 39-openroad-stamidpnr-2 | `clock__skew__worst_setup` | 0.3199 |
| 39-openroad-stamidpnr-2 | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.3199 |
| 39-openroad-stamidpnr-2 | `power__internal__total` | 0.006431 |
| 39-openroad-stamidpnr-2 | `power__leakage__total` | 6.326e-08 |
| 39-openroad-stamidpnr-2 | `power__switching__total` | 0.002796 |
| 39-openroad-stamidpnr-2 | `power__total` | 0.009228 |
| 39-openroad-stamidpnr-2 | `timing__hold__ws` | 0.2868 |
| 39-openroad-stamidpnr-2 | `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.2868 |
| 39-openroad-stamidpnr-2 | `timing__setup__ws` | 15.48 |
| 39-openroad-stamidpnr-2 | `timing__setup__ws__corner:nom_tt_025C_1v80` | 15.48 |

## Báo cáo chi tiết của LibreLane

- `36-openroad-cts/cts.rpt`
- `37-openroad-stamidpnr-1/checks.rpt`
- `37-openroad-stamidpnr-1/clock.rpt`
- `37-openroad-stamidpnr-1/max.rpt`
- `37-openroad-stamidpnr-1/min.rpt`
- `37-openroad-stamidpnr-1/power.rpt`
- `37-openroad-stamidpnr-1/skew.max.rpt`
- `37-openroad-stamidpnr-1/skew.min.rpt`
- `37-openroad-stamidpnr-1/tns.max.rpt`
- `37-openroad-stamidpnr-1/tns.min.rpt`
- `37-openroad-stamidpnr-1/unpropagated.rpt`
- `37-openroad-stamidpnr-1/violator_list.rpt`
- `37-openroad-stamidpnr-1/wns.max.rpt`
- `37-openroad-stamidpnr-1/wns.min.rpt`
- `37-openroad-stamidpnr-1/ws.max.rpt`
- `37-openroad-stamidpnr-1/ws.min.rpt`
- `39-openroad-stamidpnr-2/checks.rpt`
- `39-openroad-stamidpnr-2/clock.rpt`
- `39-openroad-stamidpnr-2/max.rpt`
- `39-openroad-stamidpnr-2/min.rpt`
- `39-openroad-stamidpnr-2/power.rpt`
- `39-openroad-stamidpnr-2/skew.max.rpt`
- `39-openroad-stamidpnr-2/skew.min.rpt`
- `39-openroad-stamidpnr-2/tns.max.rpt`
- `39-openroad-stamidpnr-2/tns.min.rpt`
- `39-openroad-stamidpnr-2/unpropagated.rpt`
- `39-openroad-stamidpnr-2/violator_list.rpt`
- `39-openroad-stamidpnr-2/wns.max.rpt`
- `39-openroad-stamidpnr-2/wns.min.rpt`
- `39-openroad-stamidpnr-2/ws.max.rpt`
- `39-openroad-stamidpnr-2/ws.min.rpt`

## Đánh giá

**Kết luận: đạt.**

- CTS dựng cây H-tree cho 2.119 flip-flop: gom thành 216 cụm (tối đa 10 sink, đường kính 50 µm), 265 buffer (gốc `clkbuf_16`, lá `clkbuf_8`); mọi đường clock đi qua đúng 4 buffer nên cây cân bằng. Cây clock gồm 319 buffer clock và 40 inverter clock, diện tích 5.084 µm².
- Skew ở corner tt giảm từ +2,35/−3,62 ns (trước CTS) xuống +0,32/−0,44 ns; vi phạm slew 2.120 → 0, cap 1 → 0. Setup slack tt từ −3,57 lên +15,48 ns.
- Sửa timing sau CTS: không có vi phạm setup; ở các corner nhanh có 1.865 điểm cuối vi phạm hold, công cụ chèn 3.388 buffer hold. Diện tích buffer sửa timing tăng từ 7.317 lên 20.034 µm² (+12.717 µm², khoảng 9,5% diện tích cell), mật độ 57,2% → 62,6%. Đây là chi phí lớn nhất của cả flow, một phần vì cấu hình fix3 loại cell trễ `dlygate4sd*` nên phải dùng buffer thường để sửa hold. Hold slack tt sau sửa +0,29 ns.
- Còn 67 vi phạm fanout, 67 trong số đó ở net của cây clock; fanout của các net vi phạm từ 11 đến 16.
- Công suất ước lượng 9,23 mW (có cây clock, chưa có dây thật). Chiều dài dây ước lượng 439.614 µm.

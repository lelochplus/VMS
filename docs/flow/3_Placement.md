# 3. Placement

Run `openlane/runs/step`, 13 step: 22-odb-removepdnobstructions → 34-openroad-detailedplacement

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| KHÔNG ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | -5.118 |
| KHÔNG ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | -14.01 |
| KHÔNG ĐẠT | Không vi phạm max slew (ràng buộc 0,75 ns) | `design__max_slew_violation__count` | 7719 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 73 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 222 |

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 31-openroad-stamidpnr | `clock__skew__worst_hold` | -3.593 |
| 31-openroad-stamidpnr | `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -3.593 |
| 31-openroad-stamidpnr | `clock__skew__worst_setup` | 2.327 |
| 31-openroad-stamidpnr | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 2.327 |
| 31-openroad-stamidpnr | `design__max_cap_violation__count` | 73 |
| 31-openroad-stamidpnr | `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 73 |
| 31-openroad-stamidpnr | `design__max_fanout_violation__count` | 222 |
| 31-openroad-stamidpnr | `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 222 |
| 31-openroad-stamidpnr | `design__max_slew_violation__count` | 7719 |
| 31-openroad-stamidpnr | `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 7719 |
| 31-openroad-stamidpnr | `power__internal__total` | 0.006594 |
| 31-openroad-stamidpnr | `power__leakage__total` | 5.057e-08 |
| 31-openroad-stamidpnr | `power__switching__total` | 0.001557 |
| 31-openroad-stamidpnr | `power__total` | 0.008151 |
| 31-openroad-stamidpnr | `timing__hold__tns` | -17360 |
| 31-openroad-stamidpnr | `timing__hold__tns__corner:nom_tt_025C_1v80` | -17360 |
| 31-openroad-stamidpnr | `timing__hold__wns` | -14.01 |
| 31-openroad-stamidpnr | `timing__hold__wns__corner:nom_tt_025C_1v80` | -14.01 |
| 31-openroad-stamidpnr | `timing__hold__ws` | -14.01 |
| 31-openroad-stamidpnr | `timing__hold__ws__corner:nom_tt_025C_1v80` | -14.01 |
| 31-openroad-stamidpnr | `timing__setup__tns` | -193.4 |
| 31-openroad-stamidpnr | `timing__setup__tns__corner:nom_tt_025C_1v80` | -193.4 |
| 31-openroad-stamidpnr | `timing__setup__wns` | -5.118 |
| 31-openroad-stamidpnr | `timing__setup__wns__corner:nom_tt_025C_1v80` | -5.118 |
| 31-openroad-stamidpnr | `timing__setup__ws` | -5.118 |
| 31-openroad-stamidpnr | `timing__setup__ws__corner:nom_tt_025C_1v80` | -5.118 |
| 32-openroad-repairdesignpostgpl | `design__instance__area` | 130156 |
| 32-openroad-repairdesignpostgpl | `design__instance__area__class:multi_input_combinational_cell` | 71722 |
| 32-openroad-repairdesignpostgpl | `design__instance__area__class:timing_repair_buffer` | 7317 |
| 32-openroad-repairdesignpostgpl | `design__instance__area__stdcell` | 128820 |
| 32-openroad-repairdesignpostgpl | `design__instance__count` | 14008 |
| 32-openroad-repairdesignpostgpl | `design__instance__count__class:timing_repair_buffer` | 1242 |
| 32-openroad-repairdesignpostgpl | `design__instance__count__stdcell` | 13652 |
| 32-openroad-repairdesignpostgpl | `design__instance__utilization` | 0.5498 |
| 32-openroad-repairdesignpostgpl | `design__instance__utilization__stdcell` | 0.5498 |
| 32-openroad-repairdesignpostgpl | `route__wirelength__estimated` | 398186 |
| 34-openroad-detailedplacement | `design__instance__area` | 128820 |
| 34-openroad-detailedplacement | `design__instance__count` | 13652 |

## Báo cáo chi tiết của LibreLane

- `31-openroad-stamidpnr/checks.rpt`
- `31-openroad-stamidpnr/clock.rpt`
- `31-openroad-stamidpnr/max.rpt`
- `31-openroad-stamidpnr/min.rpt`
- `31-openroad-stamidpnr/power.rpt`
- `31-openroad-stamidpnr/skew.max.rpt`
- `31-openroad-stamidpnr/skew.min.rpt`
- `31-openroad-stamidpnr/tns.max.rpt`
- `31-openroad-stamidpnr/tns.min.rpt`
- `31-openroad-stamidpnr/unpropagated.rpt`
- `31-openroad-stamidpnr/violator_list.rpt`
- `31-openroad-stamidpnr/wns.max.rpt`
- `31-openroad-stamidpnr/wns.min.rpt`
- `31-openroad-stamidpnr/ws.max.rpt`
- `31-openroad-stamidpnr/ws.min.rpt`

## Đánh giá

**Kết luận: đạt (xem cùng báo cáo 3b).**

- Số liệu timing ở trên lấy từ STA chạy ngay sau global placement, trước Repair Design, chỉ ở corner tt: setup −5,12 ns, hold −14,01 ns, 7.719 vi phạm slew, 73 cap, 222 fanout. Đây là trạng thái trước khi sửa.
- Repair Design chèn 34 buffer cho cổng vào và 73 cho cổng ra, đều là `buf_2` (cấu hình fix3 đã loại các buffer yếu); phát hiện 205 net vi phạm slew, 221 net vi phạm fanout, 8 dây dài; chèn 1.135 buffer trên 262 net và đổi cỡ 12 cell.
- Diện tích cell tăng từ 121.438 lên 128.820 µm² (7.317 µm² là buffer sửa thiết kế), mật độ 55,0%; chiều dài dây ước lượng 398.186 µm.
- Detailed placement hợp lệ hóa vị trí cell, không thay đổi số cell.

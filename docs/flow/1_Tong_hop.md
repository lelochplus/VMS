# 1. Tong hop

Run `openlane/runs/step`, 12 step: 01-verilator-lint → 12-openroad-staprepnr

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Không có latch | `design__inferred_latch__count` | 0 |
| ĐẠT | Không có cell chưa ánh xạ | `design__instance_unmapped__count` | 0 |
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 6.075 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.01999 |
| KHÔNG ĐẠT | Không vi phạm max slew (ràng buộc 0,75 ns) | `design__max_slew_violation__count` | 5930 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 38 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 221 |

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 01-verilator-lint | `design__inferred_latch__count` | 0 |
| 06-yosys-synthesis | `design__instance__area` | 117271 |
| 06-yosys-synthesis | `design__instance__count` | 9080 |
| 06-yosys-synthesis | `design__instance_unmapped__count` | 0 |
| 06-yosys-synthesis | `synthesis__check_error__count` | 0 |
| 12-openroad-staprepnr | `clock__skew__worst_hold` | -1.218 |
| 12-openroad-staprepnr | `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -1.463 |
| 12-openroad-staprepnr | `clock__skew__worst_setup` | 1.218 |
| 12-openroad-staprepnr | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 1.463 |
| 12-openroad-staprepnr | `design__max_cap_violation__count` | 38 |
| 12-openroad-staprepnr | `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 16 |
| 12-openroad-staprepnr | `design__max_fanout_violation__count` | 221 |
| 12-openroad-staprepnr | `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 221 |
| 12-openroad-staprepnr | `design__max_slew_violation__count` | 5930 |
| 12-openroad-staprepnr | `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 3423 |
| 12-openroad-staprepnr | `power__internal__total` | 0.006242 |
| 12-openroad-staprepnr | `power__leakage__total` | 1.095e-07 |
| 12-openroad-staprepnr | `power__switching__total` | 0.001237 |
| 12-openroad-staprepnr | `power__total` | 0.00748 |
| 12-openroad-staprepnr | `timing__hold__tns` | 0 |
| 12-openroad-staprepnr | `timing__hold__tns__corner:nom_tt_025C_1v80` | 0 |
| 12-openroad-staprepnr | `timing__hold__wns` | 0 |
| 12-openroad-staprepnr | `timing__hold__wns__corner:nom_tt_025C_1v80` | 0 |
| 12-openroad-staprepnr | `timing__hold__ws` | 0.01999 |
| 12-openroad-staprepnr | `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.1572 |
| 12-openroad-staprepnr | `timing__setup__tns` | 0 |
| 12-openroad-staprepnr | `timing__setup__tns__corner:nom_tt_025C_1v80` | 0 |
| 12-openroad-staprepnr | `timing__setup__wns` | 0 |
| 12-openroad-staprepnr | `timing__setup__wns__corner:nom_tt_025C_1v80` | 0 |
| 12-openroad-staprepnr | `timing__setup__ws` | 6.075 |
| 12-openroad-staprepnr | `timing__setup__ws__corner:nom_tt_025C_1v80` | 13.24 |

## Báo cáo chi tiết của LibreLane

- `06-yosys-synthesis/reports/chk.rpt`
- `06-yosys-synthesis/reports/latch.rpt`
- `06-yosys-synthesis/reports/post_dff.json`
- `06-yosys-synthesis/reports/post_dff.rpt`
- `06-yosys-synthesis/reports/pre_synth_chk.rpt`
- `06-yosys-synthesis/reports/pre_techmap.json`
- `06-yosys-synthesis/reports/pre_techmap.rpt`
- `06-yosys-synthesis/reports/stat.json`
- `06-yosys-synthesis/reports/stat.rpt`
- `12-openroad-staprepnr/summary.rpt`

## Đánh giá

**Kết luận: đạt.**

- Netlist sau tổng hợp có 9.080 cell, diện tích 117.271 µm²; 2.119 flip-flop chiếm 45.072 µm² (38%), 6.828 cell tổ hợp chiếm 71.658 µm².
- Không có latch, không có cell chưa ánh xạ, kiểm tra tổng hợp 0 lỗi.
- STA trước P&R (chưa có dây, clock lý tưởng): setup slack +6,08 ns ở corner xấu nhất, +13,24 ns ở corner tt; hold slack +0,02 ns. Chỉ là mốc tham khảo; hold sát 0 sẽ được sửa sau CTS.
- Công suất ước lượng 7,48 mW, chưa tính cây clock và điện dung dây.
- 5.930 vi phạm slew, 38 cap, 221 fanout là các net có fanout lớn mà Yosys chưa chèn buffer (reset, chân chọn mux, bus); bước Repair Design ở giai đoạn 3 sẽ xử lý. Đây là mốc để so sánh sau giai đoạn 3.
- Số skew ±1,2 ns chưa có ý nghĩa vì cây clock chưa được dựng; so lại sau giai đoạn 4.

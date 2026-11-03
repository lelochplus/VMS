# Step 32: OpenROAD.RepairDesignPostGPL

Chèn buffer, đổi cỡ cell để sửa slew, cap, fanout. Giai đoạn: 3. Placement. Thời gian chạy: 00:00:25.916. Thư mục: `openlane/runs/chip/32-openroad-repairdesignpostgpl`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__instance__area` | 422273 | 435203 |
| `design__instance__area__class:multi_input_combinational_cell` | 82870 | 83031 |
| `design__instance__area__class:timing_repair_buffer` | – | 9143 |
| `design__instance__area__stdcell` | 137735 | 147039 |
| `design__instance__count` | 17204 | 19661 |
| `design__instance__count__class:timing_repair_buffer` | – | 1491 |
| `design__instance__count__stdcell` | 17203 | 18694 |
| `design__instance__utilization` | 0.5425 | 0.5545 |
| `design__instance__utilization__stdcell` | 0.2789 | 0.2977 |
| `route__wirelength__estimated` | – | 545114 |

## File báo cáo của LibreLane

- `openroad-repairdesignpostgpl.log`

Xem layout sau step này: `python3 scripts/step.py view 32`

## Đánh giá

(điền sau khi xem số liệu)

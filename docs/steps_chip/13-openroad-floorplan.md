# Step 13: OpenROAD.Floorplan

Tạo die, vùng core và các hàng cell (layout đầu tiên). Giai đoạn: 2. Floorplan + PDN. Thời gian chạy: 00:00:02.045. Thư mục: `openlane/runs/chip/13-openroad-floorplan`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__core__area` | – | 778377 |
| `design__die__area` | – | 810000 |
| `design__instance__area` | 129307 | 413845 |
| `design__instance__area__class:buffer` | – | 160.2 |
| `design__instance__area__class:inverter` | – | 503 |
| `design__instance__area__class:macro` | – | 284538 |
| `design__instance__area__class:multi_input_combinational_cell` | – | 82870 |
| `design__instance__area__class:sequential_cell` | – | 45774 |
| `design__instance__area__cover` | – | 0 |
| `design__instance__area__macros` | – | 284538 |
| `design__instance__area__padcells` | – | 0 |
| `design__instance__area__stdcell` | – | 129307 |
| `design__instance__count__class:buffer` | – | 32 |
| `design__instance__count__class:inverter` | – | 134 |
| `design__instance__count__class:macro` | – | 1 |
| `design__instance__count__class:multi_input_combinational_cell` | – | 8149 |
| `design__instance__count__class:sequential_cell` | – | 2152 |
| `design__instance__count__cover` | – | 0 |
| `design__instance__count__macros` | – | 1 |
| `design__instance__count__padcells` | – | 0 |
| `design__instance__count__stdcell` | – | 10467 |
| `design__instance__utilization` | – | 0.5317 |
| `design__instance__utilization__stdcell` | – | 0.2618 |

## File báo cáo của LibreLane

- `openroad-floorplan.log`

Xem layout sau step này: `python3 scripts/step.py view 13`

## Đánh giá

(điền sau khi xem số liệu)

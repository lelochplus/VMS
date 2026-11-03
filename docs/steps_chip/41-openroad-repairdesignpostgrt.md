# Step 41: OpenROAD.RepairDesignPostGRT

Sửa slew, cap sau global routing. Giai đoạn: 5. Routing. Thời gian chạy: 00:00:50.232. Thư mục: `openlane/runs/chip/41-openroad-repairdesignpostgrt`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__instance__area` | 452939 | 453397 |
| `design__instance__area__class:timing_repair_buffer` | 21848 | 22306 |
| `design__instance__area__stdcell` | 164774 | 165232 |
| `design__instance__count` | 23400 | 23440 |
| `design__instance__count__class:timing_repair_buffer` | 4876 | 4916 |
| `design__instance__count__stdcell` | 22433 | 22473 |
| `design__instance__utilization` | 0.5772 | 0.5778 |
| `design__instance__utilization__stdcell` | 0.3337 | 0.3346 |
| `global_route__wirelength` | 946459 | 948425 |
| `route__wirelength__estimated` | 589243 | 590822 |

## File báo cáo của LibreLane

- `openroad-repairdesignpostgrt.log`

Xem layout sau step này: `python3 scripts/step.py view 41`

## Đánh giá

(điền sau khi xem số liệu)

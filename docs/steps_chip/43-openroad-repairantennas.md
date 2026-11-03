# Step 43: OpenROAD.RepairAntennas

Chèn diode sửa vi phạm antenna. Giai đoạn: 5. Routing. Thời gian chạy: 00:01:04.032. Thư mục: `openlane/runs/chip/43-openroad-repairantennas`

Step này tạo hoặc thay đổi: ODB (layout), DEF (layout).

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Không có vi phạm antenna | `antenna__violating__nets` | 0 |
| ĐẠT | Không có vi phạm antenna | `antenna__violating__pins` | 0 |
| ĐẠT | Không có vi phạm antenna | `route__antenna_violation__count` | 0 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `antenna__violating__nets` | 124 | 0 |
| `antenna__violating__pins` | 152 | 0 |
| `antenna_diodes_count` | – | 59 |
| `design__instance__area` | 453397 | 453544 |
| `design__instance__area__class:antenna_cell` | – | 147.6 |
| `design__instance__area__stdcell` | 165232 | 165380 |
| `design__instance__count` | 23440 | 23499 |
| `design__instance__count__class:antenna_cell` | – | 59 |
| `design__instance__count__stdcell` | 22473 | 22532 |
| `design__instance__utilization` | 0.5778 | 0.578 |
| `design__instance__utilization__stdcell` | 0.3346 | 0.3349 |
| `route__antenna_violation__count` | 124 | 0 |

## File báo cáo của LibreLane

- `2-openroad-checkantennas/reports/antenna.rpt`
- `2-openroad-checkantennas/reports/antenna_summary.rpt`

Xem layout sau step này: `python3 scripts/step.py view 43`

## Đánh giá

(điền sau khi xem số liệu)

# Step 45: OpenROAD.DetailedRouting

Định tuyến chi tiết. Giai đoạn: 5. Routing. Thời gian chạy: 00:10:55.568. Thư mục: `openlane/runs/chip/45-openroad-detailedrouting`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Không có lỗi DRC | `route__drc_errors` | 0 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `antenna_diodes_count` | 59 | 68 |
| `design__instance__area` | 453544 | 453714 |
| `design__instance__area__class:antenna_cell` | 147.6 | 317.8 |
| `design__instance__area__stdcell` | 165380 | 165550 |
| `design__instance__count` | 23499 | 23567 |
| `design__instance__count__class:antenna_cell` | 59 | 127 |
| `design__instance__count__stdcell` | 22532 | 22600 |
| `design__instance__utilization` | 0.578 | 0.5782 |
| `design__instance__utilization__stdcell` | 0.3349 | 0.3352 |
| `route__drc_errors` | – | 0 |
| `route__wirelength` | – | 703513 |

## File báo cáo của LibreLane

- `openroad-detailedrouting.log`

Xem layout sau step này: `python3 scripts/step.py view 45`

## Đánh giá

(điền sau khi xem số liệu)

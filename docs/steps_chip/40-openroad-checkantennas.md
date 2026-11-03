# Step 40: OpenROAD.CheckAntennas

Kiểm tra antenna sau global routing. Giai đoạn: 5. Routing. Thời gian chạy: 00:00:14.719. Thư mục: `openlane/runs/chip/40-openroad-checkantennas`

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| KHÔNG ĐẠT | Không có vi phạm antenna | `antenna__violating__nets` | 124 |
| KHÔNG ĐẠT | Không có vi phạm antenna | `antenna__violating__pins` | 152 |
| KHÔNG ĐẠT | Không có vi phạm antenna | `route__antenna_violation__count` | 124 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `antenna__violating__nets` | – | 124 |
| `antenna__violating__pins` | – | 152 |
| `route__antenna_violation__count` | – | 124 |

## File báo cáo của LibreLane

- `openroad-checkantennas.log`
- `reports/antenna.rpt`
- `reports/antenna_summary.rpt`

Xem layout sau step này: `python3 scripts/step.py view 40`

## Đánh giá

(điền sau khi xem số liệu)

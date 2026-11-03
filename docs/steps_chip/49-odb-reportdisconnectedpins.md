# Step 49: Odb.ReportDisconnectedPins

Báo các chân bị hở. Giai đoạn: 5. Routing. Thời gian chạy: 00:00:01.823. Thư mục: `openlane/runs/chip/49-odb-reportdisconnectedpins`

Step này tạo hoặc thay đổi: ODB (layout), DEF (layout).

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Không có chân quan trọng bị hở | `design__critical_disconnected_pin__count` | 0 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__critical_disconnected_pin__count` | – | 0 |
| `design__disconnected_pin__count` | – | 32 |

## File báo cáo của LibreLane

- `odb-reportdisconnectedpins.log`

Xem layout sau step này: `python3 scripts/step.py view 49`

## Đánh giá

(điền sau khi xem số liệu)

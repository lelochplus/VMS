# Step 1: Verilator.Lint

Kiểm tra RTL bằng Verilator (lint). Giai đoạn: 1. Tổng hợp. Thời gian chạy: 00:00:03.682. Thư mục: `openlane/runs/chip/01-verilator-lint`

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Không có latch | `design__inferred_latch__count` | 0 |
| ĐẠT | Không có lỗi lint | `design__lint_error__count` | 0 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__inferred_latch__count` | – | 0 |
| `design__lint_error__count` | – | 0 |
| `design__lint_timing_construct__count` | – | 0 |
| `design__lint_warning__count` | – | 503 |

## File báo cáo của LibreLane

- `verilator-lint.log`

## Đánh giá

(điền sau khi xem số liệu)

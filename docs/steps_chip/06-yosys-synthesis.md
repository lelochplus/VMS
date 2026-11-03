# Step 6: Yosys.Synthesis

Tổng hợp RTL thành netlist cell sky130. Giai đoạn: 1. Tổng hợp. Thời gian chạy: 00:00:43.087. Thư mục: `openlane/runs/chip/06-yosys-synthesis`

Step này tạo hoặc thay đổi: netlist.

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Không có cell chưa ánh xạ | `design__instance_unmapped__count` | 0 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__instance__area` | – | 129307 |
| `design__instance__count` | – | 10468 |
| `design__instance_unmapped__count` | – | 0 |
| `synthesis__check_error__count` | – | 0 |

## File báo cáo của LibreLane

- `reports/chk.rpt`
- `reports/latch.rpt`
- `reports/post_dff.json`
- `reports/post_dff.rpt`
- `reports/pre_synth_chk.rpt`
- `reports/pre_techmap.json`
- `reports/pre_techmap.rpt`
- `reports/stat.json`
- `reports/stat.rpt`
- `yosys-synthesis.log`

## Đánh giá

(điền sau khi xem số liệu)

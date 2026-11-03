# Step 35: OpenROAD.CTS

Tổng hợp cây clock. Giai đoạn: 4. CTS. Thời gian chạy: 00:00:35.347. Thư mục: `openlane/runs/chip/35-openroad-cts`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__instance__area` | 431577 | 440233 |
| `design__instance__area__class:clock_buffer` | – | 4743 |
| `design__instance__area__class:clock_inverter` | – | 286.5 |
| `design__instance__area__stdcell` | 147039 | 152068 |
| `design__instance__count` | 18695 | 20015 |
| `design__instance__count__class:clock_buffer` | – | 330 |
| `design__instance__count__class:clock_inverter` | – | 24 |
| `design__instance__count__stdcell` | 18694 | 19048 |
| `design__instance__utilization` | 0.5545 | 0.5609 |
| `design__instance__utilization__stdcell` | 0.2977 | 0.3079 |
| `route__wirelength__estimated` | 545114 | 568628 |

## File báo cáo của LibreLane

- `cts.rpt`
- `openroad-cts.log`

Xem layout sau step này: `python3 scripts/step.py view 35`

## Đánh giá

(điền sau khi xem số liệu)

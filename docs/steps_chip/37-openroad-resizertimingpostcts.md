# Step 37: OpenROAD.ResizerTimingPostCTS

Sửa setup/hold sau CTS. Giai đoạn: 4. CTS. Thời gian chạy: 00:01:50.305. Thư mục: `openlane/runs/chip/37-openroad-resizertimingpostcts`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__instance__area` | 440233 | 452939 |
| `design__instance__area__class:timing_repair_buffer` | 9143 | 21848 |
| `design__instance__area__stdcell` | 152068 | 164774 |
| `design__instance__count` | 20015 | 23400 |
| `design__instance__count__class:timing_repair_buffer` | 1491 | 4876 |
| `design__instance__count__hold_buffer` | – | 3385 |
| `design__instance__count__setup_buffer` | – | 0 |
| `design__instance__count__stdcell` | 19048 | 22433 |
| `design__instance__utilization` | 0.5609 | 0.5772 |
| `design__instance__utilization__stdcell` | 0.3079 | 0.3337 |
| `route__wirelength__estimated` | 568628 | 589243 |

## File báo cáo của LibreLane

- `openroad-resizertimingpostcts.log`

Xem layout sau step này: `python3 scripts/step.py view 37`

## Đánh giá

(điền sau khi xem số liệu)

# Step 19: OpenROAD.TapEndcapInsertion

Chèn tap cell và endcap. Giai đoạn: 2. Floorplan + PDN. Thời gian chạy: 00:00:01.115. Thư mục: `openlane/runs/chip/19-openroad-tapendcapinsertion`

Step này tạo hoặc thay đổi: netlist, ODB (layout), DEF (layout), SDC, netlist có chân nguồn.

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `design__instance__area` | 413845 | 425899 |
| `design__instance__area__class:fill_cell` | – | 3626 |
| `design__instance__area__class:tap_cell` | – | 8428 |
| `design__instance__area__stdcell` | 129307 | 137735 |
| `design__instance__count` | 10468 | 18170 |
| `design__instance__count__class:fill_cell` | – | 966 |
| `design__instance__count__class:tap_cell` | – | 6736 |
| `design__instance__count__stdcell` | 10467 | 17203 |
| `design__instance__utilization` | 0.5317 | 0.5425 |
| `design__instance__utilization__stdcell` | 0.2618 | 0.2789 |

## File báo cáo của LibreLane

- `openroad-tapendcapinsertion.log`

Xem layout sau step này: `python3 scripts/step.py view 19`

## Đánh giá

(điền sau khi xem số liệu)

# 2. Floorplan va PDN

Run `openlane/runs/step`, 9 step: 13-openroad-floorplan → 21-openroad-generatepdn

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 13-openroad-floorplan | `design__core__area` | 234295 |
| 13-openroad-floorplan | `design__die__area` | 250667 |
| 13-openroad-floorplan | `design__instance__area` | 117271 |
| 13-openroad-floorplan | `design__instance__area__class:buffer` | 170.2 |
| 13-openroad-floorplan | `design__instance__area__class:inverter` | 371.6 |
| 13-openroad-floorplan | `design__instance__area__class:multi_input_combinational_cell` | 71658 |
| 13-openroad-floorplan | `design__instance__area__class:sequential_cell` | 45072 |
| 13-openroad-floorplan | `design__instance__area__cover` | 0 |
| 13-openroad-floorplan | `design__instance__area__macros` | 0 |
| 13-openroad-floorplan | `design__instance__area__padcells` | 0 |
| 13-openroad-floorplan | `design__instance__area__stdcell` | 117271 |
| 13-openroad-floorplan | `design__instance__count__class:buffer` | 34 |
| 13-openroad-floorplan | `design__instance__count__class:inverter` | 99 |
| 13-openroad-floorplan | `design__instance__count__class:multi_input_combinational_cell` | 6828 |
| 13-openroad-floorplan | `design__instance__count__class:sequential_cell` | 2119 |
| 13-openroad-floorplan | `design__instance__count__cover` | 0 |
| 13-openroad-floorplan | `design__instance__count__macros` | 0 |
| 13-openroad-floorplan | `design__instance__count__padcells` | 0 |
| 13-openroad-floorplan | `design__instance__count__stdcell` | 9080 |
| 13-openroad-floorplan | `design__instance__utilization` | 0.5005 |
| 13-openroad-floorplan | `design__instance__utilization__stdcell` | 0.5005 |
| 19-openroad-tapendcapinsertion | `design__instance__area` | 122774 |
| 19-openroad-tapendcapinsertion | `design__instance__area__class:fill_cell` | 1336 |
| 19-openroad-tapendcapinsertion | `design__instance__area__class:tap_cell` | 4166 |
| 19-openroad-tapendcapinsertion | `design__instance__area__stdcell` | 121438 |
| 19-openroad-tapendcapinsertion | `design__instance__count` | 12766 |
| 19-openroad-tapendcapinsertion | `design__instance__count__class:fill_cell` | 356 |
| 19-openroad-tapendcapinsertion | `design__instance__count__class:tap_cell` | 3330 |
| 19-openroad-tapendcapinsertion | `design__instance__count__stdcell` | 12410 |
| 19-openroad-tapendcapinsertion | `design__instance__utilization` | 0.5183 |
| 19-openroad-tapendcapinsertion | `design__instance__utilization__stdcell` | 0.5183 |
| 21-openroad-generatepdn | `design__instance__area` | 121438 |
| 21-openroad-generatepdn | `design__instance__count` | 12410 |

## Báo cáo chi tiết của LibreLane

- `14-openroad-dumprcvalues/layer_values_after.rpt`
- `14-openroad-dumprcvalues/resizer_values_after.rpt`
- `14-openroad-dumprcvalues/tlef_values.rpt`
- `21-openroad-generatepdn/VGND-grid-errors.rpt`
- `21-openroad-generatepdn/VPWR-grid-errors.rpt`

## Đánh giá

**Kết luận: đạt.**

- Die 250.667 µm², vùng core 234.295 µm².
- Mật độ cell 50,05%: floorplan được tính để cell chiếm một nửa core, nửa còn lại cho buffer sửa thiết kế, cây clock và đi dây.
- Chèn 3.330 tap cell (4.166 µm²) và 356 cell endcap ở hai đầu 178 hàng cell; mật độ tăng lên 51,8%.
- Lưới nguồn VPWR/VGND đã được tạo. File lỗi lưới nguồn: `VGND-grid-errors.rpt` rỗng (không có lỗi); `VPWR-grid-errors.rpt` rỗng (không có lỗi).

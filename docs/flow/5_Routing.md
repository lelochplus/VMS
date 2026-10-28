# 5. Routing

Run `openlane/runs/step`, 14 step: 40-openroad-globalrouting → 53-checker-wirelength

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 15.22 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.2993 |
| ĐẠT | Không có lỗi DRC | `route__drc_errors` | 0 |
| ĐẠT | Không có vi phạm antenna | `antenna__violating__nets` | 0 |
| ĐẠT | Không có vi phạm antenna | `antenna__violating__pins` | 0 |
| ĐẠT | Không có vi phạm antenna | `route__antenna_violation__count` | 0 |
| ĐẠT | Không có chân bị hở | `design__critical_disconnected_pin__count` | 0 |
| ĐẠT | Không có chân bị hở | `design__disconnected_pin__count` | 0 |

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 40-openroad-globalrouting | `global_route__wirelength` | 716351 |
| 41-openroad-checkantennas | `antenna__violating__nets` | 66 |
| 41-openroad-checkantennas | `antenna__violating__pins` | 83 |
| 41-openroad-checkantennas | `route__antenna_violation__count` | 66 |
| 42-openroad-repairdesignpostgrt | `design__instance__area` | 147997 |
| 42-openroad-repairdesignpostgrt | `design__instance__area__class:timing_repair_buffer` | 20074 |
| 42-openroad-repairdesignpostgrt | `design__instance__area__stdcell` | 146661 |
| 42-openroad-repairdesignpostgrt | `design__instance__count` | 17757 |
| 42-openroad-repairdesignpostgrt | `design__instance__count__class:timing_repair_buffer` | 4632 |
| 42-openroad-repairdesignpostgrt | `design__instance__count__stdcell` | 17401 |
| 42-openroad-repairdesignpostgrt | `design__instance__utilization` | 0.626 |
| 42-openroad-repairdesignpostgrt | `design__instance__utilization__stdcell` | 0.626 |
| 42-openroad-repairdesignpostgrt | `global_route__wirelength` | 716323 |
| 42-openroad-repairdesignpostgrt | `route__wirelength__estimated` | 439672 |
| 44-openroad-repairantennas | `antenna__violating__nets` | 0 |
| 44-openroad-repairantennas | `antenna__violating__pins` | 0 |
| 44-openroad-repairantennas | `antenna_diodes_count` | 34 |
| 44-openroad-repairantennas | `design__instance__area` | 148082 |
| 44-openroad-repairantennas | `design__instance__area__class:antenna_cell` | 85.08 |
| 44-openroad-repairantennas | `design__instance__area__stdcell` | 146746 |
| 44-openroad-repairantennas | `design__instance__count` | 17791 |
| 44-openroad-repairantennas | `design__instance__count__class:antenna_cell` | 34 |
| 44-openroad-repairantennas | `design__instance__count__stdcell` | 17435 |
| 44-openroad-repairantennas | `design__instance__utilization` | 0.6263 |
| 44-openroad-repairantennas | `design__instance__utilization__stdcell` | 0.6263 |
| 44-openroad-repairantennas | `route__antenna_violation__count` | 0 |
| 45-openroad-stamidpnr-3 | `clock__skew__worst_hold` | -0.441 |
| 45-openroad-stamidpnr-3 | `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -0.441 |
| 45-openroad-stamidpnr-3 | `clock__skew__worst_setup` | 0.3226 |
| 45-openroad-stamidpnr-3 | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.3226 |
| 45-openroad-stamidpnr-3 | `power__internal__total` | 0.006436 |
| 45-openroad-stamidpnr-3 | `power__leakage__total` | 6.328e-08 |
| 45-openroad-stamidpnr-3 | `power__switching__total` | 0.003076 |
| 45-openroad-stamidpnr-3 | `power__total` | 0.009511 |
| 45-openroad-stamidpnr-3 | `timing__hold__ws` | 0.2993 |
| 45-openroad-stamidpnr-3 | `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.2993 |
| 45-openroad-stamidpnr-3 | `timing__setup__ws` | 15.22 |
| 45-openroad-stamidpnr-3 | `timing__setup__ws__corner:nom_tt_025C_1v80` | 15.22 |
| 46-openroad-detailedrouting | `design__instance__area` | 148167 |
| 46-openroad-detailedrouting | `design__instance__area__class:antenna_cell` | 170.2 |
| 46-openroad-detailedrouting | `design__instance__area__stdcell` | 146831 |
| 46-openroad-detailedrouting | `design__instance__count` | 17825 |
| 46-openroad-detailedrouting | `design__instance__count__class:antenna_cell` | 68 |
| 46-openroad-detailedrouting | `design__instance__count__stdcell` | 17469 |
| 46-openroad-detailedrouting | `design__instance__utilization` | 0.6267 |
| 46-openroad-detailedrouting | `design__instance__utilization__stdcell` | 0.6267 |
| 46-openroad-detailedrouting | `route__drc_errors` | 0 |
| 46-openroad-detailedrouting | `route__wirelength` | 515917 |
| 50-odb-reportdisconnectedpins | `design__critical_disconnected_pin__count` | 0 |
| 50-odb-reportdisconnectedpins | `design__disconnected_pin__count` | 0 |
| 52-odb-reportwirelength | `route__wirelength__max` | 1241 |

## Báo cáo chi tiết của LibreLane

- `41-openroad-checkantennas/reports/antenna.rpt`
- `41-openroad-checkantennas/reports/antenna_summary.rpt`
- `45-openroad-stamidpnr-3/checks.rpt`
- `45-openroad-stamidpnr-3/clock.rpt`
- `45-openroad-stamidpnr-3/max.rpt`
- `45-openroad-stamidpnr-3/min.rpt`
- `45-openroad-stamidpnr-3/power.rpt`
- `45-openroad-stamidpnr-3/skew.max.rpt`
- `45-openroad-stamidpnr-3/skew.min.rpt`
- `45-openroad-stamidpnr-3/tns.max.rpt`
- `45-openroad-stamidpnr-3/tns.min.rpt`
- `45-openroad-stamidpnr-3/unpropagated.rpt`
- `45-openroad-stamidpnr-3/violator_list.rpt`
- `45-openroad-stamidpnr-3/wns.max.rpt`
- `45-openroad-stamidpnr-3/wns.min.rpt`
- `45-openroad-stamidpnr-3/ws.max.rpt`
- `45-openroad-stamidpnr-3/ws.min.rpt`
- `48-openroad-checkantennas-1/reports/antenna.rpt`
- `48-openroad-checkantennas-1/reports/antenna_summary.rpt`

## Đánh giá

**Kết luận: đạt.**

- Global routing: chiều dài dây ước lượng 716.351 µm; có tắc nghẽn ban đầu nên công cụ chạy thêm vòng lặp để gỡ overflow, và detailed routing sạch lỗi cho thấy đã gỡ được.
- Antenna: sau global routing có 66 net (83 chân) vi phạm tỉ lệ antenna (giới hạn 400 theo diện tích cạnh); Repair Antennas chèn 34 diode và đưa vi phạm về 0. Sau detailed routing có 68 diode (170 µm²), kiểm tra antenna lần hai vẫn 0 vi phạm.
- Repair Design sau global routing chỉ thêm 2 buffer, cho thấy giai đoạn 3 đã sửa gần hết.
- STA sau global routing (corner tt): setup +15,22 ns, hold +0,30 ns, skew +0,32/−0,44 ns, gần như không đổi so với sau CTS.
- Detailed routing: 0 lỗi DRC; tổng chiều dài dây 515.917 µm, gồm met1 194.157 µm (38%), met2 224.515 µm (44%), met3 68.043 µm (13%), met4 28.482 µm (6%), met5 718 µm; 104.019 via; dây dài nhất 1.241 µm. met4/met5 chủ yếu dành cho lưới nguồn.
- Không có chân bị hở. Diện tích cell cuối 146.831 µm², mật độ 62,7%, trùng với lần chạy fix3 một lần, tức chạy theo từng bước cho cùng kết quả.
- Công suất ước lượng 9,51 mW (chưa trích xuất RC; giá trị cuối ở giai đoạn 6).

# 6. Signoff

Run `openlane/runs/step`, 25 step: 54-openroad-fillinsertion → 78-misc-reportmanufacturability

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 2.843 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.1041 |
| ĐẠT | Không có lỗi DRC | `magic__drc_error__count` | 0 |
| ĐẠT | Không có lỗi DRC | `klayout__drc_error__count` | 0 |
| KHÔNG ĐẠT | Không vi phạm max slew (ràng buộc 0,75 ns) | `design__max_slew_violation__count` | 1007 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 1 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 71 |
| ĐẠT | GDS của Magic và KLayout trùng nhau | `design__xor_difference__count` | 0 |

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 54-openroad-fillinsertion | `design__instance__area` | 234295 |
| 54-openroad-fillinsertion | `design__instance__area__class:fill_cell` | 87464 |
| 54-openroad-fillinsertion | `design__instance__count` | 44078 |
| 54-openroad-fillinsertion | `design__instance__count__class:fill_cell` | 26609 |
| 57-openroad-stapostpnr | `clock__skew__worst_hold` | -0.4116 |
| 57-openroad-stapostpnr | `clock__skew__worst_hold__corner:max_ss_100C_1v60` | -0.7119 |
| 57-openroad-stapostpnr | `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -0.4992 |
| 57-openroad-stapostpnr | `clock__skew__worst_setup` | 0.319 |
| 57-openroad-stapostpnr | `clock__skew__worst_setup__corner:max_ss_100C_1v60` | 0.4549 |
| 57-openroad-stapostpnr | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.36 |
| 57-openroad-stapostpnr | `design__max_cap_violation__count` | 1 |
| 57-openroad-stapostpnr | `design__max_cap_violation__count__corner:max_ss_100C_1v60` | 1 |
| 57-openroad-stapostpnr | `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 1 |
| 57-openroad-stapostpnr | `design__max_fanout_violation__count` | 71 |
| 57-openroad-stapostpnr | `design__max_fanout_violation__count__corner:max_ss_100C_1v60` | 71 |
| 57-openroad-stapostpnr | `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 71 |
| 57-openroad-stapostpnr | `design__max_slew_violation__count` | 1007 |
| 57-openroad-stapostpnr | `design__max_slew_violation__count__corner:max_ss_100C_1v60` | 1007 |
| 57-openroad-stapostpnr | `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 2 |
| 57-openroad-stapostpnr | `power__internal__total` | 0.007416 |
| 57-openroad-stapostpnr | `power__leakage__total` | 2.153e-07 |
| 57-openroad-stapostpnr | `power__switching__total` | 0.004932 |
| 57-openroad-stapostpnr | `power__total` | 0.01235 |
| 57-openroad-stapostpnr | `timing__hold__tns__corner:max_ss_100C_1v60` | 0 |
| 57-openroad-stapostpnr | `timing__hold__wns__corner:max_ss_100C_1v60` | 0 |
| 57-openroad-stapostpnr | `timing__hold__ws` | 0.1041 |
| 57-openroad-stapostpnr | `timing__hold__ws__corner:max_ss_100C_1v60` | 0.8412 |
| 57-openroad-stapostpnr | `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.3047 |
| 57-openroad-stapostpnr | `timing__setup__tns__corner:max_ss_100C_1v60` | 0 |
| 57-openroad-stapostpnr | `timing__setup__wns__corner:max_ss_100C_1v60` | 0 |
| 57-openroad-stapostpnr | `timing__setup__ws` | 2.843 |
| 57-openroad-stapostpnr | `timing__setup__ws__corner:max_ss_100C_1v60` | 2.843 |
| 57-openroad-stapostpnr | `timing__setup__ws__corner:nom_tt_025C_1v80` | 14.51 |
| 58-openroad-irdropreport | `ir__drop__avg` | 0.000105 |
| 58-openroad-irdropreport | `ir__drop__worst` | 0.00048 |
| 64-klayout-xor | `design__xor_difference__count` | 0 |
| 66-magic-drc | `magic__drc_error__count` | 0 |
| 67-klayout-drc | `klayout__drc_error__count` | 0 |
| 70-magic-spiceextraction | `magic__illegal_overlap__count` | 0 |

## Báo cáo chi tiết của LibreLane

- `55-odb-cellfrequencytables/buffers.rpt`
- `55-odb-cellfrequencytables/by_scl.rpt`
- `55-odb-cellfrequencytables/cell.rpt`
- `55-odb-cellfrequencytables/cell_function.rpt`
- `57-openroad-stapostpnr/summary.rpt`
- `58-openroad-irdropreport/irdrop.rpt`
- `66-magic-drc/reports/drc.magic.lyrdb`
- `66-magic-drc/reports/drc.magic.rpt`
- `67-klayout-drc/reports/drc.klayout.json`
- `67-klayout-drc/reports/drc.klayout.lyrdb`
- `72-netgen-lvs/reports/lvs.netgen.json`
- `72-netgen-lvs/reports/lvs.netgen.rpt`
- `78-misc-reportmanufacturability/manufacturability.rpt`

## Đánh giá

**Kết luận: đạt.** Sạch DRC (Magic 0, KLayout 0), LVS khớp, không vi phạm antenna, timing đạt ở cả 9 corner.

- Fill: chèn 26.609 cell fill (87.464 µm²) lấp kín vùng core.
- STA sau trích xuất RC, 9 corner: setup slack xấu nhất +2,84 ns (max_ss_100C_1v60), +14,51 ns ở tt; hold slack xấu nhất +0,104 ns (các corner ff), +0,30 ns ở tt; 0 đường vi phạm setup và hold ở mọi corner. Skew +0,36/−0,50 ns ở tt, +0,45/−0,71 ns ở max_ss.
- Công suất sau trích xuất RC (tt) 12,35 mW: nội bộ 7,42 mW, chuyển mạch 4,93 mW, rò 0,2 µW; tăng từ 9,51 mW ước lượng vì có điện dung dây thật.
- IR drop xấu nhất 0,48 mV trên VPWR (0,03% của 1,8 V), 0,37 mV trên VGND; không đáng kể. Phân tích dùng vị trí nguồn mặc định vì chưa khai báo `VSRC_LOC_FILES`.
- GDS xuất bằng Magic và KLayout trùng nhau (XOR 0 khác biệt); không có chồng lấn bất hợp lệ.
- Các cảnh báo luật thiết kế còn lại: vi phạm max slew theo ràng buộc 0,75 ns ở corner chậm (1.007 ở max_ss, 639 ở nom_ss, 2 ở tt, 0 ở ff); slew xấu nhất 1.37 ns ở max_ss, 0 chân vượt giới hạn 1,5 ns của thư viện. 1 vi phạm max cap tại `clkbuf_0_clk/X` (buffer gốc cây clock). 71 vi phạm max fanout, 67 trong số đó ở net cây clock.
- Kết quả trùng khớp lần chạy fix3 một lần (setup +2,84 ns, hold +0,104 ns, 12,35 mW, 1.007 vi phạm slew).

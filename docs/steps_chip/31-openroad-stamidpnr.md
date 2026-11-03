# Step 31: OpenROAD.STAMidPNR

STA sau global placement. Giai đoạn: 3. Placement. Thời gian chạy: 00:00:14.929. Thư mục: `openlane/runs/chip/31-openroad-stamidpnr`

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| KHÔNG ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | -1.699 |
| KHÔNG ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | -12.48 |
| KHÔNG ĐẠT | Không vi phạm max slew | `design__max_slew_violation__count` | 9181 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 91 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 311 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `clock__skew__worst_hold` | -6.637 | -10.31 |
| `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -7.559 | -10.31 |
| `clock__skew__worst_setup` | -6.368 | -7.261 |
| `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | -5.23 | -7.261 |
| `design__max_cap_violation__count` | 36 | 91 |
| `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 19 | 91 |
| `design__max_fanout_violation__count` | 310 | 311 |
| `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 310 | 311 |
| `design__max_slew_violation__count` | 7135 | 9181 |
| `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 4021 | 9181 |
| `power__internal__total` | 0.00735 | 0.00826 |
| `power__leakage__total` | 1.785e-05 | 1.778e-05 |
| `power__switching__total` | 0.001636 | 0.002396 |
| `power__total` | 0.009004 | 0.01067 |
| `timing__hold__tns` | 0 | -16979 |
| `timing__hold__tns__corner:nom_tt_025C_1v80` | 0 | -16979 |
| `timing__hold__wns` | 0 | -12.48 |
| `timing__hold__wns__corner:nom_tt_025C_1v80` | 0 | -12.48 |
| `timing__hold__ws` | 0.0232 | -12.48 |
| `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.1727 | -12.48 |
| `timing__setup__tns` | 0 | -3.37 |
| `timing__setup__tns__corner:nom_tt_025C_1v80` | 0 | -3.37 |
| `timing__setup__wns` | 0 | -1.699 |
| `timing__setup__wns__corner:nom_tt_025C_1v80` | 0 | -1.699 |
| `timing__setup__ws` | 5.908 | -1.699 |
| `timing__setup__ws__corner:nom_tt_025C_1v80` | 10.91 | -1.699 |

## File báo cáo của LibreLane

- `checks.rpt`
- `clock.rpt`
- `max.rpt`
- `min.rpt`
- `openroad-stamidpnr.log`
- `power.rpt`
- `skew.max.rpt`
- `skew.min.rpt`
- `tns.max.rpt`
- `tns.min.rpt`
- `unpropagated.rpt`
- `violator_list.rpt`
- `wns.max.rpt`
- `wns.min.rpt`
- `ws.max.rpt`
- `ws.min.rpt`

Xem layout sau step này: `python3 scripts/step.py view 31`

## Đánh giá

(điền sau khi xem số liệu)

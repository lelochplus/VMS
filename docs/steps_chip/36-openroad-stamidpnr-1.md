# Step 36: OpenROAD.STAMidPNR-1

STA sau CTS. Giai đoạn: 4. CTS. Thời gian chạy: 00:00:10.962. Thư mục: `openlane/runs/chip/36-openroad-stamidpnr-1`

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 10.8 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.1407 |
| KHÔNG ĐẠT | Không vi phạm max slew | `design__max_slew_violation__count` | 13 |
| ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 0 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 127 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `clock__skew__worst_hold` | -10.31 | -0.618 |
| `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -10.31 | -0.618 |
| `clock__skew__worst_setup` | -7.261 | 0.5833 |
| `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | -7.261 | 0.5833 |
| `design__max_cap_violation__count` | 91 | 0 |
| `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 91 | 0 |
| `design__max_fanout_violation__count` | 311 | 127 |
| `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 311 | 127 |
| `design__max_slew_violation__count` | 9181 | 13 |
| `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 9181 | 13 |
| `power__internal__total` | 0.00826 | 0.007997 |
| `power__leakage__total` | 1.778e-05 | 1.779e-05 |
| `power__switching__total` | 0.002396 | 0.003624 |
| `power__total` | 0.01067 | 0.01164 |
| `timing__hold__tns` | -16979 | 0 |
| `timing__hold__tns__corner:nom_tt_025C_1v80` | -16979 | 0 |
| `timing__hold__wns` | -12.48 | 0 |
| `timing__hold__wns__corner:nom_tt_025C_1v80` | -12.48 | 0 |
| `timing__hold__ws` | -12.48 | 0.1407 |
| `timing__hold__ws__corner:nom_tt_025C_1v80` | -12.48 | 0.1407 |
| `timing__setup__tns` | -3.37 | 0 |
| `timing__setup__tns__corner:nom_tt_025C_1v80` | -3.37 | 0 |
| `timing__setup__wns` | -1.699 | 0 |
| `timing__setup__wns__corner:nom_tt_025C_1v80` | -1.699 | 0 |
| `timing__setup__ws` | -1.699 | 10.8 |
| `timing__setup__ws__corner:nom_tt_025C_1v80` | -1.699 | 10.8 |

## File báo cáo của LibreLane

- `checks.rpt`
- `clock.rpt`
- `max.rpt`
- `min.rpt`
- `openroad-stamidpnr-1.log`
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

Xem layout sau step này: `python3 scripts/step.py view 36`

## Đánh giá

(điền sau khi xem số liệu)

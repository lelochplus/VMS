# Step 56: OpenROAD.STAPostPNR

STA signoff ở 9 corner. Giai đoạn: 6. Signoff. Thời gian chạy: 00:00:38.899. Thư mục: `openlane/runs/chip/56-openroad-stapostpnr`

Step này tạo hoặc thay đổi: SDF, Liberty.

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 3.846 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.04264 |
| KHÔNG ĐẠT | Không vi phạm max slew | `design__max_slew_violation__count` | 2166 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 5 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 135 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `clock__skew__worst_hold` | -0.6462 | -0.6359 |
| `clock__skew__worst_hold__corner:max_ss_100C_1v60` | – | -1.336 |
| `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -0.6462 | -0.848 |
| `clock__skew__worst_setup` | 0.6087 | 0.5841 |
| `clock__skew__worst_setup__corner:max_ss_100C_1v60` | – | 1.183 |
| `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.6087 | 0.7632 |
| `design__max_cap_violation__count` | 0 | 5 |
| `design__max_cap_violation__count__corner:max_ss_100C_1v60` | – | 5 |
| `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 0 | 4 |
| `design__max_fanout_violation__count` | 128 | 135 |
| `design__max_fanout_violation__count__corner:max_ss_100C_1v60` | – | 135 |
| `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 128 | 135 |
| `design__max_slew_violation__count` | 13 | 2166 |
| `design__max_slew_violation__count__corner:max_ss_100C_1v60` | – | 2166 |
| `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 13 | 17 |
| `power__internal__total` | 0.008127 | 0.009148 |
| `power__leakage__total` | 1.78e-05 | 1.817e-05 |
| `power__switching__total` | 0.004043 | 0.007138 |
| `power__total` | 0.01219 | 0.0163 |
| `timing__hold__tns__corner:max_ss_100C_1v60` | – | 0 |
| `timing__hold__wns__corner:max_ss_100C_1v60` | – | 0 |
| `timing__hold__ws` | 0.2145 | 0.04264 |
| `timing__hold__ws__corner:max_ss_100C_1v60` | – | 0.7258 |
| `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.2145 | 0.2198 |
| `timing__setup__tns__corner:max_ss_100C_1v60` | – | 0 |
| `timing__setup__wns__corner:max_ss_100C_1v60` | – | 0 |
| `timing__setup__ws` | 10.72 | 3.846 |
| `timing__setup__ws__corner:max_ss_100C_1v60` | – | 3.846 |
| `timing__setup__ws__corner:nom_tt_025C_1v80` | 10.72 | 10.7 |

## File báo cáo của LibreLane

- `max_ff_n40C_1v95/checks.rpt`
- `max_ff_n40C_1v95/clock.rpt`
- `max_ff_n40C_1v95/max.rpt`
- `max_ff_n40C_1v95/min.rpt`
- `max_ff_n40C_1v95/power.rpt`
- `max_ff_n40C_1v95/skew.max.rpt`
- `max_ff_n40C_1v95/skew.min.rpt`
- `max_ff_n40C_1v95/tns.max.rpt`
- `max_ff_n40C_1v95/tns.min.rpt`
- `max_ff_n40C_1v95/unpropagated.rpt`
- `max_ff_n40C_1v95/violator_list.rpt`
- `max_ff_n40C_1v95/wns.max.rpt`
- `max_ff_n40C_1v95/wns.min.rpt`
- `max_ff_n40C_1v95/ws.max.rpt`
- `max_ff_n40C_1v95/ws.min.rpt`
- `max_ss_100C_1v60/checks.rpt`
- `max_ss_100C_1v60/clock.rpt`
- `max_ss_100C_1v60/max.rpt`
- `max_ss_100C_1v60/min.rpt`
- `max_ss_100C_1v60/power.rpt`
- `max_ss_100C_1v60/skew.max.rpt`
- `max_ss_100C_1v60/skew.min.rpt`
- `max_ss_100C_1v60/tns.max.rpt`
- `max_ss_100C_1v60/tns.min.rpt`
- `max_ss_100C_1v60/unpropagated.rpt`
- `max_ss_100C_1v60/violator_list.rpt`
- `max_ss_100C_1v60/wns.max.rpt`
- `max_ss_100C_1v60/wns.min.rpt`
- `max_ss_100C_1v60/ws.max.rpt`
- `max_ss_100C_1v60/ws.min.rpt`
- `max_tt_025C_1v80/checks.rpt`
- `max_tt_025C_1v80/clock.rpt`
- `max_tt_025C_1v80/max.rpt`
- `max_tt_025C_1v80/min.rpt`
- `max_tt_025C_1v80/power.rpt`
- `max_tt_025C_1v80/skew.max.rpt`
- `max_tt_025C_1v80/skew.min.rpt`
- `max_tt_025C_1v80/tns.max.rpt`
- `max_tt_025C_1v80/tns.min.rpt`
- `max_tt_025C_1v80/unpropagated.rpt`
- `max_tt_025C_1v80/violator_list.rpt`
- `max_tt_025C_1v80/wns.max.rpt`
- `max_tt_025C_1v80/wns.min.rpt`
- `max_tt_025C_1v80/ws.max.rpt`
- `max_tt_025C_1v80/ws.min.rpt`
- `min_ff_n40C_1v95/checks.rpt`
- `min_ff_n40C_1v95/clock.rpt`
- `min_ff_n40C_1v95/max.rpt`
- `min_ff_n40C_1v95/min.rpt`
- `min_ff_n40C_1v95/power.rpt`
- `min_ff_n40C_1v95/skew.max.rpt`
- `min_ff_n40C_1v95/skew.min.rpt`
- `min_ff_n40C_1v95/tns.max.rpt`
- `min_ff_n40C_1v95/tns.min.rpt`
- `min_ff_n40C_1v95/unpropagated.rpt`
- `min_ff_n40C_1v95/violator_list.rpt`
- `min_ff_n40C_1v95/wns.max.rpt`
- `min_ff_n40C_1v95/wns.min.rpt`
- `min_ff_n40C_1v95/ws.max.rpt`
- `min_ff_n40C_1v95/ws.min.rpt`
- `min_ss_100C_1v60/checks.rpt`
- `min_ss_100C_1v60/clock.rpt`
- `min_ss_100C_1v60/max.rpt`
- `min_ss_100C_1v60/min.rpt`
- `min_ss_100C_1v60/power.rpt`
- `min_ss_100C_1v60/skew.max.rpt`
- `min_ss_100C_1v60/skew.min.rpt`
- `min_ss_100C_1v60/tns.max.rpt`
- `min_ss_100C_1v60/tns.min.rpt`
- `min_ss_100C_1v60/unpropagated.rpt`
- `min_ss_100C_1v60/violator_list.rpt`
- `min_ss_100C_1v60/wns.max.rpt`
- `min_ss_100C_1v60/wns.min.rpt`
- `min_ss_100C_1v60/ws.max.rpt`
- `min_ss_100C_1v60/ws.min.rpt`
- `min_tt_025C_1v80/checks.rpt`
- `min_tt_025C_1v80/clock.rpt`
- `min_tt_025C_1v80/max.rpt`
- `min_tt_025C_1v80/min.rpt`
- `min_tt_025C_1v80/power.rpt`
- `min_tt_025C_1v80/skew.max.rpt`
- `min_tt_025C_1v80/skew.min.rpt`
- `min_tt_025C_1v80/tns.max.rpt`
- `min_tt_025C_1v80/tns.min.rpt`
- `min_tt_025C_1v80/unpropagated.rpt`
- `min_tt_025C_1v80/violator_list.rpt`
- `min_tt_025C_1v80/wns.max.rpt`
- `min_tt_025C_1v80/wns.min.rpt`
- `min_tt_025C_1v80/ws.max.rpt`
- `min_tt_025C_1v80/ws.min.rpt`
- `nom_ff_n40C_1v95/checks.rpt`
- `nom_ff_n40C_1v95/clock.rpt`
- `nom_ff_n40C_1v95/max.rpt`
- `nom_ff_n40C_1v95/min.rpt`
- `nom_ff_n40C_1v95/power.rpt`
- `nom_ff_n40C_1v95/skew.max.rpt`
- `nom_ff_n40C_1v95/skew.min.rpt`
- `nom_ff_n40C_1v95/tns.max.rpt`
- `nom_ff_n40C_1v95/tns.min.rpt`
- `nom_ff_n40C_1v95/unpropagated.rpt`
- `nom_ff_n40C_1v95/violator_list.rpt`
- `nom_ff_n40C_1v95/wns.max.rpt`
- `nom_ff_n40C_1v95/wns.min.rpt`
- `nom_ff_n40C_1v95/ws.max.rpt`
- `nom_ff_n40C_1v95/ws.min.rpt`
- `nom_ss_100C_1v60/checks.rpt`
- `nom_ss_100C_1v60/clock.rpt`
- `nom_ss_100C_1v60/max.rpt`
- `nom_ss_100C_1v60/min.rpt`
- `nom_ss_100C_1v60/power.rpt`
- `nom_ss_100C_1v60/skew.max.rpt`
- `nom_ss_100C_1v60/skew.min.rpt`
- `nom_ss_100C_1v60/tns.max.rpt`
- `nom_ss_100C_1v60/tns.min.rpt`
- `nom_ss_100C_1v60/unpropagated.rpt`
- `nom_ss_100C_1v60/violator_list.rpt`
- `nom_ss_100C_1v60/wns.max.rpt`
- `nom_ss_100C_1v60/wns.min.rpt`
- `nom_ss_100C_1v60/ws.max.rpt`
- `nom_ss_100C_1v60/ws.min.rpt`
- `nom_tt_025C_1v80/checks.rpt`
- `nom_tt_025C_1v80/clock.rpt`
- `nom_tt_025C_1v80/max.rpt`
- `nom_tt_025C_1v80/min.rpt`
- `nom_tt_025C_1v80/power.rpt`
- `nom_tt_025C_1v80/skew.max.rpt`
- `nom_tt_025C_1v80/skew.min.rpt`
- `nom_tt_025C_1v80/tns.max.rpt`
- `nom_tt_025C_1v80/tns.min.rpt`
- `nom_tt_025C_1v80/unpropagated.rpt`
- `nom_tt_025C_1v80/violator_list.rpt`
- `nom_tt_025C_1v80/wns.max.rpt`
- `nom_tt_025C_1v80/wns.min.rpt`
- `nom_tt_025C_1v80/ws.max.rpt`
- `nom_tt_025C_1v80/ws.min.rpt`
- `summary.rpt`

Xem layout sau step này: `python3 scripts/step.py view 56`

## Đánh giá

(điền sau khi xem số liệu)

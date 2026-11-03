# Step 12: OpenROAD.STAPrePNR

STA trước đặt cell (clock lý tưởng, chưa có dây). Giai đoạn: 1. Tổng hợp. Thời gian chạy: 00:00:08.886. Thư mục: `openlane/runs/chip/12-openroad-staprepnr`

Step này tạo hoặc thay đổi: SDF.

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 5.908 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.0232 |
| KHÔNG ĐẠT | Không vi phạm max slew | `design__max_slew_violation__count` | 7135 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 36 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 310 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `clock__skew__worst_hold` | – | -6.637 |
| `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | – | -7.559 |
| `clock__skew__worst_setup` | – | -6.368 |
| `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | – | -5.23 |
| `design__max_cap_violation__count` | – | 36 |
| `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | – | 19 |
| `design__max_fanout_violation__count` | – | 310 |
| `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | – | 310 |
| `design__max_slew_violation__count` | – | 7135 |
| `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | – | 4021 |
| `power__internal__total` | – | 0.00735 |
| `power__leakage__total` | – | 1.785e-05 |
| `power__switching__total` | – | 0.001636 |
| `power__total` | – | 0.009004 |
| `timing__hold__tns` | – | 0 |
| `timing__hold__tns__corner:nom_tt_025C_1v80` | – | 0 |
| `timing__hold__wns` | – | 0 |
| `timing__hold__wns__corner:nom_tt_025C_1v80` | – | 0 |
| `timing__hold__ws` | – | 0.0232 |
| `timing__hold__ws__corner:nom_tt_025C_1v80` | – | 0.1727 |
| `timing__setup__tns` | – | 0 |
| `timing__setup__tns__corner:nom_tt_025C_1v80` | – | 0 |
| `timing__setup__wns` | – | 0 |
| `timing__setup__wns__corner:nom_tt_025C_1v80` | – | 0 |
| `timing__setup__ws` | – | 5.908 |
| `timing__setup__ws__corner:nom_tt_025C_1v80` | – | 10.91 |

## File báo cáo của LibreLane

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

## Đánh giá

(điền sau khi xem số liệu)

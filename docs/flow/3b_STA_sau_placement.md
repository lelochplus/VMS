# 3b. STA sau placement

Run `openlane/runs/step`, 1 step: 35-openroad-stamidpnr → 35-openroad-stamidpnr

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| KHÔNG ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | -3.574 |
| KHÔNG ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | -14.1 |
| KHÔNG ĐẠT | Không vi phạm max slew (ràng buộc 0,75 ns) | `design__max_slew_violation__count` | 2120 |
| KHÔNG ĐẠT | Không vi phạm max capacitance | `design__max_cap_violation__count` | 1 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 1 |

## Chỉ số

| Step | Chỉ số | Giá trị |
|---|---|---|
| 35-openroad-stamidpnr | `clock__skew__worst_hold` | -3.621 |
| 35-openroad-stamidpnr | `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -3.621 |
| 35-openroad-stamidpnr | `clock__skew__worst_setup` | 2.35 |
| 35-openroad-stamidpnr | `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 2.35 |
| 35-openroad-stamidpnr | `design__max_cap_violation__count` | 1 |
| 35-openroad-stamidpnr | `design__max_cap_violation__count__corner:nom_tt_025C_1v80` | 1 |
| 35-openroad-stamidpnr | `design__max_fanout_violation__count` | 1 |
| 35-openroad-stamidpnr | `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 1 |
| 35-openroad-stamidpnr | `design__max_slew_violation__count` | 2120 |
| 35-openroad-stamidpnr | `design__max_slew_violation__count__corner:nom_tt_025C_1v80` | 2120 |
| 35-openroad-stamidpnr | `power__internal__total` | 0.006753 |
| 35-openroad-stamidpnr | `power__leakage__total` | 5.66e-08 |
| 35-openroad-stamidpnr | `power__switching__total` | 0.001729 |
| 35-openroad-stamidpnr | `power__total` | 0.008482 |
| 35-openroad-stamidpnr | `timing__hold__tns` | -24342 |
| 35-openroad-stamidpnr | `timing__hold__tns__corner:nom_tt_025C_1v80` | -24342 |
| 35-openroad-stamidpnr | `timing__hold__wns` | -14.1 |
| 35-openroad-stamidpnr | `timing__hold__wns__corner:nom_tt_025C_1v80` | -14.1 |
| 35-openroad-stamidpnr | `timing__hold__ws` | -14.1 |
| 35-openroad-stamidpnr | `timing__hold__ws__corner:nom_tt_025C_1v80` | -14.1 |
| 35-openroad-stamidpnr | `timing__setup__tns` | -174.4 |
| 35-openroad-stamidpnr | `timing__setup__tns__corner:nom_tt_025C_1v80` | -174.4 |
| 35-openroad-stamidpnr | `timing__setup__wns` | -3.574 |
| 35-openroad-stamidpnr | `timing__setup__wns__corner:nom_tt_025C_1v80` | -3.574 |
| 35-openroad-stamidpnr | `timing__setup__ws` | -3.574 |
| 35-openroad-stamidpnr | `timing__setup__ws__corner:nom_tt_025C_1v80` | -3.574 |

## Báo cáo chi tiết của LibreLane

- `35-openroad-stamidpnr/checks.rpt`
- `35-openroad-stamidpnr/clock.rpt`
- `35-openroad-stamidpnr/max.rpt`
- `35-openroad-stamidpnr/min.rpt`
- `35-openroad-stamidpnr/power.rpt`
- `35-openroad-stamidpnr/skew.max.rpt`
- `35-openroad-stamidpnr/skew.min.rpt`
- `35-openroad-stamidpnr/tns.max.rpt`
- `35-openroad-stamidpnr/tns.min.rpt`
- `35-openroad-stamidpnr/unpropagated.rpt`
- `35-openroad-stamidpnr/violator_list.rpt`
- `35-openroad-stamidpnr/wns.max.rpt`
- `35-openroad-stamidpnr/wns.min.rpt`
- `35-openroad-stamidpnr/ws.max.rpt`
- `35-openroad-stamidpnr/ws.min.rpt`

## Đánh giá

**Kết luận: đạt; các vi phạm còn lại nằm trên net clock, chờ CTS.**

- Sau Repair Design và Detailed Placement (corner tt): vi phạm fanout 222 → 1, cap 73 → 1, slew 7.719 → 2120; setup −5,12 → −3,57 ns.
- 2119/2120 chân vi phạm slew là chân CLK của flip-flop; vi phạm cap tại `clk`, fanout tại `clk`. Net clock vẫn là một dây kéo tới 2.120 chân; Repair Design không sửa net clock vì đó là việc của CTS.
- Setup −3,57 ns, hold −14,1 ns và skew −3,62/+2,35 ns đều do clock chưa có cây. Kỳ vọng sau CTS: hết vi phạm slew trên clock, skew giảm mạnh, setup dương; hold được sửa ở bước Resizer Timing sau CTS.
- Công suất ước lượng 8,48 mW.

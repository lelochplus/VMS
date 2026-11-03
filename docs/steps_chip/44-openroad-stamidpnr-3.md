# Step 44: OpenROAD.STAMidPNR-3

STA sau global routing. Giai đoạn: 5. Routing. Thời gian chạy: 00:00:11.914. Thư mục: `openlane/runs/chip/44-openroad-stamidpnr-3`

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 10.72 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.2145 |
| KHÔNG ĐẠT | Không vi phạm max fanout | `design__max_fanout_violation__count` | 128 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `clock__skew__worst_hold` | -0.618 | -0.6462 |
| `clock__skew__worst_hold__corner:nom_tt_025C_1v80` | -0.618 | -0.6462 |
| `clock__skew__worst_setup` | 0.5834 | 0.6087 |
| `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.5834 | 0.6087 |
| `design__max_fanout_violation__count` | 127 | 128 |
| `design__max_fanout_violation__count__corner:nom_tt_025C_1v80` | 127 | 128 |
| `power__internal__total` | 0.008077 | 0.008127 |
| `power__leakage__total` | 1.78e-05 | 1.78e-05 |
| `power__switching__total` | 0.003668 | 0.004043 |
| `power__total` | 0.01176 | 0.01219 |
| `timing__hold__ws` | 0.2822 | 0.2145 |
| `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.2822 | 0.2145 |
| `timing__setup__ws` | 10.72 | 10.72 |
| `timing__setup__ws__corner:nom_tt_025C_1v80` | 10.72 | 10.72 |

## File báo cáo của LibreLane

- `checks.rpt`
- `clock.rpt`
- `max.rpt`
- `min.rpt`
- `openroad-stamidpnr-3.log`
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

Xem layout sau step này: `python3 scripts/step.py view 44`

## Đánh giá

(điền sau khi xem số liệu)

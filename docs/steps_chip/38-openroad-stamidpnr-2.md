# Step 38: OpenROAD.STAMidPNR-2

STA sau khi sửa timing. Giai đoạn: 4. CTS. Thời gian chạy: 00:00:12.105. Thư mục: `openlane/runs/chip/38-openroad-stamidpnr-2`

## Kiểm tra tự động

| Kết quả | Tiêu chí | Chỉ số | Giá trị |
|---|---|---|---|
| ĐẠT | Setup slack ≥ 0 ở corner xấu nhất | `timing__setup__ws` | 10.72 |
| ĐẠT | Hold slack ≥ 0 ở corner xấu nhất | `timing__hold__ws` | 0.2822 |

## Chỉ số thay đổi

| Chỉ số | Trước | Sau |
|---|---|---|
| `clock__skew__worst_setup` | 0.5833 | 0.5834 |
| `clock__skew__worst_setup__corner:nom_tt_025C_1v80` | 0.5833 | 0.5834 |
| `power__internal__total` | 0.007997 | 0.008077 |
| `power__leakage__total` | 1.779e-05 | 1.78e-05 |
| `power__switching__total` | 0.003624 | 0.003668 |
| `power__total` | 0.01164 | 0.01176 |
| `timing__hold__ws` | 0.1407 | 0.2822 |
| `timing__hold__ws__corner:nom_tt_025C_1v80` | 0.1407 | 0.2822 |
| `timing__setup__ws` | 10.8 | 10.72 |
| `timing__setup__ws__corner:nom_tt_025C_1v80` | 10.8 | 10.72 |

## File báo cáo của LibreLane

- `checks.rpt`
- `clock.rpt`
- `max.rpt`
- `min.rpt`
- `openroad-stamidpnr-2.log`
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

Xem layout sau step này: `python3 scripts/step.py view 38`

## Đánh giá

(điền sau khi xem số liệu)

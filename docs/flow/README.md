# Thiết kế vật lý theo từng giai đoạn

LibreLane 3.0.16, PDK Sky130A, khối `soc_core` (không gồm RAM), cấu hình `openlane/soc_core_fix3.json`, chu kỳ clock 25 ns (40 MHz). Flow Classic (80 step) được chạy thành 6 giai đoạn bằng `--from`/`--to` trên cùng run `openlane/runs/step`; sau mỗi giai đoạn, `scripts/stage_report.py` ghi báo cáo gồm kiểm tra tự động, chỉ số, đường dẫn tới báo cáo gốc của LibreLane và đánh giá.

Lệnh chung: `librelane --dockerized --run-tag step <tùy chọn> openlane/soc_core_fix3.json`

| # | Giai đoạn | Tùy chọn | Kết quả chính | Đánh giá |
|---|---|---|---|---|
| 1 | [Tổng hợp](1_Tong_hop.md) | `--to OpenROAD.STAPrePNR` | 9.080 cell, 117.271 µm², 0 latch, 0 cell chưa ánh xạ | Đạt |
| 2 | [Floorplan + PDN](2_Floorplan_va_PDN.md) | `--from OpenROAD.Floorplan --to OpenROAD.GeneratePDN` | die 250.667 µm², mật độ 50% → 51,8%, lưới nguồn không lỗi | Đạt |
| 3 | [Placement](3_Placement.md), [STA sau placement](3b_STA_sau_placement.md) | `--from Odb.RemovePDNObstructions --to OpenROAD.DetailedPlacement` | 1.135 buffer; fanout 222 → 1, cap 73 → 1; vi phạm còn lại chỉ trên net clock | Đạt |
| 4 | [CTS](4_CTS.md) | `--from OpenROAD.CTS --to OpenROAD.STAMidPNR-2` | H-tree 4 tầng, skew 0,32/0,44 ns, setup tt +15,48 ns, 3.388 buffer sửa hold | Đạt |
| 5 | [Routing](5_Routing.md) | `--from OpenROAD.GlobalRouting --to Checker.WireLength` | 0 lỗi DRC, antenna 66 → 0, dây 515.917 µm | Đạt |
| 6 | [Signoff](6_Signoff.md) | `--from OpenROAD.FillInsertion` | DRC/LVS/antenna đạt; setup +2,84 ns, hold +0,104 ns ở mọi corner; 12,35 mW | Đạt |

Số liệu qua từng giai đoạn (corner tt; giai đoạn 3–5 là STA giữa flow, giai đoạn 6 là STA sau trích xuất RC):

| Sau giai đoạn | Diện tích cell (µm²) | Mật độ | Setup slack | Hold slack | Vi phạm slew | Công suất |
|---|---|---|---|---|---|---|
| 1. Tổng hợp | 117.271 | – | +13,24 ns | +0,16 ns | 3.423 | 7,48 mW |
| 2. Floorplan + PDN | 121.438 | 51,8% | – | – | – | – |
| 3. Placement | 128.820 | 55,0% | −3,57 ns | −14,10 ns | 2.120 | 8,48 mW |
| 4. CTS | 146.621 | 62,6% | +15,48 ns | +0,29 ns | 0 | 9,23 mW |
| 5. Routing | 146.831 | 62,7% | +15,22 ns | +0,30 ns | 0 | 9,51 mW |
| 6. Signoff | 146.831 | 62,7% | +14,51 ns | +0,30 ns | 2 | 12,35 mW |

- Setup và hold âm sau placement là do net clock chưa có cây (một dây kéo tới 2.120 chân); CTS giải quyết ở giai đoạn 4.
- Chi phí diện tích lớn nhất là sửa hold sau CTS (+12.717 µm²), vì ở các corner nhanh có 1.865 điểm cuối vi phạm hold.
- Signoff ở 9 corner: setup xấu nhất ở max_ss_100C_1v60, hold xấu nhất ở các corner ff; không có đường vi phạm.
- Cảnh báo còn lại: vi phạm max slew theo ràng buộc 0,75 ns ở corner chậm (1.007 ở max_ss, slew xấu nhất 1,37 ns), 1 vi phạm max cap ở buffer gốc cây clock, 71 vi phạm max fanout, 67 trong số đó ở net cây clock.
- Chạy theo từng giai đoạn cho kết quả trùng với chạy cả flow một lần.

## Thời gian chạy

Cộng từ `runtime.txt` của từng step (máy ảo 8 nhân, 7 GB RAM):

| Giai đoạn | Số step | Thời gian | Step lâu nhất |
|---|---|---|---|
| 1. Tổng hợp | 12 | 0.6 phút | `06-yosys-synthesis` (0.4 phút) |
| 2. Floorplan + PDN | 9 | 0.1 phút | `21-openroad-generatepdn` (0.0 phút) |
| 3. Placement (kèm STA 3b) | 14 | 1.1 phút | `32-openroad-repairdesignpostgpl` (0.3 phút) |
| 4. CTS | 4 | 2.1 phút | `38-openroad-resizertimingpostcts` (1.4 phút) |
| 5. Routing | 14 | 10.6 phút | `46-openroad-detailedrouting` (8.5 phút) |
| 6. Signoff | 25 | 5.7 phút | `66-magic-drc` (1.9 phút) |
| **Tổng** | 78 | **20.2 phút** | |

Ảnh layout cuối do KLayout vẽ: [`docs/layout_soc_core_step.png`](../layout_soc_core_step.png).

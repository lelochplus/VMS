# RISC-V SoC tích hợp bộ điều khiển DMA

SoC gồm lõi PicoRV32 (RV32I), bus Wishbone dùng chung cho hai master (CPU, DMA) qua arbiter round-robin, RAM, UART TX và bộ điều khiển DMA một kênh có ngắt. Toàn bộ quy trình chạy trên Linux: mô phỏng (Verilator, Icarus, GTKWave), firmware (RISC-V GCC), thiết kế vật lý (LibreLane, Sky130, KLayout) và chạy thật trên FPGA Sipeed Tang Nano 20K.

## Cấu trúc

| Đường dẫn | Nội dung |
|---|---|
| `rtl/dma_ctrl.v` | Bộ điều khiển DMA (slave cấu hình + master truyền dữ liệu) |
| `rtl/soc_core.v` | Lõi SoC: CPU, arbiter, giải mã địa chỉ, UART, DMA; RAM nối ra cổng `ext_*`; macro `NO_DMA` bỏ DMA để so tài nguyên |
| `rtl/soc_top.v` | `soc_core` + RAM, dùng cho mô phỏng và FPGA |
| `rtl/soc_periph.v` | `wb_ram` (4 làn 8 bit), `wb_uart_tx` |
| `tb/tb_dma.v` | 11 ca kiểm tra DMA, slave có độ trễ ngẫu nhiên |
| `tb/tb_soc.v` | Chạy firmware, giải mã UART, ghi BUSY và độ trễ khởi động, đếm giao dịch RAM của từng master |
| `tb/tb_fpga.v` | Mô phỏng đúng top FPGA ở 27 MHz |
| `sw/` | `start.S` (reset, vector ngắt), `link.ld` (RAM 8 KB), `main.c` (DMA, ngắt, chạy đồng thời, đo N = 16…256) |
| `fpga/` | `tangnano20k_top.v` (reset, LED gỡ lỗi), `tangnano20k.cst` |
| `openlane/` | Cấu hình LibreLane: `dma_ctrl`, `soc_core`, `soc_core_nodma` |
| `scripts/` | `gtkw_t5.py` (mở GTKWave đúng ca T5), `asic_metrics.py`, `layout_shot.py` |
| `docs/` | Ảnh layout |
| `lint.vlt` | Các cảnh báo Verilator được miễn có chủ đích |

## Cài đặt

```bash
sudo apt install verilator iverilog gtkwave klayout gcc-riscv64-unknown-elf docker.io openfpgaloader picocom
git clone --depth 1 https://github.com/YosysHQ/picorv32.git third_party/picorv32
python3 -m venv .venv && source .venv/bin/activate && pip install librelane
```

Phần FPGA dùng [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) giải nén ở `~/tools/oss-cad-suite` (đổi bằng `make OSS=<thư mục bin>`).

## Chạy

```bash
make lint                     # Verilator -Wall
make test                     # lint + tb_dma + tb_soc, dừng nếu có FAIL
gtkwave soc.vcd               # dạng sóng toàn SoC
make sim-dma && python3 scripts/gtkw_t5.py dump.vcd && gtkwave t5.gtkw   # mở sẵn ca T5
make fpga                     # tổng hợp + P&R cho Tang Nano 20K, in tài nguyên và Fmax
make prog                     # nạp vào SRAM của FPGA (mất khi rút điện)
openFPGALoader -b tangnano20k -f fpga/soc.fs                            # ghi vào flash
picocom -b 115200 --imap lfcrlf /dev/ttyUSB1                            # xem UART, bấm S1 để chạy lại
librelane --dockerized openlane/soc_core.json                           # RTL -> GDSII, chạy trong terminal thật
klayout -l $(find ~/.volare -name sky130A.lyp | head -1) openlane/runs/<run>/final/gds/soc_core.gds
```

So tài nguyên khi không có DMA: `make fpga DEFS=-DNO_DMA` và `librelane --dockerized --run-tag nodma openlane/soc_core_nodma.json`.

## Bản đồ bộ nhớ

| Địa chỉ | Khối |
|---|---|
| `0x0000_0000` | RAM 8 KB (mô phỏng và FPGA; với ASIC, RAM nằm ngoài lõi qua cổng `ext_*`) |
| `0x1000_0000` | UART: `+0x0` ghi byte, `+0x4` bit0 = BUSY |
| `0x1000_4000` | Thanh ghi DMA |

## Thanh ghi DMA

| Offset | Tên | Nội dung |
|---|---|---|
| `0x00` | CTRL | bit0 START, bit1 IRQ_EN, bit2 SRC_INC, bit3 DST_INC (bỏ qua khi BUSY) |
| `0x04` | STATUS | bit0 BUSY, bit1 DONE, bit2 ERR (ghi 1 để xóa DONE/ERR) |
| `0x08` | SRC | Địa chỉ nguồn (bỏ qua khi BUSY) |
| `0x0C` | DST | Địa chỉ đích (bỏ qua khi BUSY) |
| `0x10` | LEN | Số word 32 bit (bỏ qua khi BUSY; START bị bỏ qua nếu LEN = 0) |

Ngắt DMA nối vào `irq[3]` của PicoRV32, cấu hình theo mức (`LATCHED_IRQ` bit 3 = 0) để trình xử lý không bị gọi hai lần.

## Kết quả

Chép N word với cùng một firmware, đo bằng `rdcycle`. Số trên Tang Nano 20K (27 MHz) trùng từng chu kỳ với mô phỏng:

| N (word) | CPU | DMA, gồm cấu hình và chờ | DMA, thời gian BUSY | Tăng tốc |
|---|---|---|---|---|
| 16 | 969 | 255 | 122 | 3,8× |
| 32 | 1.881 | 379 | 246 | 5,0× |
| 64 | 3.705 | 627 | 494 | 5,9× |
| 128 | 7.353 | 1.123 | 990 | 6,5× |
| 256 | 14.649 | 2.115 | 1.982 | 6,9× |

- CPU tốn khoảng 57 chu kỳ/word; DMA tốn 7,75 chu kỳ/word cộng 133 chu kỳ cố định cho cấu hình và chờ. Tăng tốc tiến tới 7,4 lần.
- Độ trễ khởi động: 2 chu kỳ từ lúc BUSY lên đến giao dịch RAM đầu tiên của DMA.
- Chạy đồng thời (DMA chép 64 word trong khi CPU tự chép 16 word): dữ liệu cả hai đều đúng. Trong mọi lúc DMA BUSY, CPU hoàn tất 599 giao dịch RAM, DMA 1.184 (= 2 × 592 word đã chép).

FPGA Tang Nano 20K (GW2AR-18), RAM 8 KB:

| | Không DMA | Có DMA |
|---|---|---|
| LUT4 | 2.511 | 3.207 (+28%) |
| DFF | 900 | 1.016 (+13%) |
| BSRAM | 6 | 6 |
| Fmax | 115,3 MHz | 104,1 MHz |

LibreLane 3.0.16, Sky130A, `soc_core` (không gồm RAM), chu kỳ 25 ns, lần chạy 28/10:

| | Không DMA | Có DMA | Chi phí của DMA |
|---|---|---|---|
| Diện tích standard cell | 148.547 µm² | 160.295 µm² | +7,9% |
| Diện tích die | 231.279 µm² | 250.587 µm² | +8,3% |
| Số standard cell | 15.037 | 16.298 | +1.261 |
| Flip-flop | 1.975 | 2.119 | +144 |
| Công suất (ước lượng) | 11,6 mW | 13,0 mW | +1,3 mW |
| Setup / hold slack (corner xấu nhất) | −0,95 / +0,108 ns | +1,52 / +0,102 ns | |
| DRC / LVS / antenna | Đạt | Đạt | |

Sửa vi phạm slew (bản có DMA, cùng chu kỳ 25 ns):

| Cấu hình | Vi phạm slew (corner xấu nhất) | Slew xấu nhất ở nom_ss | Setup / hold slack | Diện tích cell | Công suất |
|---|---|---|---|---|---|
| Mặc định (`soc_core.json`) | 4.378 | – | +1,52 / +0,102 ns | 160.295 µm² | 13,0 mW |
| `soc_core_fix.json`: buffer cho dây > 400 µm, biên 30%, sửa sau global routing | 2.816 | 1,60 ns | +1,89 / +0,106 ns | 160.272 µm² | 13,0 mW |
| `soc_core_fix3.json`: như trên + loại buffer yếu (`clkdlybuf4s*`, `dlygate4sd*`, `buf_1`) | 1.007 | 1,25 ns | +2,84 / +0,104 ns | 146.831 µm² | 12,3 mW |

Nguyên nhân gốc: `repair_design` của OpenROAD chèn buffer yếu nhất trong thư viện (log ghi `clkdlybuf4s25_1`) và không nâng cỡ, trong khi tải ước lượng sau placement thấp hơn tải thật sau đi dây. Loại các buffer yếu giảm 77% vi phạm, tăng setup slack, giảm diện tích và công suất. Với fix3, slew xấu nhất ở mọi corner là 1,37 ns (corner max_ss), dưới giới hạn 1,5 ns của thư viện; các vi phạm còn lại chỉ là vượt ràng buộc 0,75 ns do flow đặt.

`dma_ctrl` riêng lẻ (20 ns, lần chạy 26/10): die 21.083 µm², 142 flip-flop, setup/hold +3,76/+0,108 ns, 1,04 mW, DRC/LVS/antenna đạt.

## Hạn chế

- Với fix3 vẫn còn 1.007 chân vượt ràng buộc 0,75 ns (`MAX_TRANSITION_CONSTRAINT`) ở corner xấu nhất, còn vi phạm max cap ở buffer gốc của cây clock (`clkbuf_0_clk`, 0,26 pF so với giới hạn 0,2 pF) và 71 vi phạm max fanout. `dma_ctrl` riêng lẻ chưa chạy lại với cấu hình này (366 vi phạm slew).
- Luồng vật lý chưa gồm RAM; số liệu diện tích/công suất chỉ của lõi.
- DMA một kênh, chỉ truyền nguyên word, không burst, chưa bắt tay với ngoại vi (chưa chép thẳng vào UART được).
- Vòng polling STATUS tranh bus với DMA: chép 64 word giữ BUSY 494 chu kỳ khi CPU polling, 477 chu kỳ khi CPU đang tự chép dữ liệu.
- Testbench chưa phủ lỗi bus phía ghi và reset giữa lúc truyền.
- Yosys 0.70 bỏ dữ liệu `$readmemh` nếu cùng khối `initial` có vòng xóa RAM, nên `wb_ram` chỉ xóa RAM trong mô phỏng (`ifndef SYNTHESIS`).

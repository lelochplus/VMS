# RISC-V SoC tích hợp bộ điều khiển DMA

SoC gồm lõi PicoRV32 (RV32I), bus Wishbone dùng chung cho hai master (CPU, DMA) qua arbiter round-robin, RAM, UART TX và bộ điều khiển DMA một kênh có ngắt. Toàn bộ quy trình chạy trên Linux: mô phỏng (Verilator, Icarus), firmware (RISC-V GCC), thiết kế vật lý (LibreLane, Sky130).

## Cấu trúc

| Thư mục | Nội dung |
|---|---|
| `rtl/dma_ctrl.v` | Bộ điều khiển DMA (slave cấu hình + master truyền dữ liệu) |
| `rtl/soc_core.v` | Lõi SoC: CPU, arbiter, giải mã địa chỉ, UART, DMA; RAM nối ra cổng `ext_*` |
| `rtl/soc_top.v` | `soc_core` + RAM, dùng để mô phỏng |
| `rtl/soc_periph.v` | `wb_ram`, `wb_uart_tx` |
| `tb/` | `tb_dma.v` (9 ca kiểm tra DMA), `tb_soc.v` (chạy firmware, giải mã UART) |
| `sw/` | `start.S` (reset, vector ngắt), `link.ld`, `main.c` (kiểm tra DMA, ngắt, đo hiệu năng) |
| `openlane/` | Cấu hình LibreLane cho `dma_ctrl` và `soc_core` |

## Cài đặt

```bash
sudo apt install verilator iverilog gtkwave gcc-riscv64-unknown-elf docker.io
git clone --depth 1 https://github.com/YosysHQ/picorv32.git third_party/picorv32
python3 -m venv .venv && source .venv/bin/activate && pip install librelane
```

## Chạy

```bash
make test                     # testbench DMA + SoC, dừng nếu có FAIL
gtkwave soc.vcd               # xem dạng sóng
python3 -m librelane --dockerized openlane/soc_core.json   # RTL -> GDSII
```

## Bản đồ bộ nhớ

| Địa chỉ | Khối |
|---|---|
| `0x0000_0000` | RAM (4 KB khi mô phỏng) |
| `0x1000_0000` | UART: `+0x0` ghi byte, `+0x4` bit0 = BUSY |
| `0x1000_4000` | Thanh ghi DMA |

## Thanh ghi DMA

| Offset | Tên | Nội dung |
|---|---|---|
| `0x00` | CTRL | bit0 START, bit1 IRQ_EN, bit2 SRC_INC, bit3 DST_INC |
| `0x04` | STATUS | bit0 BUSY, bit1 DONE, bit2 ERR (ghi 1 để xóa DONE/ERR) |
| `0x08` | SRC | Địa chỉ nguồn (bỏ qua khi BUSY) |
| `0x0C` | DST | Địa chỉ đích (bỏ qua khi BUSY) |
| `0x10` | LEN | Số word 32 bit (bỏ qua khi BUSY, START bị bỏ qua nếu LEN = 0) |

Ngắt DMA nối vào `irq[3]` của PicoRV32, cấu hình theo mức (`LATCHED_IRQ` bit 3 = 0) để trình xử lý không bị gọi hai lần.

## Kết quả

Mô phỏng, chép 64 word:

| Cách chép | Chu kỳ |
|---|---|
| CPU (vòng lặp `lw`/`sw`) | 3.277 |
| DMA, tính cả cấu hình và polling | 645 |
| DMA, thời gian BUSY | 494 (khoảng 7,7 chu kỳ/word) |

LibreLane, Sky130A:

| | `dma_ctrl` (20 ns) | `soc_core` (25 ns, không RAM) |
|---|---|---|
| Diện tích die | 21.083 µm² | 250.306 µm² |
| Flip-flop | 142 | 2.119 |
| Setup / hold slack | +3,76 / +0,108 ns | +2,28 / +0,105 ns |
| Công suất (ước lượng) | 1,04 mW | 11,9 mW |
| DRC / LVS / antenna | Đạt | Đạt |

## Hạn chế

- Còn vi phạm max slew ở corner chậm (366 với `dma_ctrl`, 4.189 với `soc_core`), chưa xác định nguyên nhân gốc. Cấm cell trễ `clkdlybuf4s*` không giải quyết được.
- Luồng vật lý chưa gồm RAM; số liệu diện tích/công suất chỉ của lõi.
- DMA một kênh, chỉ truyền nguyên word, không burst.
- Testbench chưa phủ lỗi bus phía ghi và reset giữa lúc truyền.
- Chưa chạy trên FPGA thật.

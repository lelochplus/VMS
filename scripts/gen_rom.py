#!/usr/bin/env python3
# Sinh rtl/boot_rom.v (ROM to hop) tu firmware nhi phan cua ban ASIC.
# Dung: python3 scripts/gen_rom.py sw/fw_asic.bin rtl/boot_rom.v
import sys

src, dst = sys.argv[1], sys.argv[2]
data = open(src, 'rb').read()
data += b'\0' * (-len(data) % 4)
words = [int.from_bytes(data[i:i + 4], 'little') for i in range(0, len(data), 4)]
if len(words) > 1024:
    sys.exit(f'Firmware {len(words) * 4} byte, vuot qua ROM 4 KB')
lines = [
    f'// TU SINH boi scripts/gen_rom.py tu {src} ({len(words) * 4} byte). Khong sua tay: chay "make rom".',
    'module boot_rom (',
    '    input  wire [9:0]  addr,      // chi so word (dia chi byte >> 2)',
    '    output reg  [31:0] data',
    ');',
    '    always @(*) begin',
    '        case (addr)',
]
lines += [f"            10'd{i}: data = 32'h{w:08x};" for i, w in enumerate(words) if w]
lines += ["            default: data = 32'h00000000;", '        endcase', '    end', 'endmodule', '']
open(dst, 'w').write('\n'.join(lines))
print(f'{dst}: {len(words)} word ({len(words) * 4} byte)')

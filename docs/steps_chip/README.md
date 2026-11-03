# Báo cáo từng step

Cấu hình `openlane/soc_chip.json`, run `openlane/runs/chip`.

| Step | ID | Nội dung | Thời gian | Kết luận |
|---|---|---|---|---|
| [01](01-verilator-lint.md) | `Verilator.Lint` | Kiểm tra RTL bằng Verilator (lint) | 00:00:03.682 | Đạt |
| [02](02-checker-linttimingconstructs.md) | `Checker.LintTimingConstructs` | Kiểm tra RTL không có cấu trúc trễ không tổng hợp được | 00:00:00.001 | – |
| [03](03-checker-linterrors.md) | `Checker.LintErrors` | Báo lỗi nếu lint có lỗi | 00:00:00.001 | – |
| [04](04-checker-lintwarnings.md) | `Checker.LintWarnings` | Báo số cảnh báo lint | 00:00:00.001 | – |
| [05](05-yosys-jsonheader.md) | `Yosys.JsonHeader` | Ghi mô tả cổng của module top (JSON) | 00:00:02.782 | – |
| [06](06-yosys-synthesis.md) | `Yosys.Synthesis` | Tổng hợp RTL thành netlist cell sky130 | 00:00:43.087 | Đạt |
| [07](07-checker-yosysunmappedcells.md) | `Checker.YosysUnmappedCells` | Kiểm tra không còn cell chưa ánh xạ | 00:00:00.001 | – |
| [08](08-checker-yosyssynthchecks.md) | `Checker.YosysSynthChecks` | Kiểm tra lỗi tổng hợp (lệnh check của Yosys) | 00:00:00.001 | – |
| [09](09-checker-netlistassignstatements.md) | `Checker.NetlistAssignStatements` | Kiểm tra netlist không còn lệnh assign | 00:00:00.020 | – |
| [10](10-openroad-checksdcfiles.md) | `OpenROAD.CheckSDCFiles` | Kiểm tra file ràng buộc thời gian SDC | 00:00:00.003 | – |
| [11](11-openroad-checkmacroinstances.md) | `OpenROAD.CheckMacroInstances` | Kiểm tra các macro khai báo có trong netlist | 00:00:00.615 | – |
| [12](12-openroad-staprepnr.md) | `OpenROAD.STAPrePNR` | STA trước đặt cell (clock lý tưởng, chưa có dây) | 00:00:08.886 | Cần xem lại |
| [13](13-openroad-floorplan.md) | `OpenROAD.Floorplan` | Tạo die, vùng core và các hàng cell (layout đầu tiên) | 00:00:02.045 | – |
| [14](14-openroad-dumprcvalues.md) | `OpenROAD.DumpRCValues` | Ghi điện trở, điện dung của các lớp kim loại | 00:00:00.815 | – |
| [15](15-odb-checkmacroantennaproperties.md) | `Odb.CheckMacroAntennaProperties` | Kiểm tra thuộc tính antenna của macro | 00:00:01.015 | – |
| [16](16-odb-setpowerconnections.md) | `Odb.SetPowerConnections` | Nối chân nguồn VPWR/VGND của cell | 00:00:00.912 | – |
| [17](17-odb-manualmacroplacement.md) | `Odb.ManualMacroPlacement` | Đặt macro theo cấu hình (không có macro thì không làm gì) | 00:00:01.013 | – |
| [18](18-openroad-cutrows.md) | `OpenROAD.CutRows` | Cắt hàng cell quanh macro và vật cản | 00:00:01.022 | – |
| [19](19-openroad-tapendcapinsertion.md) | `OpenROAD.TapEndcapInsertion` | Chèn tap cell và endcap | 00:00:01.115 | – |
| [20](20-odb-addpdnobstructions.md) | `Odb.AddPDNObstructions` | Thêm vùng cấm cho lưới nguồn (nếu có) | 00:00:00.003 | – |
| [21](21-openroad-generatepdn.md) | `OpenROAD.GeneratePDN` | Tạo lưới nguồn VPWR/VGND | 00:00:01.630 | – |
| [22](22-odb-removepdnobstructions.md) | `Odb.RemovePDNObstructions` | Gỡ vùng cấm lưới nguồn | 00:00:00.002 | – |
| [23](23-odb-addroutingobstructions.md) | `Odb.AddRoutingObstructions` | Thêm vùng cấm đi dây (nếu có) | 00:00:00.001 | – |
| [24](24-openroad-globalplacementskipio.md) | `OpenROAD.GlobalPlacementSkipIO` | Đặt cell sơ bộ để tìm vị trí chân IO | 00:00:05.149 | – |
| [25](25-openroad-ioplacement.md) | `OpenROAD.IOPlacement` | Đặt chân IO quanh die | 00:00:01.323 | – |
| [26](26-odb-customioplacement.md) | `Odb.CustomIOPlacement` | Đặt chân IO theo file cấu hình (nếu có) | 00:00:00.002 | – |
| [27](27-odb-applydeftemplate.md) | `Odb.ApplyDEFTemplate` | Áp template DEF (nếu có) | 00:00:00.002 | – |
| [28](28-openroad-globalplacement.md) | `OpenROAD.GlobalPlacement` | Đặt cell toàn cục | 00:00:16.293 | – |
| [29](29-odb-writeverilogheader.md) | `Odb.WriteVerilogHeader` | Ghi header Verilog có chân nguồn | 00:00:00.710 | – |
| [30](30-checker-powergridviolations.md) | `Checker.PowerGridViolations` | Kiểm tra lưới nguồn nối đủ | 00:00:00.002 | – |
| [31](31-openroad-stamidpnr.md) | `OpenROAD.STAMidPNR` | STA sau global placement | 00:00:14.929 | Cần xem lại |
| [32](32-openroad-repairdesignpostgpl.md) | `OpenROAD.RepairDesignPostGPL` | Chèn buffer, đổi cỡ cell để sửa slew, cap, fanout | 00:00:25.916 | – |
| [33](33-odb-manualglobalplacement.md) | `Odb.ManualGlobalPlacement` | Đặt tay cell theo cấu hình (nếu có) | 00:00:00.002 | – |
| [34](34-openroad-detailedplacement.md) | `OpenROAD.DetailedPlacement` | Đặt chi tiết: đưa cell vào đúng hàng, không chồng nhau | 00:00:01.922 | – |
| [35](35-openroad-cts.md) | `OpenROAD.CTS` | Tổng hợp cây clock | 00:00:35.347 | – |
| [36](36-openroad-stamidpnr-1.md) | `OpenROAD.STAMidPNR-1` | STA sau CTS | 00:00:10.962 | Cần xem lại |
| [37](37-openroad-resizertimingpostcts.md) | `OpenROAD.ResizerTimingPostCTS` | Sửa setup/hold sau CTS | 00:01:50.305 | – |
| [38](38-openroad-stamidpnr-2.md) | `OpenROAD.STAMidPNR-2` | STA sau khi sửa timing | 00:00:12.105 | Đạt |
| [39](39-openroad-globalrouting.md) | `OpenROAD.GlobalRouting` | Định tuyến toàn cục | 00:00:05.459 | – |
| [40](40-openroad-checkantennas.md) | `OpenROAD.CheckAntennas` | Kiểm tra antenna sau global routing | 00:00:14.719 | Cần xem lại |
| [41](41-openroad-repairdesignpostgrt.md) | `OpenROAD.RepairDesignPostGRT` | Sửa slew, cap sau global routing | 00:00:50.232 | – |
| [42](42-odb-diodesonports.md) | `Odb.DiodesOnPorts` | Chèn diode ở chân IO (nếu bật) | 00:00:00.002 | – |
| [43](43-openroad-repairantennas.md) | `OpenROAD.RepairAntennas` | Chèn diode sửa vi phạm antenna | 00:01:04.032 | Đạt |
| [44](44-openroad-stamidpnr-3.md) | `OpenROAD.STAMidPNR-3` | STA sau global routing | 00:00:11.914 | Cần xem lại |
| [45](45-openroad-detailedrouting.md) | `OpenROAD.DetailedRouting` | Định tuyến chi tiết | 00:10:55.568 | Đạt |
| [46](46-odb-removeroutingobstructions.md) | `Odb.RemoveRoutingObstructions` | Gỡ vùng cấm đi dây | 00:00:00.002 | – |
| [47](47-openroad-checkantennas-1.md) | `OpenROAD.CheckAntennas-1` | Kiểm tra antenna sau định tuyến chi tiết | 00:00:10.485 | – |
| [48](48-checker-trdrc.md) | `Checker.TrDRC` | Báo lỗi DRC của bộ định tuyến | 00:00:00.002 | – |
| [49](49-odb-reportdisconnectedpins.md) | `Odb.ReportDisconnectedPins` | Báo các chân bị hở | 00:00:01.823 | Đạt |
| [50](50-checker-disconnectedpins.md) | `Checker.DisconnectedPins` | Báo lỗi nếu chân quan trọng bị hở | 00:00:00.002 | – |
| [51](51-odb-reportwirelength.md) | `Odb.ReportWireLength` | Báo chiều dài dây | 00:00:00.910 | – |
| [52](52-checker-wirelength.md) | `Checker.WireLength` | Cảnh báo dây quá dài | 00:00:00.003 | – |
| [53](53-openroad-fillinsertion.md) | `OpenROAD.FillInsertion` | Chèn cell fill lấp chỗ trống | 00:00:03.343 | – |
| [54](54-odb-cellfrequencytables.md) | `Odb.CellFrequencyTables` | Thống kê số cell theo loại | 00:00:02.548 | – |
| [55](55-openroad-rcx.md) | `OpenROAD.RCX` | Trích xuất RC ký sinh (SPEF) | 00:00:04.976 | – |
| [56](56-openroad-stapostpnr.md) | `OpenROAD.STAPostPNR` | STA signoff ở 9 corner | 00:00:38.899 | Cần xem lại |
| [57](57-openroad-irdropreport.md) | `OpenROAD.IRDropReport` | Phân tích sụt áp lưới nguồn | 00:00:20.912 | – |
| [58](58-magic-streamout.md) | `Magic.StreamOut` | Xuất GDS bằng Magic | 00:00:37.805 | – |
| [59](59-klayout-streamout.md) | `KLayout.StreamOut` | Xuất GDS bằng KLayout | 00:00:03.333 | – |
| [60](60-klayout-streamout.md) | `KLayout.StreamOut` | Xuất GDS bằng KLayout | 00:00:03.066 | – |
| [61](61-klayout-render.md) | `KLayout.Render` | Vẽ ảnh PNG của layout | 00:00:04.043 | – |
| [62](62-magic-writelef.md) | `Magic.WriteLEF` | Xuất LEF của khối | 00:01:18.195 | – |
| [63](63-odb-checkdesignantennaproperties.md) | `Odb.CheckDesignAntennaProperties` | Kiểm tra thuộc tính antenna của khối | 00:00:01.521 | – |
| [64](64-klayout-xor.md) | `KLayout.XOR` | So GDS của Magic với GDS của KLayout | 00:00:49.367 | Đạt |
| [65](65-checker-xor.md) | `Checker.XOR` | Báo lỗi nếu hai GDS khác nhau | 00:00:00.002 | – |
| [66](66-magic-drc.md) | `Magic.DRC` | DRC bằng Magic | 00:11:27.266 | Cần xem lại |
| [67](67-magic-drc.md) | `Magic.DRC` | DRC bằng Magic | 00:04:37.384 | Đạt |
| [68](68-klayout-drc.md) | `KLayout.DRC` | DRC bằng KLayout | 00:05:22.415 | Đạt |
| [69](69-checker-magicdrc.md) | `Checker.MagicDRC` | Báo lỗi nếu Magic có lỗi DRC | 00:00:00.003 | – |
| [70](70-checker-klayoutdrc.md) | `Checker.KLayoutDRC` | Báo lỗi nếu KLayout có lỗi DRC | 00:00:00.002 | – |
| [71](71-magic-spiceextraction.md) | `Magic.SpiceExtraction` | Trích netlist SPICE từ layout | 00:00:37.618 | – |
| [72](72-checker-illegaloverlap.md) | `Checker.IllegalOverlap` | Kiểm tra chồng lấn bất hợp lệ | 00:00:00.002 | – |
| [73](73-netgen-lvs.md) | `Netgen.LVS` | So layout với netlist (LVS) | 00:00:11.857 | Đạt |
| [74](74-checker-lvs.md) | `Checker.LVS` | Báo lỗi nếu LVS không khớp | 00:00:00.002 | – |
| [75](75-checker-setupviolations.md) | `Checker.SetupViolations` | Báo vi phạm setup | 00:00:00.002 | – |
| [76](76-checker-holdviolations.md) | `Checker.HoldViolations` | Báo vi phạm hold | 00:00:00.002 | – |
| [77](77-checker-maxslewviolations.md) | `Checker.MaxSlewViolations` | Báo vi phạm max slew | 00:00:00.011 | – |
| [78](78-checker-maxcapviolations.md) | `Checker.MaxCapViolations` | Báo vi phạm max capacitance | 00:00:00.013 | – |
| [79](79-misc-reportmanufacturability.md) | `Misc.ReportManufacturability` | Tóm tắt khả năng chế tạo: DRC, LVS, antenna | 00:00:00.003 | – |

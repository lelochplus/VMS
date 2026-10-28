# Xuất ảnh layout từ GDS bằng KLayout (không mở giao diện).
# Dùng: klayout -z -nc -rx -r scripts/layout_shot.py -rd gds=<file.gds> -rd lyp=<sky130A.lyp> -rd out=<anh.png>
#       thêm -rd zoom=0.12 để chụp vùng giữa rộng 12% (thấy rõ cell và dây), -rd w=2400 để đổi độ rộng ảnh
import pya
g = globals()
gds, out = g['gds'], g['out']
lyp, w, zoom = g.get('lyp', ''), int(g.get('w', 2400)), float(g.get('zoom', 1))

lv = pya.LayoutView()
lv.set_config('background-color', '#ffffff')
lv.set_config('grid-visible', 'false')
lv.load_layout(gds, 0)
if lyp: lv.load_layer_props(lyp)
lv.max_hier()
bb = lv.active_cellview().cell.dbbox()
if zoom < 1:
    c, dx, dy = bb.center(), bb.width() * zoom / 2, bb.height() * zoom / 2
    bb = pya.DBox(c.x - dx, c.y - dy, c.x + dx, c.y + dy)
lv.zoom_box(bb)
h = max(200, round(w * bb.height() / bb.width()))
lv.save_image(out, w, h)
print(f'{out}: {w}x{h} px, vung {bb.width():.1f} x {bb.height():.1f} um')

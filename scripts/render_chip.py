# Ve anh PNG cua 1 file GDS, chi hien li1 va met1..met5.
# Chay: klayout -zz -rd gds=<file.gds> -rd png=<anh.png> [-rd lyp=<file.lyp>] -r scripts/render_chip.py
import pya
lv = pya.LayoutView()
lv.load_layout(gds, True)
if "lyp" in globals():
    lv.load_layer_props(lyp)
else:
    lv.add_missing_layers()
keep = {(67, 20), (68, 20), (69, 20), (70, 20), (71, 20), (72, 20)}
it = lv.begin_layers()
while not it.at_end():
    n = it.current()
    if not n.has_children():
        n.visible = (n.source_layer, n.source_datatype) in keep
    it.next()
lv.set_config("background-color", "#ffffff")
lv.set_config("grid-visible", "false")
lv.max_hier()
lv.zoom_fit()
lv.save_image(png, 2000, 2000)
print("Da ghi", png)

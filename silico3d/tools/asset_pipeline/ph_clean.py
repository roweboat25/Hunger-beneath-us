# blender -b -P ph_clean.py -- in.gltf out.glb max_tris tex_px preview_prefix
import bpy, sys, math
from mathutils import Vector
a = sys.argv[sys.argv.index("--")+1:]
src, dst, tris, px, prev = a[0], a[1], int(a[2]), int(a[3]), a[4]
real = float(a[5]) if len(a) > 5 else 0.0
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=src)
meshes = [o for o in bpy.context.scene.objects if o.type == "MESH"]
cur = sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in meshes)
if cur > tris:
    for o in meshes:
        bpy.context.view_layer.objects.active = o
        m = o.modifiers.new("dec", "DECIMATE"); m.ratio = tris/cur
        bpy.ops.object.modifier_apply(modifier="dec")
for o in meshes:
    for p in o.data.polygons: p.use_smooth = False
if real > 0:  # rescale the whole set to its real-world size (Poly Haven metadata)
    bpy.context.view_layer.update()
    pts=[o.matrix_world @ Vector(c) for o in meshes for c in o.bound_box]
    big=max(max(p[i] for p in pts)-min(p[i] for p in pts) for i in range(3))
    k=real/big
    if abs(k-1) > 0.05:
        for o in bpy.context.scene.objects:
            if o.parent is None: o.scale = o.scale*k; o.location = o.location*k
        print("RESCALE", round(k,3), flush=True)
    bpy.context.view_layer.update()
# shrink every texture: PS1 texel density, smaller download
for img in bpy.data.images:
    if img.size[0] > px:
        r = px / max(img.size); img.scale(max(8,int(img.size[0]*r)), max(8,int(img.size[1]*r)))
        img.pack()
final = sum(sum(len(p.vertices)-2 for p in o.data.polygons) for o in meshes)
bpy.ops.export_scene.gltf(filepath=dst, export_format="GLB", export_image_format="JPEG", export_jpeg_quality=85)
print("TRIS", cur, "->", final, flush=True)
# bounds for camera
pts=[o.matrix_world @ Vector(c) for o in meshes for c in o.bound_box]
mn=Vector((min(p.x for p in pts),min(p.y for p in pts),min(p.z for p in pts))); mx=Vector((max(p.x for p in pts),max(p.y for p in pts),max(p.z for p in pts)))
ctr=(mn+mx)/2; size=max(mx-mn)
sc=bpy.context.scene; sc.render.engine="CYCLES"; sc.cycles.device="CPU"; sc.cycles.samples=24; sc.cycles.use_denoising=False
sc.render.resolution_x=sc.render.resolution_y=320
w=bpy.data.worlds.new("w"); w.use_nodes=True; w.node_tree.nodes["Background"].inputs[0].default_value=(0.18,0.18,0.2,1); w.node_tree.nodes["Background"].inputs[1].default_value=1.2; sc.world=w
sun=bpy.data.objects.new("sun", bpy.data.lights.new("sun","SUN")); sun.data.energy=3.5; sun.rotation_euler=(0.8,0.2,0.6); sc.collection.objects.link(sun)
sc.view_settings.view_transform="Standard"
cam=bpy.data.objects.new("cam", bpy.data.cameras.new("cam")); sc.collection.objects.link(cam); sc.camera=cam
r=size*1.9
for i,ang in enumerate([30,120,210,300]):
    t=math.radians(ang); cam.location=ctr+Vector((r*math.cos(t), r*math.sin(t), size*0.5))
    d=ctr-cam.location; cam.rotation_euler=d.to_track_quat("-Z","Y").to_euler()
    sc.render.filepath=f"{prev}_{i}.png"; bpy.ops.render.render(write_still=True)

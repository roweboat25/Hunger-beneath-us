# blender -b -P clean.py -- in_mesh out.glb target_tris size_m preview_prefix
import bpy, sys, math, bmesh
from mathutils import Vector
a = sys.argv[sys.argv.index("--")+1:]
src, dst, tris, size, prev = a[0], a[1], int(a[2]), float(a[3]), a[4]
bpy.ops.wm.read_factory_settings(use_empty=True)
if src.endswith(".obj"):
    bpy.ops.wm.obj_import(filepath=src, up_axis="Z", forward_axis="Y")
else:
    bpy.ops.import_scene.gltf(filepath=src)
meshes = [o for o in bpy.context.scene.objects if o.type == "MESH"]
bpy.ops.object.select_all(action="DESELECT")
for o in meshes: o.select_set(True)
bpy.context.view_layer.objects.active = meshes[0]
if len(meshes) > 1: bpy.ops.object.join()
ob = bpy.context.view_layer.objects.active
bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)
# clean: merge doubles, drop tiny floating islands, fix normals
bm = bmesh.new(); bm.from_mesh(ob.data)
bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=1e-5)
islands, seen = [], set()
for f in bm.faces:
    if f.index in seen: continue
    stack, isl = [f], []
    seen.add(f.index)
    while stack:
        c = stack.pop(); isl.append(c)
        for e in c.edges:
            for n in e.link_faces:
                if n.index not in seen: seen.add(n.index); stack.append(n)
    islands.append(isl)
big = max(len(i) for i in islands)
kill = [f for i in islands if len(i) < big*0.02 for f in i]
bmesh.ops.delete(bm, geom=kill, context="FACES")
bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
bm.to_mesh(ob.data); bm.free()
# decimate to budget
cur = sum(len(p.vertices)-2 for p in ob.data.polygons)
if cur > tris:
    m = ob.modifiers.new("dec", "DECIMATE"); m.ratio = tris/cur
    bpy.ops.object.modifier_apply(modifier="dec")
# scale longest side to size, origin at bottom centre
ob.data.update()
xs=[v.co for v in ob.data.vertices]
mn=Vector((min(v.x for v in xs),min(v.y for v in xs),min(v.z for v in xs)))
mx=Vector((max(v.x for v in xs),max(v.y for v in xs),max(v.z for v in xs)))
s = size/max(mx-mn)
off = Vector(((mn.x+mx.x)/2,(mn.y+mx.y)/2,mn.z))
for v in ob.data.vertices: v.co = (v.co-off)*s
for p in ob.data.polygons: p.use_smooth = False   # flat shading = PS1 facets
# material that shows vertex colours (glTF COLOR_0)
mat = bpy.data.materials.new("m"); mat.use_nodes=True
nt=mat.node_tree; bsdf=nt.nodes["Principled BSDF"]; bsdf.inputs["Roughness"].default_value=0.8
if ob.data.color_attributes:
    ca=nt.nodes.new("ShaderNodeVertexColor"); ca.layer_name=ob.data.color_attributes[0].name
    nt.links.new(ca.outputs["Color"], bsdf.inputs["Base Color"])
ob.data.materials.clear(); ob.data.materials.append(mat)
final = sum(len(p.vertices)-2 for p in ob.data.polygons)
bpy.ops.export_scene.gltf(filepath=dst, export_format="GLB", use_selection=False)
print("TRIS", cur, "->", final, flush=True)
# turntable previews (workbench, vertex colour)
sc=bpy.context.scene; sc.render.engine="CYCLES"; sc.cycles.device="CPU"; sc.cycles.samples=24; sc.cycles.use_denoising=False
sc.render.resolution_x=sc.render.resolution_y=320; sc.render.film_transparent=False
w=bpy.data.worlds.new("w"); w.use_nodes=True; w.node_tree.nodes["Background"].inputs[0].default_value=(0.18,0.18,0.2,1); w.node_tree.nodes["Background"].inputs[1].default_value=1.2; sc.world=w
sun=bpy.data.objects.new("sun", bpy.data.lights.new("sun","SUN")); sun.data.energy=3.5; sun.rotation_euler=(0.8,0.2,0.6); sc.collection.objects.link(sun)
sc.view_settings.view_transform="Standard"
cam=bpy.data.objects.new("cam", bpy.data.cameras.new("cam")); sc.collection.objects.link(cam); sc.camera=cam
h=(mx-mn).z*s; r=size*2.0
for i,ang in enumerate([30,120,210,300]):
    t=math.radians(ang); cam.location=(r*math.cos(t), r*math.sin(t), h*0.5+size*0.6)
    d=Vector((0,0,h*0.45))-cam.location; cam.rotation_euler=d.to_track_quat("-Z","Y").to_euler()
    sc.render.filepath=f"{prev}_{i}.png"; bpy.ops.render.render(write_still=True)

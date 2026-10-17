# blender -b -P photobox.py -- ref.png out.glb W H D crop(x0,y0,x1,y1 in 0-1) side_rgb preview
# The PS1 trick: a plain box, its front face textured with the AI reference image.
import bpy, sys, math, bmesh
from mathutils import Vector
a = sys.argv[sys.argv.index("--")+1:]
ref, dst = a[0], a[1]; W, H, D = map(float, a[2:5]); x0,y0,x1,y1 = map(float, a[5].split(",")); side = [float(c) for c in a[6].split(",")]; prev=a[7]
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.mesh.primitive_cube_add(size=1); ob = bpy.context.object
ob.scale = (W, D, H); bpy.ops.object.transform_apply(scale=True); ob.location.z = H/2; bpy.ops.object.transform_apply(location=True)
img = bpy.data.images.load(ref); img.scale(256, 256); img.pack()
front = bpy.data.materials.new("front"); front.use_nodes = True
tex = front.node_tree.nodes.new("ShaderNodeTexImage"); tex.image = img; tex.interpolation = "Closest"
b = front.node_tree.nodes["Principled BSDF"]; front.node_tree.links.new(tex.outputs["Color"], b.inputs["Base Color"])
front.node_tree.links.new(tex.outputs["Color"], b.inputs["Emission Color"]); b.inputs["Emission Strength"].default_value = 0.35
body = bpy.data.materials.new("body"); body.use_nodes = True
body.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value = (*side, 1); body.node_tree.nodes["Principled BSDF"].inputs["Metallic"].default_value = 0.6
ob.data.materials.append(body); ob.data.materials.append(front)
bm = bmesh.new(); bm.from_mesh(ob.data); uv = bm.loops.layers.uv.verify()
for f in bm.faces:
    if f.normal.y < -0.9:  # front face (-Y)
        f.material_index = 1
        for l in f.loops:
            u = (l.vert.co.x/W + 0.5); v = (l.vert.co.z/H)
            l[uv].uv = (x0 + u*(x1-x0), 1-(y1 - v*(y1-y0)) if False else (1-y1) + v*(y1-y0))
bm.to_mesh(ob.data); bm.free()
bpy.ops.export_scene.gltf(filepath=dst, export_format="GLB", export_image_format="JPEG")
sc=bpy.context.scene; sc.render.engine="CYCLES"; sc.cycles.samples=24; sc.cycles.use_denoising=False; sc.render.resolution_x=sc.render.resolution_y=320
w=bpy.data.worlds.new("w"); w.use_nodes=True; w.node_tree.nodes["Background"].inputs[0].default_value=(0.18,0.18,0.2,1); sc.world=w
sun=bpy.data.objects.new("sun", bpy.data.lights.new("sun","SUN")); sun.data.energy=3; sun.rotation_euler=(0.8,0.2,-0.6); sc.collection.objects.link(sun)
sc.view_settings.view_transform="Standard"
cam=bpy.data.objects.new("cam", bpy.data.cameras.new("cam")); sc.collection.objects.link(cam); sc.camera=cam
size=max(W,H,D); ctr=Vector((0,0,H/2))
for i,ang in enumerate([-60,-100,-140,-20]):
    t=math.radians(ang); cam.location=ctr+Vector((size*1.8*math.cos(t), size*1.8*math.sin(t), size*0.3))
    cam.rotation_euler=(ctr-cam.location).to_track_quat("-Z","Y").to_euler(); sc.render.filepath=f"{prev}_{i}.png"; bpy.ops.render.render(write_still=True)

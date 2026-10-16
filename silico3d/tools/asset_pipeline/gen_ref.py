import sys, json, time, torch
from diffusers import AutoPipelineForText2Image
torch.set_num_threads(4)
pipe = AutoPipelineForText2Image.from_pretrained("stabilityai/sdxl-turbo", torch_dtype=torch.float32)
STYLE = (" Isolated single 3D game asset, three-quarter view from slightly above, centered, entire object in frame, "
         "plain light grey seamless studio background, soft even lighting, no shadows, no text, no logos, clean product render.")
jobs = json.load(open(sys.argv[1]))
only = sys.argv[2:] 
for j in jobs:
    if only and j["id"] not in only: continue
    for k in range(j.get("n", 2)):
        t=time.time()
        g = torch.Generator().manual_seed(100+k)
        img = pipe(prompt=j["prompt"]+STYLE, num_inference_steps=4, guidance_scale=0.0, width=512, height=512, generator=g).images[0]
        img.save(f"./work/ref/{j['id']}_{k}.png"); print(j["id"], k, round(time.time()-t,1), "s", flush=True)

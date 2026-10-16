import json, sys, os, urllib.request
op=urllib.request.build_opener(); op.addheaders=[("User-Agent","silico-asset-tool/1.0")]; urllib.request.install_opener(op)
for aid in sys.argv[1:]:
    f = json.load(urllib.request.urlopen(f"https://api.polyhaven.com/files/{aid}"))
    g = f["gltf"]["1k"]["gltf"]
    d = f"./work/ph/{aid}"; os.makedirs(d, exist_ok=True)
    urllib.request.urlretrieve(g["url"], f"{d}/{aid}.gltf")
    for rel, inc in g.get("include", {}).items():
        p = os.path.join(d, rel); os.makedirs(os.path.dirname(p), exist_ok=True)
        urllib.request.urlretrieve(inc["url"], p)
    print("got", aid, flush=True)

import sys
from PIL import Image
n=sys.argv[1]; ims=[Image.open(f'./work/prev/{n}_{i}.png') for i in range(4)]
s=Image.new('RGB',(1280,320)); [s.paste(im,(i*320,0)) for i,im in enumerate(ims)]; s.save(f'./work/prev/{n}_sheet.png')

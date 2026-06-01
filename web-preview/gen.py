import os
base = r'C:\Users\hftan\Documents\Codex\2026-06-01\superpowers-plugin-superpowers-openai-curated\orishas-path\web-preview'
js = []
js.append('// Orishas Path Game')
js.append('var G={n:c:null,l:1,e:0,et:100,o:0,mh:100,h:100,mm:50,mp:50,a:15,d:10}')
with open(os.path.join(base, 'game.js'), 'w') as f:
    f.write(chr(10).join(js))
print('game.js written')
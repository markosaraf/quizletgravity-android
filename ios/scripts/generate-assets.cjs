// Usage: NODE_PATH=/path/to/node_modules node ios/scripts/generate-assets.cjs
const fs = require('fs');
const path = require('path');
const sharp = require('sharp');
const root = path.resolve(__dirname, '../..');
const assets = path.join(root, 'ios/QuizletGravity/Assets.xcassets');
const info = {version: 1, author: 'xcode'};
const json = (p,v) => fs.writeFileSync(p, JSON.stringify(v,null,2)+'\n');
(async () => {
  json(path.join(assets,'Contents.json'), {info});
  for (const [name, source] of Object.entries({LogoGold:'quizlet-q-chip-gold-on-indigo-3.svg',LogoGoldBackground:'quizlet-q-chip-indigo-on-gold-3.svg',LogoBlack:'quizlet-q-chip-black-on-indigo3.svg',LogoWhite:'quizlet-q-chip-white-on-indigo-3.svg'})) {
    const dir=path.join(assets, name+'.imageset'); fs.mkdirSync(dir,{recursive:true});
    const images=[];
    for (const scale of [1,2,3]) {
      const filename=`${name}@${scale}x.png`;
      await sharp(path.join(root,'artwork',source)).resize(156*scale,156*scale).flatten().png().toFile(path.join(dir,filename));
      images.push({idiom:'universal',filename,scale:scale+'x'});
    }
    json(path.join(dir,'Contents.json'),{images,info});
  }
  const dir=path.join(assets,'AppIcon.appiconset');fs.mkdirSync(dir,{recursive:true});
  const images=[];
  for(const [idiom, size, scales] of [['iphone',20,[2,3]],['iphone',29,[2,3]],['iphone',40,[2,3]],['iphone',60,[2,3]],['ipad',20,[1,2]],['ipad',29,[1,2]],['ipad',40,[1,2]],['ipad',76,[1,2]],['ipad',83.5,[2]],['ios-marketing',1024,[1]]]) {
    for(const scale of scales){
      const filename=`${idiom}-${size}-${scale}.png`;
      await sharp(path.join(root,'artwork/app-icon-source.svg')).resize(size*scale,size*scale).flatten().png().toFile(path.join(dir,filename));
      images.push({idiom,size:`${size}x${size}`,scale:`${scale}x`,filename});
    }
  }
  json(path.join(dir,'Contents.json'),{images,info});
  for(const [folder,size] of [['google-play',512],['app-store',1024]]) await sharp(path.join(root,'artwork/app-icon-source.svg')).resize(size,size).flatten().png().toFile(path.join(root,'store',folder,'app-icon.png'));
})();

import { resolve } from 'path';
import { promises as fs } from 'fs';

const path = resolve(process.cwd(),'../server/hta-data/gamedata/gameobjects/vehicleparts.json');

await fs.readFile(path, 'utf8')
.then(data => JSON.parse(data))
.then(data => data.Prototypes.Folder)
.then(folders => folders.map(folder => ({
  name: folder._attributes.Name,
  parts: folder.Prototype.map((item) => item._attributes.Name)
})))
.then(data => {
  var object = {};
  data.forEach(({ name, parts }) => { object[name] = parts })

  return object;
})


.then(console.log)
.catch((error) => console.log(`Error: ${error}`))
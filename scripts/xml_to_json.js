import { globby } from 'globby';
import { resolve } from 'path';
import { promises as fs } from 'fs';
import { xml2json } from 'xml-js'

globby([
  resolve(process.cwd(), '../client/hta-data/**/*.xml'),
  resolve(process.cwd(),'../server/hta-data/**/*.xml')
])
.then((paths => paths.map(async path => ({ path, data: await fs.readFile(path, 'utf8')}))))
.then(promises => Promise.all(promises))
.then(xmls => xmls.map(({ data, path }) => ({ path, data: xml2json(data, { compact: true, spaces: 2 })})))
.then(JSONs => JSONs.map(({ path, data }) => ({ path: path.replace('.xml', '.json'), data })))
.then(JSONs => JSONs.map(async ({ path, data }) => { await fs.writeFile(path, data); return path }))
.then(promises => Promise.all(promises))
.then(paths => paths.map((path => path.replace('.json', '.xml'))))
.then(paths => paths.map(async path => await fs.rm(path)))
.then(promises => Promise.all(promises))
.then(() => console.log('success'))
.catch((error) => console.log(`Translation failed! Error: ${error}`))
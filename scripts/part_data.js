import { resolve } from 'path';
import { promises as fs } from 'fs';

const path = resolve(process.cwd(),'../server/hta-data/gamedata/gameobjects/vehicleparts.json');

if (process.argv[2] === 'to_console') {
  partData().then(console.log)
}


export function partData() {
  return fs
    .readFile(path, 'utf8')
    .then(data => JSON.parse(data))
    .then(data => data.Prototypes.Folder)
    .then(folders => folders.map(folder => ({
      name: folder._attributes.Name,
      data: folder.Prototype
        .filter(data => singular(data._attributes.Class) === singular(folder._attributes.Name))
        .map((item) => ({ 
          name: item._attributes.Name, 
          data: Object.keys(item._attributes).map(key => ({
            name: key,
            data: typeByValue(item._attributes[key])
          }))
        })),
    })))
    .then(folders => folders.map(({ name, data }) => ({ name, data: data.map(({ name, data }) => ({ name, data: array_to_object(data)}))})))
    .then(folders => folders.map(({ name, data }) => ({ name, data: data.map(({ data }) => data).reduce(partsReducer, {})})))
    .then(array_to_object)
    .then(JSON.stringify)
}

function singular(str) {
  if (str.at(-1) === 's') {
    return str.slice(0, -1);
  }

  return str;
}

function array_to_object(array) {
  const object = {};
  array.forEach((item) => { object[item.name] = item.data })

  return object;
}

function typeByValue(value) {
  const split = value.trim().split(' ');

  if (split.length > 1) {
    return `Array of ${getSimpleType(split[0])}`
  }

  return getSimpleType(value);
}

function getSimpleType(value) {
  if (value.trim() === '')
    return `An Empty String`

  if (Number.isInteger(Number(value))) {
    return 'int'
  }

  if (!Number.isNaN(Number(value))) {
    return 'float'
  }


  if (value === 'false' || value === 'true')
    return 'bool'

  return "String";
}

function partsReducer(previousValue, currentValue, index, array) {
  const current = { ...currentValue }
  const result = { ... previousValue };

  for (const key in previousValue) {
    if (current[key] !== undefined) {
      if (result[key].split(' | ').indexOf(current[key]) === -1) {
        result[key] = `${result[key]} | ${current[key]}`
      }

      current[key] = undefined;
      delete current[key];
    }
    else {
      if (result[key].split(' | ').indexOf('Null') === -1) {
        result[key] = `${result[key]} | Null`
      }
    }
  }

  for (const key in current) {
    result[key] = index === 0 ? current[key] : `${current[key]} | Null`;
  }


  return result;
}
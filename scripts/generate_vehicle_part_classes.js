import { partData } from "./part_data.js";

const godotReservedFields = [
  "if",
  "elif",
  "else",
  "for",
  "while",
  "match",
  "break",
  "continue",
  "pass",
  "return",
  "class",
  "class_name",
  "extends",
  "is",
  "as",
  "self",
  "tool",
  "signal",
  "func",
  "static",
  "const",
  "enum",
  "var",
  "onready",
  "export",
  "setget",
  "breakpoint",
  "preload",
  "yield",
  "assert",
  "remote",
  "master",
  "puppet",
  "remotesync",
  "mastersync",
  "puppetsync",
  "PI",
  "TAU",
  "INF",
  "NAN"
]

const snippet = {
  'class': `\n\n\n\nclass {name} extends VehiclePart:\n	var nullable: Nullable\n`,
  'field': `	var {name}: {type}\n`,
  'nullable_declaration': `	\n	class Nullable:\n`,
  'nullable_field':`		var {name}: {type}\n`,
  'constructor_declaration': `\n\n	func _init(json).(json):\n		self.nullable = Nullable.new()\n`,
  'constructor_field': `		self.{godot_name} = {load_function}('{json_name}')\n`,
  'constructor_nullable_field': `		self.nullable.{godot_name} = {load_function}('{json_name}')\n`,
}

partData()
.then(JSON.parse)
.then((json) => {
  let code = ``;

  for(const key in json) {
    const fields = json[key];
    const notNullable = {}
    const nullable = {}

    for(const field in fields) {
      if (fields[field].split('Null').length > 1)
        nullable[field] = fields[field];
      else
        notNullable[field] = fields[field];
    }

    code += use_snippet(snippet.class, { name: `${key}VehiclePart` });

    for(const field in notNullable) {
      code += use_snippet(snippet.field, { name: `${toVariableName(field)}`, type: fields[field] });
    }

    code += use_snippet(snippet.nullable_declaration, {});
    
    for(const field in nullable) {
      code += use_snippet(snippet.nullable_field, { name: `${toVariableName(field)}`, type: fields[field] });
    }

    code += use_snippet(snippet.constructor_declaration, {});

    for(const field in notNullable) {
      code += use_snippet(snippet.constructor_field, { godot_name: `${toVariableName(field)}`, load_function: get_type(fields[field]), json_name: field});
    }

    for(const field in nullable) {
      code += use_snippet(snippet.constructor_nullable_field, { godot_name: `${toVariableName(field)}`, load_function: get_type(fields[field]), json_name: field});
    }
  }
  
  return code;
})
.then(console.log)

function use_snippet(snippet, args) {
  let result = snippet;

  for(const argument in args) {
    result = result.replaceAll(`{${argument}}`, args[argument]);
  }

  return result;
}

function toVariableName(str) {
  const name = toSneakCase(str);

  if (godotReservedFields.indexOf(name) !== -1) {
    return `_${name}`;
  }

  return name;
}

function toSneakCase(str) {
  return str[0].toLowerCase() + str.slice(1).replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`);
}

function get_type(value) {
  if (value === 'int' || value === 'int | Null')
    return 'load_int'

  if (value === 'String' || value === 'String | Null')
    return 'load_string'

  if (value === 'float' || value === 'float | Null')
    return 'load_float'

  if (value === 'bool' || value === 'bool | Null')
    return 'load_boolean'

  if (value === 'Array of String' || value === 'Array of String | Null')
    return 'load_string_array'

  if (value === 'Array of Int' || value === 'Array of Int | Null')
    return 'load_int_array'

  if (value === 'Array of Float' || value === 'Array of Float | Null')
    return 'load_float_array'


  return '__need_attention__'
}

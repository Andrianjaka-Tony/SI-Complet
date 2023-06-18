import { get } from "./function.js";

/**
 * @param {string} tablename
 * @param {string} filename
 * @return {Promise<string>}
 */
export async function read(tablename, filename) {
  let response = `INSERT INTO ${tablename} (`;
  let data = await get(filename);
  let array = data.split("\n");
  let cols = array[0].split(";");
  array.shift();
  cols.forEach((col, index) => {
    response += col;
    if (index != cols.length - 1) {
      response += ", ";
    }
  });
  response += ") VALUES ";
  array.forEach((row, index) => {
    response += "(";
    let values = row.split(";");
    values.forEach((value, i) => {
      response += `'${value}'`;
      if (i != values.length - 1) {
        response += ", ";
      }
    });
    response += ")";

    if (index != array.length - 1) {
      response += ", ";
    }
  });
  console.log(response);
}

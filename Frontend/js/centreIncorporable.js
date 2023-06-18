import { CentreIncorporable } from "../models/centreIncorporable.js";
import {
  createTransitionDiv,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
} from "../utils/function.js";

/**
 * @param {number} centre
 * @return {Promise<CentreIncorporable[]>}
 */
async function getData(centre) {
  const url = `http://localhost:120/SI/hello/centre_incorporable?centre=${centre}`;
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {CentreIncorporable} centreIncorporable
 * @return {HTMLTableRowElement}
 */
function createRow(centreIncorporable) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td class="numeric" width="200px">${centreIncorporable.compte}</td>
    <td width="400px">${centreIncorporable.intitule}</td>
    <td class="numeric" width="250px">${printNumber(
      centreIncorporable.variable
    )}</td>
    <td class="numeric" width="250px">${printNumber(
      centreIncorporable.fixe
    )}</td>
  `;
  return tr;
}

/**
 * @param {CentreIncorporable[]} centreIncorporables
 * @return {void}
 */
function addRows(centreIncorporables) {
  let tbody = document.querySelector("tbody");
  centreIncorporables.forEach((centreIncorporable) => {
    tbody.appendChild(createRow(centreIncorporable));
  });
}

/**
 * @param {CentreIncorporable[]} centreIncorporables
 * @return {void}
 */
function updateRoot(centreIncorporables) {
  rootDiv.innerHTML = `
    <div class="table__container">
      <table class="table">
        <thead class="table__header">
          <tr>
            <td class="first" width="200px">Compte</td>
            <td width="400px">Intitulé</td>
            <td width="250px">Variable</td>
            <td class="last" width="250px">Fixe</td>
          </tr>
        </thead>
        <tbody class="table__body"></tbody>
      </table>
      <div class="table__container__pagination"></div>
    </div>
  `;
  addRows(centreIncorporables);
  updatePagination();
  rootDiv.classList.remove("hidden");
}

/**
 * @param {number} centre
 */
export default async function (centre) {
  let centreIncorporables = await getData(centre);
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(centreIncorporables);
    removeTransitionDiv();
  }, 400);
}

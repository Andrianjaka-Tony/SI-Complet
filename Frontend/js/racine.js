import { Comptable } from "../models/comptable.js";
import {
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
  updateTableRowCount,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/racine";

/**
 * @return {Promise<Comptable[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Comptable} comptable
 * @return {HTMLTableRowElement}
 */
function createRow(comptable) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td class="numeric" width="200px">${comptable.compte}</td>
    <td width="600px">${comptable.intitule}</td>
  `;
  return tr;
}

/**
 * @param {Comptable[]} comptables
 * @return {void}
 */
function addRows(comptables) {
  let tbody = document.querySelector("tbody");
  comptables.forEach((comptable) => {
    tbody.appendChild(createRow(comptable));
  });
}

/**
 * @param {Comptable[]} comptables
 * @return {void}
 */
function updateRoot(comptables) {
  rootDiv.innerHTML = `
    <div class="table__container">
      <table class="table">
        <thead class="table__header">
          <tr>
            <td class="first" width="200px">Compte</td>
            <td class="last" width="600px">Intitulé</td>
          </tr>
        </thead>
        <tbody class="table__body"></tbody>
      </table>
      <div class="table__container__pagination"></div>
      <div class="table__row__count">Nombre d'enregistrements</div>
    </div>
  `;
  addRows(comptables);
  updatePagination();
  updateTableRowCount();
  rootDiv.classList.remove("hidden");
}

export default async function () {
  let comptables = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(comptables);
    removeTransitionDiv();
  }, 400);
}

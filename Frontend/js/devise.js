import { Devise } from "../models/devise.js";
import {
  createTransitionDiv,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
  updateTableRowCount,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/devise";

/**
 * @return {Promise<Devise[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Devise} devise
 * @return {HTMLTableRowElement}
 */
function createRow(devise) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td width="300px">${devise.nom}</td>
    <td class="numeric" width="200px">${printNumber(devise.valeur)}</td>
    <td width="200px">${devise.date}</td>
  `;
  return tr;
}

/**
 * @param {Devise[]} devises
 * @return {void}
 */
function addRows(devises) {
  let tbody = document.querySelector("tbody");
  devises.forEach((devise) => {
    tbody.appendChild(createRow(devise));
  });
}

/**
 * @param {Devise[]} devises
 * @return {void}
 */
function updateRoot(devises) {
  rootDiv.innerHTML = `
    <div class="table__container">
      <table class="table">
        <thead class="table__header">
          <tr>
            <td class="first" width="300px">Nom</td>
            <td width="200px">Valeur</td>
            <td class="last" width="200px">Date</td>
          </tr>
        </thead>
        <tbody class="table__body"></tbody>
      </table>
      <div class="table__container__pagination"></div>
      <div class="table__row__count">Nombre d'enregistrements</div>
    </div>
  `;
  addRows(devises);
  updatePagination();
  updateTableRowCount();
  rootDiv.classList.remove("hidden");
}

export default async function () {
  let devises = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(devises);
    removeTransitionDiv();
  }, 400);
}

import { Ecriture } from "../models/ecriture.js";
import {
  createTransitionDiv,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
  updateTableRowCount,
} from "../utils/function.js";

/**
 * @param {string} url
 * @return {Promise<Ecriture[]>}
 */
async function getData(url) {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Ecriture} ecriture
 * @return {HTMLTableRowElement}
 */
function createRow(ecriture) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td class="numeric" width="200px">${ecriture.compte}</td>
    <td width="400px">${ecriture.intitule}</td>
    <td width="200px">${ecriture.tiers ? ecriture.tiers : ""}</td>
    <td width="300px">${ecriture.journal}${ecriture.piece}</td>
    <td class="numeric" width="250px">${printNumber(ecriture.debit)}</td>
    <td class="numeric" width="250px">${printNumber(ecriture.credit)}</td>
    <td width="150px">${ecriture.date}</td>
  `;
  return tr;
}

/**
 * @param {Ecriture[]} ecritures
 * @return {void}
 */
function addRows(ecritures) {
  let tbody = document.querySelector("tbody");
  ecritures.forEach((ecriture) => {
    tbody.appendChild(createRow(ecriture));
  });
}

/**
 * @param {string} title
 * @param {string} subtitle
 * @param {Ecriture[]} ecritures
 * @return {void}
 */
function updateRoot(title, subtitle, ecritures) {
  rootDiv.innerHTML = `
  <div class="livre">
    <h1 class="livre__title">${title}</h1>
    <h2 class="livre__subtitle">${subtitle}</h2>
    <div class="table__container">
      <table class="table">
        <thead class="table__header">
          <tr>
            <td class="first" width="200px">Compte</td>
            <td width="400px">Intitulé</td>
            <td width="200px">Tiers</td>
            <td width="300px">Piece</td>
            <td width="250px">Débit</td>
            <td width="250px">Crédit</td>
            <td class="last" width="150px">Date</td>
          </tr>
        </thead>
        <tbody class="table__body"></tbody>
      </table>
      <div class="table__container__pagination"></div>
      <div class="table__row__count">Nombre d'enregistrements</div>
    </div>
  </div>
  `;
  addRows(ecritures);
  updatePagination();
  updateTableRowCount();
  rootDiv.classList.remove("hidden");
}

/**
 * @param {string} title
 * @param {string} subtitle
 * @param {string} url
 * @return {void}
 */
export default async function (title, subtitle, url) {
  let ecritures = await getData(url);
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(title, subtitle, ecritures);
    removeTransitionDiv();
  }, 400);
}

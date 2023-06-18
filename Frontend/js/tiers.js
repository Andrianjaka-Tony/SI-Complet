import { Tiers } from "../models/tiers.js";
import { default as renderForm } from "./forms/tiers.js";
import {
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
  updateTableRowCount,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/tiers";

/**
 * @return {Promise<Tiers[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Tiers} tiers
 * @return {HTMLTableRowElement}
 */
function createRow(tiers) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td class="numeric" width="200px">${tiers.compte}${tiers.numero}</td>
    <td width="600px">${tiers.intitule}</td>
  `;
  return tr;
}

/**
 * @param {Tiers[]} tiers
 * @return {void}
 */
function addRows(tiers) {
  let tbody = document.querySelector("tbody");
  tiers.forEach((tier) => {
    tbody.appendChild(createRow(tier));
  });
}

/**
 * @return {void}
 */
function lisetBtnAjouter() {
  let btn = rootDiv.querySelector(".btn__ajouter");
  btn.addEventListener("click", renderForm);
}

/**
 * @param {Tiers[]} tiers
 * @return {void}
 */
function updateRoot(tiers) {
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
    <button class="btn btn__ajouter">Ajouter</button>
  `;
  addRows(tiers);
  updatePagination();
  updateTableRowCount();
  lisetBtnAjouter();
  rootDiv.classList.remove("hidden");
}

export default async function () {
  let tiers = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(tiers);
    removeTransitionDiv();
  }, 400);
}

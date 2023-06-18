import { Journal } from "../models/journal.js";
import { default as renderLivre } from "./livre.js";
import { default as renderForm } from "./forms/journal.js";
import {
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
  updateTableRowCount,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/journal";

/**
 * @return {Promise<Journal[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Journal} journal
 * @return {HTMLTableRowElement}
 */
function createRow(journal) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td class="numeric" width="200px">${journal.code}</td>
    <td width="600px">${journal.intitule}</td>
  `;

  tr.addEventListener("click", () => {
    renderLivre(
      journal.code,
      journal.intitule,
      `http://localhost:120/SI/hello/livre?col=journal&value=${journal.code}`
    );
  });
  return tr;
}

/**
 * @param {Journal[]} journaux
 * @return {void}
 */
function addRows(journaux) {
  let tbody = document.querySelector("tbody");
  journaux.forEach((journal) => {
    tbody.appendChild(createRow(journal));
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
 * @param {Journal[]} journaux
 * @return {void}
 */
function updateRoot(journaux) {
  rootDiv.innerHTML = `
    <div class="table__container">
      <table class="table">
        <thead class="table__header">
          <tr>
            <td class="first" width="200px">Code</td>
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
  addRows(journaux);
  updatePagination();
  updateTableRowCount();
  lisetBtnAjouter();
  rootDiv.classList.remove("hidden");
}

export default async function () {
  let journaux = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(journaux);
    removeTransitionDiv();
  }, 400);
}

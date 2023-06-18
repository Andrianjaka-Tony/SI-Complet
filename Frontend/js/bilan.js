import { Balance } from "../models/balance.js";
import {
  createTransitionDiv,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/bilan?date=2023-12-31";

/**
 * @return {Promise<Balance[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Balance} balance
 * @return {HTMLTableRowElement}
 */
function createRow(balance) {
  let solde = Math.abs(balance.debit - balance.credit);
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <td class="numeric" width="200px">${balance.compte}</td>
    <td width="400px">${balance.intitule}</td>
    <td class="numeric" width="250px">${printNumber(balance.debit)}</td>
    <td class="numeric" width="250px">${printNumber(balance.credit)}</td>
    <td class="numeric" width="250px">${
      parseInt(balance.debit) > parseInt(balance.credit)
        ? printNumber(solde)
        : 0
    }</td>
    <td class="numeric" width="250px">${
      parseInt(balance.credit) > parseInt(balance.debit)
        ? printNumber(solde)
        : 0
    }</td>
  `;
  return tr;
}

/**
 * @param {Balance[]} balances
 * @return {void}
 */
function addRows(balances) {
  let tbody = document.querySelector("tbody");
  balances.forEach((balance) => {
    tbody.appendChild(createRow(balance));
  });
}

/**
 * @return {void}
 */
function reset() {
  rootDiv.querySelector("tbody").innerHTML = "";
  rootDiv.querySelector(".table__container__pagination").innerHTML = "";
}

/**
 * @param {string} date
 * @return {void}
 */
async function updateOnNewDate(date) {
  let APIUrl = `http://localhost:120/SI/hello/bilan?date=${date}`;
  let data = await get(APIUrl);
  data = JSON.parse(data);
  reset();
  addRows(data);
  updatePagination();
}

/**
 * @param {Balance[]} balances
 * @return {void}
 */
function updateRoot(balances) {
  rootDiv.innerHTML = `
    <span class="label">Choisir la date</span>
    <input id="date" type="date" value="2023-12-31" class="input__date" />
    <div class="table__container">
      <table class="table">
        <thead class="table__header">
          <tr>
            <td class="first" width="200px">Compte</td>
            <td width="400px">Intitulé</td>
            <td width="250px">Débit</td>
            <td width="250px">Crédit</td>
            <td width="250px">Solde debiteur</td>
            <td class="last" width="250px">Solde crediteur</td>
          </tr>
        </thead>
        <tbody class="table__body"></tbody>
      </table>
      <div class="table__container__pagination"></div>
    </div>
  `;
  addRows(balances);
  updatePagination();
  rootDiv.classList.remove("hidden");

  let input = rootDiv.querySelector("#date");
  input.addEventListener("change", () => {
    updateOnNewDate(input.value);
  });
}

export default async function () {
  let balances = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(balances);
    removeTransitionDiv();
  }, 400);
}

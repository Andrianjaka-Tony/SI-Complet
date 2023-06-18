import { Balance } from "../models/balance.js";
import {
  createTransitionDiv,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
  updatePagination,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/balance?id=1";

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
 * @param {Balance[]} balances
 * @return {void}
 */
function updateRoot(balances) {
  let debit = 0,
    credit = 0,
    soldeD = 0,
    sodleC = 0;
  balances.forEach((balance) => {
    debit += parseInt(balance.debit);
    credit += parseInt(balance.credit);

    if (parseInt(balance.debit) > parseInt(balance.credit)) {
      soldeD += parseInt(balance.debit) - parseInt(balance.credit);
    } else {
      sodleC += -parseInt(balance.debit) + parseInt(balance.credit);
    }
  });

  rootDiv.innerHTML = `
    <div class="balance__container">
      <div class="balance__card">
      <h1 class="balance__title">Mouvement</h1>
        <p class="balance__text">Débit <span>${printNumber(debit)} Ar</span></p>
        <p class="balance__text">Crédit <span>${printNumber(
          credit
        )} Ar</span></p>
      </div>
      <div class="balance__card">
        <h1 class="balance__title">Solde</h1>
        <p class="balance__text">Débit <span>${printNumber(
          soldeD
        )} Ar</span></p>
        <p class="balance__text">Crédit <span>${printNumber(
          sodleC
        )} Ar</span></p>
      </div>
    </div>
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

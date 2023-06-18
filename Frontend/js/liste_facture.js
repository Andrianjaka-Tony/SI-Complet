import {
  createTransitionDiv,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
} from "../utils/function.js";
import { default as renderFacture } from "./facture__card.js";

const url = "http://localhost:120/SI/hello/facture";

/**
 * @return {Promise<Tiers[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {*} facture
 * @return {HTMLTableRowElement}
 */
function createCard(facture) {
  let div = document.createElement("div");
  div.classList.add("facture__card");
  facture.json = JSON.parse(facture.json);
  div.innerHTML = `
    <h1 class="company">${facture.json.entreprise.nom}</h1>
    <p class="facture">${facture.id}</p>
    <p class="intitule">${facture.json.objet}</p>
    <p class="montant">${printNumber(facture.json.total)} Ar TTC</p>
    <p class="date">${facture.date}</p>
  `;
  div.addEventListener("click", () => {
    renderFacture(facture.json);
  });
  return div;
}

/**
 * @param {*[]} factures
 * @return {void}
 */
function addCards(factures) {
  let facture__liste = document.querySelector(".facture__liste");
  factures.forEach((facture) => {
    facture__liste.appendChild(createCard(facture));
  });
}

/**
 * @return {void}
 */
async function searchByText() {
  if (!rootDiv.querySelector("#textuel").value) {
    let API = `http://localhost:120/SI/hello/facture`;
    let data = await get(API);
    data = JSON.parse(data);
    rootDiv.querySelector(".facture__liste").innerHTML = "";
    addCards(data);
  } else {
    let value = rootDiv.querySelector("#textuel").value;
    let API = `http://localhost:120/SI/hello/recherche_textuel?texte=${value}`;
    let data = await get(API);
    data = JSON.parse(data);
    rootDiv.querySelector(".facture__liste").innerHTML = "";
    addCards(data);
  }
}

/**
 * @return {void}
 */
async function searchByDate() {
  let begin = rootDiv.querySelector("#begin").value;
  let end = rootDiv.querySelector("#end").value;
  let API = `http://localhost:120/SI/hello/recherche_date?begin=${begin}&end=${end}`;
  let data = await get(API);
  data = JSON.parse(data);
  rootDiv.querySelector(".facture__liste").innerHTML = "";
  addCards(data);
}

/**
 * @return {void}
 */
async function searchByMontant() {
  let begin = rootDiv.querySelector("#montant_begin").value;
  let end = rootDiv.querySelector("#montant_end").value;
  let API = `http://localhost:120/SI/hello/recherche_montant?montant_begin=${begin}&montant_end=${end}`;
  let data = await get(API);
  data = JSON.parse(data);
  rootDiv.querySelector(".facture__liste").innerHTML = "";
  addCards(data);
}

/**
 * @param {Tiers[]} tiers
 * @return {void}
 */
function updateRoot(tiers) {
  rootDiv.innerHTML = `
    <div class="search__container">
      <section>
        <label class="label">Recherche textuel</label>
        <input type="text" id="textuel" class="input" />
      </section>
      <section>
        <label class="label">Du</label>
        <input type="date" id="begin" class="input" />
        <label class="label">au</label>
        <input type="date" id="end" class="input" />
        <button id="date-search" class="btn confirm">Rechercher</button>
      </section>
      <section>
        <label class="label">Montant de </label>
        <input type="text" id="montant_begin" class="input" />
        <label class="label">jusqu'a</label>
        <input type="text" id="montant_end" class="input" />
        <button id="montant-search" class="btn confirm">Rechercher</button>
      </section>
    </div>
    <div class="facture__liste"></div>
  `;
  addCards(tiers);

  rootDiv.querySelector("#textuel").addEventListener("input", searchByText);
  rootDiv.querySelector("#date-search").addEventListener("click", searchByDate);
  rootDiv
    .querySelector("#montant-search")
    .addEventListener("click", searchByMontant);

  rootDiv.classList.remove("hidden");
}

export default async function () {
  let factures = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(factures);
    removeTransitionDiv();
  }, 400);
}

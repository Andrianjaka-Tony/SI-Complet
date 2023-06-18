import { Centre } from "../models/centre.js";
import { default as renderCharge } from "./forms/charge.js";
import { default as renderCentreIncorporable } from "./centreIncorporable.js";
import {
  createTransitionDiv,
  drawGraph,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/centre";

/**
 * @return {Promise<Centre[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Centre} centre
 * @return {HTMLTableRowElement}
 */
function createCard(centre) {
  let div = document.createElement("div");
  div.classList.add("card");

  let total = parseInt(centre.fixe) + parseInt(centre.variable);
  div.innerHTML = `
    <h1 class="card__title">${centre.nom}</h1>
    <p class="card__info info__end"><span>${printNumber(total)} Ar</span></p>
    <p class="card__info">Variable: <span>${printNumber(
      centre.variable
    )} Ar</span></p>
    <p class="card__info">Fixe: <span>${printNumber(centre.fixe)} Ar</span></p>
    <p class="link">Voir les details</p>
    <div class="card__graphe">
      <canvas id="graphe__${centre.centre}"></canvas>
    </div>
  `;

  drawGraph(
    ["Fixe", "Variable"],
    [centre.fixe, centre.variable],
    ["rgb(255, 99, 132)", "rgb(255, 205, 86)"],
    div.querySelector(`#graphe__${centre.centre}`)
  );

  div.querySelector(".link").addEventListener("click", () => {
    renderCentreIncorporable(centre.centre);
  });
  return div;
}

/**
 * @param {Centre[]} centres
 * @return {void}
 */
function addCards(centres) {
  let cards_container = document.querySelector(".cards__container");
  centres.forEach((centre) => {
    cards_container.appendChild(createCard(centre));
  });
}

/**
 * @param {Centre[]} centres
 * @return {void}
 */
function updateRoot(centres) {
  rootDiv.innerHTML = `
    <div class="cards__container"></div>
    <p class="link add__charge">Ajouter une écriture de charge</p>
  `;
  addCards(centres);

  rootDiv.querySelector(".add__charge").addEventListener("click", renderCharge);

  rootDiv.classList.remove("hidden");
}

export default async function () {
  let centres = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(centres);
    removeTransitionDiv();
  }, 400);
}

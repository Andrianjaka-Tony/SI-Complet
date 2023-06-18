import { Societe } from "../models/societe.js";
import {
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/societe";

/**
 * @return {Promise<Societe>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Societe} societe
 * @return {string}
 */
function getInnerHTML(societe) {
  return `
    <div class="societe">
      <img
        src="./image/${societe.logo}"
        alt="Logo de la société"
        class="societe__logo"
      />
      <div class="societe__infos">
        <h1 class="societe__infos__nom">${societe.nom}</h1>
        <p class="societe__infos__text">${societe.dirigeant}</p>
        <p class="societe__infos__text">${societe.creation}</p>
        <p class="societe__infos__text">${societe.email}</p>
        <p class="societe__infos__text">${societe.adresse}</p>
        <p class="societe__infos__text">${societe.telephone}</p>
        <p class="societe__infos__autres">Autres</p>
      </div>
    </div>
    <button class="btn btn__modifier">Modifier</button>
  `;
}

/**
 * @param {Societe} societe
 * @return {void}
 */
function updateRoot(societe) {
  rootDiv.innerHTML = getInnerHTML(societe);
  rootDiv.classList.remove("hidden");
}

/**
 * @return {void}
 */
export default async function () {
  let societe = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(societe);
    removeTransitionDiv();
  }, 300);
}

import { Produit } from "../../models/produit.js";
import {
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
} from "../../utils/function.js";

/**
 * @return {Promise<Produit[]>}
 */
async function getData() {
  const url = "http://localhost:120/SI/hello/produit";
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Produit[]} produits
 * @return {void}
 */
function createValueHidden(produits) {
  let value = "";
  produits.forEach((produit, index) => {
    value += produit.produit;
    if (index != produits.length - 1) {
      value += "_";
    }
  });
  return value;
}

/**
 * @param {Produit[]} produits
 * @return {void}
 */
function updateModification(produits) {
  let modif__container = rootDiv.querySelector(".modif__container");
  produits.forEach((produit, index) => {
    modif__container.innerHTML += `
      <div class="input__container">
      <label class="label">${produit.nom}</label>
      <input
        type="text"
        name="charge_${index}"
        autocomplete="off"
        class="input" required
      />
    </div>
    `;
  });
}

/**
 * @return {void}
 */
function sendForm() {
  const url = "http://localhost:120/SI/hello/create_produit";
  let form = document.querySelector(".form__charge");
  let formData = new FormData(form);
  get(url, "POST", formData).then(console.log);
}

/**
 * @return {void}
 */
async function updateRoot() {
  let produits = await getData();
  let value = createValueHidden(produits);
  rootDiv.innerHTML = `
    <form class="form__charge">
      <div class="container">
        <h1 class="form__title">Produit</h1>
        <div class="input__container">
          <label class="label">Nom</label>
          <input type="text" name="nom" autocomplete="off" class="input" required />
        </div>
        <div class="input__container">
          <label class="label">Charge</label>
          <input
            type="text"
            name="charge"
            autocomplete="off"
            class="input" required
          />
        </div>
        <div class="input__container">
          <label class="label">Production</label>
          <input type="text" name="production" autocomplete="off" class="input" required />
        </div>
        <div class="input__container">
          <label class="label">Prix de vente</label>
          <input
            type="text"
            name="prix"
            autocomplete="off"
            class="input" required
          />
        </div>
        <input type="submit" value="Ajouter" class="btn__submit" />
      </div>
      <div class="container modif__container">
        <h1 class="form__title">Modification</h1>
        <input type="hidden" value="${value}" name="ids" id="id_produits" />
      </div>
    </form>
  `;

  rootDiv.querySelector(".form__charge").addEventListener("submit", (event) => {
    event.preventDefault();
    sendForm();
  });

  updateModification(produits);

  rootDiv.classList.remove("hidden");
}

export default function () {
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot();
    removeTransitionDiv();
  }, 400);
}

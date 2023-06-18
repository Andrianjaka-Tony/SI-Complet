import {
  createMessage,
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
} from "../../utils/function.js";
import { Produit } from "../../models/produit.js";
import { Unite } from "../../models/unite.js";
import { Tiers } from "../../models/tiers.js";
import { default as renderFacture } from "../facture.js";
import { default as renderFactureListe } from "../liste_facture.js";

/**
 * @return {Promise<string>}
 */
async function send() {
  let form = new FormData(rootDiv.querySelector("form"));
  form.append("n_products", rootDiv.querySelector(".n__products").innerHTML);
  let response = await get(
    "http://localhost:120/SI/hello/create_facture",
    "POST",
    form
  );
  return response;
}

/**
 *
 * @param {Produit[]} produits
 * @param {Unite[]} unites
 * @param {number} rank
 * @param {*} unites
 */
function createProduct(produits, unites, rank) {
  let response = document.createElement("div");
  response.classList.add("product__card");
  response.innerHTML = `
    <div class="field__container">
      <label class="label">Produit</label>
      <div class="select__container">
        <select name="id__produit__${rank}" class="select produit"></select>
      </div>
    </div>
    <div class="field__container">
      <label class="label">Quantité</label>
      <input autocomplete="off" type="text" name="quantite__${rank}" class="input" />
    </div>
    <div class="field__container">
      <label class="label">Unité</label>
      <div class="select__container">
        <select name="unite__${rank}" class="select unite"></select>
      </div>
    </div>
  `;

  produits.forEach((produit) => {
    let option = document.createElement("option");
    option.value = produit.produit;
    option.innerHTML = produit.nom;

    response.querySelector(".produit").appendChild(option);
  });

  unites.forEach((unite) => {
    let option = document.createElement("option");
    option.value = unite.id;
    option.innerHTML = unite.nom;

    response.querySelector(".unite").appendChild(option);
  });

  return response;
}

/**
 * @param {Tiers[]} clients
 * @return {void}
 */
function appendClient(clients) {
  let clientSelect = rootDiv.querySelector(".client");
  clients.forEach((client) => {
    let option = document.createElement("option");
    option.value = `${client.compte}_${client.numero}`;
    option.innerHTML = client.intitule;

    clientSelect.appendChild(option);
  });
}

/**
 * @param {Produit[]} produits
 * @param {Unite[]} unites
 * @param {Tiers[]} clients
 * @return {void}
 */
function updateRoot(produits, unites, clients) {
  rootDiv.innerHTML = `
    <form class="facture__form">
      <p class="n__products">1</p>
      <h1 class="form__title">Produits</h1>
      <div class="product__container"></div>
      <div style="transform: translateY(0);" class="autre">
        <div class="field__container">
          <label class="label">Objet</label>
          <input autocomplete="off" type="text" name="objet" class="input" />
        </div>
      </div>
      <div style="transform: translateY(0);" class="autre">
        <div class="field__container">
          <label class="label">Client</label>
          <div class="select__container">
            <select name="client" class="select client"></select>
          </div>
        </div>
        <div class="field__container">
          <label class="label">Date</label>
          <input type="date" name="date" class="input" />
        </div>
        <div class="field__container">
          <label class="label">Avance</label>
          <input autocomplete="off" type="text" name="avance" class="input" />
        </div>
      </div>
      <p style="transform: translateY(0);" class="btn add__product">Ajouter un produit</p><br>
      <input style="transform: translateY(0);" type="submit" class="btn" value="Facturer" />
    </form>
    <p class="link">Voir la liste des factures</p>
  `;

  let rank = 1;

  rootDiv
    .querySelector(".product__container")
    .appendChild(createProduct(produits, unites, rank));
  appendClient(clients);

  rootDiv.querySelector(".link").addEventListener("click", renderFactureListe);

  rootDiv.querySelector(".add__product").addEventListener("click", () => {
    rank++;
    if (rank <= produits.length) {
      let product = createProduct(produits, unites, rank);
      let timeline = anime.timeline({ easing: "easeOutQuad" });
      timeline.add({
        targets: [".btn", ".autre", ".link"],
        opacity: [1, 0],
        duration: 200,
      });
      timeline.add({
        targets: product,
        opacity: [0, 1],
        translateX: [-100, 0],
        duration: 200,
      });
      timeline.add({
        targets: [".btn", ".autre", ".link"],
        opacity: [0, 1],
        duration: 200,
      });

      window.setTimeout(() => {
        rootDiv.querySelector(".product__container").appendChild(product);
      }, 200);

      rootDiv.querySelector(".n__products").innerHTML = rank;
    } else {
      createMessage(
        `Nous n'avons que ${produits.length} types de produits`,
        "error2"
      );
    }
  });

  rootDiv.querySelector("form").addEventListener("submit", async (event) => {
    event.preventDefault();
    let response = await send();
    response = JSON.parse(response);
    renderFacture(response);
  });

  rootDiv.classList.remove("hidden");
}

export default async function () {
  let produits = await get("http://localhost:120/SI/hello/produit");
  produits = JSON.parse(produits);
  let unites = await get("http://localhost:120/SI/hello/unite");
  unites = JSON.parse(unites);
  let clients = await get("http://localhost:120/SI/hello/client");
  clients = JSON.parse(clients);

  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(produits, unites, clients);
    removeTransitionDiv();
  }, 400);
}

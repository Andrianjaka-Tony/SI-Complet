import { Produit } from "../models/produit.js";
import { default as renderForm } from "./forms/produit.js";
import {
  createTransitionDiv,
  drawGraph,
  get,
  printNumber,
  removeTransitionDiv,
  rootDiv,
} from "../utils/function.js";

const url = "http://localhost:120/SI/hello/produit";

/**
 * @return {Promise<Produit[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @param {Produit} produit
 * @return {HTMLTableRowElement}
 */
function createCard(produit) {
  let div = document.createElement("div");
  div.classList.add("card");

  div.innerHTML = `
    <h1 class="card__title">${produit.nom}</h1>
    <p class="card__info">Variable: <span>${printNumber(
      produit.variable
    )} Ar</span></p>
    <p class="card__info">Seuil de rentabilité: <span>${printNumber(
      produit.poids
    )} kg</span></p>
    <p class="card__info">Production: <span>${printNumber(
      produit.production
    )} kg</span></p>
    <p class="card__info">Prix de vente: <span>${printNumber(
      produit.prix
    )} Ar</span></p>
    <p class="card__info">Chiffre d'affaire: <span>${printNumber(
      produit.production * produit.prix
    )} Ar</span></p>
    <div class="card__graphe">
      <canvas id="graphe__${produit.produit}"></canvas>
    </div>
  `;

  drawGraph(
    ["Variable", "Chiffre d'affaire"],
    [produit.variable, produit.production * produit.prix],
    ["rgb(255, 99, 132)", "rgb(255, 205, 86)"],
    div.querySelector(`#graphe__${produit.produit}`)
  );
  return div;
}

/**
 * @param {Produit[]} produits
 * @return {void}
 */
function addCards(produits) {
  let cards_container = document.querySelector(".cards__container");
  produits.forEach((produit) => {
    cards_container.appendChild(createCard(produit));
  });
}

/**
 * @param {Produit[]} produits
 * @return {void}
 */
function updateRoot(produits) {
  rootDiv.innerHTML = `
    <div class="cards__container"></div>
    <p class="link add__link">Ajouter un nouveau produit</p>
  `;
  addCards(produits);

  rootDiv.querySelector(".add__link").addEventListener("click", renderForm);

  rootDiv.classList.remove("hidden");
}

export default async function () {
  let produits = await getData();
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(produits);
    removeTransitionDiv();
  }, 400);
}

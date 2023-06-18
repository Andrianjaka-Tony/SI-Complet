import { Ligne } from "../models/ligne.js";
import { get, printNumber } from "../utils/function.js";

/**
 * @param {Ligne} ligne
 * @return {HTMLTableRowElement}
 */
function createRow(ligne) {
  let tr = document.createElement("tr");
  tr.innerHTML = `
    <tr>
      <td width="220px">${ligne.nom}</td>
      <td width="110px">${ligne.unite}</td>
      <td width="120px">${ligne.quantite}</td>
      <td width="120px">${ligne.prixUnitaire}</td>
      <td width="170px">${ligne.prixTotal}</td>
    </tr>
  `;
  return tr;
}

/**
 * @param {Ligne[]} lignes
 * @param {HTMLElement} element
 * @return {void}
 */
function addRows(lignes, element) {
  let tbody = element.querySelector("tbody");
  lignes.forEach((ligne) => {
    tbody.appendChild(createRow(ligne));
  });
}

/**
 * @return {void}
 */
function animateFacture() {
  let timeline = anime.timeline({ autoplay: true, easing: "easeOutQuad" });
  timeline.add({
    targets: [".facture__container"],
    opacity: [0, 1],
    duration: 300,
  });
  timeline.add({
    targets: [
      ".facture__header .title",
      ".facture__header .infos .text",
      ".facture__header .subtitle",
      ".section__client .left__side .numero__facture",
      ".left__side .text",
      ".right__side .text",
      "thead tr",
      "tbody tr",
      ".footer .footer__title",
      ".footer .text",
      ".end__text",
      ".btn__container .btn",
    ],
    opacity: [0, 1],
    translateY: [40, 0],
    delay: anime.stagger(50),
    duration: 300,
  });
}

/**
 * @return {void}
 */
function removeFacture() {
  let timeline = anime.timeline({ autoplay: true, easing: "easeOutQuad" });
  timeline.add({
    targets: [
      ".facture__header .title",
      ".facture__header .infos .text",
      ".facture__header .subtitle",
      ".section__client .left__side .numero__facture",
      ".left__side .text",
      ".right__side .text",
      "thead tr",
      "tbody tr",
      ".footer .footer__title",
      ".footer .text",
      ".end__text",
      ".btn__container .btn",
    ],
    opacity: [1, 0],
    translateY: [0, 40],
    delay: anime.stagger(50, { direction: "reverse" }),
    duration: 300,
  });
  timeline.add({
    targets: [".facture__container"],
    opacity: [1, 0],
    duration: 300,
  });
}

/**
 * @return {void}
 */
function createFacture(facture) {
  let response = document.createElement("div");
  response.classList.add("facture__container");

  response.innerHTML = `
    <div class="facture">
      <section class="facture__header">
        <h1 class="title">${facture.header.nom}</h1>
        <div class="infos">
          <p class="text">${facture.header.adresse}</p>
          <p class="text">${facture.header.telephone}</p>
          <p class="text">${facture.header.email}</p>
        </div>
        <div class="line"></div>
        <h1 class="subtitle">Facture</h1>
        <section class="section__client">
          <div class="left__side">
            <div class="numero__facture">${facture.facture}</div>
            <p class="text">Référence bon de commande</p>
            <p class="text">
              ${facture.objet}
            </p>
          </div>
          <div class="right__side">
            <p class="text">${facture.date}</p>
            <p class="text">${facture.entreprise.nom}</p>
            <p class="text">${facture.entreprise.adresse}</p>
            <p class="text">${facture.entreprise.email}</p>
            <p class="text">${facture.entreprise.dirigeant}</p>
          </div>
        </section>
      </section>
      <table class="facture_table">
        <thead>
          <tr>
            <td width="220px">Designation</td>
            <td width="110px">Unité</td>
            <td width="120px">Quantité</td>
            <td width="120px">Prix</td>
            <td width="170px">Total</td>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
      <section class="footer">
        <div class="footer__title">Total</div>
        <p class="text">Produit: <span>${printNumber(
          facture.montant
        )} Ar</span></p>
        <p class="text">TVA: <span>${printNumber(facture.tva)} Ar</span></p>
        <p class="text">Total: <span>${printNumber(facture.total)} Ar</span></p>
        <p class="text">Avance: <span>${printNumber(
          facture.avance
        )} Ar</span></p>
        <p class="text">Reste a payer: <span>${printNumber(
          facture.reste
        )} Ar</span></p>
        <p class="end__text">
          Arrété la présente facture au prix de <span>${printNumber(
            facture.total
          )} Ar TTC</span>
        </p>
        <div class="btn__container">
          <button class="btn modify close">Fermer</button>
        </div>
      </section>
    </div>
  `;
  addRows(facture.ligne, response);

  response.querySelector(".close").addEventListener("click", () => {
    removeFacture();
    window.setTimeout(() => {
      document.body.removeChild(response);
    }, 2000);
  });

  return response;
}

export default function (facture) {
  document.body.appendChild(createFacture(facture));
  animateFacture();
}

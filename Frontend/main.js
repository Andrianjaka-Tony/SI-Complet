import { default as renderSociete } from "./js/societe.js";
import { default as renderDevise } from "./js/devise.js";
import { default as renderRacine } from "./js/racine.js";
import { default as renderComptable } from "./js/comptable.js";
import { default as renderTiers } from "./js/tiers.js";
import { default as renderJournal } from "./js/journal.js";
import { default as renderEcriture } from "./js/ecriture.js";
import { default as renderBalance } from "./js/balance.js";
import { default as renderBilan } from "./js/bilan.js";
import { default as renderCentre } from "./js/centre.js";
import { default as renderProduit } from "./js/produit.js";
import { default as renderFacture } from "./js/forms/facture.js";
import { createMessage, get, resetSidebar } from "./utils/function.js";

document
  .getElementById("sidebar__item__societe")
  .addEventListener("click", function () {
    resetSidebar();
    renderSociete();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__devise")
  .addEventListener("click", function () {
    resetSidebar();
    renderDevise();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__racine")
  .addEventListener("click", function () {
    resetSidebar();
    renderRacine();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__comptable")
  .addEventListener("click", function () {
    resetSidebar();
    renderComptable();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__tiers")
  .addEventListener("click", function () {
    resetSidebar();
    renderTiers();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__journal")
  .addEventListener("click", function () {
    resetSidebar();
    renderJournal();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__ecriture")
  .addEventListener("click", function () {
    resetSidebar();
    renderEcriture();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__balance")
  .addEventListener("click", function () {
    resetSidebar();
    renderBalance();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__bilan")
  .addEventListener("click", function () {
    resetSidebar();
    renderBilan();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__centre")
  .addEventListener("click", function () {
    resetSidebar();
    renderCentre();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__produit")
  .addEventListener("click", function () {
    resetSidebar();
    renderProduit();
    this.classList.add("active");
  });

document
  .getElementById("sidebar__item__facture")
  .addEventListener("click", function () {
    resetSidebar();
    renderFacture();
    this.classList.add("active");
  });

renderSociete();

import { Comptable } from "../../models/comptable.js";
import { Tiers } from "../../models/tiers.js";
import {
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
} from "../../utils/function.js";

/**
 * @param {Comptable[]} comptables
 * @param {Tiers[]} fournisseurs
 * @return {HTMLFormElement}
 */
function formAchat(comptables, fournisseurs) {
  let response = document.createElement("form");
  response.className = "form__achat form__ecriture active";
  response.innerHTML = `
    <form class="form__achat form__ecriture active">
      <div class="input__container">
        <label class="label">Compte</label>
        <div class="select__container">
          <select name="compte" class="select compte__select"></select>
        </div>
      </div>
      <div class="input__container">
        <label class="label">Intitule</label>
        <input type="text" class="input" name="intitule" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Piece</label>
        <input type="text" class="input" name="piece" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Valeur</label>
        <input type="text" class="input" name="valeur" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Fournisseur</label>
        <div class="select__container">
          <select name="fournisseur" class="select fournisseur__select"></select>
        </div>
      </div>
      <div class="input__container">
        <label class="label">Date</label>
        <input type="date" class="input" name="date" autocomplete="off" />
      </div>
      <input type="submit" class="btn__submit" value="Ajouter" />
    </form>
  `;

  let compteSelect = response.querySelector(".compte__select");
  comptables.forEach((comptable) => {
    let option = document.createElement("option");
    option.value = comptable.compte;
    option.innerHTML = comptable.intitule;
    compteSelect.appendChild(option);
  });

  let fournisseurSelect = response.querySelector(".fournisseur__select");
  fournisseurs.forEach((fournisseur) => {
    let option = document.createElement("option");
    option.value = `${fournisseur.compte}_${fournisseur.numero}`;
    option.innerHTML = fournisseur.intitule;
    fournisseurSelect.appendChild(option);
  });

  response.addEventListener("submit", async (event) => {
    event.preventDefault();
    let url = "http://localhost:120/SI/hello/achat";
    let method = "POST";
    let form = new FormData(response);
    let responseText = await get(url, method, form);

    console.log(responseText);
  });

  return response;
}

/**
 * @param {Comptable[]} comptables
 * @param {Tiers[]} clients
 * @return {HTMLFormElement}
 */
function formVente(comptables, clients) {
  let response = document.createElement("form");
  response.className = "form__vente form__ecriture";
  response.innerHTML = `
    <form class="form__vente form__ecriture">
      <div class="input__container">
        <label class="label">Compte</label>
        <div class="select__container">
          <select name="compte" class="select compte__select"></select>
        </div>
      </div>
      <div class="input__container">
        <label class="label">Intitule</label>
        <input type="text" class="input" name="intitule" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Piece</label>
        <input type="text" class="input" name="piece" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Valeur</label>
        <input type="text" class="input" name="valeur" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Client</label>
        <div class="select__container">
          <select name="client" class="select client__select"></select>
        </div>
      </div>
      <div class="input__container">
        <label class="label">Date</label>
        <input type="date" class="input" name="date" autocomplete="off" />
      </div>
      <input type="submit" class="btn__submit" value="Ajouter" />
    </form>
  `;

  let compteSelect = response.querySelector(".compte__select");
  comptables.forEach((comptable) => {
    let option = document.createElement("option");
    option.value = comptable.compte;
    option.innerHTML = comptable.intitule;
    compteSelect.appendChild(option);
  });

  let clientSelect = response.querySelector(".client__select");
  clients.forEach((client) => {
    let option = document.createElement("option");
    option.value = `${client.compte}_${client.numero}`;
    option.innerHTML = client.intitule;
    clientSelect.appendChild(option);
  });

  response.addEventListener("submit", async (event) => {
    event.preventDefault();
    let url = "http://localhost:120/SI/hello/vente";
    let method = "POST";
    let form = new FormData(response);
    let responseText = await get(url, method, form);

    console.log(responseText);
  });

  return response;
}

/**
 * @param {Comptable[]} comptables
 * @return {HTMLFormElement}
 */
function formAutre(comptables) {
  let response = document.createElement("form");
  response.className = "form__autre form__ecriture";
  response.innerHTML = `
    <form class="form__autre form__ecriture">
      <div class="input__container">
        <label class="label">Compte</label>
        <div class="select__container">
          <select name="compte" class="select compte__select"></select>
        </div>
      </div>
      <div class="input__container">
        <label class="label">Intitule</label>
        <input type="text" class="input" name="intitule" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Debit</label>
        <input type="text" class="input" name="debit" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Credit</label>
        <input type="text" class="input" name="credit" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Piece</label>
        <input type="text" class="input" name="piece" autocomplete="off" />
      </div>
      <div class="input__container">
        <label class="label">Date</label>
        <input type="date" class="input" name="date" autocomplete="off" />
      </div>
      <div class="empty">
        <input type="submit" class="btn__submit" value="Ajouter" />
      </div>
    </form>
  `;

  let compteSelect = response.querySelector(".compte__select");
  comptables.forEach((comptable) => {
    let option = document.createElement("option");
    option.value = comptable.compte;
    option.innerHTML = comptable.intitule;
    compteSelect.appendChild(option);
  });

  response.addEventListener("submit", async (event) => {
    event.preventDefault();
    let url = "http://localhost:120/SI/hello/autre";
    let method = "POST";
    let form = new FormData(response);
    let responseText = await get(url, method, form);

    console.log(responseText);
  });

  return response;
}

/**
 * @return {void}
 */
function reset() {
  rootDiv.querySelectorAll(".nav__ecriture__item").forEach((item) => {
    item.classList.remove("active");
  });
  rootDiv.querySelectorAll(".form__ecriture").forEach((form) => {
    form.classList.add("hidden");
    window.setTimeout(() => {
      form.classList.remove("active");
    }, 200);
  });
}

/**
 * @return {void}
 */
function listenItems() {
  rootDiv.querySelectorAll(".nav__ecriture__item").forEach((item) => {
    item.addEventListener("click", () => {
      let form = document.querySelector(`.${item.getAttribute("target")}`);
      reset();
      window.setTimeout(() => {
        form.classList.add("active");
        window.setTimeout(() => {
          form.classList.remove("hidden");
        }, 200);
      }, 200);
      item.classList.add("active");
    });
  });
}

/**
 * @param {Comptable[]} comptables
 * @param {Tiers[]} fournisseurs
 * @param {Tiers[]} clients
 * @return {HTMLFormElement}
 */
function updateRoot(comptables, fournisseurs, clients) {
  rootDiv.innerHTML = `
    <nav class="nav__eecriture">
      <div target="form__achat" class="nav__ecriture__item active">Achat</div>
      <div target="form__vente" class="nav__ecriture__item">Vente</div>
      <div target="form__autre" class="nav__ecriture__item">Autres</div>
    </nav>
  `;
  rootDiv.appendChild(formAchat(comptables, fournisseurs));
  rootDiv.appendChild(formVente(comptables, clients));
  rootDiv.appendChild(formAutre(comptables));
  rootDiv.classList.remove("hidden");

  listenItems();
}

export default async function () {
  let comptables = await get("http://localhost:120/SI/hello/comptable");
  comptables = JSON.parse(comptables);
  let fournisseurs = await get("http://localhost:120/SI/hello/fournisseur");
  fournisseurs = JSON.parse(fournisseurs);
  let clients = await get("http://localhost:120/SI/hello/client");
  clients = JSON.parse(clients);
  rootDiv.classList.add("hidden");
  createTransitionDiv();
  window.setTimeout(() => {
    updateRoot(comptables, fournisseurs, clients);
    removeTransitionDiv();
  }, 400);
}

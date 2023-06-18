import { Comptable } from "../../models/comptable.js";
import { createMessage, get } from "../../utils/function.js";
import { default as renderTiers } from "../tiers.js";

const url = "http://localhost:120/SI/hello/compte_tiers";

/**
 * @return {Promise<Comptable[]>}
 */
async function getData() {
  let data = await get(url);
  return JSON.parse(data);
}

/**
 * @returns {Promise<string>}
 */
async function send() {
  let form = document.querySelector(".form__container__form");
  let formData = new FormData(form);
  let response = await get(
    "http://localhost:120/SI/hello/create_tiers",
    "POST",
    formData
  );
  return response;
}

/**
 * @return {void}
 */
function remove() {
  let formContainer = document.querySelector(".form__container");
  formContainer.animate(
    { opacity: 0 },
    {
      duration: 200,
      fill: "forwards",
    }
  );
  window.setTimeout(() => {
    document.body.removeChild(formContainer);
  }, 400);
}

/**
 * @param {Comptable[]} comptables
 * @param {HTMLSelectElement} select
 * @return {void}
 */
function appendSelect(comptables, select) {
  comptables.forEach((comptable) => {
    let option = document.createElement("option");
    option.value = comptable.compte;
    option.innerHTML = comptable.intitule;
    select.appendChild(option);
  });
}

/**
 * @param {number} response
 * @return {void}
 */
function errorGestion(response) {
  if (response == 1) {
    createMessage("Veuillez remplir tous les champs", "error1");
  }
  if (response == 2) {
    createMessage("Le tiers que vous voulez créer éxiste déja", "error1");
  }
  if (response == 3) {
    createMessage(
      "Vérifiez que le numero soit bien composé de 8 caracteres",
      "error1"
    );
  }
  if (response == 0) {
    remove();
    window.setTimeout(() => {
      renderTiers();
    }, 500);
  }
}

/**
 * @return {HTMLDivElement}
 */
async function createFormContainer() {
  let response = document.createElement("div");
  response.classList.add("form__container");

  response.innerHTML = `
    <div class="form__container__filter"></div>
    <form class="form__container__form">
      <h1 class="form__container__form__title">Tiers</h1>
      <select name="compte" class="select"></select>
      <input
        autocomplete="off"
        type="text"
        class="form__container__form__input"
        required
        placeholder="numero"
        name="numero"
      />
      <input
        autocomplete="off"
        type="text"
        class="form__container__form__input"
        required
        placeholder="Intitulé"
        name="intitule"
      />
      <input
        type="submit"
        class="form__container__form__btn"
        value="Ajouter"
      />
    </form>
  `;

  let options = await getData();
  appendSelect(options, response.querySelector(".select"));

  response
    .querySelector(".form__container__filter")
    .addEventListener("click", remove);

  response
    .querySelector(".form__container__form")
    .addEventListener("submit", async (event) => {
      event.preventDefault();
      let response = await send();
      errorGestion(response);
    });

  document.body.appendChild(response);
}

/**
 * @return {void}
 */
export default function () {
  createFormContainer();
}

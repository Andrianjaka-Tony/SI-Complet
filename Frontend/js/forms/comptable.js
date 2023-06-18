import { createMessage, get } from "../../utils/function.js";
import { default as renderComptable } from "../comptable.js";

/**
 * @return {Promise<number>}
 */
async function send() {
  let form = document.querySelector(".form__container__form");
  let formData = new FormData(form);
  let response = await get(
    "http://localhost:120/SI/hello/create_comptable",
    "POST",
    formData
  );
  return parseInt(response);
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
 * @param {number} response
 * @return {void}
 */
function errorGestion(response) {
  if (response == 1) {
    createMessage("Veuillez remplir tous les champs", "error1");
  }
  if (response == 2) {
    createMessage("Le compte que vous voulez créer éxiste déja!", "error1");
  }
  if (response == 0) {
    remove();
    window.setTimeout(() => {
      renderComptable();
    }, 500);
  }
}

/**
 * @return {HTMLDivElement}
 */
function createFormContainer() {
  let response = document.createElement("div");
  response.classList.add("form__container");

  response.innerHTML = `
    <div class="form__container__filter"></div>
    <form class="form__container__form">
      <h1 class="form__container__form__title">Comptable</h1>
      <input
        autocomplete="off"
        type="text"
        class="form__container__form__input"
        required
        placeholder="Compte"
        name="compte"
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

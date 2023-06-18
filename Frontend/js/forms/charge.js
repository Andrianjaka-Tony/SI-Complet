import {
  createMessage,
  createTransitionDiv,
  get,
  removeTransitionDiv,
  rootDiv,
} from "../../utils/function.js";
import { default as renderCentre } from "../centre.js";

const url = "http://localhost:120/SI/hello/charge";

/**
 * @return {Promise<number>}
 */
async function sendForm() {
  let form = document.querySelector(".form__charge");
  let formData = new FormData(form);
  let response = await get(url, "POST", formData);
  return parseInt(response);
}

/**
 * @param {number} response
 * @return {void}
 */
function errorGestion(response) {
  if (response == 1) {
    createMessage("Veuillez remplir tous les champs", "error2");
  }
  if (response == 2) {
    createMessage(
      "La somme des charges variables et fixes du compte doit etre égal a 100",
      "error2"
    );
  }
  if (response == 3) {
    createMessage("Le débit doit etre positif", "error2");
  }
  if (response == 4) {
    createMessage(
      "La somme des variables et des fixes de chaque centre doit etre egal a 100",
      "error2"
    );
  }
  if (response == 5) {
    createMessage(
      "Aucun éxercice comptable ne correspond a la date donnée",
      "error2"
    );
  }
  if (response == 0) {
    renderCentre();
  }
}

/**
 * @return {void}
 */
function updateRoot() {
  rootDiv.innerHTML = `
    <form class="form__charge">
      <div class="container">
        <h1 class="form__title">Compte</h1>
        <div class="input__container">
          <label class="label">Compte</label>
          <input type="text" name="compte" autocomplete="off" class="input" required />
        </div>
        <div class="input__container">
          <label class="label">Intitulé</label>
          <input
            type="text"
            name="intitule"
            autocomplete="off"
            class="input" required
          />
        </div>
        <div class="input__container">
          <label class="label">Débit</label>
          <input type="text" name="debit" autocomplete="off" class="input" required />
        </div>
        <div class="input__container">
          <label class="label">Variable</label>
          <input
            type="text"
            name="variable"
            autocomplete="off"
            class="input" required
          />
        </div>
        <div class="input__container">
          <label class="label">Fixe</label>
          <input type="text" name="fixe" autocomplete="off" class="input" required />
        </div>
        <div class="input__container">
          <label class="label">Piece</label>
          <input type="text" name="piece" autocomplete="off" class="input" required />
        </div>
        <div class="input__container">
          <label class="label">Date</label>
          <input type="date" name="date" autocomplete="off" class="input" required />
        </div>
        <input type="submit" value="Ajouter" class="btn__submit" />
      </div>
      <div class="container">
        <h1 class="form__title">Centre</h1>
        <h2 class="subtitle">Administration et district</h2>
        <div class="input__container">
          <label class="label">Variable</label>
          <input
            type="text"
            name="variable_1"
            autocomplete="off"
            class="input" required
          />
        </div>
        <div class="input__container">
          <label class="label">Fixe</label>
          <input type="text" name="fixe_1" autocomplete="off" class="input" required />
        </div>
        <h2 class="subtitle">Industrie</h2>
        <div class="input__container">
          <label class="label">Variable</label>
          <input
            type="text"
            name="variable_2"
            autocomplete="off"
            class="input" required
          />
        </div>
        <div class="input__container">
          <label class="label">Fixe</label>
          <input type="text" name="fixe_2" autocomplete="off" class="input" required />
        </div>
        <h2 class="subtitle">Plantation</h2>
        <div class="input__container">
          <label class="label">Variable</label>
          <input
            type="text"
            name="variable_3"
            autocomplete="off"
            class="input" required
          />
        </div>
        <div class="input__container">
          <label class="label">Fixe</label>
          <input type="text" name="fixe_3" autocomplete="off" class="input" required />
        </div>
      </div>
    </form>
  `;

  rootDiv
    .querySelector(".form__charge")
    .addEventListener("submit", async (event) => {
      event.preventDefault();
      let response = await sendForm();
      errorGestion(response);
    });

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

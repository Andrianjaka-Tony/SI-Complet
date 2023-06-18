export const rootDiv = document.getElementById("root");

const COUNT = 8;

/**
 * @param {string} text
 * @param {string} className
 * @return {void}
 */
export function createMessage(text, className) {
  let message = document.createElement("div");
  message.className = `message__box ${className}`;
  message.innerHTML = text;
  document.body.appendChild(message);

  window.setTimeout(() => {
    document.body.removeChild(message);
  }, 5000);
}

/**
 *
 * @param {string[]} labels
 * @param {string[]} values
 * @param {string[]} colors
 * @param {HTMLCanvasElement} canvasElement
 * @return {void}
 */
export function drawGraph(labels, values, colors, canvasElement) {
  let data = {
    labels: labels,
    datasets: [
      {
        data: values,
        backgroundColor: colors,
        hoverOffset: 4,
      },
    ],
    option: {
      responsive: true,
    },
  };
  let config = {
    type: "doughnut",
    data: data,
  };
  new Chart(canvasElement, config);
}

/**
 * @param {number} number
 * @return {string}
 */
export function printNumber(number) {
  let str = `` + parseInt(number);
  let count = 1;
  let response = "";
  for (let i = str.length - 1; i >= 0; i--) {
    response = str[i] + response;
    if (count % 3 == 0 && i != 0) {
      response = ", " + response;
    }
    count++;
  }
  return response;
}

/**
 * @param {number} rows
 * @return {number}
 */
export function countPages(rows) {
  let pages = parseInt(rows / COUNT);
  if (pages * COUNT == rows) {
    return pages;
  }
  return pages + 1;
}

/**
 * @return {void}
 */
function resetActiveRows() {
  let rows = document.querySelectorAll("tbody tr");
  rows.forEach((row) => row.classList.remove("active"));
}

/**
 * @param {number} number
 * @return {void}
 */
function updateTable(number) {
  let begin = `:nth-child(n + ${(number - 1) * COUNT + 1})`;
  let end = `:nth-child(-n + ${number * COUNT})`;
  document.querySelector("tbody").classList.add("hidden");
  window.setTimeout(() => {
    resetActiveRows();
    let actives = document.querySelectorAll(`tbody tr${begin}${end}`);
    actives.forEach((active) => active.classList.add("active"));
    document.querySelector("tbody").classList.remove("hidden");
  }, 200);
}

/**
 * @return {void}
 */
export function createTransitionDiv() {
  let div = document.createElement("div");
  div.classList.add("transition-div");
  document.body.appendChild(div);
  anime({
    targets: div,
    width: window.innerWidth,
    duration: 400,
    easing: "easeOutQuad",
  });
}

/**
 * @return {void}
 */
export function removeTransitionDiv() {
  anime({
    targets: ".transition-div",
    scaleX: 0,
    duration: 400,
    easing: "easeInQuad",
  });
  window.setTimeout(() => {
    document.body.removeChild(document.querySelector(".transition-div"));
  }, 400);
}

/**
 * @return {void}
 */
function resetPaginationSpan() {
  document
    .querySelectorAll(".table__container__pagination span")
    .forEach((span) => {
      span.classList.remove("active");
    });
}

/**
 * @return {void}
 */
export function updatePagination() {
  let rows = document.querySelectorAll("tbody tr").length;
  let tableContainerPagination = document.querySelector(
    ".table__container__pagination"
  );
  let pages = countPages(rows);
  let i = 0;
  while (i < pages) {
    let span = document.createElement("span");
    span.innerHTML = i + 1;
    if (i + 1 == 1) span.classList.add("active");
    tableContainerPagination.appendChild(span);
    span.addEventListener("click", () => {
      resetPaginationSpan();
      updateTable(span.innerHTML);
      span.classList.add("active");
    });
    i++;
  }
  updateTable(1);
}

/**
 * @return {void}
 */
export function updateTableRowCount() {
  document.querySelector(".table__row__count").innerHTML += `
  <span>${document.querySelectorAll("tbody tr").length}</span>`;
}

/**
 * @return {void}
 */
export function resetSidebar() {
  document.querySelectorAll(".sidebar__item").forEach((sidebarItem) => {
    sidebarItem.classList.remove("active");
  });
}

/**
 * @param {string} url
 * @param {string} method
 * @param {Object} data
 * @return {Promise<string>}
 */
export function get(url = "", method = "GET", data = null) {
  let xhr = new XMLHttpRequest();
  xhr.open(method, url);
  xhr.send(data);
  return new Promise((resolve) => {
    xhr.addEventListener("load", () => {
      resolve(xhr.responseText);
    });
  });
}

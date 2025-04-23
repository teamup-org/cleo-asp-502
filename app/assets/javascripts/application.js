//= require jquery
//= require select2

$(document).ready(function() {
    $('.searchable-select').select2({
      placeholder: "Select a course",
      allowClear: true
    });
  });

// document.addEventListener("DOMContentLoaded", function() {
//   const toggleBtn = document.getElementById("accessibility-toggle");
//   const menu = document.getElementById("accessibility-menu");
//   const widget = document.getElementById("accessibility-widget");
//   const fontSizeSlider = document.getElementById("font-size-slider");

//   toggleBtn.addEventListener("click", (e) => {
//     e.stopPropagation(); // Prevent immediate closing
//     menu.style.display = (menu.style.display === "none" ? "block" : "none");
//   });
//   // Hide the menu when clicking outside the widget
//   document.addEventListener("click", (event) => {
//     if (!widget.contains(event.target)) {
//       menu.style.display = "none";
//     }
//   });
//   // Prevent closing when interacting inside the menu
//   menu.addEventListener("click", (e) => {
//     e.stopPropagation();
//   });
//   // Apply font size based on slider value
//   fontSizeSlider.addEventListener("input", function() {
//     const scale = parseFloat(this.value);
//     document.documentElement.style.setProperty('--user-font-scale', scale);
//   });
// });

// function toggleHighContrast() {
//   document.body.classList.toggle("high-contrast");
// }

// function toggleMagnifier() {
//   document.body.classList.toggle("magnified");
// }

// function toggleScreenReader() {
//   const msg = new SpeechSynthesisUtterance(document.body.innerText);
//   window.speechSynthesis.speak(msg);
// }

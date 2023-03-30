document.addEventListener('DOMContentLoaded', () => {
  // Functions to open and close a modal
  function openModal($el) {
    $el.classList.add('is-active');
  }

  function setTurboFrameSrc($el) {
    const frame = $el.querySelector('turbo-frame')
    frame.setAttribute('src', $el.getAttribute("data-turbo-frame-src"))
  }

  function closeModal($el) {
    $el.classList.remove('is-active');
    if($el.classList.contains('modal-turbo-frame')) {
      $el.querySelector(".modal-content .box turbo-frame").innerHTML = ""
    }
  }

  function closeAllModals() {
    (document.querySelectorAll('.modal') || []).forEach(($modal) => {
      closeModal($modal);
      if($modal.classList.contains('modal-turbo-frame')) {
        $modal.querySelector(".modal-content .box turbo-frame").innerHTML = ""
      }
    });
  }

  // Add a click event on buttons to open a specific modal
  (document.querySelectorAll('.modal-trigger') || []).forEach(($trigger) => {
    const modal = $trigger.dataset.target;
    const $target = document.getElementById(modal);

    $trigger.addEventListener('click', (event) => {
      event.preventDefault();
      openModal($target);
      if($target.classList.contains('modal-turbo-frame')) {
        setTurboFrameSrc($target);
      }
    });
  });

  // Add a click event on various child elements to close the parent modal
  (document.querySelectorAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button') || []).forEach(($close) => {
    const $target = $close.closest('.modal');

    $close.addEventListener('click', () => {
      closeModal($target);
    });
  });

  // Add a keyboard event to close all modals
  document.addEventListener('keydown', (event) => {
    const e = event || window.event;

    if (e.keyCode === 27) { // Escape key
      closeAllModals();
    }
  });
});

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const controller = this

    let observer = new IntersectionObserver((entries, observer) => { 
      entries.forEach(function(entry, index) {
        if(entry.isIntersecting) {
          setTimeout(() => { controller.fadeElem(entry, observer) }, 200 * (index + 1))
        }
      });
    }, {rootMargin: "0px 0px -50px 0px"});    

    document.querySelectorAll(".fadeable").forEach(element => { observer.observe(element) });
  }


  fadeElem(entry, observer) {
    console.log("fading: ", entry.target.innerText)
    entry.target.classList.add("faded")
    observer.unobserve(entry.target);
  }
}
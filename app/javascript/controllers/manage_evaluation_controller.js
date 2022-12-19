import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    checked: {type: Number, default: 0}
  }

  static targets = ['check']

  readyOnConnect()
  {
    if (this.element.querySelector("input[type=checkbox]"))
    {
      this.checkedValue = this.element.querySelector(".common-table").querySelectorAll("input[type=checkbox]:not([value=all]):not(.filter):not(.flt-check):checked").length;
      this.element.querySelectorAll("input[type=checkbox]:checked")
        .forEach( function (ele) {
        let target = ele.parentElement.querySelector(".ic-checkbox-empty");
        target && target.classList.remove("ic-checkbox-empty");
        target && target.classList.add("ic-checkbox");
        })
    }
  }

  connect() {
    this.readyOnConnect();
  }

  checkTargetConnected() {
    this.readyOnConnect();
  }

  showModal(e) {
    let modal_name = e.target.dataset.modal;
    let modal_eval = document.querySelector(".update");
    modal_eval.classList.remove("hidden");
    modal_eval.querySelector("."+modal_name+"-modal-container").classList.remove("hidden");
    modal_eval.querySelector(".modal-update").setAttribute("href",e.target.dataset.href);
  }
}

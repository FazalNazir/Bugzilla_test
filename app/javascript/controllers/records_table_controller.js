import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    checked: {type: Number, default: 0}
  }

  static targets = ['check']

  readyOnConnect()
  {
    this.element.dataset.ids = ''
    if (this.element.querySelector("input[type=checkbox]"))
    {
      this.checkedValue = this.element.querySelectorAll(".common-table input[type=checkbox]:not([value=all]):not(.filter):not(.flt-check):checked").length;
      this.element.querySelectorAll("input[type=checkbox]:checked").forEach(function(ele){
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

  userCheckAll(e) {
    let target = e.target;
    let parentTable = target.closest("table");
    let checkbox = parentTable.querySelectorAll(".ic-checkbox:not(.filter)");
    let checkboxEmpty = parentTable.querySelectorAll(".ic-checkbox-empty:not(.filter)");
    e.target.closest(".common-table").querySelectorAll(".all-check-user").forEach(function(ele){
      if(e.target!=ele)
      {
        ele.checked = e.target.checked;
      }
    });
    this.checkAll(parentTable, target, '.data-check')
    if (target.checked)
    {
      this.changeCheckbox(checkboxEmpty);
    }
    else
    {
      this.changeCheckbox(checkbox);
    }
  }

  changeCheckbox(checks) {
    checks.forEach(function(ele){
      if (ele.classList.contains("ic-checkbox"))
      {
        ele.classList.remove("ic-checkbox");
        ele.classList.add("ic-checkbox-empty");
      }
      else
      {
        ele.classList.add("ic-checkbox");
        ele.classList.remove("ic-checkbox-empty");
      }
    })
  }

  checkAll(ele, target, className) {
    ele.querySelectorAll(className).forEach(element => {
      if ((target.checked && !element.checked) || (!target.checked && element.checked))
      {
        element.click();
      }
    });
  }

  check(e) {
    this.checkedValue += e.target.checked ? 1 : -1;
  }

  checkedValueChanged() {
    if(this.element.querySelector(".selected-records")!=null && this.element.querySelector("input[type=checkbox]"))
    {
      if (this.checkedValue <= 0)
      {
        this.element.querySelector(".user-options").classList.add("hidden");
        this.element.querySelector(".options-row").classList.add("hidden")
        this.element.querySelector(".user-options").classList.remove("flex");
        this.element.querySelector(".table-head").classList.remove("hidden")
      }
      else
      {
        this.element.querySelector(".user-options").classList.remove("hidden");
        this.element.querySelector(".options-row").classList.remove("hidden")
        this.element.querySelector(".user-options").classList.add("flex");
        this.element.querySelector(".table-head").classList.add("hidden")
      }
      this.element.querySelector(".selected-records").innerHTML = this.checkedValue;
    }
  }

  bulkId(e)
  {
    let arr = this.element.dataset.ids.split(',');
    if (arr.includes(e.target.dataset.id.toString()) && !e.target.checked)
    {
      arr.splice(arr.indexOf(e.target.dataset.id.toString()), 1);
      this.element.dataset.ids = arr.join();
    }
    else
    {
      if(this.element.dataset.ids=="")
      {
        this.element.dataset.ids = e.target.dataset.id.toString();
      }
      else
      {
        this.element.dataset.ids = this.element.dataset.ids + ',' + e.target.dataset.id.toString();
      }
    }
    let ids = this.element.dataset.ids;
    this.element.querySelectorAll(".bulk-ids").forEach(function(ele){
      ele.setAttribute("href",ele.dataset.href.replace('_id', ids));
    });
  }

  submitBulk(e)
  {
    this.element.querySelector("#bulk-perform").value = e.currentTarget.dataset.perform;
    this.element.querySelector("#bulk-submit").click();
  }

  showModal(e) {
    let modal = document.querySelector(".modal");
    modal.classList.remove("hidden");
    modal.querySelector(".del-modal-container").classList.remove("hidden");
    if(!e.target.classList.contains("bulk-del") && e.target.closest(".action-menu"))
    {
      e.target.closest(".action-menu").classList.add("hidden");
    }
    if(!e.target.classList.contains("bulk-del"))
    {
      modal.querySelector(".modal-del").setAttribute("href",e.target.dataset.href);
    }
    else
    {
      if(this.checkedValue == 1)
      {
        modal.querySelector(".modal-del").setAttribute("href",e.target.dataset.href.replace("_id", this.element.dataset.ids));
      }
      else
      {
        modal.querySelector(".modal-del").setAttribute("href",e.target.dataset.href.replace("_id", `bulk_destroy/${this.element.dataset.ids}`));
      }
    }
  }

  sendRequest(e)
  {
    let target = e.currentTarget.parentElement.closest('table').querySelector(`#section-body-${e.currentTarget.dataset.id}`);
    let currentTarget = e.currentTarget;
    if (!(e.target.classList.contains("ic-action-options") || e.target.classList.contains("ic-checkbox") || e.target.classList.contains("ic-checkbox-empty") || e.target.classList.contains("data-check")))
    {
      if(e.currentTarget.classList.contains("active"))
      {
        target.innerHTML = "";
        e.currentTarget.classList.remove("active");
        e.currentTarget.classList.add("inactive");
        currentTarget.querySelector(".ic-drop-down").classList.add("-rotate-90");
        currentTarget.querySelector(".ic-drop-down").classList.remove("rotate-0");
        currentTarget.classList.remove("bg-blue-700", "text-white");
        currentTarget.classList.add("text-slate", "hover:bg-slate-300");
      }
      else
      {
        fetch(e.currentTarget.dataset.href, {
          headers: {
            Accept: "text/vnd.turbo-stream.html",
          },
        }).then(r => r.text())
          .then(html => Turbo.renderStreamMessage(html))
          .then(()=> {
            currentTarget.classList.remove("inactive");
            currentTarget.classList.add("active");
            currentTarget.querySelector(".ic-drop-down").classList.remove("-rotate-90");
            currentTarget.querySelector(".ic-drop-down").classList.add("rotate-0");
            currentTarget.classList.add("bg-blue-700", "text-white");
            currentTarget.classList.remove("text-slate", "hover:bg-slate-300");
          })
      }
    }
  }
}

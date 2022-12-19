import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  assignDate(e)
  {
    let target = e.currentTarget.parentElement.querySelector(".bg-slate-200")
    if(target)
    {
      target.classList.remove("bg-slate-200", "dark:bg-slate-800")
    }
    e.currentTarget.classList.add("bg-slate-200", "dark:bg-slate-800")
    e.currentTarget.parentElement.querySelector("input").value = e.currentTarget.dataset.value
  }
}

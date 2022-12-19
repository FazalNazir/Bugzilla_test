import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['check', 'trainees', 'supervisor', 'submit', 'startDate', 'endDate', 'timeFrom', 'timeTo',
                    'date', 'color']

  showSyncs(e) {
    let content = e.currentTarget.querySelector(".sync-menu").cloneNode(true)
    let target = document.querySelector("#edit-modal")
    target.classList.remove("hidden")
    content.classList.remove("hidden")
    target.appendChild(content)
  }

  closeModal(e) {
    let content = e.currentTarget.closest(".sync-menu")
    let target = document.querySelector("#edit-modal")
    target.removeChild(content)
    target.classList.add("hidden")
  }

  submitParentForm(e) {
    document.querySelector("#user-search-form .flt-submit").click();
  }

  assignID(e) {
    if (e.currentTarget.dataset.role == 'Supervisor' && e.currentTarget.checked)
    {
      this.supervisorTarget.value = e.currentTarget.dataset.id
      return
    }
    if (e.currentTarget.checked)
    {
      let value = this.traineesTarget.value.split(',')
      value = (value.length == 1 && value[0] == "" ? [] : value)
      this.traineesTarget.value = value.concat(e.currentTarget.dataset.id).join(',')
    }
    else
    {
      let index = this.traineesTarget.value.split(',').indexOf(e.currentTarget.dataset.id)
      if (index >= 0)
      {
        let value = this.traineesTarget.value.split(',')
        value.splice(index, 1)
        this.traineesTarget.value = value.join(',')
      }
    }
  }

  checkTargetConnected(ele) {
    if (this.traineesTarget.value.split(',').indexOf(ele.dataset.id) >= 0 || this.supervisorTarget.value == ele.dataset.id)
    {
      ele.checked = true;
    }
  }

  submitForm(e)
  {
    this.startDateTarget.value = `${this.dateTarget.value}, ${this.timeFromTarget.value}`
    this.endDateTarget.value = `${this.dateTarget.value}, ${this.timeToTarget.value}`
    this.submitTarget.click()
  }

  pickColor(e)
  {
    e.currentTarget.scrollTo(0,0)
    if(e.currentTarget.classList.contains('close'))
    {
      e.currentTarget.classList.remove("close")
      e.currentTarget.classList.add("open")
      e.currentTarget.classList.remove("w-[40px]")
      e.currentTarget.classList.add("w-[300px]")
      e.currentTarget.classList.remove("overflow-hidden")
      e.currentTarget.classList.add("overflow-scroll")
    }
    else
    {
      e.currentTarget.classList.add("close")
      e.currentTarget.classList.remove("open")
      e.currentTarget.classList.add("w-[40px]")
      e.currentTarget.classList.remove("w-[300px]")
      e.currentTarget.classList.add("overflow-hidden")
      e.currentTarget.classList.remove("overflow-scroll")
    }
  }

  changeColor(e) {
    let node = e.currentTarget.cloneNode(true)
    let parent = e.currentTarget.parentElement
    parent.removeChild(e.currentTarget)
    parent.prepend(node)
    this.colorTarget.value = e.currentTarget.getAttribute("id")
  }
}

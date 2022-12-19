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
    this.element.querySelector(".common-table").querySelectorAll(".all-check-user").forEach(function(ele){
      if(e.target!=ele)
      {
        ele.checked = e.target.checked;
      }
    });
    this.checkAll(parentTable, target, '.emp-check')
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

  filterCheckAll() {
    let e = event;
    let target = e.target;
    let parentTable = target.closest("table");
    let checkbox = parentTable.querySelectorAll(".ic-checkbox");
    let checkboxEmpty = parentTable.querySelectorAll(".ic-checkbox-empty");
    this.checkAll(parentTable, target, '.flt-check');
    if (target.checked)
    {
      this.changeCheckbox(checkboxEmpty);
    }
    else
    {
      this.changeCheckbox(checkbox);
    }
  }

  checkAll(ele, target, className) {
    ele.querySelectorAll(className).forEach(element => {
      if ((target.checked && !element.checked) || (!target.checked && element.checked))
      {
        element.click();
      }
    });
  }

  select(e) {
    let target = e.target;
    while(target.parentElement && target.parentElement.tagName=="SPAN")
    {
      target = target.parentElement;
    }
    let targetClass = target.dataset.class;
    target = target.closest(".selection");
    let menu = target.querySelector(".selection-menu");
    this.closeAllMenus(menu);
    if (target.classList.contains(targetClass+'-op'))
    {
      target.classList.remove(targetClass+'-op');
      target.classList.add(targetClass+'-cl');
      menu.classList.add("hidden")
    }
    else
    {
      target.classList.add(targetClass+'-op');
      target.classList.remove(targetClass+'-cl');
      menu.classList.remove("hidden")
    }
  }

  fetchData(e)
  {
    let target = e.currentTarget.closest(".selection");
    let menu = target.querySelector(".fetch-menu");
    this.closeAllMenus(menu);
    if (menu.classList.contains("hidden"))
    {
      menu.classList.remove("hidden")
    }
    else
    {
      menu.classList.add("hidden")
    }
  }

  check(e) {
    this.checkedValue += e.target.checked ? 1 : -1;
  }

  checkedValueChanged() {
    if(this.element.querySelector(".selected-records")!=null)
    {
      if (this.checkedValue <= 0)
      {
        this.element.querySelector(".user-options").classList.add("hidden");
        this.element.querySelector(".common-table").querySelector(".options-row").classList.add("hidden")
        this.element.querySelector(".user-options").classList.remove("flex");
        this.element.querySelector(".common-table").querySelector(".table-head").classList.remove("hidden")
      }
      else
      {
        this.element.querySelector(".user-options").classList.remove("hidden");
        this.element.querySelector(".common-table").querySelector(".options-row").classList.remove("hidden")
        this.element.querySelector(".user-options").classList.add("flex");
        this.element.querySelector(".common-table").querySelector(".table-head").classList.add("hidden")
      }
      this.element.querySelector(".selected-records").innerHTML = this.checkedValue;
    }
  }

  searchHide(e) {
    let parent = e.target.closest(".search-container");
    let target = parent.querySelector("span");
    if (target.classList.contains("hidden") && parent.querySelector("input").value == "")
    {
      target.classList.add("flex");
      target.classList.remove("hidden");
    }
    else
    {
      target.classList.remove("flex");
      target.classList.add("hidden");
    }
  }

  searchFocus(e) {
    e.target.closest(".search-container").querySelector("input").focus();
  }

  optionsShow(e) {
    let parent = e.currentTarget.parentElement;
    let target = parent.querySelector(".action-menu");
    this.closeAllMenus(target, e);
    if (target.classList.contains("hidden"))
    {
      target.classList.remove("hidden");
      if (parent.querySelector(".ic-drop-down, .ic-drop-down-b, .ic-drop-down-w, .ic-drop-down-g"))
      {
        parent.querySelector(".ic-drop-down, .ic-drop-down-b, .ic-drop-down-w, .ic-drop-down-g").classList.add("rotate-180");
      }
    }
    else
    {
      target.classList.add("hidden");
      if (parent.querySelector(".ic-drop-down, .ic-drop-down-b, .ic-drop-down-w, .ic-drop-down-g"))
      {
        parent.querySelector(".ic-drop-down, .ic-drop-down-b, .ic-drop-down-w, .ic-drop-down-g").classList.remove("rotate-180");
      }
    }

  }

  showModal(e) {
    let modalname = e.target.dataset.modal;
    let modal = document.querySelector(".modal");
    modal.classList.remove("hidden");
    modal.querySelector("."+modalname+"-modal-container").classList.remove("hidden");
    if(!e.target.classList.contains("bulk-del") && e.target.closest(".action-menu"))
    {
      e.target.closest(".action-menu").classList.add("hidden");
    }
    if (modalname == "del")
    {
      if(!e.target.classList.contains("bulk-del"))
      {
        modal.querySelector(".modal-del").setAttribute("href",e.target.dataset.href);
      }
      else
      {
        modal.querySelector(".modal-del").setAttribute("href",e.target.dataset.href+"?ids="+this.element.querySelector("#bulk-ids").value);
      }
    }
  }

  closeAllMenus(exception, e)
  {
    this.element.querySelectorAll(".action-menu:not(.hidden), .selection-menu:not(.hidden), .fetch-menu:not(.hidden), .fixed-menu:not(.hidden)").forEach(function(ele){
    if(ele!=exception && !ele.parentElement.closest(".action-menu, .selection-menu, .fetch-menu, .fixed-menu"))
      {
        ele.classList.add("hidden");
        if(ele.classList.contains("selection-menu"))
        {
          let targetParent = ele.closest("."+ele.dataset.class+"-op");
          if (targetParent)
          {
            targetParent.classList.remove(ele.dataset.class+"-op");
            targetParent.classList.add(ele.dataset.class+"-cl");
          }
        }
      }
    })
  }

  openSubDepartments(e)
  {
    let target = e.target;
    if (target.classList.contains("rotate-[-90deg]"))
    {
      if(e.type!=null)
      {
        target.classList.remove("rotate-[-90deg]");
      }
    }
    else
    {
      target.classList.add("rotate-[-90deg]");
    }
    let children = target.dataset.children;
    let sibling = target;
    for(let i = 0 ; i<children ; i++)
    {
      sibling = sibling.closest("tr").nextElementSibling;
      if (sibling.classList.contains("hidden") && e.type !=null)
      {
        sibling.classList.remove("hidden");
      }
      else
      {
        sibling.classList.add("hidden")
        if (sibling.querySelector(".ic-drop-down").dataset.children != 0 )
        {
          this.openSubDepartments({target: sibling.querySelector(".ic-drop-down"), type: null});
        }
      }
    }
  }

  checkStatus(e)
  {
    if(e.currentTarget.classList.contains("bg-blue"))
    {
      e.currentTarget.previousElementSibling.checked = true;
    }
    else
    {
      e.currentTarget.previousElementSibling.checked = false;
    }
  }

  bulkUpdate(e)
  {
    let eventTarget = e.target;
    let target =  this.element.querySelector("#bulk-status");
    target.value = eventTarget.dataset.value;
    this.closeAllMenus(target);
    this.element.querySelector("#bulk-submit").click();
    target.value = "none";

  }

  bulkId(e)
  {
    let target = this.element.querySelector("#bulk-ids");
    let arr = target.value.split(',');
    if (arr.includes(e.target.dataset.id.toString()) && !target.checked)
    {
      arr.splice(arr.indexOf(e.target.dataset.id.toString()), 1);
      target.value = arr.join();
    }
    else
    {
      if(target.value=="")
      {
        target.value = e.target.dataset.id.toString();
      }
      else
      {
        target.value = target.value + ',' + e.target.dataset.id.toString();
      }
    }
  }

  addRole(e)
  {
    let parent = e.currentTarget.closest(".role-field");
    let input = parent.querySelector(".roles");
    let arr =input.value.split(',');
    if (!arr.includes(e.currentTarget.dataset.name))
    {
      input.value += (arr.length == 1 && arr[0]=="" ? '' : ',') + e.currentTarget.dataset.name;
      let container = parent.querySelector(".tag-container")
      let child = container.appendChild(parent.querySelector('.default-role-tag').cloneNode(true));
      child.classList.remove("hidden");
      child.classList.remove("default-role-tag");
      child.classList.add("role-tag");
      child.querySelector("span").innerHTML = e.currentTarget.innerHTML;
      child.querySelector(".ic-cancel-w").dataset.name = e.currentTarget.dataset.name;
      parent.querySelector(`#${e.currentTarget.dataset.name}`).classList.add("hidden");
    }
  }
  removeRole(e)
  {
    let parent = e.currentTarget.closest(".role-field");
    let input = parent.querySelector(".roles");
    let arr =input.value.split(',');
    if (arr.includes(e.currentTarget.dataset.name) && e.currentTarget.dataset.name != 'super_user')
    {
      arr.splice(arr.indexOf(e.currentTarget.dataset.name),1);
      input.value = arr.join(',');
      parent.querySelector(`#${e.currentTarget.dataset.name}`).classList.remove("hidden");
      parent.querySelector(".tag-container").removeChild(e.currentTarget.closest(".role-tag"));
    }
  }

  rotate(e)
  {
    if (e.currentTarget.nextElementSibling.classList.contains("hidden"))
    {
      e.currentTarget.classList.add("rotate-0");
      e.currentTarget.classList.remove("rotate-180");
    }
    else
    {
      e.currentTarget.classList.remove("rotate-0");
      e.currentTarget.classList.add("rotate-180");
    }
  }

  sortParam(e)
  {
    document.querySelector("#filters-form").querySelector(".sort-field").value = e.currentTarget.dataset.name;
    this.submitForm(e);
  }

  filterParams(e)
  {
    let input = document.querySelector("#filters-form").querySelector(".role-field")
    this.addIds(e, input, e.currentTarget.dataset.role)
  }

  addIds(e, input, name)
  {
    let arr =input.value.split(',');
    if (e.currentTarget.checked)
    {
      input.value += (arr.length == 1 && arr[0]=="" ? '' : ',') + name;
    }
    else
    {
      arr.splice(arr.indexOf(name),1);
      input.value = arr.join(',');
    }
    this.submitForm(e);
  }

  addGroup(e)
  {
    let form = e.target.closest("form");
    let input = form.querySelector(".group-title-input");
    let textField = form.querySelector(".group-title");
    input.value = e.currentTarget.dataset.id;
    textField.innerHTML = e.currentTarget.innerHTML;
    form.querySelector(".selection-menu").classList.add("hidden")
  }

  submitBulk(e)
  {
    this.element.querySelector("#bulk-perform").value = e.currentTarget.dataset.perform;
    this.element.querySelector("#bulk-submit").click();
  }

  submitForm(e)
  {
    document.querySelector("#filter-search-form").querySelector(".flt-submit").click();
  }

  parentFormSubmit(e)
  {
    let form = e.currentTarget.closest('form')
    if (e.currentTarget.closest('table').dataset.recordsTableCheckedValue == 1)
    {
      form.setAttribute("action",form.dataset.href.replace("_id", e.currentTarget.closest('table').dataset.ids))
    }
    else
    {
      form.setAttribute("action",form.dataset.href.replace("_id", `bulk_update/${e.currentTarget.closest('table').dataset.ids}`))
    }
    form.querySelector("input[type=submit]").click()
  }

  closeMenu(e)
  {
    let menu = e.currentTarget.closest(".action-menu")
    menu.classList.add("hidden")
    let dropdown = menu.previousElementSibling.querySelector(".ic-drop-down, .ic-drop-down-w")
    dropdown.classList.remove("rotate-180")
  }

  submitParentForm(e)
  {
    e.currentTarget.closest("form").querySelector(".flt-submit").click();
  }

}

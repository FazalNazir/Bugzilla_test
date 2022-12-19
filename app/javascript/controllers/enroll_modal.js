import { Controller } from "@hotwired/stimulus"
import { ripple } from "../effects";


export default class extends Controller {

  static targets = ["courseValue","next","previous", "userValue"]

  connect()
  {
    this.element.querySelectorAll("button").forEach(function(ele){
      ripple(ele,"ripple", false);
      ele.classList.add("ripple-effect");
    });

  }

  showCourses(e)
  {
    let parent = e.currentTarget.parentElement;
    if (parent.classList.contains("h-[24px]"))
    {
      parent.classList.remove("h-[24px]");
      parent.classList.add("h-fit");
      parent.querySelector(".ic-drop-down-g").classList.remove("-rotate-90");
      parent.querySelector(".ic-drop-down-g").classList.add("rotate-0");
    }
    else
    {
      parent.classList.add("h-[24px]");
      parent.classList.remove("h-fit");
      parent.querySelector(".ic-drop-down-g").classList.add("-rotate-90");
      parent.querySelector(".ic-drop-down-g").classList.remove("rotate-0");
    }
  }

  removeCourse(e)
  {
    let parent = e.currentTarget.closest(".courses-container");
    let target = document.querySelector("#bulk-course-ids");
    let arr = target.value.split(',');
    parent.removeChild(e.currentTarget.closest(".course-container"));
    let enrollParent = this.element.querySelector("#enroll-course-body");
    enrollParent.removeChild(enrollParent.querySelector(`.enroll-course-row-${e.target.dataset.id}`))
    if (arr.includes(e.target.dataset.id.toString()))
    {
      arr.splice(arr.indexOf(e.target.dataset.id.toString()), 1);
      target.value = arr.join();
    }
    this.changeCourseValue(-1);
    if (arr.length != 0)
    {
      this.nextTarget.disabled = false;
      this.previousTarget.disabled = false;
    }
    else
    {
      this.nextTarget.disabled = true;
      this.previousTarget.disabled = true;
    }
  }

  changeCourseValue(num)
  {
    if (this.hasCourseValueTarget)
    {
      this.courseValueTargets.forEach(element => {
        element.innerHTML = parseInt(element.innerHTML) + num;
      });
    }
    this.noCoursesContainer();
  }

  hideOptions(e)
  {
    let parent = e.currentTarget.parentElement;
    if (!e.target.closest(".action-menu, .search-inp"))
    {
      parent.querySelector(".action-menu").classList.add("hidden");
    }
  }

  removeAllCourses(e)
  {
    let parent = e.currentTarget.closest(".right-menu");
    parent.querySelector(".courses-container").querySelectorAll(".ic-cancel:not(.default)").forEach(function(ele){
      ele.click();
    })
    this.noCoursesContainer();
  }

  addCourses(e)
  {
    let parent = e.currentTarget.closest(".action-menu");
    let checkedboxes = parent.querySelectorAll("input[type=checkbox]:checked");
    let ids = [];
    let container = this.element.querySelector(".courses-container");
    let original = this.element.querySelector(".default-course-container");
    let target = document.querySelector("#bulk-course-ids");
    let arr = target.value.split(',');
    let enrollParent = this.element.querySelector("#enroll-course-body");
    checkedboxes.forEach(function(ele){
      if (!arr.includes(ele.dataset.id) && !ids.includes(ele.dataset.id))
      {
        ids.push(ele.dataset.id);
        let clone = original.cloneNode(true);
        clone.querySelector(".course-text").innerHTML = ele.dataset.course;
        clone.querySelector(".ic-cancel").dataset.id = ele.dataset.id;
        clone.classList.remove("default-courses-container");
        clone.classList.add("course-container");
        clone.classList.remove("hidden");
        clone.classList.add("flex");
        clone.querySelector(".ic-cancel").classList.remove("default");
        container.appendChild(clone);
        clone = enrollParent.querySelector(".default-enroll-row").cloneNode(true);
        clone.querySelector(".course-title").innerHTML = ele.dataset.course;
        clone.classList.remove("default-enroll-row");
        clone.classList.add("enroll-row");
        clone.classList.add(`enroll-course-row-${ele.dataset.id}`);
        clone.classList.remove("hidden");
        enrollParent.appendChild(clone);
      }
    });
    arr = [...new Set([ids, ...arr])];
    target.value=arr.join(",");
    if (arr.length != 0)
    {
      this.nextTarget.disabled = false;
      this.previousTarget.disabled = false;
    }
    else
    {
      this.nextTarget.disabled = true;
      this.previousTarget.disabled = true;
    }
    this.changeCourseValue(ids.length);
    this.noCoursesContainer();
    e.currentTarget.closest(".right-menu").querySelector(".action-menu").classList.add("hidden");
  }

  noCoursesContainer(e)
  {
    if (parseInt(this.courseValueTarget.innerHTML)==0)
    {
      this.element.querySelector(".operations-menu").classList.add("hidden")
      this.element.querySelector(".courses-container").classList.add("hidden")
      this.element.querySelector(".no-courses").classList.remove("hidden")
    }
    else
    {
      this.element.querySelector(".operations-menu").classList.remove("hidden")
      this.element.querySelector(".courses-container").classList.remove("hidden")
      this.element.querySelector(".no-courses").classList.add("hidden")
    }
  }

  nextPart(e)
  {
    if(e.currentTarget.dataset.next == "users")
    {
      this.previousTarget.classList.remove("hidden");
      this.previousTarget.classList.add("flex");
      this.element.querySelector(".right-menu-courses").classList.add("hidden");
      this.element.querySelector(".right-menu-users").classList.remove("hidden")
      e.currentTarget.dataset.next="enrollment";
      this.previousTarget.dataset.back="courses";
      let part = this.element.querySelector(".user-part");
      part.classList.add("active-part");
      part.classList.remove("in-active-part");
      part = this.element.querySelector(".course-part");
      part.classList.remove("active-part");
      part.classList.add("in-active-part");
      part = this.element.querySelector(".user-value");
      part.classList.remove("hidden");
      part = this.element.querySelector(".next-btn");
      if (parseInt(this.userValueTarget.innerHTML)<=0)
      {
        part.disabled = true;
      }
    }
    else if (e.currentTarget.dataset.next == "enrollment")
    {
      this.element.querySelector(".right-menu-users").classList.add("hidden");
      this.element.querySelector(".right-menu-enrollment").classList.remove("hidden")
      e.currentTarget.dataset.next="none";
      this.previousTarget.dataset.back="users";
      let part = this.element.querySelector(".enrollment-part");
      part.classList.add("active-part");
      part.classList.remove("in-active-part");
      part = this.element.querySelector(".user-part");
      part.classList.remove("active-part");
      part.classList.add("in-active-part");
      part = this.element.querySelector(".next-btn");
      part.disabled = true;
      part.classList.add("hidden");
      part = this.element.querySelector(".enroll-btn");
      part.classList.add("flex");
      part.classList.remove("hidden");
      part.disabled = false;
    }
  }

  previousPart(e)
  {
    if(e.currentTarget.dataset.back == "courses")
    {
      e.currentTarget.classList.add("hidden");
      e.currentTarget.classList.add("flex");
      this.element.querySelector(".right-menu-courses").classList.remove("hidden");
      this.element.querySelector(".right-menu-users").classList.add("hidden");
      e.currentTarget.dataset.back="none";
      this.nextTarget.dataset.next="users";
      let part = this.element.querySelector(".course-part");
      part.classList.add("active-part");
      part.classList.remove("in-active-part");
      part = this.element.querySelector(".user-part");
      part.classList.remove("active-part");
      part.classList.add("in-active-part");
      part = this.element.querySelector(".user-value");
      if (!parseInt(this.userValueTarget.innerHTML)>0)
      {
        part.classList.add("hidden");
      }
      part = this.element.querySelector(".next-btn");
      part.disabled = false;
    }
    else if(e.currentTarget.dataset.back == "users")
    {
      this.element.querySelector(".right-menu-users").classList.remove("hidden");
      this.element.querySelector(".right-menu-enrollment").classList.add("hidden");
      e.currentTarget.dataset.back="courses";
      this.nextTarget.dataset.next="enrollment";
      let part = this.element.querySelector(".user-part");
      part.classList.add("active-part");
      part.classList.remove("in-active-part");
      part = this.element.querySelector(".enrollment-part");
      part.classList.remove("active-part");
      part.classList.add("in-active-part");
      part = this.element.querySelector(".user-value");
      part = this.element.querySelector(".next-btn");
      part.disabled = false;
      part.classList.remove("hidden");
      part = this.element.querySelector(".enroll-btn");
      part.classList.remove("flex");
      part.classList.add("hidden");
      part.disabled = true;
    }
  }

  showFilters(e)
  {
    let parent = e.currentTarget.closest(".right-menu-users");
    let search = parent.querySelector(".search-container");
    let filter = parent.querySelector(".filter-container")
    if (search.classList.contains("hidden"))
    {
      search.classList.remove("hidden");
      search.classList.add("flex");
      filter.classList.add("hidden");
      filter.classList.remove("flex");
    }
    else
    {
      search.classList.add("hidden");
      search.classList.remove("flex");
      filter.classList.remove("hidden");
      filter.classList.add("flex");
    }
  }

  changeUserSelectedValue(e)
  {
    let target = document.querySelector("#"+e.currentTarget.dataset.bulkid);
    this.userValueTargets.forEach(function(ele){
      ele.innerHTML = target.value == "" ? 0 : target.value.split(",").length;
    });
    let button = this.element.querySelector(".next-btn");
    if (parseInt(this.userValueTarget.innerHTML) <= 0)
    {
      button.disabled = true;
    }
    else
    {
      button.disabled = false;
    }
  }

  filterBadge(e)
  {
    let parent = e.currentTarget.closest(".filter-container");
    let btn = parent.querySelector(".filter-btn");
    let badge = parent.querySelector(".filter-badge");
    let searchBack = this.element.querySelector(".back-to-search");
    let clearFilter = this.element.querySelector(".clear-filter");
    if (parent.querySelectorAll("input[type=checkbox]:checked").length == 0)
    {
      btn.classList.remove("border-black");
      btn.classList.add("border-white");
      badge.classList.add("hidden");
      badge.classList.add("border-black");
      searchBack.classList.remove("hidden");
      clearFilter.classList.add("hidden");
    }
    else
    {
      btn.classList.add("border-black");
      btn.classList.remove("border-white");
      badge.classList.remove("hidden");
      badge.classList.remove("border-black")
      searchBack.classList.add("hidden");
      clearFilter.classList.remove("hidden");
    }
  }

  clearFilters(e)
  {
    let parent = this.element.querySelector(".filters-container");
    parent.querySelectorAll(".ic-checkbox").forEach(function(ele){
      ele.dispatchEvent(new Event('mousedown'));
    });
    parent.querySelector(".apply-filter").click();
  }

  submitFilterCourseForm(e)
  {
    let form = this.element.querySelector("#enroll-filter-course-search-form")
    form.querySelector(".flt-submit").click();
    form.querySelector(".action-menu").classList.remove("hidden");
  }

  submitFilterUserForm(e)
  {
    this.element.querySelector("#enroll-filter-user-search-form").querySelector(".flt-submit").click();
  }

  dueDate(e)
  {
    let target = e.currentTarget.closest(".due-container");
    target.querySelectorAll(".due-inp:not(.hidden) input").forEach(function(ele){
      ele.setAttribute("form", "");
    })
    target.querySelector(".due-inp:not(.hidden)").classList.add("hidden");
    if (e.currentTarget.dataset.container == "date")
    {
      target.querySelector(".by-date").classList.remove("hidden");
      target.querySelector(".by-date input").setAttribute("form", "enroll-modal-form");
    }
    else if (e.currentTarget.dataset.container == "period")
    {
      target.querySelector(".for-period").classList.remove("hidden");
      target.querySelector(".for-period input[type=number]").setAttribute("form", "enroll-modal-form");
    }
    else
    {
      target.querySelector(".no-due").classList.remove("hidden");
    }
    if (!target.querySelector(".due-inp:not(.hidden)").classList.contains("by-date"))
    {
      target.querySelector(".due-inp:not(.hidden) input[type=checkbox]").setAttribute("form", "enroll-modal-form");
    }
    target.closest(".enroll-row").querySelector(".current-due-selection").innerHTML = e.currentTarget.dataset.container;
  }

  changeDuration(e)
  {
    let parent = e.currentTarget.closest(".for-period")
    if (e.currentTarget.innerHTML=="Days")
    {
      parent.querySelector("input[type=checkbox]").checked = true;
    }
    else
    {
      parent.querySelector("input[type=checkbox]").checked = false;
    }
    parent.querySelector(".duration").innerHTML = e.currentTarget.innerHTML;
    parent.querySelector(".ic-drop-down-b").classList.remove("rotate-180");
    parent.querySelector(".fixed-menu").classList.add("hidden");
  }

  apply(e)
  {
    let parent_container = e.target.closest(".enroll-row");
    if (parent_container.querySelector(".apply-to-all").checked)
    {
      let parent = e.target.closest(".enroll-course-body");
      let current = e.target.closest(".enroll-row").querySelector(".due-inp:not(.hidden)")
      let target = current.classList.contains("for-period") ? 'period' : (current.classList.contains("by-date") ? 'date' : (current.classList.contains("no-due") ? 'none' : 'course'))
      if (target=='period')
      {
        parent.querySelectorAll(".enroll-row").forEach(function(element){
          element.querySelector(`button[data-container=${target}]`).click();
          element.querySelector("input").value = current.querySelector("input").value;
          element.querySelector("input[type=checkbox]").checked = current.querySelector("input[type=checkbox]").checked;
        })
      }
      else
      {
        parent.querySelectorAll(".enroll-row").forEach(function(element){
          element.querySelector(`button[data-container=${target}]`).click();
          element.querySelector("input[type=checkbox]").checked = current.querySelector("input[type=checkbox]").checked;
        })
      }
    }
  }

  submitForm(e)
  {
    document.querySelector(`#${e.target.dataset.formName}`).querySelector("input[type=submit]").click();
  }
}

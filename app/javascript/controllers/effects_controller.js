import { Controller } from "@hotwired/stimulus"
import { ripple } from "../effects";
import VanillaCalendar from '@uvarov.frontend/vanilla-calendar';
import easydropdown from 'easydropdown';
import { subscribeNotification } from "../channels/notifications_channel";

export default class extends Controller {

  static targets = ['flash', 'calendar', 'select', 'notification', 'dark']

  connect() {
    this.element.querySelectorAll("button").forEach(function(ele){
      ripple(ele,"ripple", false);
      ele.classList.add("ripple-effect");
    });
  }

  selectTargetConnected(ele)
  {
    const edd = easydropdown(ele,
      {
        behavior: {
          clampMaxVisibleItems:    true,
          closeOnSelect:           true,
          openOnFocus:             true,
          showPlaceholderWhenOpen: false,
          liveUpdates:             true,
          loop:                    false,
          maxVisibleItems:         5
        },
        callbacks: {
          onClose:  null,
          onOpen:   null,
          onSelect: null
        }
      });
  }

  calendarTargetConnected(ele)
  {
    const calendar = new VanillaCalendar(ele, {
      type: 'default',
      settings: {
        selection: {
          time: 12,
        },
      },
      actions: {
        clickDay(e, dates) {
          let target = ele.parentElement.querySelector("input");
          if (target.value == "" || (!target.value.includes(", ")))
          {
            target.value = dates
          }
          else
          {
            let value = target.value.split(", ");
            target.value = dates +", " + value[1]
          }
          target.dispatchEvent(new Event('change'));
        },
        changeTime(e, time, hours, minutes, keeping) {
          let target = ele.parentElement.querySelector("input");
          if (target.closest(".time-only"))
          {
            target.value = time
          }
          else
          {
            if (target.value.includes(", "))
            {
              let value = target.value.split(",");
              target.value = value[0] + ', ' + time
            }
            else
            {
              target.value += (", " + time)
            }
          }
          target.dispatchEvent(new Event('change'));
        },
      }
    });
    calendar.init();
  }

  flash() {
    let e = event;
    e.target.closest(".flash-container").classList.add("hidden");
  }

  modal(e) {
    let modal = e.target.closest(".modal,.edit-modal");
    modal.classList.add("hidden");
    if(modal.querySelector(".edit-modal-container"))
    {
      modal.querySelector(".edit-modal-container").classList.add("hidden");
    }
    if(modal.querySelector(".del-modal-container"))
    {
      modal.querySelector(".del-modal-container").classList.add("hidden");
    }
  }

  statusSelect() {
    let e = event;
    let target = e.target;
    if (!target.classList.contains("selection_container"))
    {
      target=target.parentElement;
    }
    let child = target.childNodes[0];
    if (target.classList.contains('bg-blue'))
    {
      target.classList.remove('bg-blue');
      target.classList.add('bg-[#7E7E7E]');
      child.classList.remove("right-[2px]");
      child.classList.add("right-[19px]")
    }
    else
    {
      target.classList.add('bg-blue');
      target.classList.remove('bg-[#7E7E7E]');
      child.classList.add("right-[2px]");
      child.classList.remove("right-[19px]")
    }
  }

  check() {
    let e = event;
    let target = e.target;
    if (target.classList.contains("ic-checkbox"))
    {
      target.classList.remove("ic-checkbox");
      target.classList.add("ic-checkbox-empty");
    }
    else
    {
      target.classList.add("ic-checkbox");
      target.classList.remove("ic-checkbox-empty");
    }
    target.parentElement.querySelector("input[type=checkbox]").click();
  }

  checkdiv() {
    let e = event;
    let target = e.target;
    let divTarget = e.target.parentElement.querySelector(".ic-checkbox, .ic-checkbox-empty")
    if (target.checked)
    {
      divTarget.classList.add("ic-checkbox");
      divTarget.classList.remove("ic-checkbox-empty");
    }
    else
    {
      divTarget.classList.remove("ic-checkbox");
      divTarget.classList.add("ic-checkbox-empty");
    }
  }

  darkMode(e)
  {
    let container = e.currentTarget.querySelector(".ic-moon, .ic-sun")
    if (container.classList.contains("ic-moon"))
    {
      container.classList.remove("ic-moon");
      container.classList.add("ic-sun");
      document.querySelector("html").classList.remove("dark");
      document.querySelector("html").classList.add("light");
    }
    else
    {
      container.classList.add("ic-moon");
      container.classList.remove("ic-sun");
      document.querySelector("html").classList.add("dark");
      document.querySelector("html").classList.remove("light");
    }
  }

  ApplyfixedPositionTop(e)
  {
    let [target, menu, pos] = this.getPosition(e, false);
    if(menu)
    {
      menu.style.left = (pos.left + (target.clientWidth/2)) + "px";
      menu.style.top = (pos.top - menu.clientHeight - 5) + "px";
    }
  }

  ApplyfixedPositionBottom(e)
  {
    let [target, menu, pos] = this.getPosition(e, true);
    if(menu)
    {
      menu.style.left = (pos.left - menu.clientWidth) + "px";
      menu.style.top = (pos.top + target.clientHeight + 5 + menu.clientHeight < window.innerHeight ? (pos.top + target.clientHeight + 5) : ( window.innerHeight - menu.clientHeight)) + "px";
    }
  }

  ApplyfixedPositionBottomCenterPerfect(e)
  {
    let [target, menu, pos] = this.getPosition(e, true);
    if(menu)
    {
      menu.style.left = (pos.left - ((menu.clientWidth/2)-(target.clientWidth/2))) + "px";
      menu.style.top = (pos.top + target.clientHeight + 5 + menu.clientHeight < window.innerHeight ? (pos.top + target.clientHeight + 5) : ( window.innerHeight - menu.clientHeight)) + "px";
    }
  }

  ApplyfixedPositionBottomCenter(e)
  {
    let [target, menu, pos] = this.getPosition(e, true);
    if(menu)
    {
      menu.style.left = (pos.left - (menu.clientWidth/2)) + "px";
      menu.style.top = (pos.top + target.clientHeight + 5 + menu.clientHeight < window.innerHeight ? (pos.top + target.clientHeight + 5) : ( window.innerHeight - menu.clientHeight)) + "px";
    }
  }

  getPosition(e, isParent)
  {
    let target = e.currentTarget;
    let parent = target.parentElement;
    let menu = isParent ? parent.querySelector(".fixed-menu") : target.querySelector(".fixed-menu");
    let pos = target.getBoundingClientRect();
    return [target, menu, pos]
  }

  flashTargetConnected(ele)
  {
    setTimeout(() => {
      ele.classList.add('flash-close-animation');
      ele.classList.remove('w-[436px]');
      let parent = ele.closest('.flash-container');
      parent.querySelector(".flash-text").parentElement.removeChild(parent.querySelector(".flash-text"));
      parent.querySelector(".flash-cancel").parentElement.removeChild(parent.querySelector(".flash-cancel"));
    }, 3000);
    setTimeout(()=>{
      ele.closest('#flash').removeChild(this.flashTarget)
    }, 5000)
  }

  icOver(e)
  {
    let name = e.currentTarget.dataset.classname
    let postfixR = e.currentTarget.dataset.postfixtoremove
    let postfixA = e.currentTarget.dataset.postfixtoapply
    if (e.currentTarget.querySelector('.'+name+'-'+postfixR))
    {
      let ele = e.currentTarget.querySelector('.'+name+'-'+postfixR);
      ele.classList.add(name+'-'+postfixA);
      ele.classList.remove(name+'-'+postfixR);
    }
  }

  icLeave(e)
  {
    let name = e.currentTarget.dataset.classname
    let postfixR = e.currentTarget.dataset.postfixtoremove
    let postfixA = e.currentTarget.dataset.postfixtoapply
    if (e.currentTarget.querySelector('.'+name+'-'+postfixA))
    {
      let ele = e.currentTarget.querySelector('.'+name+'-'+postfixA);
      ele.classList.add(name+'-'+postfixR);
      ele.classList.remove(name+'-'+postfixA);
    }
  }

  clearAll(e)
  {
    let parent = e.currentTarget.closest("."+e.currentTarget.dataset.container);
    if (parent)
    {
      parent.querySelectorAll(".ic-checkbox").forEach(function(ele){
        ele.dispatchEvent(new Event('mousedown'));
      });
    }
  }

  bulkIds(e)
  {
    let target = this.element.querySelector("#"+e.currentTarget.dataset.bulkid);
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
    if (e.currentTarget.dataset.clonebulk == 'true')
    {
      this.element.querySelector("#"+e.currentTarget.dataset.clone).value = target.value;
    }
  }

  closeAllMenus(e)
  {
    this.element.querySelectorAll(".action-menu, .selection-menu, .fetch-menu, .fixed-menu").forEach(function(ele){
      if(!e.target.closest(".action-menu, .selection-menu, .fetch-menu, .fixed-menu, [class*=ic-], button, input"))
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

  select(e)
  {
    let parent = e.currentTarget.closest(".select-container");
    parent.querySelector("."+e.currentTarget.dataset.name+"-name").innerHTML = e.currentTarget.innerHTML;
    parent.querySelector("."+e.currentTarget.dataset.name+"-id").value = e.currentTarget.dataset.id;
  }

  submitParentForm(e)
  {
    e.currentTarget.closest("form").querySelector("input[type=submit]").click();
  }

  animateSpin(e)
  {
    this.element.querySelectorAll(".ic-sync").forEach((ele)=>{
      ele.classList.add("animate-spin")
    })
  }

  notificationTargetConnected()
  {
    subscribeNotification();
  }

  showContainer(e) {
    let parent = e.currentTarget.closest("div");
    let target = parent.querySelector(".action-menu");
    if (target.classList.contains("hidden"))
    {
      target.classList.remove("hidden");
    }
    else
    {
      target.classList.add("hidden");
    }
  }

  darkTargetConnected(element)
  {
    let target = document.querySelector("html")
    if (element.classList.contains("ic-moon"))
    {
      target.classList.add("dark")
      target.classList.remove("light")
    }
    else
    {
      target.classList.add("light")
      target.classList.remove("dark")
    }
  }
}

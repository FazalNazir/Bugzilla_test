import { Controller } from "@hotwired/stimulus"
import { emailValidator, matchPasswordValidator, passwordValidator } from "../validators";

export default class extends Controller {

  static targets = ['pseudoMargin']
  static values = {
    'pseudoMargin': {type: Boolean, default: false}
  }

  connect() {
    this.pseudoMarginValue = this.element.querySelectorAll("[data-forms-target=pseudoMargin]").length == 1;
  }

  passShow()
  {
    let e = event;
    let [eyeOp, eyeCl] = e.target.parentElement.querySelectorAll(".eyeOp, .eyeCl");
    if (eyeOp.classList.contains("hidden"))
    {
      eyeOp.classList.remove("hidden");
      eyeCl.classList.add("hidden");
      eyeOp.parentElement.querySelector("input").setAttribute("type","password");
    }
    else
    {
      eyeOp.classList.add("hidden");
      eyeCl.classList.remove("hidden");
      eyeOp.parentElement.querySelector("input").setAttribute("type","text");
    }
  }

  validate()
  {
    let passFields = this.element.querySelectorAll("input[type=password]");
    let mailFields = this.element.querySelectorAll("input[type=email]");
    let helper = "";
    if (mailFields.length == 1 && !emailValidator(mailFields[0].value))
    {
      helper += 'Email format is incorrect';
    }
    if (passFields.length==1 && !passwordValidator(passFields[0].value))
    {
      helper += (helper!="" ? " and " : "") + "Password length must be greater than 6";
    }
    else if (passFields.length > 1 && !matchPasswordValidator(passFields[0].value, passFields[1].value))
    {
      helper += (helper!="" ? " and " : "") + "Password length is smaller or Passwords do not match";
    }
    if (helper != "")
    {
      let helperContainer = this.element.getElementsByClassName("helper")[0];
      helperContainer.classList.remove("hidden");
      helperContainer.classList.add("flex");
      helperContainer.querySelector(".helper-text").innerHTML = helper;
      this.pseudoMarginValue && this.pseudoMarginTarget.classList.add("hidden");
    }
    else
    {
      let helperContainer = this.element.getElementsByClassName("helper")[0];
      helperContainer.classList.add("hidden");
      helperContainer.classList.remove("flex");
      this.pseudoMarginValue && this.pseudoMarginTarget.classList.remove("hidden");
    }
  }
}

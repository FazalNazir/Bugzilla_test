const emailValidator = email => {
  let regex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return new RegExp(regex).test(email.toLowerCase());
}

const passwordValidator = password => {
  return password.length >= 6
}

const matchPasswordValidator = (arg_1, arg_2) => {
  return arg_1 == arg_2 && passwordValidator(arg_1) && passwordValidator(arg_2)
}

export { emailValidator, passwordValidator, matchPasswordValidator }

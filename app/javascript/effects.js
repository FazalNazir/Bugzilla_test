// This file contains functions for ripple effect(ripple)

// ripple => addKeyFrames must be called once before calling ripple function, creates ripple effect on the provided element.
//        => ele - for element on which ripple effect is needed, time - needed to specify time after which the animation disappears, clas - specific class for ripple must be same as that included in css for ripple effect to work
//        => endwait - flag to wait for the animation to end or not
const ripple = (ele, clas = "ripple", endWait = true, hidetime = 500) =>
{
  ele.onmousedown = function (e) {
    if (ele.parentElement.querySelector(`span.${clas}`) != null && endWait )
    {
      return;
    }
    let ripple = document.createElement("span");
    ripple.classList.add(clas);
    let target = e.target;
    while (target.tagName != "BUTTON")
    {
      target = target.parentElement;
    }
    let xPosition = 0;
    let yPosition = 0;
    while (target) {
      xPosition += (target.offsetLeft);
      yPosition += (target.offsetTop);
      target = target.offsetParent;
    }
    let x = e.clientX - (xPosition - window.scrollX);
    let y = e.clientY - (yPosition - window.scrollY);
    ripple.style.left = `${x}px`;
    ripple.style.top = `${y}px`;
    ele.appendChild(ripple);
    setTimeout(() => {
        ripple.remove();
    }, hidetime);
  };
}

export {ripple}

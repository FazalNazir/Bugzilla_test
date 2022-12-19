import { createConsumer } from "@rails/actioncable"

function subscribeNotification()
{
  consumer = createConsumer("/cable");
  consumer.subscriptions.create("NotificationsChannel", {
    received(data) {
      document.querySelector("#ping").classList.remove("hidden")
      addNotification(data)
    }
  })

  function addNotification(data)
  {
    const html = getNotification(data)
    const element = document.querySelector("#notifications")
    element.innerHTML = html + element.innerHTML
  }

  function getNotification(data)
  {
    return `
    <div class="h-[50px] w-fcol text-justify italic px-[10px] py-[5px] text-[14px] cursor-pointer bg-slate-100 dark:bg-slate-800">
      <span class="text-slate-800 dark:text-slate-200 font-medium not-italic">${data['title']}</span>
      <span class="text-slate-500 dark:text-slate-300 text-[12px]">${data['message']}</span>
    </div>
    `
  }
}

export {subscribeNotification}

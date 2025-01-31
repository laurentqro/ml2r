import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.element.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.document-fields')
    
    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.style.display = 'none'
      wrapper.innerHTML += '<input type="hidden" name="_destroy" value="1" />'
    }
  }
} 

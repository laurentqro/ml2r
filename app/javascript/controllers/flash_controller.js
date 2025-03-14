import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  
  connect() {
    // Auto-dismiss flash messages after 5 seconds
    this.dismissTimeout = setTimeout(() => {
      this.dismiss()
    }, 5000)
  }
  
  disconnect() {
    // Clear the timeout if the element is removed from the DOM
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
    }
  }
  
  dismiss() {
    // Fade out and remove the flash message
    this.element.classList.add("opacity-0", "transition-opacity", "duration-300")
    
    // Remove the element after the transition completes
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
} 
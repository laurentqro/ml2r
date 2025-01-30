import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step1", "step2",
    "step1Indicator", "step2Indicator",
    "nextButton", "submitButton"
  ]
  
  connect() {
    this.currentStep = 1
    this.updateIndicators()
    this.element.addEventListener('submit', this.handleSubmit.bind(this))
  }
  
  handleSubmit(event) {
    if (!this.validateCurrentStep()) {
      event.preventDefault()
    }
  }
  
  nextStep() {
    if (this.validateCurrentStep()) {
      if (this.currentStep >= 2) {
        this.element.requestSubmit()
        return
      }
      this.currentStep += 1
      this.updateStepVisibility()
      this.updateIndicators()
      this.updateButtons()
    }
  }
  
  previousStep() {
    this.currentStep -= 1
    this.updateStepVisibility()
    this.updateIndicators()
    this.updateButtons()
  }
  
  updateStepVisibility() {
    this.hideAllSteps()
    this[`step${this.currentStep}Target`].classList.remove('hidden')
  }
  
  hideAllSteps() {
    [this.step1Target, this.step2Target].forEach(step => {
      step.classList.add('hidden')
    })
  }
  
  updateIndicators() {
    [this.step1IndicatorTarget, this.step2IndicatorTarget].forEach((indicator, index) => {
      if (index + 1 === this.currentStep) {
        indicator.classList.add('text-indigo-600', 'font-bold')
      } else {
        indicator.classList.remove('text-indigo-600', 'font-bold')
      }
    })
  }

  updateButtons() {
    if (this.currentStep === 2) {
      console.log("updateButtons", this.currentStep)
      this.nextButtonTarget.classList.add('collapse')
      this.submitButtonTarget.classList.remove('collapse')
    }
  }
  
  validateCurrentStep() {
    const requiredFields = this[`step${this.currentStep}Target`].querySelectorAll('input[required], select[required], textarea[required]')
    return Array.from(requiredFields).every(field => field.value.trim() !== '')
  }
} 
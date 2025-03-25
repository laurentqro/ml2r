import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "searchInput", "dropdown", "options"]
  static values = {
    placeholder: { type: String, default: "Search..." }
  }

  connect() {
    this.setupSelectOptions()
    this.hideNativeSelect()
    this.initializeWithCurrentValue()

    // Set placeholder from select's prompt if available
    const promptOption = this.selectTarget.querySelector('option[value=""]')
    if (promptOption) {
      this.searchInputTarget.placeholder = promptOption.text
    }
    
    // Bind the clickOutside method to this controller instance
    this.boundClickOutside = this.clickOutside.bind(this)
    
    // Add click outside event listener
    document.addEventListener('click', this.boundClickOutside)
  }
  
  disconnect() {
    // Remove click outside event listener when controller disconnects
    document.removeEventListener('click', this.boundClickOutside)
  }

  setupSelectOptions() {
    // Store all options for filtering
    this.allOptions = Array.from(this.selectTarget.options)
      .filter(option => option.value) // Skip the prompt option
      .map(option => ({
        value: option.value,
        text: option.text,
        element: option
      }))
  }

  hideNativeSelect() {
    this.selectTarget.classList.add("hidden")
  }
  
  initializeWithCurrentValue() {
    // If there's a selected value, populate the search input with it
    const selectedOption = this.selectTarget.options[this.selectTarget.selectedIndex]
    if (selectedOption && selectedOption.value) {
      this.searchInputTarget.value = selectedOption.text
    }
  }

  search(event) {
    const query = event.target.value.toLowerCase().trim()
    
    // Show loading state
    this.optionsTarget.innerHTML = ""
    const loadingElement = document.createElement("div")
    loadingElement.classList.add("px-4", "py-2", "text-sm", "text-base-content/60", "italic")
    loadingElement.textContent = "Searching..."
    this.optionsTarget.appendChild(loadingElement)
    this.showDropdown()
    
    // Use setTimeout to allow the UI to update before filtering (simulates async behavior)
    setTimeout(() => {
      // Filter options based on search query
      const filteredOptions = this.allOptions.filter(option => 
        option.text.toLowerCase().includes(query)
      )
      
      // Update the dropdown with filtered options
      this.optionsTarget.innerHTML = ""
      
      filteredOptions.forEach(option => {
        const element = document.createElement("div")
        element.classList.add(
          "px-4", "py-2", "cursor-pointer", "hover:bg-base-200", "text-sm"
        )
        element.textContent = option.text
        element.dataset.value = option.value
        element.dataset.action = "click->searchable-select#selectOption"
        
        this.optionsTarget.appendChild(element)
      })
      
      // Show dropdown if we have results and search input is not empty
      if (filteredOptions.length > 0 && query.length > 0) {
        this.showDropdown()
      } else if (query.length === 0) {
        // If search is cleared, show all options
        this.showAllOptions()
      } else {
        // No results
        const element = document.createElement("div")
        element.classList.add("px-4", "py-2", "text-sm", "text-base-content/60", "italic")
        element.textContent = "No results found"
        this.optionsTarget.appendChild(element)
        this.showDropdown()
      }
    }, 100) // Small delay to show loading state
  }
  
  showAllOptions() {
    this.optionsTarget.innerHTML = ""
    
    this.allOptions.forEach(option => {
      const element = document.createElement("div")
      element.classList.add(
        "px-4", "py-2", "cursor-pointer", "hover:bg-base-200", "text-sm"
      )
      element.textContent = option.text
      element.dataset.value = option.value
      element.dataset.action = "click->searchable-select#selectOption"
      
      this.optionsTarget.appendChild(element)
    })
    
    this.showDropdown()
  }

  showDropdown() {
    this.dropdownTarget.classList.remove("hidden")
  }

  hideDropdown() {
    this.dropdownTarget.classList.add("hidden")
  }

  selectOption(event) {
    const value = event.currentTarget.dataset.value
    const text = event.currentTarget.textContent
    
    // Update the search input with the selected text
    this.searchInputTarget.value = text
    
    // Update the actual select element
    this.selectTarget.value = value
    
    // Trigger change event on the select
    this.selectTarget.dispatchEvent(new Event('change', { bubbles: true }))
    
    // Hide dropdown
    this.hideDropdown()
  }
  
  // Close dropdown when clicking outside
  clickOutside(event) {
    // Only process if dropdown is visible and click is outside the controller element
    if (!this.element.contains(event.target) && !this.dropdownTarget.classList.contains('hidden')) {
      this.hideDropdown()
    }
  }
  
  // Show all options when focusing on the search input
  showOptions() {
    if (this.searchInputTarget.value.trim() === '') {
      this.showAllOptions()
    } else {
      // Trigger search to filter based on current input
      this.search({ target: this.searchInputTarget })
    }
  }

  // Clear the search input and reset the dropdown
  clearSearch(event) {
    event.preventDefault()
    event.stopPropagation()
    
    // Clear the search input
    this.searchInputTarget.value = ''
    
    // Reset the select value
    this.selectTarget.value = ''
    
    // Trigger change event on the select
    this.selectTarget.dispatchEvent(new Event('change', { bubbles: true }))
    
    // Hide dropdown
    this.hideDropdown()
  }
} 
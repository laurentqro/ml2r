import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]
  static values = {
    lightTheme: { type: String, default: "light" },
    darkTheme: { type: String, default: "dark" }
  }

  connect() {
    // Check for saved theme preference, otherwise use system preference
    const savedTheme = localStorage.getItem("theme")
    if (savedTheme) {
      document.documentElement.setAttribute("data-theme", savedTheme)
      this.checkboxTarget.checked = savedTheme === this.darkThemeValue
    } else {
      const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
      // Use the system preference to set the theme
      document.documentElement.setAttribute("data-theme", prefersDark ? this.darkThemeValue : this.lightThemeValue)
      this.checkboxTarget.checked = prefersDark
    }
  }

  toggle() {
    const isDark = this.checkboxTarget.checked
    // Toggle between the configured light and dark themes
    document.documentElement.setAttribute("data-theme", isDark ? this.darkThemeValue : this.lightThemeValue)
    localStorage.setItem("theme", isDark ? this.darkThemeValue : this.lightThemeValue)
  }
}
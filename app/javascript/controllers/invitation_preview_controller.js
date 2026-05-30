import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "name", "previewName", "submit", "to"]

  connect() {
    this.update()
  }

  update() {
    const name = this.nameTarget.value.trim()
    const email = this.emailTarget.value.trim()

    this.previewNameTarget.textContent = name || "<name>"
    this.toTarget.textContent = email || "recipient@example.com"
    this.submitTarget.disabled = !name || !email
  }
}

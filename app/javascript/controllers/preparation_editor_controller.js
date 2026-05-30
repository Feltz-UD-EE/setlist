import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["destroyList", "list", "template"]

  connect() {
    this.nextIndex = 0
  }

  add(event) {
    event.preventDefault()

    const key = `new_${Date.now()}_${this.nextIndex++}`
    this.listTarget.insertAdjacentHTML(
      "beforeend",
      this.templateTarget.innerHTML.replaceAll("NEW_PREPARATION", key)
    )
  }

  remove(event) {
    event.preventDefault()

    const row = event.currentTarget.closest("[data-preparation-row]")
    if (!row) return

    if (row.dataset.persisted === "true") this.queuePersistedPreparationForDeletion(row)
    row.remove()
  }

  queuePersistedPreparationForDeletion(row) {
    const idInput = row.querySelector("input[name$='[id]']")
    if (!idInput?.value || !this.hasDestroyListTarget) return

    this.destroyListTarget.append(
      this.hiddenInput(`preparations[${idInput.value}][id]`, idInput.value),
      this.hiddenInput(`preparations[${idInput.value}][_destroy]`, "1")
    )
  }

  hiddenInput(name, value) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = name
    input.value = value
    return input
  }
}

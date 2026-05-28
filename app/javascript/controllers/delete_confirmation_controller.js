import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "confirmButton"]

  connect() {
    this.form = null
    this.submitter = null
  }

  confirm(event) {
    const form = event.target
    const submitter = event.submitter

    if (!this.shouldConfirm(form, submitter) || form.dataset.deleteConfirmed === "true") {
      delete form.dataset.deleteConfirmed
      return
    }

    event.preventDefault()
    this.form = form
    this.submitter = submitter
    this.dialogTarget.showModal()
  }

  delete() {
    if (!this.form) return

    const form = this.form
    const submitter = this.submitter

    form.dataset.deleteConfirmed = "true"
    this.dialogTarget.close()
    form.requestSubmit(submitter)
    this.reset()
  }

  closed() {
    this.reset()
  }

  shouldConfirm(form, submitter) {
    if (!form || !submitter) return false
    if (!this.isDeleteForm(form)) return false

    const label = this.submitterLabel(submitter)
    return label.toLowerCase().startsWith("delete")
  }

  isDeleteForm(form) {
    const methodInput = form.querySelector("input[name='_method']")
    return form.method.toLowerCase() === "delete" || methodInput?.value?.toLowerCase() === "delete"
  }

  submitterLabel(submitter) {
    if (submitter.value) return submitter.value.trim()
    return submitter.textContent.trim()
  }

  reset() {
    this.form = null
    this.submitter = null
  }
}

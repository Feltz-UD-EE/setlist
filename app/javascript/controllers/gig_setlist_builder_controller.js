import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectedList", "selectedSetlist", "count", "librarySetlist", "libraryCount"]

  connect() {
    this.draggedSetlist = null
    this.refresh()
  }

  add(event) {
    const button = event.currentTarget
    const setlist = this.buildSelectedSetlist({
      id: button.dataset.setlistId,
      name: button.dataset.setlistName,
      notes: button.dataset.setlistNotes
    })

    this.selectedListTarget.append(setlist)
    this.refresh()
  }

  remove(event) {
    event.currentTarget.closest("[data-setlist-id]").remove()
    this.refresh()
  }

  dragStart(event) {
    this.draggedSetlist = event.currentTarget
    event.dataTransfer.effectAllowed = "move"
  }

  dragOver(event) {
    event.preventDefault()
    const target = event.currentTarget

    if (target === this.draggedSetlist) return

    const position = event.offsetY > target.offsetHeight / 2 ? "afterend" : "beforebegin"
    target.insertAdjacentElement(position, this.draggedSetlist)
  }

  dragEnd() {
    this.draggedSetlist = null
    this.refresh()
  }

  buildSelectedSetlist(setlist) {
    const item = document.createElement("li")
    item.className = "selected-song"
    item.draggable = true
    item.dataset.setlistId = setlist.id
    item.dataset.gigSetlistBuilderTarget = "selectedSetlist"
    item.innerHTML = `
      <span class="drag-handle" aria-hidden="true">::</span>
      <span class="selected-song__title"></span>
      <span class="selected-song__meta"></span>
      <button type="button" class="remove-song-button" aria-label="Remove setlist" data-action="gig-setlist-builder#remove">X</button>
      <input type="hidden" name="gig_list_ids[]" value="${setlist.id}">
    `

    item.querySelector(".selected-song__title").textContent = setlist.name
    item.querySelector(".selected-song__meta").textContent = setlist.notes || ""
    item.querySelector(".remove-song-button").setAttribute("aria-label", `Remove ${setlist.name}`)
    this.bindDragEvents(item)

    return item
  }

  refresh() {
    this.selectedSetlists.forEach((setlist) => this.bindDragEvents(setlist))
    this.countTarget.textContent = this.selectedSetlists.length
    this.updateLibraryAvailability()
  }

  bindDragEvents(setlist) {
    if (setlist.dataset.dragBound === "true") return

    setlist.addEventListener("dragstart", this.dragStart.bind(this))
    setlist.addEventListener("dragover", this.dragOver.bind(this))
    setlist.addEventListener("dragend", this.dragEnd.bind(this))
    setlist.dataset.dragBound = "true"
  }

  updateLibraryAvailability() {
    const selectedIds = new Set(this.selectedSetlists.map((setlist) => setlist.dataset.setlistId))
    let availableCount = 0

    this.librarySetlistTargets.forEach((setlist) => {
      const selected = selectedIds.has(setlist.dataset.setlistId)
      setlist.disabled = selected
      setlist.classList.toggle("is-selected", selected)
      if (!selected) availableCount += 1
    })

    this.libraryCountTarget.textContent = availableCount
  }

  get selectedSetlists() {
    return Array.from(this.selectedListTarget.querySelectorAll("[data-setlist-id]"))
  }
}

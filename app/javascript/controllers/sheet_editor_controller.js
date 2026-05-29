import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "item",
    "lane",
    "dialog",
    "mainInput",
    "alternateInput",
    "mainPreview",
    "alternatePreview",
    "alternateLane",
    "alternateHeading"
  ]

  connect() {
    this.draggedItem = null
    this.pendingUploads = {
      main: new DataTransfer(),
      alternate: new DataTransfer()
    }
    this.refresh()
  }

  chooseMainSheet() {
    this.mainInputTarget.click()
  }

  mainSheetSelected() {
    this.addPendingFiles("main", this.mainInputTarget, this.mainPreviewTarget)
  }

  openAlternateDialog() {
    this.dialogTarget.showModal()
  }

  closeAlternateDialog() {
    this.dialogTarget.close()
  }

  chooseAlternateSheet() {
    this.alternateInputTarget.click()
  }

  alternateSheetSelected() {
    this.addPendingFiles("alternate", this.alternateInputTarget, this.alternatePreviewTarget)
    if (this.alternateInputTarget.files.length > 0) this.dialogTarget.close()
  }

  removePendingSheet(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.pendingType
    const pendingCard = event.currentTarget.closest(".sheet-card")
    const removeIndex = this.pendingItemsForType(type).indexOf(pendingCard)
    const input = this.inputForType(type)
    const container = this.previewForType(type)
    const nextUploads = new DataTransfer()

    Array.from(this.pendingUploads[type].files).forEach((file, index) => {
      if (index !== removeIndex) nextUploads.items.add(file)
    })

    this.pendingUploads[type] = nextUploads
    input.files = nextUploads.files
    this.renderPendingPreviews(type, container)
  }

  removeExistingSheet(event) {
    event.preventDefault()
    const sheetCard = event.currentTarget.closest(".sheet-card")
    const deleteInput = sheetCard.querySelector("[data-sheet-delete-input]")
    if (deleteInput) deleteInput.checked = true

    sheetCard.classList.add("is-removed")
    this.refresh()
  }

  dragStart(event) {
    this.draggedItem = event.currentTarget
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", "")
  }

  dragOver(event) {
    event.preventDefault()

    if (!this.draggedItem) return

    const target = event.currentTarget
    if (target === this.draggedItem) return
    if (target.dataset.sheetLane !== this.draggedItem.dataset.sheetLane) return

    const targetBounds = target.getBoundingClientRect()
    const position = event.clientX > targetBounds.left + targetBounds.width / 2 ? "afterend" : "beforebegin"
    target.insertAdjacentElement(position, this.draggedItem)
  }

  laneDragOver(event) {
    event.preventDefault()

    if (!this.draggedItem) return

    const lane = event.currentTarget
    if (lane.dataset.sheetLane !== this.draggedItem.dataset.sheetLane) return

    const afterElement = this.sheetAfterPointer(lane, event.clientX)
    if (afterElement) {
      lane.insertBefore(this.draggedItem, afterElement)
    } else {
      lane.appendChild(this.draggedItem)
    }
  }

  dragEnd() {
    this.draggedItem = null
    this.refresh()
  }

  refresh() {
    this.bindDragEvents()
    this.refreshOrders()
    this.syncPendingFileOrder("main")
    this.syncPendingFileOrder("alternate")
  }

  refreshOrders() {
    this.lanes.forEach((lane) => {
      this.itemsForLane(lane).filter((item) => !this.isRemoved(item)).forEach((item, index) => {
        const orderInput = item.querySelector("[data-sheet-order-input]")
        if (orderInput) orderInput.value = index + 1
      })
    })
  }

  bindDragEvents() {
    this.laneTargets.forEach((lane) => {
      if (lane.dataset.dragBound === "true") return

      lane.addEventListener("dragover", this.laneDragOver.bind(this))
      lane.dataset.dragBound = "true"
    })

    this.itemTargets.forEach((item) => {
      if (item.dataset.dragBound === "true") return

      item.addEventListener("dragstart", this.dragStart.bind(this))
      item.addEventListener("dragend", this.dragEnd.bind(this))
      item.dataset.dragBound = "true"
    })
  }

  addPendingFiles(type, input, container) {
    Array.from(input.files).forEach((file) => {
      this.pendingUploads[type].items.add(file)
    })

    input.files = this.pendingUploads[type].files
    this.renderPendingPreviews(type, this.previewForType(type))
  }

  renderPendingPreviews(type, container) {
    this.element.querySelectorAll(`.sheet-card[data-pending-type="${type}"]`).forEach((card) => card.remove())

    Array.from(this.pendingUploads[type].files).forEach((file, index) => {
      if (!file.type.startsWith("image/")) return

      const card = document.createElement("article")
      card.className = "sheet-card"
      card.draggable = true
      card.dataset.sheetEditorTarget = "item"
      card.dataset.sheetLane = this.laneForPendingType(type)
      card.dataset.pendingType = type
      card.dataset.pendingIndex = index

      const removeButton = document.createElement("button")
      removeButton.type = "button"
      removeButton.className = "sheet-remove-button"
      removeButton.textContent = "X"
      removeButton.setAttribute("aria-label", "Remove selected sheet")
      removeButton.dataset.action = "sheet-editor#removePendingSheet"
      removeButton.dataset.pendingType = type

      const handle = document.createElement("span")
      handle.className = "drag-handle sheet-card__handle"
      handle.setAttribute("aria-hidden", "true")
      handle.textContent = "::"

      const previewFrame = document.createElement("div")
      previewFrame.className = "sheet-card__preview-frame"

      const image = document.createElement("img")
      image.src = URL.createObjectURL(file)
      image.alt = "Selected sheet preview"
      image.className = "sheet-card__preview"
      image.onload = () => URL.revokeObjectURL(image.src)

      const orderInput = document.createElement("input")
      orderInput.type = "hidden"
      orderInput.name = this.orderInputName(type)
      orderInput.dataset.sheetOrderInput = "true"

      previewFrame.appendChild(image)
      card.append(removeButton, handle, previewFrame, orderInput)
      container.appendChild(card)
    })

    this.updateAlternateLane()
    this.refresh()
  }

  syncPendingFileOrder(type) {
    const nextUploads = new DataTransfer()
    const files = Array.from(this.pendingUploads[type].files)
    const pendingItems = this.pendingItemsForType(type)

    if (pendingItems.length !== files.length) return

    pendingItems.forEach((item) => {
      const file = files[Number(item.dataset.pendingIndex)]
      if (file) nextUploads.items.add(file)
    })

    this.pendingUploads[type] = nextUploads
    this.inputForType(type).files = nextUploads.files

    this.pendingItemsForType(type).forEach((item, index) => {
      item.dataset.pendingIndex = index
    })
  }

  updateAlternateLane() {
    if (!this.hasAlternateLaneTarget) return

    const hasUploads = this.pendingUploads.alternate.files.length > 0
    const lane = this.existingLaneForType("alternate")
    this.alternateLaneTarget.hidden = !hasUploads || Boolean(lane)

    if (hasUploads && this.hasAlternateHeadingTarget) {
      const selectedOption = this.element.querySelector("[name='song[alternate_sheet_instrument_ids]'] option:checked")
      this.alternateHeadingTarget.textContent = selectedOption?.textContent ? selectedOption.textContent.trim() : "Alternate Sheets"
      this.alternatePreviewTarget.dataset.sheetLane = this.laneForPendingType("alternate")
    }
  }

  inputForType(type) {
    return type === "main" ? this.mainInputTarget : this.alternateInputTarget
  }

  previewForType(type) {
    if (type === "main") return this.mainPreviewTarget

    return this.existingLaneForType(type) || this.alternatePreviewTarget
  }

  get lanes() {
    return [...new Set(this.itemTargets.map((item) => item.dataset.sheetLane))]
  }

  itemsForLane(lane) {
    return this.itemTargets.filter((item) => item.dataset.sheetLane === lane)
  }

  pendingItemsForType(type) {
    return this.itemTargets.filter((item) => item.dataset.pendingType === type)
  }

  sheetAfterPointer(lane, pointerX) {
    return this.itemsForLane(lane.dataset.sheetLane)
      .filter((item) => !this.isRemoved(item) && item !== this.draggedItem && item.parentElement === lane)
      .reduce((closest, item) => {
        const box = item.getBoundingClientRect()
        const offset = pointerX - box.left - box.width / 2

        if (offset < 0 && offset > closest.offset) return { offset, item }
        return closest
      }, { offset: Number.NEGATIVE_INFINITY, item: null }).item
  }

  laneForPendingType(type) {
    if (type === "main") return "main"

    const selectedOption = this.element.querySelector("[name='song[alternate_sheet_instrument_ids]'] option:checked")
    return selectedOption?.value ? `instrument-${selectedOption.value}` : "pending-alternate-new"
  }

  existingLaneForType(type) {
    if (type === "main") return this.laneTargets.find((lane) => lane.dataset.sheetLane === "main")

    const selectedOption = this.element.querySelector("[name='song[alternate_sheet_instrument_ids]'] option:checked")
    if (!selectedOption?.value) return null

    return this.laneTargets.find((lane) => lane.dataset.sheetLane === `instrument-${selectedOption.value}`) || null
  }

  orderInputName(type) {
    return type === "main" ? "song[sheet_sort_orders][]" : "song[alternate_sheet_sort_orders][]"
  }

  isRemoved(item) {
    return item.hidden || item.classList.contains("is-removed")
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectedList", "selectedSong", "count", "search", "librarySong", "libraryCount"]
  static classes = ["repeat"]

  connect() {
    this.draggedSong = null
    this.refresh()
  }

  add(event) {
    const button = event.currentTarget
    const song = this.buildSelectedSong({
      id: button.dataset.songId,
      title: button.dataset.songTitle,
      performer: button.dataset.songPerformer
    })

    this.selectedListTarget.append(song)
    this.refresh()
  }

  remove(event) {
    event.currentTarget.closest("[data-song-id]").remove()
    this.refresh()
  }

  search() {
    const query = this.searchTarget.value.trim().toLowerCase()
    let visibleCount = 0

    this.librarySongTargets.forEach((song) => {
      const matches = query.length < 3 || this.songSearchText(song).includes(query)
      song.hidden = !matches
      if (matches) visibleCount += 1
    })

    this.libraryCountTarget.textContent = visibleCount
  }

  dragStart(event) {
    this.draggedSong = event.currentTarget
    event.dataTransfer.effectAllowed = "move"
  }

  dragOver(event) {
    event.preventDefault()
    const target = event.currentTarget

    if (target === this.draggedSong) return

    const position = event.offsetY > target.offsetHeight / 2 ? "afterend" : "beforebegin"
    target.insertAdjacentElement(position, this.draggedSong)
  }

  dragEnd() {
    this.draggedSong = null
    this.refresh()
  }

  buildSelectedSong(song) {
    const item = document.createElement("li")
    item.className = "selected-song"
    item.draggable = true
    item.dataset.songId = song.id
    item.dataset.setlistBuilderTarget = "selectedSong"
    item.innerHTML = `
      <span class="drag-handle" aria-hidden="true">::</span>
      <span class="selected-song__title"></span>
      <span class="selected-song__meta"></span>
      <button type="button" class="remove-song-button" aria-label="Remove song" data-action="setlist-builder#remove">X</button>
      <input type="hidden" name="list_song_ids[]" value="${song.id}">
    `

    item.querySelector(".selected-song__title").textContent = song.title
    item.querySelector(".selected-song__meta").textContent = song.performer || ""
    item.querySelector(".remove-song-button").setAttribute("aria-label", `Remove ${song.title}`)
    this.bindDragEvents(item)

    return item
  }

  refresh() {
    this.selectedSongs.forEach((song) => this.bindDragEvents(song))
    this.countTarget.textContent = this.selectedSongs.length
    this.highlightRepeats()
  }

  bindDragEvents(song) {
    if (song.dataset.dragBound === "true") return

    song.addEventListener("dragstart", this.dragStart.bind(this))
    song.addEventListener("dragover", this.dragOver.bind(this))
    song.addEventListener("dragend", this.dragEnd.bind(this))
    song.dataset.dragBound = "true"
  }

  highlightRepeats() {
    const counts = this.selectedSongs.reduce((totals, song) => {
      totals[song.dataset.songId] = (totals[song.dataset.songId] || 0) + 1
      return totals
    }, {})

    this.selectedSongs.forEach((song) => {
      song.classList.toggle(this.repeatClass, counts[song.dataset.songId] > 1)
    })
  }

  songSearchText(song) {
    return `${song.dataset.songTitle || ""} ${song.dataset.songPerformer || ""}`.toLowerCase()
  }

  get selectedSongs() {
    return Array.from(this.selectedListTarget.querySelectorAll("[data-song-id]"))
  }
}

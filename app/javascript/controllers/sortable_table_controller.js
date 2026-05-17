import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body"]

  connect() {
    this.directionByKey = {}
  }

  sort(event) {
    const key = event.params.key
    const direction = this.nextDirection(key)
    const rows = Array.from(this.bodyTarget.querySelectorAll("tr"))

    rows.sort((left, right) => {
      const leftValue = left.dataset[key] || ""
      const rightValue = right.dataset[key] || ""

      if (key === "created") {
        return (Number(leftValue) - Number(rightValue)) * direction
      }

      return leftValue.localeCompare(rightValue) * direction
    })

    this.bodyTarget.append(...rows)
  }

  nextDirection(key) {
    this.directionByKey[key] = this.directionByKey[key] === 1 ? -1 : 1
    return this.directionByKey[key]
  }
}

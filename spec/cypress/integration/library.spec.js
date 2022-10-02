import * as helper from "../support/helpers"

describe("Chord sheets page", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("shows all chord sheets on 'My Chord Sheets' page", () => {
    cy.appFactories([
      ["create", "chord_sheet", { name: "Wonderwall" }],
      ["create", "chord_sheet", { name: "Want you back" }]
    ])

    cy.visit("/")
    cy.contains("My Chord Sheets").click()
    cy.contains("Wonderwall")
    cy.contains("Want you back")
  })

  it("allows you to search for a chord sheet", () => {
    cy.appFactories([
      ["create", "chord_sheet", { name: "Wonderwall" }],
      ["create", "chord_sheet", { name: "Want you back" }]
    ])

    cy.visit("/chord_sheets")
    cy.get("#search-box").type("Want y")
    cy.contains("Want you back")
    cy.contains("Wonderwall").not()
  })
})

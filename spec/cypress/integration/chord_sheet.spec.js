import * as helper from "../support/helpers"

describe("Chord sheets", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("saves a new chord sheet", () => {
    cy.visit("/")
    cy.contains("Create New").click()
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get("#create-btn").click()

    cy.contains("My amazing song")
    cy.contains("G   Am    D")
    cy.contains("My great lyrics")
  })

  it("transposes all the chords up", () => {
    helper.visitChordSheet()

    cy.get("#transpose-up").click()
    cy.contains("G#   A#m    D#")
  })

  it("transposes all the chords down", () => {
    helper.visitChordSheet();

    cy.get("#transpose-down").click()
    cy.contains("F#   G#m    C#")
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
})
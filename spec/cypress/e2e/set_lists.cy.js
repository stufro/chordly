import * as helper from "../support/helpers"
import "@4tw/cypress-drag-drop"

describe("Set list CRUD", () => {
  beforeEach(() => {
    cy.login()
    cy.appEval('Flipper.enable :set_lists')
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("saves a new set list", () => {
    cy.visit("/chord_sheets")
    cy.get("#create-set-list").click()
    cy.get("#set_list_name").type("Friday Night")
    cy.get("#create-btn").click()

    cy.contains("Friday Night")
  })

  it("allows the set list to be edited inline", () => {
    helper.visitSetList();

    cy.get("#show-page-title").clear().type("A new SetList title")
    cy.get("#navbar-main").click()
    cy.contains("Changes saved")

    cy.reload()
    cy.contains("A new SetList title")
  })

  it("allows the user to delete the set list", () => {
    helper.visitSetList();

    cy.get("#delete-set-list").click()
    cy.contains("Set Lists")
    cy.contains("My amazing set").should("not.exist")
  })
})


describe("Building a set list of chord sheets", () => {
  beforeEach(() => {
    cy.login()
    cy.appEval('Flipper.enable :set_lists')
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("allows chord sheets to be added to the set list", () => {
    helper.createChordSheet().then((chordSheet) => {
      helper.visitSetList()
      cy.get(`#add-chord-sheet-${chordSheet.id}`).click()

      cy.get("#set-list-chord-sheets").within(() => {
        cy.contains(chordSheet.name)
      })
    })
  })

  it("allows chord sheets to be removed from the set list", () => {
    helper.createChordSheet().then((chordSheet) => {
      helper.visitSetList([chordSheet.id])
      cy.get(`#remove-chord-sheet-${chordSheet.id}`).click()

      cy.get("#available-chord-sheets").within(() => {
        cy.contains(chordSheet.name)
      })
    })
  })

  it("allows the user to reorder the chord sheets", () => {
    helper.createChordSheet({name: "1st chord sheet"}).then((chordSheet1) => {
      helper.createChordSheet({name: "2nd chord sheet"}).then((chordSheet2) => {
        helper.createSetList([chordSheet1.id, chordSheet2.id]).then((setList) => {
          cy.visit("/chord_sheets")
          cy.contains(setList.name).click()

          cy.get(`#${chordSheet1.id}`).drag(`#${chordSheet2.id}`)
          cy.get(`#${chordSheet1.id}`).contains("2")

          cy.reload()
          cy.get(`#${chordSheet1.id}`).contains("2")
          cy.get(`#${chordSheet2.id}`).contains("1")
        })
      })
    })
  })
})

import * as helper from "../support/helpers"

describe("Creating/editing a set list", () => {
  beforeEach(() => {
    cy.login()
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

  // it("allows the user to delete the set list", () => {
  //   helper.visitSetList();

  //   cy.get("#delete-chord-sheet").click()
  //   cy.contains("set lists")
  //   cy.contains("My amazing song").should("not.exist")
  // })
})

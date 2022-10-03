import * as helper from "../support/helpers"

describe("Signing up for chordly", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("creates the new user and allows them to login", () => {
    cy.visit("/")
    cy.get("#sign-up-form-link").click()
    cy.get("#user_email").type("a@a.com")
    cy.get("#user_password").type("123456789")
    cy.get("#user_password_confirmation").type("123456789")
    cy.get("#complete-sign-up").click()

    cy.contains("Logout")
    cy.contains("Welcome! You have signed up successfully.")
    cy.contains("My Chord Sheets")
  })
})
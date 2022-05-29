// chord_sheet.spec.js created with Cypress
//
// Start writing your Cypress tests below!
// If you're unfamiliar with how Cypress works,
// check out the link below and learn how to write your first test:
// https://on.cypress.io/writing-first-test

describe('Chord sheets', function() {
  afterEach(() => {
    cy.app('clean')
  })

  it('saves a new chord sheet', function() {
    cy.visit("/")
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get('#create-btn').click()

    cy.contains("My amazing song")
    cy.contains("G   Am    D\nMy great lyrics")
  })

  it('transposes all the chords up', function() {
    cy.visit("/")
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get('#create-btn').click()
    cy.get('#transpose-up').click()
    cy.contains("A♭5   B♭m5    E♭5\nMy great lyrics")
  })

  it('transposes all the chords down', function() {
    cy.visit("/")
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get('#create-btn').click()
    cy.get('#transpose-down').click()
    cy.contains("F#5   G#m5    C#5\nMy great lyrics")
  })
})
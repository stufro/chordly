// chord_sheet.spec.js created with Cypress
//
// Start writing your Cypress tests below!
// If you're unfamiliar with how Cypress works,
// check out the link below and learn how to write your first test:
// https://on.cypress.io/writing-first-test

describe('Chord sheets', () => {
  afterEach(() => {
    cy.app('clean')
  })

  function visitChordSheet() {
    cy.appFactories([
      ["create", "chord_sheet", {name: "My amazing song", content_string: "G   Am    D\nMy great lyrics"} ]
    ]).then((records) => {
      cy.visit(`/chord_sheets/${records[0].id}`)
    })
  }

  it('saves a new chord sheet', () => {
    cy.visit("/")
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get('#create-btn').click()

    cy.contains("My amazing song")
    cy.contains("G   Am    D")
    cy.contains("My great lyrics")
  })

  it('transposes all the chords up', () => {
    visitChordSheet()

    cy.get('#transpose-up').click()
    cy.contains("A♭5   B♭m5    E♭5")
  })

  it('transposes all the chords down', () => {
    visitChordSheet();

    cy.get('#transpose-down').click()
    cy.contains("F#5   G#m5    C#5")
  })
})
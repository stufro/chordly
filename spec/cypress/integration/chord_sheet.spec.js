import * as helper from '../support/helpers'

describe('Chord sheets', () => {
  afterEach(() => {
    cy.app('clean')
  })

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
    helper.visitChordSheet()

    cy.get('#transpose-up').click()
    cy.contains("A♭5   B♭m5    E♭5")
  })

  it('transposes all the chords down', () => {
    helper.visitChordSheet();

    cy.get('#transpose-down').click()
    cy.contains("F#5   G#m5    C#5")
  })
})
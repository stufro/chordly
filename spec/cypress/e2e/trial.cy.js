describe("Trialing chordly without an account", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("lets you transpose a song without being signed in", () => {
    cy.visit("/")
    cy.contains("Transpose Song Now").click()
    cy.get("#chord-sheet-content").type("\r   G    Em     Am\rA new line of lyrics")

    cy.get("#transpose-down").click()
    cy.contains("F#  G#m   C#")
  })
})
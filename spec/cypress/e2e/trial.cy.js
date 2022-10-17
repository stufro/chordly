describe("Trialing chordly without an account", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("lets you transpose a song without being signed in", () => {
    cy.visit("/")
    cy.contains("Transpose Song Now").click()
    cy.contains("Create Chord sheet").click()

    cy.get("#chord-sheet-content").type("\r   G    Em     Am\rA new line of lyrics")
    cy.get("#transpose-down").click()
    cy.contains("F#   D#m    G#m")
    cy.contains("A new line of lyrics")
  })

  it("lets you create an account and save your trial chord sheet", () => {
    cy.visit("/")
    cy.contains("Transpose Song Now").click()
    cy.contains("Create Chord sheet").click()
    cy.get("#sign-up-to-save").click()

    cy.get("#user_email").type("a@a.com")
    cy.get("#user_password").type("123456789")
    cy.get("#user_password_confirmation").type("123456789")
    cy.get("#complete-sign-up").click()

    cy.contains("Chord Sheets")
    cy.contains("My Song")
  })

  it("lets you log in and save your trial chord sheet", () => {
    cy.appFactories([
      ["create", "user", {email: "a@a.com", password: "123456789"} ]
    ])

    cy.visit("/")
    cy.contains("Transpose Song Now").click()
    cy.contains("Create Chord sheet").click()
    cy.get("#login-to-save").click()

    cy.get("#user_email").type("a@a.com")
    cy.get("#user_password").type("123456789")
    cy.get("#login-button").click()

    cy.contains("Chord Sheets")
    cy.contains("My Song")
  })
})
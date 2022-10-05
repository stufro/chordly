describe("Signing up for chordly", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("creates the new user logs them in", () => {
    cy.visit("/users/sign_in")
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

describe("Logging in with existing account", () => {
  beforeEach(() => {
    cy.appFactories([
      ["create", "user", { email: "a@a.com", password: "123456789" } ]
    ])
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("logs the user in", () => {
    cy.visit("/users/sign_in")
    cy.get("#user_email").type("a@a.com")
    cy.get("#user_password").type("123456789")
    cy.get("#login-button").click()

    cy.contains("Logout")
    cy.contains("Signed in successfully.")
    cy.contains("My Chord Sheets")
  })
})

describe("Logging out", () => {
  beforeEach(() => {
    cy.login()
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("logs the user out", () => {
    cy.visit("/")
    cy.contains("Logout").click()

    cy.contains("Log in")
    cy.contains("A free, open-source, online chord sheet creator")
  })
})

describe("Resetting a forgotten password", () => {
  beforeEach(() => {
    cy.appFactories([
      ["create", "user", { email: "a@a.com", password: "123456789" } ]
    ])
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("sends the password reset instructions", () => {
    cy.visit("/users/sign_in")
    cy.contains("Forgot your password?").click()
    cy.get("#user_email").type("a@a.com")
    cy.contains("Send reset instructions").click()

    cy.contains("Log in")
    cy.contains("You will receive an email with instructions on how to reset your password in a few minutes.")
  })
})
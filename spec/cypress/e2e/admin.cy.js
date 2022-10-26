describe("Viewing admin stats", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("allows admin users to view the page", () => {
    cy.login({email: "admin@a.com", password: "123456789", admin: true})
    cy.visit("/")
    cy.contains("Admin").click()
    cy.contains("Total Users")
  })

  it("doesn't allow non-admin users to view the page", () => {
    cy.login({email: "pleb@a.com", password: "123456789", admin: false})
    cy.visit("/")
    cy.contains("Admin").should("not.exist")

    cy.visit("/admin")
    cy.contains("Total Users").should("not.exist")
    cy.contains("You are not authorized to view this page")
  })
})
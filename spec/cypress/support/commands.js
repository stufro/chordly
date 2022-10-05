// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

Cypress.Commands.add('login', () => {
  cy.appFactories([
    ["create", "user", {email: "a@a.com", password: "123456789"} ]
  ]).then((records) => {
    cy.session([records[0].email, "123456789"], () => {
      cy.visit("users/sign_in")
      cy.get("#user_email").type(records[0].email)
      cy.get("#user_password").type("123456789")
      cy.get("#login-button").click()
      cy.contains("Signed in successfully.")
    }, {
      cacheAcrossSpecs: true,
    })
  })
})

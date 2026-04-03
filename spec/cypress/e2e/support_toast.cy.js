describe("Support toast", () => {
  afterEach(() => {
    cy.app("clean")
  })

  describe("eligible user", () => {
    beforeEach(() => {
      cy.appFactories([
        ["create", "user", {
          email: "a@a.com",
          password: "123456789",
          sign_in_count: 5,
          created_at: new Date(Date.now() - 40 * 24 * 60 * 60 * 1000).toISOString()
        }]
      ]).then(() => {
        cy.session("eligible-user", () => {
          cy.visit("/users/sign_in")
          cy.get("#user_email").type("a@a.com")
          cy.get("#user_password").type("123456789")
          cy.get("#login-button").click()
          cy.contains("Signed in successfully.")
        })
      })
    })

    it("shows the support toast", () => {
      cy.visit("/")
      cy.get("#support-toast").should("be.visible")
      cy.get("#support-toast").contains("Enjoying Chordly?")
    })

    it("contains a Buy Me a Coffee link", () => {
      cy.visit("/")
      cy.get("#support-toast")
        .contains("Buy me a coffee")
        .should("have.attr", "href", "https://www.buymeacoffee.com/stuartfrosG")
        .should("have.attr", "target", "_blank")
    })

    it("contains an 'Other ways to support' link to the about page", () => {
      cy.visit("/")
      cy.get("#support-toast")
        .contains("Other ways to support")
        .should("have.attr", "href", "/home/about#support")
    })

    it("dismisses the toast when the close button is clicked", () => {
      cy.visit("/")
      cy.get("#support-toast").should("be.visible")
      cy.get("#support-toast .delete").click()
      cy.get("#support-toast").should("not.exist")
    })

    it("records dismissed_at when the toast is closed", () => {
      cy.visit("/")
      cy.get("#support-toast .delete").click()
      cy.get("#support-toast").should("not.exist")
      cy.appEval("User.find_by(email: 'a@a.com').support_toast_dismissed_at").then((result) => {
        expect(result).not.to.be.null
      })
    })

    it("records clicked_at when the Buy Me a Coffee link is clicked", () => {
      cy.visit("/")
      cy.intercept("PATCH", "/users/support_toast").as("trackClick")
      cy.get("#support-toast")
        .contains("Buy me a coffee")
        .invoke("removeAttr", "target") // stay in same tab
        .invoke("attr", "href", "/")    // redirect to home instead of external site
        .click()
      cy.wait("@trackClick")
      cy.appEval("User.find_by(email: 'a@a.com').support_toast_clicked_at").then((result) => {
        expect(result).not.to.be.null
      })
    })

    it("does not show the toast again within 3 months of dismissal", () => {
      cy.appEval("User.find_by(email: 'a@a.com').update(support_toast_dismissed_at: Time.current)")
      cy.visit("/")
      cy.get("#support-toast").should("not.exist")
    })

    it("shows the toast again after 3 months have elapsed since dismissal", () => {
      cy.appEval("User.find_by(email: 'a@a.com').update(support_toast_dismissed_at: 4.months.ago)")
      cy.visit("/")
      cy.get("#support-toast").should("be.visible")
    })
  })

  describe("ineligible users", () => {
    it("does not show the toast to a new user (account < 1 month old)", () => {
      cy.appFactories([
        ["create", "user", {
          email: "new@a.com",
          password: "123456789",
          sign_in_count: 10
        }]
      ]).then(() => {
        cy.session("new-user", () => {
          cy.visit("/users/sign_in")
          cy.get("#user_email").type("new@a.com")
          cy.get("#user_password").type("123456789")
          cy.get("#login-button").click()
          cy.contains("Signed in successfully.")
        })
        cy.visit("/")
        cy.get("#support-toast").should("not.exist")
      })
    })

    it("does not show the toast to a user with fewer than 5 sign ins", () => {
      cy.appFactories([
        ["create", "user", {
          email: "infrequent@a.com",
          password: "123456789",
          sign_in_count: 3,
          created_at: new Date(Date.now() - 40 * 24 * 60 * 60 * 1000).toISOString()
        }]
      ]).then(() => {
        cy.session("infrequent-user", () => {
          cy.visit("/users/sign_in")
          cy.get("#user_email").type("infrequent@a.com")
          cy.get("#user_password").type("123456789")
          cy.get("#login-button").click()
          cy.contains("Signed in successfully.")
        })
        cy.visit("/")
        cy.get("#support-toast").should("not.exist")
      })
    })
  })
})

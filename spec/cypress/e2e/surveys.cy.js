describe("Surveys", () => {
  afterEach(() => {
    cy.app("clean")
  })

  it("shows the survey banner and lets you cast a vote", () => {
    cy.login()
    cy.appEval("Flipper.enable_actor(:survey_next_features, User.find_by(email: 'a@a.com'))")

    cy.visit("/chord_sheets")
    cy.contains("What should I build next for Chordly?")
    cy.contains("Cast your vote").click()

    cy.get("#answers_next_feature_sharing").click()
    cy.get("#answers_ad_free_yes").click()
    cy.get("#answers_comments").type("Love the app")
    cy.contains("Cast my vote").click()

    cy.contains("Thanks for taking part!")
    cy.contains("Thanks, your answers are saved")

    cy.visit("/chord_sheets")
    cy.contains("Cast your vote").should("not.exist")
  })

  it("lets you change your vote afterwards", () => {
    cy.login()
    cy.appEval("Flipper.enable_actor(:survey_next_features, User.find_by(email: 'a@a.com'))")
    cy.appEval(`
      user = User.find_by(email: 'a@a.com')
      user.survey_responses.create!(survey_key: "next_features",
                                     answers: { "next_feature" => "sharing", "ad_free" => "yes" },
                                     completed_at: Time.current)
    `)

    cy.visit("/surveys/next_features")
    cy.get("#answers_next_feature_sharing").should("be.checked")

    cy.get("#answers_next_feature_styling").click()
    cy.contains("Cast my vote").click()

    cy.contains("Thanks, your answers are saved")
    cy.get("#answers_next_feature_styling").should("be.checked")
  })

  it("dismisses the banner without answering", () => {
    cy.login()
    cy.appEval("Flipper.enable_actor(:survey_next_features, User.find_by(email: 'a@a.com'))")

    cy.visit("/chord_sheets")
    cy.contains("Not now").click()

    cy.contains("Cast your vote").should("not.exist")
  })

  it("shows results to admins", () => {
    cy.appFactories([["create", "user", { email: "voter@a.com" }]]).then((users) => {
      cy.appFactories([
        ["create", "survey_response", {
          user_id: users[0].id,
          answers: { next_feature: "sharing", ad_free: "yes" },
          completed_at: new Date().toISOString()
        }]
      ])
    })

    cy.login({ email: "admin@a.com", password: "123456789", user_type: "admin" })
    cy.visit("/admin/surveys/next_features")

    cy.contains("What should I build next for Chordly?")
    cy.contains("Completed by")
    cy.contains("voter@a.com")
  })
})

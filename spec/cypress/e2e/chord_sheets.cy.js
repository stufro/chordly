import * as helper from "../support/helpers"

describe("Creating/editing a chord sheet", () => {
  beforeEach(() => {
    cy.login()
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("saves a new chord sheet", () => {
    cy.visit("/chord_sheets")
    cy.contains("Create New").click()
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get("#create-btn").click()

    cy.contains("My amazing song")
    cy.contains("G   Am    D")
    cy.contains("My great lyrics")
  })

  it("allows the chord sheet to be edited inline", () => {
    helper.visitChordSheet();

    cy.get("#show-page-title").clear().type("A new chordsheet title")
    cy.get("#navbar-main").click()
    cy.contains("Changes saved")

    cy.get("#chord-sheet-content").type("\rA new line of lyrics")
    cy.get("#navbar-main").click()
    cy.contains("Changes saved")

    cy.reload()
    cy.contains("A new chordsheet title")
    cy.contains("A new line of lyrics")
  })

  it("allows the user to copy the chord sheet to clipboard", () => {
    helper.visitChordSheet();

    cy.get("#copy-to-clipboard").click().then(() => {
      cy.window().then((win) => {
        win.navigator.clipboard.readText().then((text) => {
        expect(text).to.eq("G   Am    D\nMy great lyrics");
        });
      });
    })
  })
})

describe("Transposing a chord sheet", () => {
  beforeEach(() => {
    cy.login()
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("transposes all the chords up", () => {
    helper.visitChordSheet()

    cy.get("#transpose-up").click()
    cy.contains("G#  A#m   D#")
  })

  it("transposes all the chords down", () => {
    helper.visitChordSheet();

    cy.get("#transpose-down").click()
    cy.contains("F#  G#m   C#")
  })
})

describe("Chord sheets page", () => {
  beforeEach(() => {
    cy.login()

    cy.appFactories([
      ["create", "chord_sheet", { name: "ABC" }],
      ["create", "chord_sheet", { name: "Wonderwall" }],
      ["create", "chord_sheet", { name: "Hotel California" }],
    ])
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("shows all chord sheets on 'My Library' page", () => {
    cy.visit("/")
    cy.contains("My Library").click()
    cy.contains("Wonderwall")
    cy.contains("ABC")
    cy.contains("Hotel California")
  })

  it("allows you to search for a chord sheet", () => {
    cy.visit("/chord_sheets")
    cy.get("#search-box").type("Hote")
    cy.contains("Hotel California")
    cy.contains("Wonderwall").should("not.be.visible")
    cy.contains("ABC").should("not.be.visible")
  })

  it("allows you to sort the chord sheets by name", () => {
    cy.visit("/chord_sheets")
    cy.get("#sort-chord-sheets").click()
    
    cy.get("#chord-sheets-container").within(() => {
      cy.get("p.title")
        .then(($elems) => { return Cypress._.map($elems, "innerText") })
        .should("deep.equal", ["ABC", "Hotel California", "Wonderwall"])
    })

    cy.get("#sort-chord-sheets").click()
    cy.get("#chord-sheets-container").within(() => {
      cy.get("p.title")
        .then(($elems) => { return Cypress._.map($elems, "innerText") })
        .should("deep.equal", ["Wonderwall", "Hotel California", "ABC"])
    })
  })

  it("only shows you chord sheets which you own", () => {
    cy.appFactories([["create", "user", { email: "other@user.com" }]]).then((records) => {
      cy.appFactories([["create", "chord_sheet", { name: "Another users sheet", user_id: records[0].id }]])
    })

    cy.visit("/chord_sheets")
    cy.contains("Another users sheet").should("not.exist")
  })

  it("won't let you directly visit another users chord sheet", () => {
    cy.appFactories([["create", "user", { email: "other@user.com" }]]).then((users) => {
      cy.appFactories([["create", "chord_sheet", { name: "Another users sheet", user_id: users[0].id }]]).then((chordSheets) => {
        cy.visit(`/chord_sheets/${chordSheets[0].id}`)

        cy.contains("Another users sheet").should("not.exist")
        cy.contains("You are not authorized to view this Chord Sheet")
      })
    })
  })
})
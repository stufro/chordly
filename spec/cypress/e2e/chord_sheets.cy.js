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
    cy.get("#create-chord-sheet").click()
    cy.get("#chord_sheet_name").type("My amazing song")
    cy.get("#chord_sheet_content").type("G   Am    D\nMy great lyrics")
    cy.get("#create-btn").click()

    cy.contains("My amazing song")
    cy.contains("G   Am    D")
    cy.contains("My great lyrics")
  })

  it("saves a new chord sheet in chord pro format", () => {
    cy.visit("/chord_sheets")
    cy.get("#create-chord-sheet").click()
    cy.get("#chord-pro").click()
    cy.get("#chord_sheet_content").type("{title: My Song}\n[C]This is a ChordPro [G]song", { parseSpecialCharSequences: false })
    cy.get("#create-btn").click()

    cy.contains("My Song")
    cy.contains("C                  G")
    cy.contains("This is a ChordPro song")
  })

  it("uploading a file in chord pro format", () => {
    cy.visit("/chord_sheets")
    cy.get("#create-chord-sheet").click()
    cy.get("#chord-pro").click()

    cy.get("#chord_sheet_file").selectFile({
      contents: Cypress.Buffer.from("{title: My Song}\n[C]This is a ChordPro [G]song"),
      fileName: 'file.chopro',
    }, { force: true })

    cy.get("#create-btn").click()

    cy.contains("My Song")
    cy.contains("C                  G")
    cy.contains("This is a ChordPro song")
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

  it("allows the user to delete the chord sheet", () => {
    helper.visitChordSheet();

    cy.get("#delete-chord-sheet").click()
    cy.contains("Chord Sheets")
    cy.contains("My amazing song").should("not.exist")
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

  it("allows the user to download as PDF", () => {
    helper.visitChordSheet();

    cy.intercept({
      pathname: '/chord_sheets/*.pdf',
    }, (req) => {
      req.redirect('/')
    }).as('file')

    cy.get("#export").click()

    cy.wait('@file').its('request').then((req) => {
      cy.request(req)
        .then(({ body, headers }) => {
          expect(headers["content-type"]).to.eq("application/pdf")
          expect(headers["content-disposition"]).to.include('filename="My amazing song.pdf"')
        })
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

describe("Undoing changes", () => {
  beforeEach(() => {
    cy.login()
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("shows previous versions", () => {
    helper.visitChordSheet()

    cy.get("#show-page-title").clear().type("A new chordsheet title")
    cy.get("#navbar-main").click()

    cy.get("#versions").click()

    cy.contains("My amazing song")

    cy.get(".modal-close").click()
    cy.get("#transpose-up").click() // even after transposing

    cy.get("#versions").click()

    cy.contains("My amazing song")
  })

  it("allows the user to restore a previous version", () => {
    helper.visitChordSheet()

    cy.get("#show-page-title").clear().type("A new chordsheet title")
    cy.get("#navbar-main").click()

    cy.get("#versions").click()

    cy.get('.is-flex > .button_to > .button').click()

    cy.get("#show-page-title").contains("My amazing song")
  })
})

describe("Chord sheets index page", () => {
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

  it("allows you to restore a deleted chord sheet", () => {
    cy.appFactories([["create", "chord_sheet", { name: "Deleted sheet", deleted: true }]]).then((chordSheets) => {
      cy.visit("/chord_sheets")
      cy.contains("Bin").click()
      cy.get(`#restore-chord-sheet-${chordSheets[0].id}`).click()

      cy.visit("/chord_sheets")
      cy.get("#chord-sheets-container").within(() => {
        cy.contains("Deleted sheet")
      })
    })
  })
})

describe("Chord diagrams", () => {
  beforeEach(() => {
    cy.login()
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("allows the user to view the guitar chords", () => {
    helper.visitChordSheet()

    cy.get("#chord-diagram").click()
    cy.get("#diagram-select").invoke('show')
    cy.contains("Guitar").click()
    cy.get("svg[viewBox='0 0 200 200']").should('be.visible'); // unique to guitar chord diagrams
  })

  it("allows the user to view the ukulele chords", () => {
    helper.visitChordSheet()

    cy.get("#chord-diagram").click()
    cy.get("#diagram-select").invoke('show')
    cy.contains("Ukulele").click()
    cy.get("svg[viewBox='0 0 160 200']").should('be.visible'); // unique to ukulele chord diagrams
  })
})

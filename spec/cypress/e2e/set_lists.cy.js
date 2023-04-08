import * as helper from "../support/helpers"
import "@4tw/cypress-drag-drop"

describe("Set list CRUD", () => {
  beforeEach(() => {
    cy.login()
    cy.appEval('Flipper.enable :set_lists')
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("saves a new set list", () => {
    cy.visit("/chord_sheets")
    cy.get("#create-set-list").click()
    cy.get("#set_list_name").type("Friday Night")
    cy.get("#create-btn").click()

    cy.contains("Friday Night")
  })

  it("allows the set list to be edited inline", () => {
    helper.visitSetList();

    cy.get("#show-page-title").clear().type("A new SetList title")
    cy.get("#navbar-main").click()
    cy.contains("Changes saved")

    cy.reload()
    cy.contains("A new SetList title")
  })

  it("allows the user to delete the set list", () => {
    helper.visitSetList();

    cy.get("#delete-set-list").click()
    cy.contains("Set Lists")
    cy.contains("My amazing set").should("not.exist")
  })

  it("allows the user to download the setlist as a .zip of .pdf files", () => {
    helper.createChordSheet().then((chordSheet) => {
      helper.visitSetList([chordSheet.id])

      cy.intercept({
        pathname: '/set_lists/*.pdf',
      }, (req) => {
        req.redirect('/')
      }).as('file')

      cy.contains("Separate PDFs").click({force: true})

      cy.wait('@file').its('request').then((req) => {
        cy.request(req)
        .then(({ body, headers }) => {
          expect(headers["content-type"]).to.eq("application/zip")
          expect(headers["content-disposition"]).to.include('filename="My amazing set.zip"')
        })
      })
    })
  })

  it("allows the user to download the setlist as a single .pdf file", () => {
    helper.createChordSheet().then((chordSheet) => {
      helper.visitSetList([chordSheet.id])

      cy.intercept({
        pathname: '/set_lists/*.pdf',
      }, (req) => {
        req.redirect('/')
      }).as('file')

      cy.contains("All-in-one PDF").click({force: true})

      cy.wait('@file').its('request').then((req) => {
        cy.request(req)
        .then(({ body, headers }) => {
          expect(headers["content-type"]).to.eq("application/pdf")
          expect(headers["content-disposition"]).to.include('filename="My amazing set.pdf"')
        })
      })
    })
  })
})

describe("Set list library", () => {
  beforeEach(() => {
    cy.appEval('Flipper.enable :set_lists')
    cy.login()

    cy.appFactories([
      ["create", "set_list", { name: "Friday Night" }],
      ["create", "set_list", { name: "Open Mic Night" }],
      ["create", "set_list", { name: "Afternoon Gig" }],
    ])
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("allows you to sort the chord sheets by name", () => {
    cy.visit("/chord_sheets")
    cy.get("#sort-set-lists").click()

    cy.get("#set-lists-container").within(() => {
      cy.get("p.title")
        .then(($elems) => { return Cypress._.map($elems, "innerText") })
        .should("deep.equal", ["Afternoon Gig", "Friday Night", "Open Mic Night"])
    })

    cy.get("#sort-set-lists").click()
    cy.get("#set-lists-container").within(() => {
      cy.get("p.title")
        .then(($elems) => { return Cypress._.map($elems, "innerText") })
        .should("deep.equal", ["Open Mic Night", "Friday Night", "Afternoon Gig"])
    })
  })

  it("only shows you chord sheets which you own", () => {
    cy.appFactories([["create", "user", { email: "other@user.com" }]]).then((records) => {
      cy.appFactories([["create", "set_list", { name: "Another users sheet", user_id: records[0].id }]])
    })

    cy.visit("/chord_sheets")
    cy.contains("Another users sheet").should("not.exist")
  })

  it("won't let you directly visit another users chord sheet", () => {
    cy.appFactories([["create", "user", { email: "other@user.com" }]]).then((users) => {
      cy.appFactories([["create", "set_list", { name: "Another users set", user_id: users[0].id }]]).then((setLists) => {
        cy.visit(`/set_lists/${setLists[0].id}`)

        cy.contains("Another users set").should("not.exist")
        cy.contains("You are not authorized to view this Set List")
      })
    })
  })

  it("allows you to restore a deleted set list", () => {
    cy.appFactories([["create", "set_list", { name: "Deleted set", deleted: true }]]).then((setLists) => {
      cy.visit("/chord_sheets")
      cy.contains("Bin").click()
      cy.get(`#restore-set-list-${setLists[0].id}`).click()

      cy.visit("/chord_sheets")
      cy.get("#set-lists-container").within(() => {
        cy.contains("Deleted set")
      })
    })
  })
})

describe("Building a set list of chord sheets", () => {
  beforeEach(() => {
    cy.login()
    cy.appEval('Flipper.enable :set_lists')
  })

  afterEach(() => {
    cy.app("clean")
  })

  it("allows chord sheets to be added to the set list", () => {
    helper.createChordSheet().then((chordSheet) => {
      helper.visitSetList()
      cy.get(`#add-chord-sheet-${chordSheet.id}`).click()

      cy.get("#set-list-chord-sheets").within(() => {
        cy.contains(chordSheet.name)
      })
    })
  })

  it("allows chord sheets to be removed from the set list", () => {
    helper.createChordSheet().then((chordSheet) => {
      helper.visitSetList([chordSheet.id])
      cy.get(`#remove-chord-sheet-${chordSheet.id}`).click()

      cy.get("#available-chord-sheets").within(() => {
        cy.contains(chordSheet.name)
      })
    })
  })

  it("allows the user to reorder the chord sheets", () => {
    helper.createChordSheet({name: "1st chord sheet"}).then((chordSheet1) => {
      helper.createChordSheet({name: "2nd chord sheet"}).then((chordSheet2) => {
        helper.createSetList([chordSheet1.id, chordSheet2.id]).then((setList) => {
          cy.visit("/chord_sheets")
          cy.contains(setList.name).click()

          cy.get(`#${chordSheet1.id}`).drag(`#${chordSheet2.id}`)
          cy.get(`#${chordSheet1.id}`).contains("2")

          cy.reload()
          cy.get(`#${chordSheet1.id}`).contains("2")
          cy.get(`#${chordSheet2.id}`).contains("1")
        })
      })
    })
  })
})

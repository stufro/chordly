export function visitChordSheet() {
  cy.appFactories([
    ["create", "chord_sheet", {name: "My amazing song", content_string: "G   Am    D\nMy great lyrics"} ]
  ]).then((records) => {
    cy.visit(`/chord_sheets/${records[0].id}`)
  })
}

export function createChordSheet() {
  cy.appFactories([
    ["create", "chord_sheet"]
  ]).then((records) => {
    return records[0]
  })
}

export function visitSetList() {
  cy.appFactories([
    ["create", "set_list", {name: "My Set List" } ]
  ]).then((records) => {
    cy.visit(`/set_lists/${records[0].id}`)
  })
}

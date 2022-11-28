export function visitChordSheet() {
  cy.appFactories([
    ["create", "chord_sheet", {name: "My amazing song", content_string: "G   Am    D\nMy great lyrics"} ]
  ]).then((records) => {
    cy.visit(`/chord_sheets/${records[0].id}`)
  })
}

export function createChordSheet(attrs) {
  return cy.appFactories([
    ["create", "chord_sheet", attrs || {}]
  ]).then((records) => {
    return records[0]
  })
}

export function createSetList(chordSheets) {
  return cy.appFactories([
    ["create", "set_list", { chord_sheet_ids: chordSheets } ]
  ]).then((records) => {
    return records[0]
  })
}

export function visitSetList(chordSheets) {
  cy.appFactories([
    ["create", "set_list", { chord_sheet_ids: chordSheets } ]
  ]).then((records) => {
    cy.visit(`/set_lists/${records[0].id}`)
  })
}

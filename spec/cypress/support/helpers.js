export function visitChordSheet() {
  cy.appFactories([
    ["create", "chord_sheet", {name: "My amazing song", content_string: "G   Am    D\nMy great lyrics"} ]
  ]).then((records) => {
    cy.visit(`/chord_sheets/${records[0].id}`)
  })
}
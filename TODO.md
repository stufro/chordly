# Development Roadmap
---

## Potential ideas for beyond the planned releases below
- [ ] Prefer sharps/flats option
- [ ] Alert when creating a chord sheet with the same name
- [ ] Better formatting for PDFs (page breaks etc.)
  - [ ] Option to print PDF with content in 1 column or 2
- [ ] Set list enhancements
  - [ ] Show 2 tabs on available chord sheets: recent & A-Z
  - [ ] Add chord sheet to set list from chord sheet show
- [ ] Styling chord sheets

---

## v1.0.0
- [ ] Support for chordpro format

---

## v0.5.0
- [ ] Chord diagrams at top of sheet

## v0.4.0
- [x] Undo changes for chord sheets
- [ ] Restore deleted chord sheets & set lists

---

## v0.3.0
- [x] Set lists functionality
  - [x] Set lists CRUD
  - [x] Delete chord sheets
  - [x] Drag'n'drop chord sheets to reorder
  - [x] hide deleted sheets from set list show (& remove from set list once deleted)
  - [x] Authentication
  - [x] Fix show more button on set lists
  - [x] Fix JS errors with show more stimulus controller
  - [x] Export entire set to PDF
  - [x] Searching available chord sheets
- [x] Chord sheet validations

---
## v0.2.0
- [x] SEO
- [x] Show timestamps in local user time (https://github.com/basecamp/local_time)
- [x] Admin page

---
## v0.1.0
- [x] Create project README
- [x] Fix: ensure you can't view other trial sheets
- [x] Add version to footer
- [x] Make favicon
- [x] Sending emails (email verification, password resets)
- [x] Pick opensource license
- [x] Make homepage more appealing
- [x] Make sign up/login banner smaller on trial page
- [x] Look at responsiveness of show page
- [x] Compress features mp4 video
- [x] Minify css/js

---
## v0.1.0-pre
- [x] Home splash page
  - [x] Quickly transpose text
  - [x] Option to save to library
  - [x] Add gifs / screenshots of features
- [x] About page
- [x] Accessibility report
- [x] Pagination
- [x] Destroy chord sheet (soft delete?)
- [x] Privacy statement page
- [x] Cookies permissions page
- [x] Style/animate flash message entry
- [x] Auto close flash message
- [x] Only submit contenteditable form if value has changed
- [x] Style contenteditable boxes
- [x] Fix bug caused by gsub during transposing
- [x] Handle chords with inversions
- [x] Copy & paste content
- [x] Bug: ensure there is always at least one space in between chords when transposing
- [x] Filter chord sheets
- [x] Bug: allow whitespace lines
- [x] Export chord sheet to PDF
- [x] Login auth / sign up
- [x] Sort chord sheets by time or title
- [x] Chord sheets belong to users
- [x] Authorization
- [x] Rake task to call foreman run with another procfile which runs Rails server with cypress_server.pid file, js and css and then call yarn cy:run
- [x] Add boiler plate & teasers for set lists
- [x] Add tooltips to buttons

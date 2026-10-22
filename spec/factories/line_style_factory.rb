FactoryBot.define do
  factory :line_style do
    styleable factory: :chord_sheet
    line_type { "chords" }
    font_style { "bold" }
  end
end

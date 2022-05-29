# frozen_string_literal: true

FactoryBot.define do
  factory :chord_sheet do
    transient do
      content_string { "G   Am    D\nMy great lyrics" }
    end

    name { "My amazing song" }
    content { ChordSheetModeller.new(content_string).parse }
  end
end

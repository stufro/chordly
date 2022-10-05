FactoryBot.define do
  factory :chord_sheet do
    transient do
      content_string { "G   Am    D\nMy great lyrics" }
    end

    name { "My amazing song" }
    content { ChordSheetModeller.new(content_string.gsub("\n", "\r\n")).parse }
    user { User.first || User.create(email: "a@a.com", password: "123456789") }
  end
end

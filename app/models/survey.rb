Survey = Data.define(:key, :title, :intro, :questions) do
  self::Question = Data.define(:key, :type, :prompt, :options, :other, :optional) do
    def text? = type == "text"
    def other_key = "#{key}_other"
    def answer_keys = other ? [key, other_key] : [key]

    def valid_answer?(answers)
      value = answers[key]
      return optional if value.blank?
      return true if text?
      return other && answers[other_key].present? if value == "other"

      options.key?(value)
    end

    def answer_label(answers)
      value = answers[key]
      return value if text?

      value == "other" ? "Other: #{answers[other_key]}" : options[value]
    end

    def tally(answers) = answers.filter_map { it[key] }.tally
    def written_answers(answers) = answers.filter_map { it[text? ? key : other_key].presence }
  end

  def self.all
    YAML.load_file(Rails.root.join("config/surveys.yml")).map do |key, attributes|
      questions = attributes["questions"].map do |question|
        self::Question.new(options: {}, other: false, optional: false, **question.symbolize_keys)
      end
      new(key:, title: attributes["title"], intro: attributes["intro"], questions:)
    end
  end

  def self.find(key)
    all.find { it.key == key } || raise(ActiveRecord::RecordNotFound, "Couldn't find Survey '#{key}'")
  end

  def answer_keys
    questions.flat_map(&:answer_keys)
  end
end

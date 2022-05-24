class ChordSheet < ApplicationRecord
  def transpose(direction)
    content.map! do |line|
      return line unless chords?(line)

      {"content" => transpose_line(line["content"], direction), "type" => "chords"}
    end
  end

  private

  def transpose_line(line, direction)
    line.split.map do |chord|
      interval = Music::Interval.new(2, :minor)
      Music::Chord.new(chord).send("transpose_#{direction}", interval).name
    end.join(" ")
  end

  def chords?(line)
    line["type"] == "chords"
  end
end
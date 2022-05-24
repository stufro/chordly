class ChordSheet < ApplicationRecord
  def transpose(direction)
    content.map! do |line|
      next(line) unless chords?(line)

      {"content" => transpose_line(line["content"], direction), "type" => "chords"}
    end
  end

  private

  def transpose_line(line, direction)
    line.split.uniq.each do |chord|
      new_chord = transpose_chord(chord, direction)
      line.gsub!(chord, new_chord)
    end
    line
  end

  def transpose_chord(chord, direction)
    interval = Music::Interval.new(2, :minor)
    new_chord = Music::Chord.new(chord).send("transpose_#{direction}", interval).name
  end

  def chords?(line)
    line["type"] == "chords"
  end
end
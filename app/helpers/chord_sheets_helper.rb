module ChordSheetsHelper
  def line_class(line)
    line["type"] == "chords" ? "chord-line" : "lyric-line"
  end
end

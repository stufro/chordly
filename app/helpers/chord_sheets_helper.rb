module ChordSheetsHelper
  def line_class(line)
    case line["type"]
    when "chords" then "chord-line"
    when "heading" then "heading-line"
    else "lyric-line"
    end
  end
end

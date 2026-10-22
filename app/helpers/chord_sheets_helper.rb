module ChordSheetsHelper
  def line_class(line)
    case line["type"]
    when "chords" then "chord-line"
    when "heading" then "heading-line"
    else "lyric-line"
    end
  end

  def line_style(chord_sheet, line)
    line_style = chord_sheet.line_style_for(line["type"])
    declarations = [LineStyle::FONT_STYLES[line_style.font_style]]
    declarations << "color: #{LineStyle::COLOURS[line_style.colour]}" if line_style.colour
    declarations.join("; ")
  end
end

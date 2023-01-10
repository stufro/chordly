require "zip"

class SetListExporter
  def initialize(set_list, type)
    @set_list = set_list
    @type = type
  end

  def export
    @type == "single_file" ? to_pdf : to_zip
  end

  def to_pdf
    html = ApplicationController.new.render_to_string(
      template: "set_lists/show", formats: :pdf, layout: "application", assigns: { set_list: @set_list }
    )
    Grover.new(html).to_pdf
  end

  def to_zip
    io = Zip::OutputStream.write_buffer do |zio|
      @set_list.chord_sheets.each do |chord_sheet|
        zio.put_next_entry(file_name(chord_sheet))
        zio.write(generate_pdf(chord_sheet))
      end
      zio
    end

    io.string
  end

  def file_name(chord_sheet)
    position = @set_list.chord_sheets_set_list.find_by(chord_sheet:).position
    "#{position} - #{chord_sheet.name}.pdf"
  end

  def generate_pdf(chord_sheet)
    html = ApplicationController.new.render_to_string(
      template: "chord_sheets/show", formats: :pdf, layout: "application", assigns: { chord_sheet: }
    )
    Grover.new(html).to_pdf
  end
end

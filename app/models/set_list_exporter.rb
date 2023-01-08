require "zip"

class SetListExporter
  def initialize(set_list)
    @set_list = set_list
  end

  def to_zip
    io = Zip::OutputStream.write_buffer do |zio|
      @set_list.chord_sheets.each do |chord_sheet|
        position = @set_list.chord_sheets_set_list.find_by(chord_sheet:).position
        html = ApplicationController.new.render_to_string(template: "chord_sheets/show", formats: :pdf, layout: "application",
                                                          assigns: { chord_sheet: })
        pdf = Grover.new(html).to_pdf

        zio.put_next_entry("#{position} - #{chord_sheet.name}.pdf")
        zio.write(pdf)
      end
    end

    io.string
  end
end

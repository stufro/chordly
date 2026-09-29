module PdfHelper
  # sghtmltopdf doesn't support white-space: pre-wrap. Non-breaking spaces keep the chord alignment
  # and zero-width spaces give long lines somewhere to wrap.
  def wrappable_line(content)
    content.rstrip.gsub(" ", " ​").presence || " "
  end
end

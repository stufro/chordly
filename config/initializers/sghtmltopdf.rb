# sghtmltopdf defaults to 1in margins, wkhtmltopdf used 10mm.
Sghtmltopdf.configure do |config|
  config.margin_top = "10mm"
  config.margin_bottom = "10mm"
  config.margin_left = "10mm"
  config.margin_right = "10mm"
end

Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: {
      top: "1cm",
      bottom: "2cm",
      left: "2cm",
      right: "2cm"
    },
    launch_args: ["--no-sandbox"]
  }
end

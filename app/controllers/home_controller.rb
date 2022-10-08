class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def roadmap
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML, strikethrough: true
    )
    @content = markdown.render(File.read(Rails.root.join("TODO.md")))
  end

  def about; end
end

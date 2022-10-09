class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def roadmap
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML, strikethrough: true
    )
    @content = markdown.render(Rails.root.join("TODO.md").read)
  end

  def about; end

  def privacy; end

  def features; end
end

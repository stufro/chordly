class ArticlesController < ApplicationController
  before_action :set_markdown
  skip_before_action :authenticate_user!

  def show
    @filename = params[:id].to_s
    path = Rails.public_path.join("articles", "#{@filename}.md")

    unless File.exist?(path)
      render plain: "Article not found", status: :not_found
      return
    end

    @content = @markdown.render(File.read(path))
  end

  private

  def set_markdown
    @markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML, strikethrough: true
    )
  end
end

class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  PERMITTED_ASSET_FRAMES = %w[features_gif pdf_feature_webp articles].freeze

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

  def asset_frame
    return unless PERMITTED_ASSET_FRAMES.include? params[:asset]

    render "home/asset_frames/#{params[:asset]}", layout: nil
  end
end

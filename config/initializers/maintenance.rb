Rails.application.config.middleware.use(Class.new do
  def initialize(app)
    @app = app
    @maintenance_html = Rails.public_path.join("maintenance.html").read
  end

  def call(env)
    path = env["PATH_INFO"]
    allowed_paths = %w[/ /asset_frame]
    allowed_prefixes = %w[/home /assets /packs /favicons /webfonts]
    allowed = allowed_paths.include?(path) || allowed_prefixes.any? { |prefix| path.start_with?(prefix) }
    if Flipper.enabled?(:maintenance_mode) && !allowed
      [503, { "Content-Type" => "text/html; charset=utf-8", "Retry-After" => "3600" }, [@maintenance_html]]
    else
      @app.call(env)
    end
  end
end)

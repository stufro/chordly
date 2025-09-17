class PdfRequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"].end_with?(".pdf")
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      status, headers, body = @app.call(env)
      duration = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) * 1000).round(1)

      query     = env["QUERY_STRING"].presence
      full_path = query.present? ? "#{env['PATH_INFO']}?#{query}" : env["PATH_INFO"]
      method    = env["REQUEST_METHOD"]

      Rails.logger.info "PDF generation completed #{method} #{full_path} in #{duration}ms"

      [status, headers, body]
    else
      @app.call(env)
    end
  end
end

Rails.application.config.middleware.insert_after Rails::Rack::Logger, PdfRequestLogger

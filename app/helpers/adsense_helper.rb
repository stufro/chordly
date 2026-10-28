module AdsenseHelper
  AD_SLOTS = {
    horizontal: "2541067036",
    multiplex: "8475919995",
    in_article: "1166623229"
  }.freeze

  FORMATS = {
    horizontal: "auto",
    multiplex: "autorelaxed",
    in_article: "fluid"
  }.freeze

  def show_ads?
    (!Rails.env.test? || !Rails.env.development?) && (!user_signed_in? || current_user.standard?)
  end

  # rubocop:disable-next Metrics/MethodLength
  def adsense_unit(slot)
    return unless show_ads?

    content_tag(:div, style: "width: 100%") do
      content_tag(
        :ins, "",
        class: "adsbygoogle",
        style: style,
        data: {
          ad_client: "ca-pub-3401313551409918",
          ad_slot: AD_SLOTS[slot],
          ad_format: FORMATS[slot]
        }.tap do |data|
          data[:full_width_responsive] = "true" if slot == :horizontal
        end
      )
    end
  end

  private

  def style
    "display:block; text-align:center;"
  end
end

module AdsenseHelper
  # rubocop:disable Metrics/MethodLength
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

  def adsense_unit(slot)
    content_tag(:div, style: "width: 100%") do
      # content_tag(:div, style: "width: 100%; height: 100px; border: 2px solid black") do
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
      ) # { content_tag(:p, slot) }
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def style
    "display:block; text-align:center;"
  end
end

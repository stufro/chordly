SitemapGenerator::Sitemap.default_host = "https://chordly.co.uk"

SitemapGenerator::Sitemap.create do
  add features_home_path, changefreq: "monthly", priority: 0.8
  add about_home_path, changefreq: "monthly", priority: 0.5
  add privacy_home_path, changefreq: "yearly", priority: 0.3
  add roadmap_home_path, changefreq: "monthly", priority: 0.4
  add new_trial_path, changefreq: "monthly", priority: 0.9
end

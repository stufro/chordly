# Preview all emails at http://localhost:3000/rails/mailers/newsletter
class NewsletterPreview < ActionMailer::Preview
  def newsletter
    user = User.first
    NewsletterMailer.with(
      subject: "Chordly Newsletter",
      content: "<h1>Newsletter</h1><p>Some exciting update, <a href='#'>click here.</a></p>",
      email: user.email,
      user_uuid: user.uuid
    ).newsletter
  end
end

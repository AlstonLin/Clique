class ExampleMailer < ApplicationMailer
  default from: "drumplugteam@gmail.com"

  def sample_email(order, pin)
  	@order = order
  	@pin = pin
   	mg_client = Mailgun::Client.new ENV['api_key']
    message_params = {:from    => ENV['gmail_username'],
                      :to      => @order.payer_email,
                      :subject => 'Sample Mail using Mailgun API',
                      :text    => 'This mail is sent using Mailgun API via mailgun-ruby'}
    mg_client.send_message ENV['domain'], message_params
  end
end

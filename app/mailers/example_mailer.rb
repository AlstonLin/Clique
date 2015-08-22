class ExampleMailer < ApplicationMailer
  default from: "drumplugteam@gmail.com"

  def sample_email(order, pin)
  	@order = order
  	@pin = pin
    mail(to: @order.payer_email, subject: 'Sample Email')
  end
end

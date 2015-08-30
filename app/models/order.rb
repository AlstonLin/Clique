class Order < ActiveRecord::Base
  belongs_to :pin
  

  serialize :notification_params, Hash
  
  def paypal_url(return_path)
    values = {
        business: "#{pin.user.email}",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: id,
        amount: pin.price,
        item_name: pin.name,
        quantity: '1',
        notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

end





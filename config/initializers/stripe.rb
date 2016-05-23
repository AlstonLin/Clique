Rails.configuration.stripe = {
  :publishable_key => ENV['CLIQUE_STRIPE_PUBLISHABLE'],
  :secret_key      => ENV['CLIQUE_STRIPE_SECRET']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]

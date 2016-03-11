require 'paypal-sdk-adaptivepayments'

class CliqsController < ApplicationController
  # ----------------------- Default RESTFUL Actions-----------------------------
  def new
    @clique = Cliq.new
  end

  def create
    # Creates Clique
    @clique = Cliq.new(clique_params)
    @clique.owner = current_user
    # Saves and Redirects
    if @clique.save
      flash[:notice] = "Clique Created!"
    else
      flash[:alert] = "There was an error while creating your Clique"
    end
    redirect_to clique_settings_path
  end

  def update
    @clique = Cliq.find(params[:id])
    respond_to do |format|
      if @clique.update_attributes(clique_params)
        flash[:notice] = "Clique Updated!"
        format.js
      else
        flash[:alert] = "There was an error while updating your Clique"
        format.js
      end
    end
  end

  def show
    @clique = Cliq.find(params[:id])
  end
  # ----------------------- Custom RESTFUL Actions------------------------------
  def join
    @clique = Cliq.find(params[:cliq_id])
    raise "Already in Clique" if current_user.cliques.include? @clique
    @api = PayPal::SDK::AdaptivePayments::API.new
    @preapproval = @api.build_preapproval({
      :cancelUrl => "http://66d2a092.ngrok.io/profile/"+@clique.owner.id.to_s,
      :currencyCode => "USD",
      :dateOfMonth => 1,
      :dayOfWeek => "NO_DAY_SPECIFIED",
      :maxAmountPerPayment => 69.0,
      :maxNumberOfPayments => 100,
      :maxNumberOfPaymentsPerPeriod => 2,
      :paymentPeriod => "MONTHLY",
      :returnUrl => "http://66d2a092.ngrok.io/clique/"+@clique.id.to_s+"/joined",
      :ipnNotificationUrl => "https://paypal-sdk-samples.herokuapp.com/adaptive_payments/ipn_notify",
      :startingDate => "2016-03-11T00:00:00+00:00",
      :feesPayer => "SENDER",
      :feesPayer => "SECONDARYONLY",
      :displayMaxTotalAmount => true })

    # Make API call & get response
    @preapproval_response = @api.preapproval(@preapproval)

    # Access Response
    if @preapproval_response.success?
      puts "APPRoved" + @preapproval_response.preapprovalKey
      current_user.preapprovalKey = @preapproval_response.preapprovalKey;
      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=" + @preapproval_response.preapprovalKey
      return
    else
      puts "ERRRRRROR"
      @preapproval_response.error.each do |error|
        puts error.message
      end
    end
    redirect_to @clique.owner
  end

  def joined
    puts "FINALLY MOTHERFUCKING AT JOINED"
    @api = PayPal::SDK::AdaptivePayments::API.new
    @pay = @api.build_pay({
      :actionType => "PAY",
      :cancelUrl => "https://paypal-sdk-samples.herokuapp.com/adaptive_payments/pay",
      :currencyCode => "CAD",
      :feesPayer => "SECONDARYONLY",
      :ipnNotificationUrl => "https://paypal-sdk-samples.herokuapp.com/adaptive_payments/ipn_notify",
      :preapprovalKey => current_user.preapprovalKey,
      :receiverList => {
        :receiver => [{
          :amount => 60.0,
          :email => "anmolmago-facilitator@hotmail.com",
          :primary => true,
          :paymentType => "DIGITALGOODS" },
          {
          :amount => 50.0,
          :email => "donate-facilitator@artificialcraft.net",
          :primary => false,
          :paymentType => "DIGITALGOODS" }] },
      :reverseAllParallelPaymentsOnError => true,
      :senderEmail => "sender@gmail.com",
      :returnUrl => "https://paypal-sdk-samples.herokuapp.com/adaptive_payments/pay"
    })

    # Make API call & get response
    @pay_response = @api.pay(@pay)

    @clique = Cliq.find(params[:cliq_id])

    # Access Response
    if @pay_response.success?
      puts "SUCCESSSSSS"
      puts @pay_response.payKey
      puts @pay_response.paymentExecStatus
      puts @pay_response.payErrorList
      puts @pay_response.paymentInfoList
      puts @pay_response.sender
      puts @pay_response.defaultFundingPlan
      puts @pay_response.warningDataList
      @clique.members << current_user
      flash[:notice] = "Joined " + @clique.name
    else
      flash[:alert] = "An error has occured"
      puts "ERRRRRROR 22222222"
      @pay_response.error.each do |error|
        puts error.message
      end
    end
    redirect_to @clique.owner
  end

  def leave
    @clique = Cliq.find(params[:cliq_id])
    # TODO: Add some kind of payment thing and validation
    @clique.members.delete(current_user)
    # Response
    respond_to do |format|
      if @clique.save
        flash[:notice] = "Left " + @clique.name
      else
        flash[:alert] = "An error has occured"
      end
      @user = @clique.owner
      format.js
    end
  end

  private
  def clique_params
    params.require(:cliq).permit(:name, :price, :description, :thank_you_message)
  end
end

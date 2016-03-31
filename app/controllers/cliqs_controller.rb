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
    # Follows owner
    @user = @clique.owner
    if !is_following @user
      follow = Follow.new
      follow.follower = current_user
      follow.following = @user
      follow.save
    end
    # Payment stuff
    @api = PayPal::SDK::AdaptivePayments::API.new
    t = Time.now
    @preapproval = @api.build_preapproval({
      :cancelUrl => root_url + user_path(@clique.owner),
      :currencyCode => "CAD",
      :dateOfMonth => 1,
      :dayOfWeek => "NO_DAY_SPECIFIED",
      :maxAmountPerPayment => 0.12,
      :maxTotalAmountOfAllPayments=> 1.44,
      :maxNumberOfPaymentsPerPeriod => 2,
      :paymentPeriod => "MONTHLY",
      :returnUrl => root_url + cliq_joined_path(@clique),
      :ipnNotificationUrl => "http://cliq.fm/ipn_notify",
      :startingDate => t.strftime("%Y-%m-%d"),
      # TODO: Find a way to not have an ending date
      :endingDate => 1.year.from_now.strftime("%Y-%m-%d"),
      :feesPayer => "SENDER",
      :feesPayer => "SECONDARYONLY",
      :displayMaxTotalAmount => true })

    # Make API call & get response
    @preapproval_response = @api.preapproval(@preapproval)

    # Access Response
    if @preapproval_response.success?
      puts "APPRoved " + @preapproval_response.preapprovalKey
      current_user.preapprovalKey = @preapproval_response.preapprovalKey;
      current_user.save
      redirect_to "https://www.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=" + @preapproval_response.preapprovalKey
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
    @clique = Cliq.find(params[:cliq_id])
    @api = PayPal::SDK::AdaptivePayments::API.new
    @pay = @api.build_pay({
      :actionType => "PAY",
      :cancelUrl => root_url + user_path(@clique.owner),
      :currencyCode => "CAD",
      :feesPayer => "SECONDARYONLY",
      :ipnNotificationUrl => "https://paypal-sdk-samples.herokuapp.com/adaptive_payments/ipn_notify",
      :preapprovalKey => current_user.preapprovalKey,
      :receiverList => {
        :receiver => [{
          :amount => 0.06,
          :email => @clique.email,
          :primary => true,
          :paymentType => "DIGITALGOODS" },
          {
          :amount => 0.03,
          :email => "everestmgteam@gmail",
          :primary => false,
          :paymentType => "DIGITALGOODS" }] },
      :reverseAllParallelPaymentsOnError => true,
      :senderEmail => current_user.email,
      :returnUrl => root_url + user_path(@clique.owner)
    })

    # Make API call & get response
    @pay_response = @api.pay(@pay)

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
    @api = PayPal::SDK::AdaptivePayments::API.new

    @clique = Cliq.find(params[:cliq_id])
    # Build request object
    @cancel_preapproval = @api.build_cancel_preapproval({
      :preapprovalKey => current_user.preapprovalKey})

    # Make API call & get response
    @cancel_preapproval_response = @api.cancel_preapproval(@cancel_preapproval)

    # Access Response
    if @cancel_preapproval_response.success?
        @clique.members.delete(current_user)
    else
        @cancel_preapproval_response.error.each do |error|
          puts error.message
        end
    end
    # Response
    redirect_to @clique.owner
  end

  private
  def clique_params
    params.require(:cliq).permit(:name, :price, :email, :description, :thank_you_message)
  end
end

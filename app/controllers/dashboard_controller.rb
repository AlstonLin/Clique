class DashboardController < ApplicationController
  def main
    @partial = "yearly"
  end

  def monthly
    @partial = "monthly"
    render :action => :main
  end

  def daily
    @partial = "daily"
    render :action => :main
  end

  def tracks
  end

  def orders
  end
end

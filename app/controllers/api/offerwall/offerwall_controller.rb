class Api::Offerwall::OfferwallController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:complete_campaign]

  def complete_campaign
    logger.info { "Complete campaign, #{params}" }
  end

end

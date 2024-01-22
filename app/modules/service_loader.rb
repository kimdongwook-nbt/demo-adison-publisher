# frozen_string_literal: true

module ServiceLoader
  def load_user_reward_service(service = UserRewardService.new)
    @user_reward_service ||= service
  end
end

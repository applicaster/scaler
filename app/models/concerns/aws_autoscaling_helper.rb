require "aws-sdk"

module AwsAutoscalingHelper
  extend ActiveSupport::Concern

  class_methods do
    def autoscaling_client
      Aws::AutoScaling::Client.new
    end
  end

  def autoscaling_client
    self.class.autoscaling_client
  end
end

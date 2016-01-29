require "aws-sdk"

module AwsAutoscalingHelper
  extend ActiveSupport::Concern

  class_methods do
    def autoscaling_client(options)
      Aws::AutoScaling::Client.new(options)
    end
  end

  def autoscaling_client(options)
    self.class.autoscaling_client(options)
  end
end

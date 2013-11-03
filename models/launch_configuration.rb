class LaunchConfiguration
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :name, String
  attribute :image_id, String
  attribute :instance_type, String
  attribute :security_groups, Array
  attribute :key_pair, String

  validates_presence_of :name, :image_id, :instance_type, :security_groups, :key_pair

  def self.find(name)
    lc = AS.launch_configurations[name]
    if lc.exists?
      self.new(name: name)
    else
      nil
    end
  end

  def self.all
    AS.launch_configurations
  end

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def destroy
    AS.launch_configurations[name].delete
  end

  private

  def persist!
    AS.launch_configurations.create(name, image_id, instance_type, {security_groups: security_groups, key_pair: key_pair})
  end

end

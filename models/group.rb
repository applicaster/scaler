class Group
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :name, String
  attribute :launch_configuration, String
  attribute :availability_zones, Array 
  attribute :load_balancers, Array
  attribute :health_check_grace_period, Integer 
  attribute :health_check_type, String
  attribute :min_size, Integer
  attribute :max_size, Integer

  validates_presence_of :name, :launch_configuration, :availability_zones, :load_balancers
  validates_presence_of :health_check_grace_period, :health_check_type, :min_size, :max_size

  def self.find(name)
    as_group = AS.groups[name]
    if as_group.exists?
      group = self.new
      %w{ name health_check_grace_period health_check_type min_size max_size }.each do |attr|
        group.send("#{attr}=", as_group.send("#{attr}"))
      end
      %w{ availability_zones load_balancers }.each do |attr|
        group.send("#{attr}=", as_group.send("#{attr}").map{ |i| i.name })
      end
      group.launch_configuration = as_group.launch_configuration.name
      group 
    else
      nil
    end
  end

  def self.all
    AS.groups
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
    AS.groups[name].delete!
  end

  private

  def persist!
    if AS.groups[name].exists?
      AS.groups[name].update(launch_configuration: launch_configuration, availability_zones: availability_zones,
                    load_balancers: load_balancers, health_check_grace_period: health_check_grace_period,
                    health_check_type: health_check_type.to_sym, min_size: min_size, max_size: max_size)
    else
      AS.groups.create(name, launch_configuration: launch_configuration, availability_zones: availability_zones,
                    load_balancers: load_balancers, health_check_grace_period: health_check_grace_period,
                    health_check_type: health_check_type.to_sym, min_size: min_size, max_size: max_size)
    end
  end

end

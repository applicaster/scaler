class TimeWithZoneAttribute < Virtus::Attribute
  def coerce(value)
    return nil if value.nil?
    return value if value.is_a?(ActiveSupport::TimeWithZone)
    Time.zone.parse(value)
  end
end

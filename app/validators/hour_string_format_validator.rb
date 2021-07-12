class HourStringFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/
      record.errors[attribute] << (options[:message] || "must be in HH:MM format")
    end
  end
end
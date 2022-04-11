# frozen_string_literal: true

module ValidateParamsHelper
  def validate_params(params)
    @invalid_params = []
    check_blank_fields(params)
    if params[:date] && !valid_date?(params[:date])
      @invalid_params << { date: I18n.t('errors.messages.invalid_format') }
    end
    raise_invalid_params_exception if @invalid_params.present?
  end

  def check_blank_fields(params)
    params.map do |key, value|
      @invalid_params << { key.to_s => I18n.t('errors.messages.not_blank') } if value.nil?
    end
  end

  def valid_date?(date)
    return true if date.nil?

    Date.parse(date.to_s)
  rescue ArgumentError
    false
  end

  def raise_invalid_params_exception
    raise ::ExceptionService::InvalidParamsException.new @invalid_params
  end
end

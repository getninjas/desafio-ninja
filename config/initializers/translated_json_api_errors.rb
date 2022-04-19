# frozen_string_literal: true

class TranslatedJsonApiError < JSONAPI::Serializable::Error
  id do
    @id
  end

  title do
    __send__("translate_title_#{I18n.locale.to_s.underscore}") unless @field.nil?
  end

  detail do
    @message
  end

  source do
    pointer @pointer unless @pointer.nil?
  end

  private

  def translate_title_en
    "Invalid #{@field}"
  end

  def translate_title_pt_br
    "#{@field} inválido(a)"
  end
end

class TranslatedJsonApiErrors
  def initialize(exposures)
    @errors = exposures[:object]
    @model_instance = @errors&.instance_variable_get(:@base)
    @model_class = @model_instance&.class
    @reverse_mapping = exposures[:_jsonapi_pointers] || {}

    freeze
  end

  def as_jsonapi
    @errors.attribute_names.flat_map do |key|
      @errors.full_messages_for(key).map do |message|
        field_name, index = key_info(key)
        translated_field = @model_class&.human_attribute_name(field_name) || key
        field_id = get_field_id(field_name, index)
        TranslatedJsonApiError.new(
          field: translated_field,
          id: field_id,
          message: translate_message(message, key, translated_field),
          pointer: pointer(key, index, field_name)
        ).as_jsonapi
      end
    end
  end

  private

  def pointer(key, index, field)
    if nested_key?(key)
      pointer_path = "#{@reverse_mapping[nested_key(key)]}/" #=> "/data/relationships/related_person/"
      suffix_path = "attributes/#{field.sub(/^\w+\./, '')}"
      if suffix_path.include?('.')
        "#{pointer_path}#{suffix_path.sub('.', '/')}"
      else
        index.present? ? "#{pointer_path}data/#{suffix_path}" : "#{pointer_path}#{suffix_path}"
      end
    else
      @reverse_mapping[key] || @reverse_mapping["#{key}_id".to_sym]
    end
  end

  def key_info(key)
    field_name = key.to_s.sub(/\[\d+\]/, '')
    index = key.to_s[/\d+/]
    [field_name, index]
  end

  def get_field_id(field_name, index)
    if nested_key?(field_name)
      suffix = field_name.sub(/^\w+\./, '')
      if nested_key?(suffix) && index.nil?
        @model_instance.__send__(field_name.split('.').first).__send__(suffix.split(".").first).id
      elsif nested_key?(suffix)
        association = @model_instance.instance_variable_get(:@association_cache)[field_name.split('.').first.to_sym]
        nested_association = association.target.instance_variable_get(:@association_cache)[suffix.split(".").first.to_sym]
        changed = nested_association.target.select(&:changed_for_autosave?)
        changed[index.to_i].id
      elsif index.nil?
        @model_instance.__send__(field_name.split('.').first).id
      else
        association = @model_instance.instance_variable_get(:@association_cache)[field_name.split('.').first.to_sym]
        changed = association.target.select(&:changed_for_autosave?)
        changed[index.to_i].id
      end
    elsif @model_instance.respond_to?(:id)
      @model_instance.id
    elsif @model_instance.respond_to?(:instance)
      @model_instance.instance&.id
    end
  end

  def nested_key?(key)
    key.to_s.include?('.')
  end

  def nested_key(key)
    "#{key.to_s[/^(\w+)/]}_attributes".to_sym
  end

  def translate_message(message, key, translated_field)
    replace_regexp = Regexp.new("#{Regexp.escape(key.to_s.split('.').join(' ').gsub('_', ' '))}\\b", 'i')

    message.gsub(replace_regexp, translated_field)
  end

end

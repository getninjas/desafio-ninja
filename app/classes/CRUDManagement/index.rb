# frozen_string_literal: true

module CRUDManagement
  class Index
    include ActiveModel::Model
    attr_reader :callbacks, :page, :per_page, :ransack_params, :list, :klass, :params

    def self.perform(params, callbacks, klass)
      new(params, callbacks, klass).index
    end

    def initialize(params, callbacks, klass)
      @params = params
      @page = params.delete(:page) || 1
      @per_page = params.delete(:per_page)
      @per_page = @per_page == 'all' ? nil : @per_page || 25
      @ransack_params = params.delete(:ransack_params) || {}
      @callbacks = callbacks
      @klass = klass
    end

    def index
      @list = load_object
      callbacks[:success]&.call(list)
    end

    def load_object
      klass.where(params).ransack(@ransack_params).result.page(page).per(per_page)
    end
  end
end

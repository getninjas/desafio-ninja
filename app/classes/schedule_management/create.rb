# frozen_string_literal: true

module ScheduleManagement
  class Create < CRUDManagement::Create
    def create
      @instance = load_object
      if valid?
        instance.save!
        callbacks[:success]&.call(instance)
      else
        callbacks[:error]&.call(self)
      end
    end
  end
end

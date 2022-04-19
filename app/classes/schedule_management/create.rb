# frozen_string_literal: true

module ScheduleManagement
  class Create < CRUDManagement::Create
    def create
      @instance = load_object
      set_duration
      if valid?
        instance.save!
        callbacks[:success]&.call(instance)
      else
        callbacks[:error]&.call(self)
      end
    end

    private

    def set_duration
      if instance.start_time.present? && instance.end_time.present?
        instance.duration = (instance.end_time - instance.start_time).to_i
      end
    end
  end
end

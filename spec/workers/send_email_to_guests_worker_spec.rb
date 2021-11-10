require 'rails_helper'

RSpec.describe SendEmailToGuestsWorker, type: :worker do
  let(:perform) { described_class.new.perform(schedule_id) }

  context 'when the schedule does not exist' do
    let(:schedule_id) { -2 }

    it 'does not send email' do
      expect { perform }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  context 'when the schedule exists' do
    let!(:schedule) { create(:schedule) }
    let(:schedule_id) { schedule.id }

    context 'when the schedule does not have guests' do
      it 'does not send email' do
        expect { perform }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'when the schedule has guests' do
      let!(:guest) { create(:guest, schedules: [schedule]) }

      it 'sends email' do
        expect { perform }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end

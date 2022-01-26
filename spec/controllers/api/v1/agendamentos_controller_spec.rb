require 'rails_helper'

RSpec.describe Api::V1::AgendamentosController, type: :controller do
  let(:sala) { create(:sala, :com_agenda) }
  let!(:agendamento) { create(:agendamento, agenda_id: sala.agenda.id) }

  describe 'GET #index' do
    before { get :index }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: agendamento.id } }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #destroy' do
    before { delete :destroy, params: { id: agendamento.id } }
    it 'retorna status no_content' do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PATCH #update' do
    before { patch :update, params: { id: agendamento.id, dia: Date.current + 1.day } }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { agenda_id: sala.agenda.id, data: Date.current, horario_inicio: Time.now + 1.hour, horario_final: Time.now + 2.hour} }
    before { post :create, params: valid_params }
    it 'retorna status 201' do
      expect(response).to have_http_status(:created)
    end
  end
end

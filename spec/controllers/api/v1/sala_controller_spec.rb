require 'rails_helper'

RSpec.describe Api::V1::SalasController, type: :controller do
  let(:name) { 'SalasController' }
  let(:sala) { create(:sala, :com_agenda) }
  let!(:agendamento) { create(:agendamento, agenda_id: sala.agenda.id) }

  describe 'GET #index' do
    before { get :index }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: sala.id } }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #agendas' do
    before { get :agendas, params: { id: sala.id } }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #todos_agendamentos' do
    before { get :todos_agendamentos, params: { id: sala.id } }
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #buscar_agendamento' do
    before do
      post :buscar_agendamento,
           params: { id: sala.id, data: agendamento.data }
    end
    it 'retorna status 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::FacilitiesController, type: :controller do
  login_user

  describe 'POST #search_by_siret' do
    let(:siret) { '12345678901234' }

    before do
      company_json = JSON.parse(File.read(Rails.root.join('spec/fixtures/api_entreprise_get_entreprise.json')))
      entreprises_instance = ApiEntreprise::EntrepriseWrapper.new(company_json)
      allow(UseCases::SearchCompany).to receive(:with_siret).with(siret) { entreprises_instance }

      facility_json = JSON.parse(File.read(Rails.root.join('spec/fixtures/api_entreprise_get_etablissement.json')))
      facility_instance = ApiEntreprise::EtablissementWrapper.new(facility_json)
      allow(UseCases::SearchFacility).to receive(:with_siret).with(siret) { facility_instance }
    end

    it 'returns http success' do
      post :search_by_siret, params: { siret: siret }, format: :js

      expect(response).to have_http_status(:success)
      expect(response.body).to eq({ company_name: 'Octo Technology', facility_location: '75008 Paris 8' }.to_json)
    end
  end
end

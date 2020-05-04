# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'companies/show.html.haml', type: :view do
  let(:company_json) do
    JSON.parse(file_fixture('api_entreprise_get_entreprise.json').read)
  end

  let(:facility_json) do
    JSON.parse(file_fixture('api_entreprise_get_etablissement.json').read)
  end

  let(:diagnoses) { create_list :diagnosis, 2 }

  before do
    assign :diagnosis, build(:diagnosis)
    assign :facility, ApiEntreprise::EtablissementWrapper.new(facility_json)
    assign :company, ApiEntreprise::EntrepriseWrapper.new(company_json)
    assign :diagnoses, diagnoses
    render
  end

  it('displays a title') { expect(rendered).to match(/Raison Sociale/) }
end

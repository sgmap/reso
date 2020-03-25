# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Solicitation, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :diagnoses }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :full_name }
    it { is_expected.to validate_presence_of :phone_number }
    it { is_expected.to validate_presence_of :email }
  end

  describe 'custom validations' do
    describe 'validate_selected_options' do
      subject(:solicitation) { build :solicitation, landing: landing, options: options }

      before { solicitation.validate }

      context 'no option in landing' do
        let(:landing) { build :landing }
        let(:options) { {} }

        it { is_expected.to be_valid }
      end

      context 'with options in landing' do
        let(:landing) { build :landing, :with_options }

        context 'with a chosen option' do
          let(:options) { { landing.landing_options.first => '0', landing.landing_options.last => '1' } }

          it { is_expected.to be_valid }
        end

        context 'with no chosen option' do
          let(:options) { { landing.landing_options.first => '0', landing.landing_options.last => '0' } }

          it { is_expected.not_to be_valid }
          it { expect(solicitation.errors.details).to eq({ options: [{ error: :blank }] }) }
        end
      end
    end
  end
end
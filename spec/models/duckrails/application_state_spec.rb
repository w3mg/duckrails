require 'rails_helper'

module Duckrails
  RSpec.describe ApplicationState, type: :model do
    context 'attributes' do
      it { should respond_to :mock_synchronization_token, :mock_synchronization_token= }
    end

    context 'CRUD' do
      let(:application_state) { FactoryBot.create :application_state }

      it 'should save application states' do
        application_state = FactoryBot.build :application_state, mock_synchronization_token: '123456'

        expect{ application_state.save }.to change(ApplicationState, :count).from(0).to(1)
      end

      it 'should update application states' do
        application_state = FactoryBot.create :application_state, mock_synchronization_token: '123456'

        application_state.mock_synchronization_token = '789123'
        expect(application_state.save).to be true

        application_state.reload
        expect(application_state.mock_synchronization_token).to eq '789123'
      end

      it 'should destroy application states' do
        application_state = FactoryBot.create :application_state, mock_synchronization_token: '123456'

        expect{ application_state.destroy }.to change(ApplicationState, :count).from(1).to(0)
      end
    end
  end
end

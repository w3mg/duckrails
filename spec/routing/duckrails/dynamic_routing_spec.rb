require 'rails_helper'

describe 'Dynamic routes' do
  let(:mock) { FactoryGirl.create :mock, request_method: request_method, route_path: route_path }
  let(:request_method) { }
  let(:route_path) { '/mocker/:mocker_id/mocks' }

  before do
    mock.save!
    Duckrails::Application.routes_reloader.reload!
  end

  Duckrails::Router::METHODS.each do |method|
    context "Serving mocks with #{method}" do
      let(:request_method) { method }

      it 'should serve the mock' do
        expect("#{method}": route_path).to route_to({
          controller: 'duckrails/mocks',
          action: 'serve_mock',
          duckrails_mock_id: mock.id,
          mocker_id: ':mocker_id'
          })
      end
    end
  end
end

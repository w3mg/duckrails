require 'rails_helper'

module Duckrails
  RSpec.describe Duckrails::MocksController, type: :controller do
    describe 'action callbacks' do
      context '#load_mock' do
        it { should execute_before_filter :load_mock, :on => :edit, with: { id: 'foo' } }
        it { should execute_before_filter :load_mock, :on => :update, with: { id: 'foo' } }
        it { should execute_before_filter :load_mock, :on => :destroy, with: { id: 'foo' } }
        it { should_not execute_before_filter :load_mock, :on => :index }
        it { should_not execute_before_filter :load_mock, :on => :new }
      end

      context '#reload_routes' do
        let(:mock) { FactoryGirl.create(:mock) }

        it { should execute_after_filter :reload_routes, :on => :update, with: { id: mock.id } }
        it { should execute_after_filter :reload_routes, :on => :create }
        it { should execute_after_filter :reload_routes, :on => :destroy, with: { id: mock.id } }
        it { should_not execute_after_filter :reload_routes, :on => :index }
        it { should_not execute_after_filter :reload_routes, :on => :new }
      end
    end

    describe "GET #index" do
      let(:page) { nil }

      before do
        expect(Mock).to receive(:page).with(page).and_call_original

        get :index, page: page
      end

      context 'with page parameter' do
        let(:page) { '10' }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :index  }
        end
      end

      context 'without page parameter' do
        let(:page) { nil }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :index  }
        end
      end
    end

    describe 'GET #edit' do
      let(:mock) { FactoryGirl.create :mock }

      before do
        get :edit, id: mock.id
      end

      describe 'response' do
        subject { response }

        it { should have_http_status :success }
        it { should render_template :edit  }
      end

      describe '@mock' do
        subject { assigns :mock }

        it { should eq mock }
      end
    end

    describe 'GET #new' do
      let(:mock) { FactoryGirl.build :mock }

      before do
        expect(Mock).to receive(:new).once.and_return(mock)

        get :new
      end

      describe 'response' do
        subject { response }

        it { should have_http_status :success }
        it { should render_template :new  }
      end

      describe '@mock' do
        subject { assigns :mock }

        it { should eq mock }
      end
    end

    describe 'PUT/PATCH #update' do
      let(:mock) { FactoryGirl.create :mock }
      let(:valid) { nil }

      before do
        expect_any_instance_of(Mock).to receive(:save).once.and_return(valid)

        put :update, id: mock.id, duckrails_mock: { name: 'Updated Name' }
      end

      context 'with valid mock' do
        let(:valid) { true }

        describe 'response' do
          subject { response }

          it { should have_http_status :redirect }
          it { should redirect_to duckrails_mocks_path  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Updated Name'
          end
        end
      end

      context 'with invalid mock' do
        let(:valid) { false }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :edit  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Updated Name'
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:mock) { FactoryGirl.create :mock }

      before do
        expect(Duckrails::Router).to receive(:unregister_mock).with(mock).once.and_call_original

        delete :destroy, id: mock.id
      end

      describe 'response' do
        subject { response }

        it { should redirect_to duckrails_mocks_path }
      end

    end

    describe '#serve_mock' do
      let(:body_type) { nil }
      let(:body_content) { nil }
      let(:script_type) { nil }
      let(:script) { nil }
      let(:headers) { nil }
      let!(:mock) { FactoryGirl.create(:mock,
                                      headers: headers || [],
                                      body_type: body_type,
                                      body_content: body_content,
                                      script_type: script_type,
                                      script: script ) }

      before do
        Duckrails::Application.routes_reloader.reload!

        expect(controller).to receive(:evaluate_content).with(body_type, body_content).once.and_call_original
        expect(controller).to receive(:evaluate_content).with(script_type, script, true).once.and_call_original
      end

      context 'without overrides' do
        let(:body_type) { Duckrails::Mock::SCRIPT_TYPE_STATIC }
        let(:body_content) { 'Hello world' }

        context 'without headers' do
          it 'should render the body content' do
            expect(controller).to receive(:add_response_header).never

            get :serve_mock, id: mock.id, duckrails_mock_id: mock.id

            expect(response.body).to eq body_content
            expect(response.content_type).to eq mock.content_type
            expect(response.status).to eq mock.status
          end
        end
      end

      pending 'continue adding missing specs here'
    end
  end
end

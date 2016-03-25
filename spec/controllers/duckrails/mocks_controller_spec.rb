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

        describe '#serve_mock' do
          let(:mock) { FactoryGirl.build :mock }

          before do
            mock.save!

            Duckrails::Application.routes_reloader.reload!
          end

          it { should_not execute_before_filter :load_mock, :on => :serve_mock, with: { id: mock.id, duckrails_mock_id: mock.id } }
          it { should_not execute_before_filter :verify_authenticity_token, :on => :serve_mock, with: { id: mock.id, duckrails_mock_id: mock.id } }
          it { should_not execute_after_filter :reload_routes, :on => :serve_mock, with: { id: mock.id, duckrails_mock_id: mock.id } }
        end
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

    describe 'POST #create' do
      let(:mock) { FactoryGirl.build :mock }
      let(:valid) { nil }

      before do
        expect(controller).to receive(:mock_params).and_call_original
        expect_any_instance_of(Mock).to receive(:save).once.and_return(valid)

        post :create, id: mock.id, duckrails_mock: FactoryGirl.attributes_for(:mock)
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
            expect(subject.name).to eq 'Default mock'
          end
        end
      end

      context 'with invalid mock' do
        let(:valid) { false }

        describe 'response' do
          subject { response }

          it { should have_http_status :success }
          it { should render_template :new  }
        end

        describe '@mock' do
          subject { assigns :mock }

          it 'should assign attributes' do
            expect(subject.name).to eq 'Default mock'
          end
        end
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
      let(:body_type) { Duckrails::Mock::SCRIPT_TYPE_STATIC }
      let(:body_content) { 'Hello world' }
      let(:mock) { FactoryGirl.build(:mock,
                                      headers: headers || [],
                                      body_type: body_type,
                                      body_content: body_content,
                                      script_type: script_type,
                                      script: script ) }

      before do
        mock.save!

        Duckrails::Application.routes_reloader.reload!

        expect(controller).to receive(:evaluate_content).with(body_type, body_content).once.and_call_original
        expect(controller).to receive(:evaluate_content).with(script_type, script, true).once.and_call_original
      end

      context 'without script' do
        context 'without headers' do
          it 'should respond with mock\'s body, content & status' do
            expect(controller).to receive(:add_response_header).never

            get :serve_mock, id: mock.id, duckrails_mock_id: mock.id

            expect(response.body).to eq body_content
            expect(response.content_type).to eq mock.content_type
            expect(response.status).to eq mock.status
          end
        end

        context 'with headers' do
          let(:headers) {
            [ FactoryGirl.build(:header, name: 'Header 1', value: 'Value 1'),
              FactoryGirl.build(:header, name: 'Header 2', value: 'Value 2')] }

          it 'should respond with mock\'s body, content, status & headers' do
            expect(controller).to receive(:add_response_header).twice.and_call_original

            get :serve_mock, id: mock.id, duckrails_mock_id: mock.id

            expect(response.body).to eq body_content
            expect(response.content_type).to eq mock.content_type
            expect(response.status).to eq mock.status
            expect(response.headers['Header 1']).to eq 'Value 1'
            expect(response.headers['Header 2']).to eq 'Value 2'
          end
        end
      end

      context 'with script' do
        let(:script_type) { Duckrails::Mock::SCRIPT_TYPE_EMBEDDED_RUBY }
        let(:script_headers) { '[{ name: "Header 1", value: "Override 1" }, { name: "Header 3", value: "New Header" }]' }
        let(:content_type) { 'application/duckrails' }
        let(:status_code) { 418 }
        let(:script) { "<%= { headers: #{script_headers}, content_type: '#{content_type}', status_code: #{status_code} }.to_json %>" }

        context 'without headers' do
          it 'should respond with mock\'s body, override content, status & add new headers' do
            expect(controller).to receive(:add_response_header).exactly(2).times.and_call_original

            get :serve_mock, id: mock.id, duckrails_mock_id: mock.id

            expect(response.body).to eq body_content
            expect(response.content_type).to eq content_type
            expect(response.status).to eq status_code
            expect(response.headers['Header 1']).to eq 'Override 1'
            expect(response.headers['Header 3']).to eq 'New Header'
          end
        end

        context 'with headers' do
          let(:headers) {
            [ FactoryGirl.build(:header, name: 'Header 1', value: 'Value 1'),
              FactoryGirl.build(:header, name: 'Header 2', value: 'Value 2')] }

          it 'should respond with mock\'s body, content, status & headers' do
            expect(controller).to receive(:add_response_header).exactly(4).times.and_call_original

            get :serve_mock, id: mock.id, duckrails_mock_id: mock.id

            expect(response.body).to eq body_content
            expect(response.content_type).to eq content_type
            expect(response.status).to eq status_code
            expect(response.headers['Header 1']).to eq 'Override 1'
            expect(response.headers['Header 2']).to eq 'Value 2'
            expect(response.headers['Header 3']).to eq 'New Header'
          end
        end
      end
    end

    ###########
    # protected
    ###########

    describe '#add_response_header' do
      let(:response) { ActionController::TestResponse.new }
      let(:header) { FactoryGirl.build :header }

      it 'should' do
        expect(controller).to receive(:response).and_return(response)

        controller.send(:add_response_header, header)

        expect(response.headers['Authorization']).to eq header.value
      end
    end

    describe '#evaluate_content' do
      let(:script_type) { nil }
      let(:script) { nil }
      let(:force_json) { nil }
      let(:should_raise_exception) { false }
      let(:response) { ActionController::TestResponse.new }

      before do
        allow(controller).to receive(:response).and_return(response)

        arguments = [script_type, script]
        arguments << force_json unless force_json.nil?

        @result = controller.send :evaluate_content, *arguments

        if should_raise_exception
          expect(response.headers['Duckrails-Error']).not_to be_blank
        else
          expect(response.headers['Duckrails-Error']).to be_blank
        end
      end

      subject { @result }

      context 'with force json variable' do
        let(:force_json) { false }

        context 'without script type' do
          context 'without script' do
            it { should be nil }
          end

          context 'with script' do
            let(:script) { 'Whatever' }

            it { should be nil }
          end
        end

        context 'with script type' do
          context 'with static script type' do
            let(:script_type) { Duckrails::Mock::SCRIPT_TYPE_STATIC }

            context 'without script' do
              context 'with force json' do
                let(:force_json) { true }

                it { should == {} }
              end

              context 'without force json' do
                it { should be nil }
              end
            end

            context 'with script' do
              let(:script) { 'test' }

              context 'with force json' do
                let(:force_json) { true }

                context 'and invalid json' do
                  let(:should_raise_exception) { true }

                  it { should be nil }
                end

                context 'and valid json' do
                  let(:script) { { foo: 1 }.to_json }

                  it { should == { 'foo' => 1 } }
                end
              end

              context 'without force json' do
                it { should eq 'test' }
              end
            end
          end

          context 'with embedded ruby script' do
            let(:script_type) { Duckrails::Mock::SCRIPT_TYPE_EMBEDDED_RUBY }

            context 'without script' do
              context 'with force json' do
                let(:force_json) { true }

                it { should == {} }
              end

              context 'without force json' do
                it { should be nil }
              end
            end

            context 'with script' do
              context 'with force json' do
                let(:force_json) { true }

                context 'and invalid json' do
                  let(:script) { '<%= Date.today %>' }
                  let(:should_raise_exception) { true }

                  it { should be nil }
                end

                context 'and valid json' do
                  let(:script) { '<%= { foo: Date.today }.to_json %>' }

                  it { should == { foo: Date.today }.as_json }
                end
              end
            end
          end
        end
      end

      context 'without force json variable' do
        let(:force_json) { nil }

        context 'without script type' do
          context 'without script' do
            it { should be nil }
          end

          context 'with script' do
            let(:script) { 'Whatever' }

            it { should be nil }
          end
        end

        context 'with script type' do
          context 'with static script type' do
            let(:script_type) { Duckrails::Mock::SCRIPT_TYPE_STATIC }

            context 'without script' do
              context 'with force json' do
                let(:force_json) { true }

                it { should == {} }
              end

              context 'without force json' do
                it { should be nil }
              end
            end

            context 'with script' do
              let(:script) { 'test' }

              context 'with force json' do
                let(:force_json) { true }

                context 'and invalid json' do
                  let(:should_raise_exception) { true }

                  it { should be nil }
                end

                context 'and valid json' do
                  let(:script) { { foo: 1 }.to_json }

                  it { should == { 'foo' => 1 } }
                end
              end

              context 'without force json' do
                it { should eq 'test' }
              end
            end
          end

          context 'with embedded ruby script' do
            let(:script_type) { Duckrails::Mock::SCRIPT_TYPE_EMBEDDED_RUBY }

            context 'without script' do
              context 'with force json' do
                let(:force_json) { true }

                it { should == {} }
              end

              context 'without force json' do
                it { should be nil }
              end
            end

            context 'with script' do
              context 'with force json' do
                let(:force_json) { true }

                context 'and invalid json' do
                  let(:script) { '<%= Date.today %>' }
                  let(:should_raise_exception) { true }

                  it { should be nil }
                end

                context 'and valid json' do
                  let(:script) { '<%= { foo: Date.today }.to_json %>' }

                  it { should == { foo: Date.today }.as_json }
                end
              end
            end
          end
        end
      end
    end
  end
end

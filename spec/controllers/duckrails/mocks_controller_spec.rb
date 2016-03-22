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
  end
end

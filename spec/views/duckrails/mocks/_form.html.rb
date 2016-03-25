require 'rails_helper'

RSpec.describe 'duckrails/mocks/_form.html.erb', type: :view do
  let(:title) { t('Home') }
  let(:mock) { Duckrails::Mock.new }
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    assign :mock, mock
    render partial: 'form.html.erb'
  end

  subject { rendered }

  it { should have_css "form[method='post'][action='#{view.duckrails_mocks_path}']" }

  context 'for new record' do
    it { should_not have_css 'input[type="hidden"][name="_method"][value="patch"]' }
  end

  context 'for existing record' do
    let(:mock) { FactoryGirl.create :mock }

    it { should have_css 'input[type="hidden"][name="_method"][value="patch"]' }
  end

  context 'tabs' do
    it { should have_css 'ul.tabs[data-tab] .tab-title.active a[href="#general"]', text: t(:general_tab) }
    it { should have_css 'ul.tabs[data-tab] .tab-title a[href="#response_body"]', text: t(:response_body_tab) }
    it { should have_css 'ul.tabs[data-tab] .tab-title a[href="#headers"]', text: t(:headers_tab) }
    it { should have_css 'ul.tabs[data-tab] .tab-title a[href="#advanced"]', text: t(:advanced_tab) }
  end

  context 'tab content' do
    context 'general tab' do
      subject { page.find '.tabs-content #general' }

      it { should have_css 'p', text: t(:general_tab_header) }

      it { should have_field 'Name', type: 'text' }
      it { should have_css '.hint', text: t(:field_name_hint) }

      it { should have_field 'Description', type: 'textarea' }
      it { should have_css '.hint', text: t(:field_description_hint) }

      it { should have_field 'Request method', type: 'select' }
      it { should have_css '.hint', text: t(:field_request_method_hint) }

      it { should have_field 'Status', type: 'number' }
      it { should have_css '.hint', text: t(:field_status_hint) }

      it { should have_field 'Route path', type: 'text' }
      it { should have_css '.hint', text: t(:field_route_path_hint) }
    end

    context 'response body' do
      subject { page.find '.tabs-content #response_body' }

      it { should have_css 'p', text: t(:response_body_tab_header) }

      it { should have_field 'Body type', type: 'select' }
      it { should have_css '.hint', text: t(:field_body_type_hint) }

      it { should have_field 'Content type', type: 'select' }
      it { should have_css '.hint', text: t(:field_content_type_hint) }

      it { should have_field 'Body content', type: 'textarea' }
      it { should have_css '.hint', text: t(:field_body_content_hint) }
    end

    pending 'add missing specs'
  end
end

require 'duckrails/router'

module Duckrails
  class MocksController < ApplicationController
    before_filter :load_mock, only: [:edit, :update, :destroy]
    after_filter :reload_routes, only: [:update, :create, :destroy]

    def index
      @mocks = Duckrails::Mock.page params[:page]
    end

    def edit
    end

    def new
      @mock = Duckrails::Mock.new
    end

    def update
      @mock.assign_attributes mock_params

      if @mock.save
        redirect_to duckrails_mocks_path, flash: { info: 'The mock was successfully updated.' }
      else
        render :edit
      end
    end

    def create
      @mock = Duckrails::Mock.new mock_params

      if @mock.save
        redirect_to duckrails_mocks_path, flash: { info: 'The mock was created successfully.' }
      else
        render :new
      end
    end

    def destroy
      @mock.delete
      Duckrails::Router.unregister_mock @mock
      redirect_to duckrails_mocks_path, flash: { info: "Mock '#{@mock.name}' was deleted successfully." }
    end

    # This is the one and only action mapped to each mock route
    def mockify
      mock_id = params[:duckrails_mock_id]
      mock = Duckrails::Mock.find mock_id

      body = mock.dynamic? ? erubify(mock.content) : mock.content

      mock.headers.each do |header|
        response.headers[header.name] = header.value
      end

      render body: body, content_type: mock.content_type, status: mock.status
    end

    #########
    protected
    #########

    def register_mock
      Duckrails::Router.register_mock @mock
    end

    def reload_routes
      Duckrails::Application.routes_reloader.reload!
    end

    def mock_params
      params.require(:duckrails_mock).permit(:name,
                                             :description,
                                             :status,
                                             :body_type,
                                             :content,
                                             :method,
                                             :content_type,
                                             :route_path,
                                             headers_attributes: [:id,
                                                                  :name,
                                                                  :value,
                                                                  :_destroy])
    end

    def load_mock
      @mock = Duckrails::Mock.find params[:id]
    end

    def erubify(template)
      variables = {
        request: request,
        parameters: params
      }

      Erubis::Eruby.new(template).result(variables)
    end
  end
end

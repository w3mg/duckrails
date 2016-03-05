module Duckrails
  class MocksController < ApplicationController
    before_filter :load_mock, only: [:edit, :update, :destroy]
    after_filter :reload_routes, only: [:update, :create, :destroy]

    def index
      @mocks = Duckrails::Mock.all
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
    end

    # This is the one and only action mapped to each mock route
    def mockify
      mock_id = params[:duckrails_mock_id]
      mock = Duckrails::Mock.find mock_id

      body = mock.dynamic? ? erubify(mock.content) : mock.content

      render body: body, content_type: mock.content_type, status: mock.status
    end

    #########
    protected
    #########

    def reload_routes
      Duckrails::Router.reload
    end

    def mock_params
      params.require(:duckrails_mock).permit(:name,
                                             :description,
                                             :status,
                                             :body_type,
                                             :content,
                                             :method,
                                             :content_type,
                                             :route_path)
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

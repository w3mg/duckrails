module Duckrails
  class Router
    class << self
      def register_mock(mock)
        Duckrails::Application.routes.draw do
          self.send(mock.method, mock.route_path, to: 'duckrails/mocks#mockify', defaults: { duckrails_mock_id: mock.id })
        end
      end

      def register_mocks
        # Since the routes are loaded before
        # even migrating the db, don't try to register if the
        # table doesn't exist.
        #
        # FIXME: this shouldn't be here.
        return unless ActiveRecord::Base.connection.table_exists? Duckrails::Mock.table_name

        Duckrails::Mock.all.each do |mock|
          register_mock mock
        end
      end

      def reload
        Duckrails::Application.routes_reloader.reload!
      end
    end
  end
end

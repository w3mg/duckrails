require 'duckrails/router'


Duckrails::Router.register_current_mocks if ActiveRecord::Base.connection.table_exists? Duckrails::Mock.table_name

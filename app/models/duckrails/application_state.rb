require 'duckrails/synchronizer'
# The application state
module Duckrails
  class ApplicationState < ActiveRecord::Base
    self.table_name = 'application_state'

    default_scope { order(id: :desc) }

    validates_inclusion_of :singleton_guard, in: [0]

    class << self
      def instance
        ApplicationState.first || ApplicationState.create(singleton_guard: 0,
                                                          mock_synchronization_token: Synchronizer.generate_token)
      end
    end
  end
end

require 'duckrails/synchronizer'

module Duckrails
  # The application state
  class ApplicationState < ActiveRecord::Base
    self.table_name = 'application_state'

    default_scope { order(id: :desc) }

    validates_inclusion_of :singleton_guard, in: [0]

    class << self
      # @return [ApplicationState] the one and only application state
      def instance
        ApplicationState.first || ApplicationState.create(singleton_guard: 0,
                                                          mock_synchronization_token: Synchronizer.generate_token)
      end
    end
  end
end

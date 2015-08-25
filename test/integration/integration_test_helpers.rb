module Croesus
  module Test
    module IntegrationTestHelpers
      def json
        JSON.parse(response.body)
      end
    end
  end
end
module Zend::Command
  class Ticket
    class Description < Base
      attr_reader :ticket, :description

      def initialize(id, description)
        @ticket = api.tickets.find(id: id)
        @description = description
        puts(output)
      end

      def output
        desc = "Zendesk ##{ticket.id}: \"#{ticket.subject}\""
        desc << " - #{description}" if description
        desc
      end
    end
  end
end

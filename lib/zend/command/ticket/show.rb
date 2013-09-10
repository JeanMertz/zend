module Zend::Command
  class Ticket
    class Show < Base
      attr_reader :ticket

      def initialize(id)
        @ticket = api.tickets.find(id: id, include: :users)

        puts(table)
        puts(ticket.description)
      end

      def table
        puts Terminal::Table.new(
          style: {
            width: terminal_width,
            padding_left: 3
          },
          rows: tabular_data
        )
      end

      def tabular_data
        rows = Array.new
        rows << [value: col_subject, colspan: 3]
        rows << :separator
        rows << [col_requester, col_created, col_updated]
      end

    private

      def col_subject
        "##{ticket.id}: #{ticket.subject}"
      end

      def col_requester
        "By: #{ticket.requester.name}"
      end

      def col_created
        %Q{Created: #{ticket.created_at.getlocal.strftime("%-d %B, %H:%M")}}
      end

      def col_updated
        %Q{Updated: #{ticket.updated_at.getlocal.strftime("%-d %B, %H:%M")}}
      end
    end
  end
end

module Zend
  module Command
    class Ticket < Base
      attr_reader :ticket

      def initialize(ticket_id)
        @ticket = api.tickets.find(id: ticket_id, include: :users)
      end

      def print
        rows = Array.new
        rows << [value: col_subject, colspan: 3]
        rows << :separator
        rows << [col_requester, col_created, col_updated]

        puts Terminal::Table.new(
          style: {
            width: terminal_width,
            padding_left: 3
          },
          rows: rows
        )

        puts col_description
      end

    private

      def col_subject
        "##{ticket.id}: #{ticket.subject}"
      end

      def col_requester
        "By: #{requester}"
      end

      def col_created
        %Q{Created: #{ticket.created_at.getlocal.strftime("%-d %B, %H:%M")}}
      end

      def col_updated
        %Q{Updated: #{ticket.updated_at.getlocal.strftime("%-d %B, %H:%M")}}
      end

      def col_description
        "\n#{ticket.description}"
        #.scan(/.{1,80}/m).join("\n")
      end

      def requester
        ticket.requester.name
      end

    end
  end
end

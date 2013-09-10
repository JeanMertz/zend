module Zend::Command
  class Ticket
    class List < Base
      attr_reader :new, :open, :pending, :solved, :closed

      def initialize(query, options)
        @query    = query
        @new      = options['new']
        @open     = options['open']
        @pending  = options['pending']
        @solved   = options['solved']
        @closed   = options['closed']

        puts(table)
      end

      def tabular_data
        search_command.fetch.each_with_object([]) do |ticket, arr|
          arr << [ticket.id, col_subject(ticket.subject), ticket.status]
        end
      end

      def search_command
        # require 'pry'
        # binding.pry
        if query_string.strip == 'type:ticket'
          api.tickets.page((api.tickets.count/20).floor).per_page(20)
        else
          api.search(query: query_string)
        end
      end

      def col_subject(subject)
        truncate(subject, terminal_width - 30)
      end

      def col_id(ticket)

      end

      def table
        Terminal::Table.new(
          headings: %w[# Title Status],
          style: {
            width: terminal_width,
            padding_left: 2
          },
          rows: tabular_data
        )
      end

      def all?
        ! [@new, @open, @pending, @solved, @closed].any?
      end

      def query_string
        if is_num?(query)
          query
        else
          ['type:ticket', status, query].join(' ')
        end
      end

      def query
        @query
      end

      def status
        return '' if all?

        status = Array.new
        status << 'new'     if @new
        status << 'open'    if @open
        status << 'pending' if @pending
        status << 'solved'  if @solved
        status << 'closed'  if @closed

        status.map!{ |type| "status:#{type}" }.join(' ')
      end
    end
  end
end

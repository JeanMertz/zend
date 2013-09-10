module Zend
  class CLI < Thor

    desc 'login', 'Starts prompt to login to your Zendesk account'
    def login
      Zend::Auth.login
    end

    desc 'logout', 'Remove credentials from local machine'
    def logout
      Zend::Auth.logout
    end

    class Tickets < Thor
      desc 'show ID', 'Get details of a Zendesk ticket'
      def show(id)
        Zend::Command::Ticket::Show.new(id)
      end
    end
    desc 'tickets SUBCOMMAND ...ARGS', 'manage tickets'
    subcommand 'tickets', CLI::Tickets
  end
end

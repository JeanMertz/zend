module Zend
  class Tickets < Thor
    desc 'tickets list [string]', 'Print list of tickets'
    option :new, aliases: '-n', type: :boolean, desc: 'include new tickets'
    option :open, aliases: '-o', type: :boolean, desc: 'include open tickets'
    option :pending, aliases: '-p', type: :boolean, desc: 'include pending tickets'
    option :solved, aliases: '-s', type: :boolean, desc: 'include solved tickets'
    option :closed, aliases: '-c', type: :boolean, desc: 'include closed tickets'
    option :tags, aliases: '-t', type: :array, desc: 'only list tickets containing these tags'
    def list(query='')
      Zend::Command::Ticket::List.new(query, options)
    end

    desc 'show ID', 'Get details of a Zendesk ticket'
    def show(id)
      Zend::Command::Ticket::Show.new(id)
    end

    desc 'description ID [DESCRIPTION]', 'Get single line ticket description'
    def description(id, description=nil)
      Zend::Command::Ticket::Description.new(id, description)
    end
  end

  class CLI < Thor

    desc 'login', 'Starts prompt to login to your Zendesk account'
    def login
      Zend::Auth.login
    end

    desc 'logout', 'Remove credentials from local machine'
    def logout
      Zend::Auth.logout
    end

    desc 'tickets SUBCOMMAND ...ARGS', 'manage tickets'
    subcommand 'tickets', Tickets
  end
end

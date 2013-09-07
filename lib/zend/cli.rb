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

    desc 'ticket details', 'Get details of a Zendesk ticket'
    def show(ticket_id)
      puts Zend::Command::Ticket.new(ticket_id).print
    end
  end
end

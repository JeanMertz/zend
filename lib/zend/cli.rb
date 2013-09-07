module Zend
  class CLI < Thor

    desc 'login', 'Starts prompt to login to your Zendesk account'
    def login
      Zend::Auth.login
    end
  end
end

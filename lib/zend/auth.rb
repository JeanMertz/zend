require 'zendesk_api'
require 'netrc'
require 'highline/import'

module Zend
  class Auth
    class << self
      def api
        @api ||= ZendeskAPI::Client.new do |config|
          config.url = "https://#{domain}/api/v2"
          config.username = user
          config.password = password
        end
      end

      def login
        delete_credentials
        get_credentials
      end

      def logout
        delete_credentials
      end

      def domain
        "#{get_account}.zendesk.com"
      end

      def user
        get_credentials[0]
      end

      def password
        get_credentials[1]
      end

      def get_account
        @account ||= (env_zend_account || ask_for_account)
      end

      def env_zend_account
        ENV['ZEND_ACCOUNT']
      end

      def verify
        api.users.fetch!
      rescue ZendeskAPI::Error::NetworkError => e
        authentication_failed if e.to_s.include?('401')
      end

      def netrc_path
        default = Netrc.default_path
        encrypted = default + '.gpg'
        if File.exists?(encrypted)
          encrypted
        else
          default
        end
      end

      def netrc
        @netrc ||= begin
          File.exists?(netrc_path) && Netrc.read(netrc_path)
        rescue => error
          if error.message =~ /^Permission bits for/
            perm = File.stat(netrc_path).mode & 0777
            Kernel.abort "Permissions #{perm} for '#{netrc_path}' are too
            open. You should run `chmod 0600 #{netrc_path}` so that your
            credentials are NOT accessible by others."
          else
            raise error
          end
        end
      end

      def get_credentials
        @credentials ||= (read_credentials || ask_for_and_save_credentials)
      end

      def delete_credentials
        if netrc
          netrc.delete(domain)
          netrc.save
        end
        @api, @account, @credentials = nil
      end

      def read_credentials
        netrc[domain] if netrc
      end

      def write_credentials
        FileUtils.mkdir_p(File.dirname(netrc_path))
        FileUtils.touch(netrc_path)
        FileUtils.chmod(0600, netrc_path)
        netrc[domain] = @credentials
        netrc.save
      end

      def ask_for_account
        unless @login_attempts
          say "Enter your Zendesk account (subdomain). Set a ZEND_ACCOUNT environment variable to skip this step.\n\n"
        end

        @account = ask 'Zendesk subdomain: '
      end

      def ask_for_credentials
        say 'Enter your Zendesk credentials.' if env_zend_account

        email = ask 'E-mail address: '
        password = ask_secret 'Password (typing will be hidden): '

        [email, password]
      end

      def ask_for_and_save_credentials
        @credentials = ask_for_credentials
        write_credentials
        verify

        @credentials
      end

      def authentication_failed
        say "Authentication failed.\n\n"
        delete_credentials

        if retry_login?
          get_account
          ask_for_and_save_credentials
        else
          exit 1
        end
      end

      def ask_secret(message)
        HighLine.new.ask(message) do |q|
          q.echo = false
        end
      end

      def retry_login?
        @login_attempts ||= 0
        @login_attempts += 1
        @login_attempts < 3
      end
    end
  end
end

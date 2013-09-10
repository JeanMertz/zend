require 'spec_helper'

module Zend
  describe Auth do
    let(:auth)    { Zend::Auth }
    let(:account) { 'test' }
    let(:user)    { 'user1' }
    let(:pass)    { 'pass1' }
    let(:netrc)   { 'tmp/netrc' }

    before do
      allow(auth).to receive(:say)
      allow(auth).to receive(:verify)
      allow(auth).to receive(:env_zend_account)
      allow(auth).to receive(:ask_for_account).and_return(account)
      allow(auth).to receive(:ask_for_credentials).and_return([user, pass])
      allow(auth).to receive(:netrc_path).and_return(netrc)
    end

    describe '.api' do
      it 'returns an instance of ZendeskAPI::Client' do
        expect(auth.api).to be_instance_of ZendeskAPI::Client
      end

      it 'gets credentials from cached storage' do
        auth.login
        expect(auth).to receive(:user)
        expect(auth).to receive(:password)
        expect(auth).not_to receive(:ask_for_and_save_credentials)
        expect(auth).not_to receive(:write_credentials)
        auth.api
      end
    end

    describe '.login' do
      context 'with stored credentials' do
        let(:user2) { 'user2' }
        let(:pass2) { 'pass2' }

        it 'removes cached credentials' do
          auth.login # old credentials
          allow(auth).to receive(:ask_for_credentials).and_return([user2, pass2])
          auth.login # new credentials
          expect(auth.read_credentials).to eq [user2, pass2]
        end
      end

      context 'without stored credentials' do
        before { allow(auth).to receive(:read_credentials).and_return(nil) }

        it 'asks for account name' do
          expect(auth).to receive(:ask_for_account)
          auth.login
        end

        it 'asks for user credentials' do
          expect(auth).to receive(:ask_for_credentials).and_return([user, pass])
          auth.login
        end

        it 'stores credentials in cache' do
          auth.login
          expect(File.read(netrc)).to include "machine #{account}.zendesk.com"
          expect(File.read(netrc)).to include "login #{user}"
          expect(File.read(netrc)).to include "password #{pass}"
        end

        it 'grants three login attempts' do
          auth.unstub(:verify)
          expect(auth).to receive(:ask_for_credentials).exactly(3).times
          expect{ VCR.use_cassette(:failed_auth) { auth.login } }.to raise_error(SystemExit)
        end
      end
    end

    describe '.logout' do
      before { auth.login }

      it 'removes cached credentials' do
        expect(auth).to receive(:delete_credentials)
        auth.logout
      end
    end
  end
end

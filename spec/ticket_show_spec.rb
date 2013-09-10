require 'spec_helper'

module Zend::Command
  describe Ticket::Show do
    before do
      allow_any_instance_of(Base).to receive(:api).and_return(stubbed_api)
    end

    let(:show) do
      VCR.use_cassette(:ticket_with_user) do
        Ticket::Show.new(1)
      end
    end

    describe '#ticket' do
      it 'returns a Zendesk instance' do
        expect(show.ticket).to be_instance_of ZendeskAPI::Ticket
      end
    end

    describe '#table' do
      it 'returns a Terminal::Table instance' do
        expect(show.table).to be_instance_of Terminal::Table
      end
    end

    describe '#output' do
      it 'prints table-like output' do
        expect(show.output).to include('+--------')
        expect(show.output).to include('--------+')
        expect(show.output).to include(' | ')
      end

      it 'includes ticket id' do
        expect(show.output).to include(show.ticket.id.to_s)
      end

      it 'includes ticket subject' do
        expect(show.output).to include(show.ticket.subject)
      end

      it 'includes ticket requester' do
        expect(show.output).to include(show.ticket.requester.name)
      end

      it 'includes ticket description' do
        expect(show.output).to include(show.ticket.description)
      end
    end
  end
end

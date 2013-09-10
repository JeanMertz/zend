require 'spec_helper'

module Zend::Command
  describe Ticket::Description do
    before do
      allow_any_instance_of(Base).to receive(:api).and_return(stubbed_api)
    end

    let(:ticket) { description.ticket }
    let(:output) { description.output }
    let(:description) do
      VCR.use_cassette(:ticket) do
        Ticket::Description.new(1, comment)
      end
    end

    context 'without added comment' do
      let(:comment) { nil }

      it 'prints ticket description' do
        expect(output).to start_with "Zendesk ##{ticket.id}: "
        expect(output).to end_with "\"#{ticket.subject}\""
      end
    end

    context 'with comments' do
      let(:comment) { 'this is a comment' }

      it 'appends comment to ticket description' do
        expect(output).to end_with " - #{comment}"
      end
    end
  end
end

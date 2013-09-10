require 'spec_helper'

module Zend::Command
  describe Ticket::List do
    before do
      allow_any_instance_of(Base).to receive(:api).and_return(stubbed_api)
    end

    let(:list) do
      Ticket::List.new(query, options)
    end

    context 'without any arguments' do
      let(:last_20_tickets) do
        VCR.use_cassette(:last_20_tickets) do
          list.tabular_data
        end
      end

      let(:query) { nil }
      let(:options) { {} }

      it 'returns 20 last created tickets' do
        expect(last_20_tickets.size).to eq 20
      end

      it 'does not filter ticket status' do
        expect(last_20_tickets.flatten).to include 'open'
        expect(last_20_tickets.flatten).to include 'pending'
        expect(last_20_tickets.flatten).to include 'solved'
      end
    end

    context 'filtered by' do

      context 'text' do
        let(:filtered_tickets) do
          VCR.use_cassette(:tickets_filtered_by_ticket_1_string) do
            list.tabular_data
          end
        end

        let(:query) { '"ticket 1"' }
        let(:options) { {} }

        it 'returns tickets containing "ticket 1" string' do
          expect(filtered_tickets.flatten).to include 'new test ticket 1'
          expect(filtered_tickets.flatten).to include 'open test ticket 1'
        end

        it 'ignores tickets without "ticket 1" string' do
          expect(filtered_tickets.flatten).not_to include 'new test ticket 2'
        end
      end

      context 'open tickets' do
        let(:query) { nil }
        let(:options) { { 'open' => true } }

        let(:open_tickets) do
          VCR.use_cassette(:tickets_open) do
            list.tabular_data.flatten
          end
        end

        it 'returns only open tickets' do
          expect(open_tickets).to include 'open'
          expect(open_tickets).not_to include 'new'
          expect(open_tickets).not_to include 'pending'
          expect(open_tickets).not_to include 'solved'
        end
      end

      context 'pending tickets' do
        let(:query) { nil }
        let(:options) { { 'pending' => true } }

        let(:pending_tickets) do
          VCR.use_cassette(:tickets_pending) do
            list.tabular_data.flatten
          end
        end

        it 'returns only pending tickets' do
          expect(pending_tickets).to include 'pending'
          expect(pending_tickets).not_to include 'new'
          expect(pending_tickets).not_to include 'open'
          expect(pending_tickets).not_to include 'solved'
        end
      end

      context 'solved tickets' do
        let(:query) { nil }
        let(:options) { { 'solved' => true } }

        let(:solved_tickets) do
          VCR.use_cassette(:tickets_solved) do
            list.tabular_data.flatten
          end
        end

        it 'returns only solved tickets' do
          expect(solved_tickets).to include 'solved'
          expect(solved_tickets).not_to include 'new'
          expect(solved_tickets).not_to include 'pending'
          expect(solved_tickets).not_to include 'open'
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => token_generator(user.id) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe '#authorize_request' do
    context 'when auth token is passed' do
      before { allow(request).to receive(:headers).and_return(headers) }

      it 'sets the current user' do
        # rubocop:disable RSpec/NamedSubject
        expect(subject.instance_eval { authorize_request }).to eq(user)
        # rubocop:enable RSpec/NamedSubject
      end
    end

    context 'when auth token is not passed' do
      before { allow(request).to receive(:headers).and_return(invalid_headers) }

      it 'raises MissingToken error' do
        # rubocop:disable RSpec/NamedSubject
        expect { subject.instance_eval { authorize_request } }
          .to raise_error(ExceptionHandler::MissingToken, /Missing token/)
        # rubocop:enable RSpec/NamedSubject
      end
    end
  end
end

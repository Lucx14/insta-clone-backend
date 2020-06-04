require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  subject(:request_obj) { described_class.new(header) }

  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }

  describe '#call' do
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    context 'when invalid request' do
      context 'when missing token' do
        subject(:invalid_request_obj) { described_class.new({}) }

        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::MissingToken)
            .with_message('Missing token')
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) { described_class.new('Authorization' => token_generator(5)) }

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }.to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        subject(:request_obj) { described_class.new(header) }

        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }

        it 'raises ExpiredSignature error' do
          expect { request_obj.call }.to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
        end
      end

      context 'when fake token' do
        subject(:invalid_request_obj) { described_class.new(header) }

        let(:header) { { 'Authorization' => 'invalid' } }

        it 'handles JWT::Decode error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
        end
      end
    end
  end
end

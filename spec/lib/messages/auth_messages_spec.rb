require 'rails_helper'

RSpec.describe Messages::AuthMessages do
  describe '#not found' do
    it 'returns message' do
      expect(described_class.not_found).to eq('Sorry, record not found')
    end
  end

  describe '#unauthorized' do
    it 'returns message' do
      expect(described_class.unauthorized).to eq('Unauthorized request')
    end
  end

  describe '#account_not_created' do
    it 'returns message' do
      expect(described_class.account_not_created).to eq('Account could not be created')
    end
  end

  describe '#expired_token' do
    it 'returns message' do
      expect(described_class.expired_token).to eq('Sorry, your token has expired. Please login to continue.')
    end
  end
end

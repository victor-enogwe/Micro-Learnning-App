require_relative '../../../lib/middlewares/error_middleware.rb'

RSpec.describe ErrorHandler, '#error_json' do
  context 'eooroo' do
    it 'should return an error status' do
      handle_error = ErrorHandler.new
      error = StandardError.new 'some arbitrary app error'
      expect(handle_error.error_json error).to eq 2
    end
  end
end

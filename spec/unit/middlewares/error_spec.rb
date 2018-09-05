# frozen_string_literal: true

RSpec.describe ErrorHandler do
  describe '.error_json' do
    context 'when error' do
      it 'should return an error status' do
        error_message = 'some arbitrary app error'
        error = StandardError.new error_message
        code, content_type, status = described_class.new(app).error_json error
        status = JSON.parse status[0]
        expect(content_type['Content-Type']).to match 'application/json'
        expect(code).to be_between(400, 500)
        expect(status['status']).to match 'error'
        expect(status['message']).to match error_message
      end
    end
  end
end

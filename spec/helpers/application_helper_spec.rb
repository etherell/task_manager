require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#toastr_flash' do
    subject(:set_flash) { toastr_flash(type) }

    let(:type) { 'success' }

    context 'with success type' do
      it 'returns success toastr flash' do
        expect(set_flash).to eq('toastr.success')
      end
    end

    context 'with error type' do
      let(:type) { 'error' }

      it 'returns error toastr flash' do
        expect(set_flash).to eq('toastr.error')
      end
    end

    context 'with other types' do
      let(:type) { 'hello' }

      it 'returns info toastr flash' do
        expect(set_flash).to eq('toastr.info')
      end
    end
  end
end

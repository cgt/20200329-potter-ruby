# frozen_string_literal: true
RSpec.describe 'Sale' do
  context 'with no items' do
    it 'has total 0' do
      empty_sale = Sale.new
      expect(empty_sale.total).to eq 0
    end
  end
end

class Sale
  def total
    0
  end
end
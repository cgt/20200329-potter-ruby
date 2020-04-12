# frozen_string_literal: true
RSpec.describe 'Sale' do
  context 'with no items' do
    it 'has total 0' do
      empty_sale = Sale.new
      expect(empty_sale.total).to eq 0
    end
  end

  context 'with one book' do
    it 'has total 8' do
      sale = Sale.new
      sale.add :first_book
      expect(sale.total).to eq 8
    end
  end

  context 'with two copies of the same book' do
    it 'has total 16' do
      sale = Sale.new
      sale.add :first_book
      sale.add :first_book
      expect(sale.total).to eq 16
    end
  end
end

class Sale
  def initialize
    @items = []
  end

  def add(item)
    @items << item
  end

  def total
    8 * @items.size
  end
end
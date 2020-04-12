# frozen_string_literal: true
RSpec.describe 'Sale' do
  context 'with no items' do
    it 'has total price 0' do
      sale = Sale.new([])
      expect(sale.total).to eq(0)
    end
  end

  context 'with one book' do
    it 'has total price 8' do
      sale = Sale.new(%i[first])
      expect(sale.total).to eq(8)
    end
  end

  context 'with two different books' do
    it 'gets a 5 % discount' do
      sale = Sale.new(%i[first second])
      expect(sale.total).to eq(2 * 8 * 0.95)
    end
  end

  xit 'acceptance test' do
    sale = Sale.new(%i[first second third fourth first second fifth])
    expect(sale.total).to eq(51.2)
  end
end

class Sale
  def initialize(items)
    @items = items
  end

  def total
    total = @items.size * 8
    if @items.size >= 2
      total *= 0.95
    end
    total
  end
end
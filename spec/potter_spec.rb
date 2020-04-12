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

  context 'with two different books' do
    it 'has a 5 % discount' do
      sale = Sale.new
      sale.add :first_book
      sale.add :second_book
      expect(sale.total).to eq 16 * 0.95
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
    total = 8 * @items.size
    total *= 0.95 if eligible_for_5_percent_discount?
    total
  end

  private

  def eligible_for_5_percent_discount?
    (@items.size > 1) && (@items.uniq.size == @items.size)
  end
end
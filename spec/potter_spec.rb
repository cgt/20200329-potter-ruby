# frozen_string_literal: true

RSpec.describe "Sale" do
  PRICE_OF_BOOK = 8

  let(:sale) { Sale.new }

  xit "acceptance test" do
    sale.add :first_book, :second_book, :third_book, :fourth_book
    sale.add :first_book, :second_book, :third_book, :fifth_book
    expect(sale.total).to eq 51.20
  end

  context "with no items" do
    it "has total 0" do
      expect(sale.total).to eq 0
    end
  end

  context "with one book" do
    it "has total 8" do
      sale.add :first_book
      expect(sale.total).to eq PRICE_OF_BOOK
    end
  end

  context "with two copies of the same book" do
    it "has total 16" do
      sale.add :first_book, :first_book
      expect(sale.total).to eq 16
    end
  end

  context "with two different books" do
    it "has a 5 % discount" do
      sale.add :first_book, :second_book
      expect(sale.total).to eq 2 * PRICE_OF_BOOK * 0.95
    end
  end

  context "with three different books" do
    it "has a 10 % discount" do
      sale.add :first_book, :second_book, :third_book
      expect(sale.total).to eq 3 * PRICE_OF_BOOK * 0.90
    end
  end

  context "with one set of two books and one set of one book" do
    it "has a 5 % discount on the set of two and no discount on the set of one" do
      sale.add :first_book, :second_book
      sale.add :first_book
      expect(sale.total).to eq((2 * PRICE_OF_BOOK * 0.95) + 1 * PRICE_OF_BOOK)
    end
  end
end

class Sale
  def initialize
    @items = []
  end

  def add(*items)
    @items.concat items
  end

  def total
    items_as_sets
      .map(&method(:without_nil_elements))
      .map { |set|
        total = 8 * set.size
        if eligible_for_10_percent_discount? set
          total *= 0.90
        elsif eligible_for_5_percent_discount? set
          total *= 0.95
        end
        total
      }
      .inject(0) { |total, set_price| total + set_price }
  end

  private

  def without_nil_elements(items)
    items.select { |x| x }
  end

  def items_as_sets
    return [] if @items.empty?
    sets = @items
      .group_by(&:itself)
      .values
    sets[0].zip(*sets[1..-1])
  end

  def eligible_for_10_percent_discount?(items)
    (items.size > 2) && (items.uniq.size == items.size)
  end

  def eligible_for_5_percent_discount?(items)
    (items.size > 1) && (items.uniq.size == items.size)
  end
end

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
      expect(sale.total).to eq 2 * PRICE_OF_BOOK
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

  context "with one set of four books" do
    it "has a 20 % discount" do
      sale.add :first_book, :second_book, :third_book, :fourth_book
      expect(sale.total).to eq 4 * PRICE_OF_BOOK * 0.80
    end
  end

  context "with one set of five books" do
    it "has 25 % discount" do
      sale.add :first_book, :second_book, :third_book, :fourth_book, :fifth_book
      expect(sale.total).to eq 5 * PRICE_OF_BOOK * 0.75
    end
  end

  context "learning tests" do
    it "groups the basket of items from the acceptance test into a set of five and a set of three" do
      sale.add :first_book, :second_book, :third_book, :fourth_book
      sale.add :first_book, :second_book, :third_book, :fifth_book
      expect(sale.items_as_sets).to eq([
        [:first_book, :second_book, :third_book, :fourth_book, :fifth_book],
        [:first_book, :second_book, :third_book]
      ])
    end

    it "balance sets" do
      sale.add :first_book, :second_book, :third_book, :fourth_book
      sale.add :first_book, :second_book, :third_book, :fifth_book

      sets_by_size = sale.items_as_sets.group_by { |set| set.size }
      expect(sets_by_size).to eq({
        5 => [[:first_book, :second_book, :third_book, :fourth_book, :fifth_book]],
        3 => [[:first_book, :second_book, :third_book]]
      })

      expect(sets_by_size.size).to eq 2
      sets_hi_to_lo = sets_by_size.keys.sort.reverse
      most = sets_by_size[sets_hi_to_lo[0]][0]
      expect(most.size).to eq 5
      fewest = sets_by_size[sets_hi_to_lo[-1]][0]
      expect(fewest.size).to eq 3

      fewest << most.pop
      expect(most.size).to eq 4
      expect(fewest.size).to eq 4
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
    sets = items_as_sets
    sets
      .map(&method(:set_total))
      .inject(0) { |total, set_price| total + set_price }
  end

  def without_nil_elements(items)
    items.select { |x| x }
  end

  def items_as_sets
    return [] if @items.empty?
    sets = @items
      .group_by(&:itself)
      .values
    items_as_sets_value = sets[0].zip(*sets[1..-1])
    items_as_sets_value.map(&method(:without_nil_elements))
  end

  def eligible_for_25_percent_discount?(set)
    set.size >= 5
  end

  def eligible_for_20_percent_discount?(set)
    set.size >= 4
  end

  def eligible_for_10_percent_discount?(set)
    set.size >= 3
  end

  def eligible_for_5_percent_discount?(set)
    set.size >= 2
  end

  def set_total(set)
    8 * set.size * set_discount(set)
  end

  def set_discount(set)
    if eligible_for_25_percent_discount? set
      0.75
    elsif eligible_for_20_percent_discount? set
      0.80
    elsif eligible_for_10_percent_discount? set
      0.90
    elsif eligible_for_5_percent_discount? set
      0.95
    else
      1.00
    end
  end
end

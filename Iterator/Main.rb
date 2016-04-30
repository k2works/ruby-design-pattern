require 'minitest/autorun'

class ArrayIterator
  def initialize(array)
    @array = array
    @index = 0
  end

  def has_next?
    @index < @array.length
  end

  def item
    @array[@index]
  end

  def next_item
    value = @array[@index]
    @index += 1
    value
  end

  def for_each_element(array)
    i = 0
    while i < array.length
      yield(array[i])
      i += 1
    end
  end

  def merge(array1, array2)
    merged = []

    iterator1 = ArrayIterator.new(array1)
    iterator2 = ArrayIterator.new(array2)

    while( iterator1.has_next? and iterator2.has_next? )
      if iterator1.item < iterator2.item
        merged << iterator1.next_item
      else
        merged << iterator2.next_item
      end
    end

    # array1から残りを取り出す

    while( iterator1.has_next?)
      merged << iterator1.next_item
    end

    # array2から残りを取り出す

    while( iterator2.has_next?)
      merged << iterator2.next_item
    end

    merged
  end

  def change_resistant_for_each_element(array)
    copy = Array.new(array)
    i = 0
    while i < copy.length
      yield(copy[i])
      i += 1
    end
  end
end

class Account
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=>(other)
    balance <=> other.balance
  end
end

class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def add_account(account)
    @accounts << account
  end
end

describe ArrayIterator do
  #配列の内容を順番に出力する
  it "should output of array's content." do
    array_in = ['red', 'green', 'blue']
    array_out = []
    i = ArrayIterator.new(array_in)
    while i.has_next?
      array_out << i.next_item
    end
    array_out.must_equal array_in
  end

  #文字列を分割して出力する
  it "should output array's character split." do
    i = ArrayIterator.new('abc')
    array_out = []
    while i.has_next?
      array_out << i.next_item.chr
    end
    array_out.must_equal ['a','b','c']
  end

  #コードブロックで配列の内容を順番に出力する
  it "should output of array's content by code block." do
    a_in = [10, 20, 30]
    a_out = <<-EOS
10
20
30
EOS
    i = ArrayIterator.new(a_in)
    proc {i.for_each_element(a_in) {|element| puts element}}.must_output a_out
  end

  #eachメソッドを使ってコードブロックで配列の内容を順番に出力する
  it "should output of array's content by code block with each method." do
    a_in = [10, 20, 30]
    a_out = <<-EOS
10
20
30
    EOS
    proc {a_in.each {|element| puts element}}.must_output a_out
  end

  #二つの配列をマージする
  it "should be merged two array's." do
    array1 = [1,2,3]
    array2 = [3,4,5]
    i = ArrayIterator.new(Array.new)
    i.merge(array1,array2).must_equal [1,2,3,3,4,5]
  end

  #eachメソッドを使ってコードブロックで安全に配列の内容を順番に出力する
  it "should output of array's content safely by code block with each method." do
    a_in = ['red', 'green', 'blue', 'purple']
    a_out = <<-EOS
red
blue
purple
    EOS
    i = ArrayIterator.new(a_in)
    a_in.delete('green')
    proc { i.change_resistant_for_each_element(a_in) do |element|
      puts(element)
      if element == 'green'
        element.delete(element)
      end
    end }.must_output a_out
  end
end

describe Portfolio do
  before(:each) do
    @portfolio = Portfolio.new
  end

  #ポートフォリの口座に$2000より多くの残高ある
  it "should have account which over 2000." do
    @portfolio.add_account(Account.new('Tom',1000))
    @portfolio.add_account(Account.new('Jerry',2001))
    @portfolio.any? {|account| account.balance > 2000}.must_equal true
  end

  #すべての口座の残高が$10以上ある
  it "should have all accounts which over 10." do
    @portfolio.add_account(Account.new('Tom',10))
    @portfolio.add_account(Account.new('Jerry',10))
    @portfolio.all? {|account| account.balance >= 10}.must_equal true
  end

end
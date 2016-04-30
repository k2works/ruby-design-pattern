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
end
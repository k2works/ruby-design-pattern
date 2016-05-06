require 'minitest/autorun'

class ClassVariableTester
  @@class_count = 0

  def initialize
    @instance_count = 0
  end

  def increment
    @@class_count = @@class_count + 1
    @instance_count = @instance_count + 1
  end

  def to_s
    "class_count: #{@@class_count} instance_count: #{@instance_count}"
  end
end

class SomeClass
  def self.class_level_method
    puts('hello from the class method')
  end

  def SomeClass.class_level_method2
    puts('hello from the class method2')
  end
end

describe ClassVariableTester do
  # １つ目のインスタンスは同じ値を持つ
  it 'should have same value.' do
    c1 = ClassVariableTester.new
    c1.increment
    c1.increment
    proc{puts("c1: #{c1}")}.must_output "c1: class_count: 2 instance_count: 2\n"
  end

  # ２つ目のインスタンスは異なる値を持つ
  it 'should not same value.' do
    c1 = ClassVariableTester.new
    c1.increment
    c1.increment
    c2 = ClassVariableTester.new
    proc{puts("c2: #{c2}")}.must_output "c2: class_count: 4 instance_count: 0\n"
  end
end

describe SomeClass do
  # クラスメソッドはselfで定義できる
  it 'should define class method start with self.' do
    proc{SomeClass.class_level_method}.must_output "hello from the class method\n"
  end

  # クラスメソッドはクラス名で定義できる
  it 'should define class method start with class name.' do
    proc{SomeClass.class_level_method2}.must_output "hello from the class method2\n"
  end

end
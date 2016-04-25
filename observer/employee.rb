require 'minitest/autorun'

class Employee
  attr_reader :name
  attr_accessor :ttile, :salary

  def initialize( name, title, salary )
    @name = name
    @title = title
    @salary = salary
  end
end

describe Employee do
  # フレッドの給料が昇給している
  it 'should raise fred salary.' do
    fred = Employee.new("Fred Flintstone", "Crane Operator", 30000.0)
    fred.salary.must_equal 30000.0
  end
end


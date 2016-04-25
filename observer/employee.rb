require 'minitest/autorun'

class Payroll
  def update( changed_employee )
    puts("#{changed_employee.name}のために小切手を切ります！")
    puts("彼の給料はいま#{changed_employee.salary}です！")
  end
end

class TaxMan
  def update( changed_employee )
    puts("#{changed_employee.name}に新しい税金の請求書を送ります！")
  end
end

require 'observer'
class Employee
  include Observable

  attr_reader :name, :address
  attr_accessor :ttile, :salary

  def initialize( name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end
end


describe Payroll do
  # 経理部門はFredの賃金の変更を知ることができる
  it "should know the change of fred's salary." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )

    output = <<-EOS
Fredのために小切手を切ります！
彼の給料はいま35000です！
    EOS

    proc {fred.salary = 35000}.must_output output
  end
end

describe TaxMan do
  # 税務署員はFredの賃金の変更を知ることができる
  it "should know then change of fred's salary." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    tax_man = TaxMan.new
    fred.add_observer( tax_man )

    output = <<-EOS
Fredに新しい税金の請求書を送ります！
    EOS

    proc {fred.salary = 35000}.must_output output
  end
end


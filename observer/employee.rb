require 'minitest/autorun'

class Payroll
  def update( changed_employee )
    puts("#{changed_employee.name}のために小切手を切ります！")
    puts("彼の給料はいま#{changed_employee.salary}です！")
  end
end

class Employee
  attr_reader :name
  attr_accessor :ttile, :salary

  def initialize( name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
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


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
  attr_accessor :title, :salary

  def initialize( name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    old_salary = @salary
    @salary = new_salary
    if old_salary != new_salary
      changed
      notify_observers(self)
    end
  end

  def title=(new_title)
    old_title = @title
    @title = new_title
    if old_title != new_title
      changed = true
      notify_observers(self)
    end
  end
end

describe Employee do
  # 給与が変更されたら通知する
  it "should notify whne salary changed." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )

    proc {fred.salary = 35000}.wont_be_nil
  end
  # 肩書きが変更されたら通知する
  it "should notify when title changed." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )

    proc {fred.title = 'Vice President of Sales'}.wont_be_nil
  end
  # 同じ給与で更新した場合は通知しない
  it "should not notify change of fred's salary when it is same salary." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )

    proc {fred.salary = 30000}.must_output nil
  end
  # 同じ肩書きで更新した場合は通知しない
  it "should not notify change of fred's title when it is same title." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )

    proc {fred.title = 'Crane Operator'}.must_output nil
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


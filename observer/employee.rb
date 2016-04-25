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
    @title_changed = false
    @salary_changed = false
  end

  def salary=(new_salary)
    old_salary = @salary
    @salary = new_salary
    if old_salary != new_salary
      @salary_changed = true
    else
      @salary_changed = false
    end
  end

  def title=(new_title)
    old_title = @title
    @title = new_title
    if old_title != new_title
      @title_changed = true
    else
      @title_changed = false
    end
  end

  def changes_complete
    if @salary_changed == true
      if @title_changed == true
        changed
        notify_observers(self)
        return true
      end
    end
    if @salary_changed == true
      if @title_changed == false
        return check_salary_title_table
      end
    end
    if @salary_changed == false
      if @title_changed == true
        return check_salary_title_table
      end
    end
  end

  private
  def check_salary_title_table
    case @title
      when 'Crane Operator'
        if @salary <= 50000
          changed
          notify_observers(self)
          true
        end
      when 'Vice President of Sales'
        if @salary > 50000
          changed
          notify_observers(self)
          true
        end
      else
        false
    end
  end
end

describe Employee do
  # 給与が変更されたら通知する
  it "should notify when salary changed." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )
    fred.salary = 35000

    fred.changes_complete.must_equal true
  end
  # 肩書きが変更されたら通知する
  it "should notify when title changed." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )
    fred.salary = 50001
    fred.title = 'Vice President of Sales'

    fred.changes_complete.must_equal true
  end
  # 同じ給与で更新した場合は通知しない
  it "should not notify change of fred's salary when it is same salary." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )
    fred.salary = 30000

    proc { fred.changes_complete }.must_output ''
  end
  # 同じ肩書きで更新した場合は通知しない
  it "should not notify change of fred's title when it is same title." do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )
    fred.title = 'Crane Operator'

    proc { fred.changes_complete }.must_output ''
  end
  # 肩書きと一貫性のない更新は通知しない
  it "should not notify change which is inconsistent fred's title" do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )
    fred.salary = 1000000

    proc { fred.changes_complete }.must_output ''
  end
  # 肩書きと一貫性のある更新は通知する
  it "should notify change which is consistent in fred's title" do
    fred = Employee.new('Fred','Crane Operator', 30000)

    payroll = Payroll.new
    fred.add_observer( payroll )
    fred.title = 'Vice President of Sales'
    fred.salary = 1000000

    proc { fred.changes_complete }.wont_be_nil
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
    fred.salary = 35000
    proc { fred.changes_complete }.must_output output
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
    fred.salary = 35000
    proc { fred.changes_complete }.must_output output
  end
end


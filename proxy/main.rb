require 'minitest/autorun'

class BankAccount
  attr_reader :balance

  def initialize(starting_balance=0)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

class BankAccountProxy
  def initialize(real_object)
    @real_object = real_object
  end

  def balance
    @real_object.balance
  end

  def deposit(amount)
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    @real_object.withdraw(amount)
  end
end

require 'etc'

class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @subject = real_account
    @owner_name = owner_name
  end

  def deposit(amount)
    check_access
    return @subject.deposit(amount)
  end

  def withdraw(amount)
    check_access
    return @subject.withdraw(amount)
  end

  def balance
    check_access
    return @subject.balance
  end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account."
    end
  end
end

describe BankAccount do
  # 銀行口座の残高は140になる
  it 'should be 140.' do
    account = BankAccount.new(100)
    account.deposit(50)
    account.withdraw(10)
    account.balance.must_equal 140
  end
end

describe BankAccountProxy do
  # 銀行口座の残高は140になる
  it 'should be 140.' do
    account = BankAccount.new(100)
    account = BankAccountProxy.new(account)
    account.deposit(50)
    account.withdraw(10)
    account.balance.must_equal 140
  end
end

describe AccountProtectionProxy do
  # 許可されていないユーザーは口座にアクセスできない
  it 'should protect access from illegal access.' do
    account = BankAccount.new(100)
    account = AccountProtectionProxy.new(account,'Illegal User')
    proc{account.deposit(50)}.must_raise RuntimeError
  end
end
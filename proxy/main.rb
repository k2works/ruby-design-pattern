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
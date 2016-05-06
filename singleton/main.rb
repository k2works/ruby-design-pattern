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

class SimpleLogger
  attr_accessor :level

  ERROR = 1
  WARNING = 2
  INFO = 3

  def initialize
    @log = File.open("log.txt", "w")
    @level = WARNING
  end

  def error(msg)
    @log.puts(msg)
    @log.flush
  end

  def warning(msg)
    @log.puts(msg) if @level >= WARNING
    @log.flush
  end

  def info(msg)
    @log.puts(msg) if @level >= INFO
    @log.flush
  end

  @@instance = SimpleLogger.new

  def self.instance
    return @@instance
  end

  private_class_method :new
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

describe SimpleLogger do
  # 全く同じロガーオブジェクトが返される
  it 'should same logger object.' do
    logger1 = SimpleLogger.instance
    logger2 = SimpleLogger.instance

    logger2.must_be_same_as logger1
  end

  # INFOレベルでログを保存する
  it 'should output logs with info level.' do
    SimpleLogger.instance.level= SimpleLogger::INFO
    SimpleLogger.instance.info('コンピュータがチェスゲームに勝ちました。')
    file = File.open('log.txt')
    file.readlines.must_include "コンピュータがチェスゲームに勝ちました。\n"
    file.close
  end

  # WARNINGレベルでログを保存する
  it 'should output logs with warning level.' do
    SimpleLogger.instance.level= SimpleLogger::WARNING
    SimpleLogger.instance.warning('ユニットAE-35の故障が予測されました。')
    file = File.open('log.txt')
    file.readlines.must_include "ユニットAE-35の故障が予測されました。\n"
    file.close
  end

  # ERRORレベルでログを保存する
  it 'should output logs with error level.' do
    SimpleLogger.instance.error('HAL-9000 機能停止、緊急動作を実行します！')
    file = File.open('log.txt')
    file.readlines.must_include "HAL-9000 機能停止、緊急動作を実行します！\n"
    file.close
  end
end
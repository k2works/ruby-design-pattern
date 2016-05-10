require 'minitest/autorun'
require 'find'

class Expression
  # 一般的な式のコードはここに追加されます・・・
end

class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end

class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if(File.size(p) > @size)
    end
    results
  end
end

class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if( File.writable?(p) )
    end
    results
  end
end

describe All do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    all = All.new
    results = all.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe FileName do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    files = FileName.new('test.*')
    results = files.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe Bigger do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    files = Bigger.new(100)
    results = files.evaluate('./test_dir')
    results.wont_be_empty
  end
end

describe Writable do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    files = Writable.new
    results = files.evaluate('./test_dir')
    results.wont_be_empty
  end
end
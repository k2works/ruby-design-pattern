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
    file = FileName.new('test.*')
    results = file.evaluate('./test_dir')
    results.wont_be_empty
  end
end
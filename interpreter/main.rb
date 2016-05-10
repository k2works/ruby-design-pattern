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

class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

class Or < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 + result2).sort.uniq
  end
end

class And < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 & result2).sort.uniq
  end
end

class Parser
  def initialize(text)
    @tokens = text.scan(/\(|\)|[\w\.\*]+/)
  end

  def next_token
    @tokens.shift
  end

  def expression
    token = next_token

    if token == nil
      return nil

    elsif token == '('
      result = expression
      raise 'Expected )' unless next_token == ')'
      result

    elsif token == 'all'
      return All.new

    elsif token == 'writable'
      return Writable.new

    elsif token == 'bigger'
      return Bigger.new(next_token.to_i)

    elsif token == 'filename'
      return FileName.new(next_token)

    elsif token == 'not'
      return Not.new(expression)

    elsif token == 'and'
      return And.new(expression, expression)

    elsif token == 'or'
      return Or.new(expression, expression)

    else
      raise "Unxepected token: #{token}"
    end
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

describe Not do
  # テストディレクリにファイルが存在しない
  it 'should not be exist file in directory.' do
    expr_not_writable = Not.new(Writable.new)
    readonly_files = expr_not_writable.evaluate('./test_dir')
    readonly_files.must_be_empty
  end

  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    expr_not_writable = Not.new(Bigger.new(100))
    readonly_files = expr_not_writable.evaluate('./test_dir')
    readonly_files.wont_be_empty
  end

  # テストディレクリにファイルが存在しない
  it 'should not be exist file in directory.' do
    expr_not_writable = Not.new(FileName.new('*.txt'))
    readonly_files = expr_not_writable.evaluate('./test_dir')
    readonly_files.must_be_empty
  end
end

describe Or do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    big_or_txt_expr = Or.new(Bigger.new(1000), FileName.new('*.txt'))
    big_or_txt = big_or_txt_expr.evaluate('./test_dir')
    big_or_txt.wont_be_empty
  end
end

describe And do
  # テストディレクリにファイルが存在しない
  it 'should not be exist file in directory.' do
    complex_expression = And.new(
                                And.new(Bigger.new(0),
                                        FileName.new('*.txt')),
                                Not.new(Writable.new))
    complex_expression.evaluate('./test_dir').must_be_empty
  end
end

describe Parser do
  # テストディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    parser = Parser.new "and (and(bigger 10) (filename *.txt)) writable"
    ast = parser.expression
    ast.evaluate('./test_dir').wont_be_empty
  end
end
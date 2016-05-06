require 'minitest/autorun'

class SimpleWriter
  def initialize(path)
    @file = File.open(path,'w')
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end

class WriterDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
  end
end

class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

class CheckSummingWriter < WriterDecorator
  attr_reader :check_sum

  def initialize(real_writer)
    @real_writer = real_writer
    @check_sum = 0
  end

  def write_line(line)
    line.each_byte { |byte| @check_sum = (@check_sum + byte) % 256 }
    @check_sum += "\n".ord % 256
    @real_writer.write_line(line)
  end
end

class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new}: #{line}")
  end
end

describe NumberingWriter do
  # 行番号付きで出力される
  it 'should output with line number.' do
    input = 'Hello out there'
    output =<<-EOS
1: Hello out there
    EOS
    writer = NumberingWriter.new(SimpleWriter.new('final.txt'))
    writer.write_line(input)
    writer.close
    file = File.open('final.txt')
    proc{puts file.read}.must_output output
    file.close
  end
end

describe CheckSummingWriter do
  # タイムスタンプ付きで出力される
  it 'should output with time stamp.' do
    input = 'Hello out there'
    output =<<-EOS
1: #{Time.new}: Hello out there
    EOS
    writer = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('final2.txt'))))
    writer.write_line(input)
    writer.close
    file = File.open('final2.txt')
    proc{puts file.read}.must_output output
    file.close
  end

  # チェックサムが生成される
  it 'should generate checksum.' do
    input = 'Hello out there'
    output =<<-EOS
1: #{Time.new}: Hello out there
    EOS
    writer = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new('final2.txt'))))
    writer.write_line(input)
    writer.close
    writer.check_sum.must_be_kind_of Fixnum
  end
end
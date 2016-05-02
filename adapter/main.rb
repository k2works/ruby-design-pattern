require 'minitest/autorun'

class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      encrypted_char = reader.getbyte ^ @key.getbyte(key_index)
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getbyte
    raise EOFError if @position >= @string.length

    ch = @string.getbyte(@position)
    @position += 1
    ch
  end

  def eof?
    return @position >= @string.length
  end
end

describe Encrypter do
  before(:each) do
    @encrypter = Encrypter.new('my seret key')
  end

  # 入力ファイルが暗号化される
  it 'should encrypt input file.' do
    reader = File.open('message.txt')
    writer = File.open('message.encrypted','w')
    @encrypter.encrypt(reader,writer)
    reader.wont_equal writer
  end
end

describe StringIOAdapter do
  before(:each) do
    @string_io_adapter = StringIOAdapter.new('We attack at dawn')
  end

  # ファイルではなく文字列を暗号化する
  it 'should not encrypt fle but string array.' do
    encrypter = Encrypter.new('XYZZY')
    reader = @string_io_adapter
    writer = File.open('out.txt','w')
    encrypter.encrypt(reader,writer)
    reader.wont_equal writer
  end
end
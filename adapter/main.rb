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

class Renderer
  def render(text_object)
    text = text_object.text
    size = text_object.size_inches
    color = text_object.color

    # 文字列を表示します・・・
    puts "text:#{text}"
    puts "size:#{size}"
    puts "color:#{color}"
  end
end

class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end

class BritishTextObject
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end

class BritishTextObjectAdapter < TextObject
  def initialize(bto)
    @bto = bto
  end

  def text
    return @bto.string
  end

  def size_inches
    return @bto.size_mm / 25.4
  end

  def color
    return @bto.colour
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

describe Renderer do
  before(:each) do
    @render = Renderer.new
  end

  # TextObjectの内容が出力される
  it 'should output contents of TextObject.' do
    output =<<EOS
text:Hoge
size:25.4
color:Blue
EOS
    text_object = TextObject.new('Hoge',25.4,'Blue')
    proc{@render.render(text_object)}.must_output output
  end

  # BritishTextObjectの内容が出力される
  it 'should output contents of BritishTextObject.' do
    output =<<EOS
text:Hoge
size:1.0
color:Blue
EOS
    text_object = BritishTextObjectAdapter.new(BritishTextObject.new('Hoge',25.4,'Blue'))
    proc{@render.render(text_object)}.must_output output
  end

  # BritishTextObjectの内容が出力される
  it 'should output contents of BritishTextObject.' do
    output =<<EOS
text:Hoge
size:1.0
color:Blue
EOS

    class BritishTextObject
      def color
        return colour
      end

      def text
        return string
      end

      def size_inches
        return size_mm / 25.4
      end
    end

    text_object = BritishTextObject.new('Hoge',25.4,'Blue')
    proc{@render.render(text_object)}.must_output output
  end
end
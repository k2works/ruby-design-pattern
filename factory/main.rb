require 'minitest/autorun'

class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts("アヒル#{@name}は食事中です。")
  end

  def speak
    puts("アヒル#{@name}がガーガー鳴いています。")
  end

  def sleep
    puts("アヒル#{@name}は静かに眠っています。")
  end
end

class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts("カエル#{@name}は食事中です。")
  end

  def speak
    puts("カエル#{@name}はゲロゲロと鳴いています。")
  end

  def sleep
    puts("カエル#{@name}は眠りません。一晩中ゲロゲロ鳴いています。")
  end
end

class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end
  end

  def simulate_one_day
    @animals.each {|animal| animal.speak}
    @animals.each {|animal| animal.eat}
    @animals.each {|animal| animal.sleep}
  end
end

class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end

describe Pond do
  # 池には３匹のアヒルがいる
  it 'should be three ducks.' do
    output =<<EOS
アヒル動物0がガーガー鳴いています。
アヒル動物1がガーガー鳴いています。
アヒル動物2がガーガー鳴いています。
アヒル動物0は食事中です。
アヒル動物1は食事中です。
アヒル動物2は食事中です。
アヒル動物0は静かに眠っています。
アヒル動物1は静かに眠っています。
アヒル動物2は静かに眠っています。
EOS
    pond = DuckPond.new(3)
    proc{pond.simulate_one_day}.must_output output
  end

  # 池には３匹のカエルがいる
  it 'should be three frogs.' do
    output =<<EOS
カエル動物0はゲロゲロと鳴いています。
カエル動物1はゲロゲロと鳴いています。
カエル動物2はゲロゲロと鳴いています。
カエル動物0は食事中です。
カエル動物1は食事中です。
カエル動物2は食事中です。
カエル動物0は眠りません。一晩中ゲロゲロ鳴いています。
カエル動物1は眠りません。一晩中ゲロゲロ鳴いています。
カエル動物2は眠りません。一晩中ゲロゲロ鳴いています。
EOS
    pond = FrogPond.new(3)
    proc{pond.simulate_one_day}.must_output output
  end
end
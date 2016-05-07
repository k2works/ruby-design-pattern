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

class Pond
  def initialize(number_ducks)
    @ducks = []
    number_ducks.times do |i|
      duck = Duck.new("アヒル#{i}")
      @ducks << duck
    end
  end

  def simulate_one_day
    @ducks.each {|duck| duck.speak}
    @ducks.each {|duck| duck.eat}
    @ducks.each {|duck| duck.sleep}
  end
end

describe Pond do
  # 池には３匹のアヒルがいる
  it 'should be three duck.' do
    output =<<EOS
アヒルアヒル0がガーガー鳴いています。
アヒルアヒル1がガーガー鳴いています。
アヒルアヒル2がガーガー鳴いています。
アヒルアヒル0は食事中です。
アヒルアヒル1は食事中です。
アヒルアヒル2は食事中です。
アヒルアヒル0は静かに眠っています。
アヒルアヒル1は静かに眠っています。
アヒルアヒル2は静かに眠っています。
EOS
    pond = Pond.new(3)
    proc{pond.simulate_one_day}.must_output output
  end
end
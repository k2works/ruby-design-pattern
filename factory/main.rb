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

class Algae
  def initialize(name)
    @name = name
  end

  def grow
    puts("藻#{@name}は日光を浴びて育ちます。")
  end
end

class WaterLily
  def initialize(name)
    @name = name
  end

  def grow
    puts("スイレン#{@name}は浮きながら日光を浴びて育ちます。")
  end
end

class Pond
  def initialize(number_animals, number_plants)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = new_plant("植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each {|plant| plant.grow} unless @plants[0].nil?
    @animals.each {|animal| animal.speak}
    @animals.each {|animal| animal.eat}
    @animals.each {|animal| animal.sleep}
  end
end

class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
  end
end

class DuckWaterLilyPond < Pond
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end

class FrogAlgaePond < Pond
  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
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
    pond = DuckPond.new(3,0)
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
    pond = FrogPond.new(3,0)
    proc{pond.simulate_one_day}.must_output output
  end

  # 池には３匹のアヒルと１つのスイレンがいる
  it 'should be three ducks and a waterlily.' do
    output =<<EOS
スイレン植物0は浮きながら日光を浴びて育ちます。
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
    pond = DuckWaterLilyPond.new(3,1)
    proc{pond.simulate_one_day}.must_output output
  end

  # 池には３匹のカエルと１つの藻がいる
  it 'should be three frogs and a algae.' do
    output =<<EOS
藻植物0は日光を浴びて育ちます。
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
    pond = FrogAlgaePond.new(3,1)
    proc{pond.simulate_one_day}.must_output output
  end

end
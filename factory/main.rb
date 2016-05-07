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

class Tree
  def initialize(name)
    @name = name
  end

  def grow
    puts("樹木#{@name}が高く育っています。")
  end
end

class Tiger
  def initialize(name)
    @name = name
  end

  def eat
    puts("トラ#{@name}は食べたいものを何でも食べます。")
  end

  def speak
    puts("トラ#{@name}はガオーとほえています。")
  end

  def sleep
    puts("トラ#{@name}は眠くなったら眠ります。")
  end
end

class Pond
  def initialize(number_animals, animal_class,
                 number_plants, plant_class)
    @animal_class = animal_class
    @plant_class = plant_class

    @animals = []
    number_animals.times do |i|
      animal = new_organism(:animal,"動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = new_organism(:plant,"植物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each {|plant| plant.grow} unless @plants[0].nil?
    @animals.each {|animal| animal.speak}
    @animals.each {|animal| animal.eat}
    @animals.each {|animal| animal.sleep}
  end

  def new_organism(type, name)
    if type == :animal
      @animal_class.new(name)
    elsif type == :plant
      @plant_class.new(name)
    else
      raise "Unknow organism type: #{type}"
    end
  end
end

class Habitat < Pond
  def initialize(number_animals, number_plants, organism_factory)
    @organism_factory = organism_factory

    @animals = []
    number_animals.times do |i|
      animal = @organism_factory.new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = @organism_factory.new_plant("植物#{i}")
      @plants << plant
    end
  end
end

class DuckPond < Pond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

class FrogPond < Pond
  def new_organism(type, name)
    if type == :animal
      Frog.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

class DuckWaterLilyPond < Pond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    elsif type == :plant
      WaterLily.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

class FrogAlgaePond < Pond
  def new_organism(type, name)
    if type == :animal
      Frog.new(name)
    elsif type == :plant
      Algae.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

class PondOrganismFactory
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end

class JungleOrganismFactory
  def new_animal(name)
    Tiger.new(name)
  end

  def new_plant(name)
    Tree.new(name)
  end
end

class OrganismFactory
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class = animal_class
  end

  def new_animal(name)
    @animal_class.new(name)
  end

  def new_plant(name)
    @plant_class.new(name)
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
    pond = DuckPond.new(3,Duck,0,nil)
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
    pond = FrogPond.new(3,Frog,0,nil)
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
    pond = DuckWaterLilyPond.new(3,Duck,1,WaterLily)
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
    pond = FrogAlgaePond.new(3,Frog,1,Algae)
    proc{pond.simulate_one_day}.must_output output
  end

end

describe Habitat do
  # 生息環境には１匹のトラと４本の木がいる
  it 'should be a tiger and four trees.' do
    output =<<EOS
樹木植物0が高く育っています。
樹木植物1が高く育っています。
樹木植物2が高く育っています。
樹木植物3が高く育っています。
トラ動物0はガオーとほえています。
トラ動物0は食べたいものを何でも食べます。
トラ動物0は眠くなったら眠ります。
EOS
    jungle_organism_factory = OrganismFactory.new(Tree,Tiger)
    habitat = Habitat.new(1,4,jungle_organism_factory)
    proc{habitat.simulate_one_day}.must_output output
  end

  # 生息環境には２匹のアヒルと４つのスイレンがいる
  it 'should be two ducks and four waterlilies.' do
    output =<<EOS
スイレン植物0は浮きながら日光を浴びて育ちます。
スイレン植物1は浮きながら日光を浴びて育ちます。
スイレン植物2は浮きながら日光を浴びて育ちます。
スイレン植物3は浮きながら日光を浴びて育ちます。
アヒル動物0がガーガー鳴いています。
アヒル動物1がガーガー鳴いています。
アヒル動物0は食事中です。
アヒル動物1は食事中です。
アヒル動物0は静かに眠っています。
アヒル動物1は静かに眠っています。
EOS
    pond_organism_factory = OrganismFactory.new(WaterLily,Duck)
    habitat = Habitat.new(2,4,pond_organism_factory)
    proc{habitat.simulate_one_day}.must_output output
  end
end
require 'minitest/autorun'

class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end

class AddDryIngredientsTask < Task

  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0 # 小麦粉と砂糖を加えるのに１分
  end
end

class AddLiquidsTask < Task
  def initialize
    super('Add Liquids')
  end

  def get_time_required
    1.0 # 水を加えるのに１分
  end
end

class MixTask < Task

  def initialize
    super('Mix that batter up!')
  end

  def get_time_required
    3.0 # 混ぜるのに３分
  end
end

class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end
  def <<(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    time=0.0
    @sub_tasks.each {|task| time += task.get_time_required}
    time
  end

  def [](index)
    @sub_tasks[index]
  end

  def []=(index, new_value)
    @sub_tasks[index] = new_value
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    @sub_tasks << AddDryIngredientsTask.new
    @sub_tasks << AddLiquidsTask.new
    @sub_tasks << MixTask.new
  end
end

class FillPanTask < Task

  def initialize
    super('Fill pan')
  end

  def get_time_required
    1.0
  end
end

class BakeTask < Task

  def initialize
    super('Bake')
  end

  def get_time_required
    10.0
  end
end

class FrostTask < Task

  def initialize
    super('Frost')
  end

  def get_time_required
    5.0
  end
end

class LickSpoonTask < Task

  def initialize
    super('Lick spoon')
  end

  def get_time_required
    1.0
  end
end

class MakeCakeTask < CompositeTask
  def initialize
    super('Make cake')
    @sub_tasks << MakeBatterTask.new
    @sub_tasks << FillPanTask.new
    @sub_tasks << BakeTask.new
    @sub_tasks << FrostTask.new
    @sub_tasks << LickSpoonTask.new
  end
end

describe MakeBatterTask do
  # バターを作るのに５分かかる
  it 'should take 5 minutes. ' do
    batter = MakeBatterTask.new
    batter.get_time_required.must_equal 5.0
  end
end

describe MakeCakeTask do
  before(:each) do
    @cake = MakeCakeTask.new
  end

  # ケーキを焼くのに２２分かかる
  it 'should take 22 minutes.' do
    @cake.get_time_required.must_equal 22.0
  end
  # ケーキを焼く工程のバターを作る工程の中の混ぜる工程の時間は３分である
  it 'should 3 minutes of mix task which is in making batter in making cake task.' do
    @cake[0][2].get_time_required.must_equal 3.0
  end
  # 冷凍工程の後に再度焼く工程を追加する
  it 'should be added bake task after frost task.' do
    @cake[5] = @cake[4]
    @cake[4] = @cake[3]
    @cake[3] = BakeTask.new

    @cake[3].name.must_equal 'Bake'
    @cake[4].name.must_equal 'Frost'
    @cake[5].name.must_equal 'Lick spoon'
  end
end
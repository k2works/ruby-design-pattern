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
  def add_sub_task(task)
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
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    @sub_tasks = []
    add_sub_task( AddDryIngredientsTask.new )
    add_sub_task( AddLiquidsTask.new )
    add_sub_task( MixTask.new )
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
    add_sub_task( MakeBatterTask.new )
    add_sub_task( FillPanTask.new )
    add_sub_task( BakeTask.new )
    add_sub_task( FrostTask.new )
    add_sub_task( LickSpoonTask.new )
  end
end

describe MakeBatterTask do
  # バターを作るのに５分かかる
  it 'should take 5 minutes. ' do
    batter = MakeBatterTask.new
    batter.get_time_required.must_equal 5.0
  end
  # ケーキを焼くのに２２分かかる
  it 'should take 22 minutes.' do
    cake = MakeCakeTask.new
    cake.get_time_required.must_equal 22.0
  end
end

require 'minitest/autorun'

class Task
  attr_reader :name
  attr_accessor :parent

  def initialize(name)
    @name = name
    @parent = nil
  end

  def get_time_required
    0.0
  end

  def total_number_basic_tasks
    1
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
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
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

  def total_number_basic_tasks
    total = 0
    @sub_tasks.each {|task| total += task.total_number_basic_tasks}
    total
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
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
  before(:each) do
    @batter = MakeBatterTask.new
  end
  # バターを作るのに５分かかる
  it 'should take 5 minutes. ' do
    @batter.get_time_required.must_equal 5.0
  end
  # バターを作る工程は全部で３工程ある
  it 'should have 3 tasks' do
    @batter.total_number_basic_tasks.must_equal 3
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
  # ケーキを焼く工程はバターを作る工程の親工程である
  it 'should be parent task of making batter task.' do
    @cake[0].name.must_equal 'Make batter'
    @cake[0].parent.name.must_equal 'Make cake'
  end
  # ケーキを焼く工程は全部で全部で７工程ある
  it 'should have 7 tasks' do
    @cake.total_number_basic_tasks.must_equal 7
  end
end
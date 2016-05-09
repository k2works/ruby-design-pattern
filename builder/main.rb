require 'minitest/autorun'

class Computer
  attr_accessor :display
  attr_accessor :motherboard
  attr_accessor :drives

  def initialize(display=:crt, motherboard=Motherboard.new, drives=[])
    @motherboard = motherboard
    @drives = drives
    @display = display
  end
end

class CPU
  # CPU共通のコード・・・
end

class BasicCPU < CPU
  # あまり高速でないCPUに関するたくさんのコード・・・
end

class TurboCPU < CPU
  # 超高速のCPUに関するたくさんのコード・・・
end

class Motherboard
  attr_accessor :cpu
  attr_accessor :memory_size
  def initialize(cpu=BasicCPU.new, memory_size=1000)
    @cpu = cpu
    @memory_size = memory_size
  end
end

class Drive
  attr_accessor :type # :hard_diskか:cdか:dvd
  attr_accessor :size # MBで
  attr_accessor :writable # ドライブが書き込み可能ならばtrue

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end

class ComputerBuilder
  attr_accessor :computer

  def initialize
    @computer = Computer.new
  end

  def turbo(has_turbo_cpu=true)
    @computer.motherboard.cpu = TurboCPU.new
  end

  def display=(display)
    @computer.display=display
  end

  def memory_size=(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end

  def add_cd(writer=false)
    @computer.drives << Drive.new(:cd, 760, writer)
  end

  def add_dvd(writer=false)
    @computer.drives << Drive.new(:dvd, 4000, writer)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << Drive.new(:hard_disk, size_in_mb, true)
  end
end

describe Computer do
  describe 'when not using builder.' do
    before(:each) do
      motherboard = Motherboard.new(TurboCPU.new, 4000)

      drives = []
      drives << Drive.new(:hard_drive, 200000, true)
      drives << Drive.new(:cd, 760, true)
      drives << Drive.new(:dvd, 4700, false)

      @computer = Computer.new(:lcd, motherboard, drives)
    end

    # LCDディスプレイを搭載している
    it 'should have LCD display.' do
      @computer.display.must_equal :lcd
    end

    # TurboCPUを搭載している
    it 'should have TurboCPU on motherboard.' do
      @computer.motherboard.cpu.must_be_instance_of TurboCPU
    end

    # 200GBの書き込み可能ハードディスクドライブを搭載している
    it 'should have 200GB writable hard drive.' do
      @computer.drives[0].type.must_equal :hard_drive
      @computer.drives[0].size.must_equal 200000
      @computer.drives[0].writable.must_equal true
    end

    # 760MBの書き込み可能CDドライブを搭載している
    it 'should have 760MB writable cd drive.' do
      @computer.drives[1].type.must_equal :cd
      @computer.drives[1].size.must_equal 760
      @computer.drives[1].writable.must_equal true
    end

    # 4.7GBの読み込み専用DVDドライブを搭載している
    it 'should have 4.7GB read only dvd drive.' do
      @computer.drives[2].type.must_equal :dvd
      @computer.drives[2].size.must_equal 4700
      @computer.drives[2].writable.must_equal false
    end
  end
end

describe ComputerBuilder do

  describe 'when using builder.' do
    before(:each) do
      @builder = ComputerBuilder.new
      @builder.turbo
      @builder.add_cd(true)
      @builder.add_dvd
      @builder.add_hard_disk(100000)
    end

    # CRTディスプレイを搭載している
    it 'should have CRT display.' do
      computer = @builder.computer
      computer.display.must_equal :crt
    end

    # TurboCPUを搭載している
    it 'should have TurboCPU on motherboard.' do
      computer = @builder.computer
      computer.motherboard.cpu.must_be_instance_of TurboCPU
    end

    # 760MBの書き込み可能CDドライブを搭載している
    it 'should have 760MB writable cd drive.' do
      computer = @builder.computer
      computer.drives[0].type.must_equal :cd
      computer.drives[0].size.must_equal 760
      computer.drives[0].writable.must_equal true
    end

    # 4GBの読み込み専用DVDドライブを搭載している
    it 'should have 4GB read only dvd drive.' do
      computer = @builder.computer
      computer.drives[1].type.must_equal :dvd
      computer.drives[1].size.must_equal 4000
      computer.drives[1].writable.must_equal false
    end

    # 100GBの書き込み可能ハードディスクドライブを搭載している
    it 'should have 100GB writable hard drive.' do
      computer = @builder.computer
      computer.drives[2].type.must_equal :hard_disk
      computer.drives[2].size.must_equal 100000
      computer.drives[2].writable.must_equal true
    end
  end
end
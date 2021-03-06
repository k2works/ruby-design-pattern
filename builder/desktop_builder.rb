#
# == ディスクトップPCビルダークラス
#
# Author:: k2works
# Version:: 1.0.0
# License:: Ruby License
#
class DesktopBuilder < ComputerBuilder
  def initialize
    @computer = DesktopComputer.new
  end

  def display=(display)
    @computer.display=display
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

  def reset
    @computer = DesktopComputer.new
  end

  def method_missing(name, *args)
    words = name.to_s.split("_")
    return super(name, *args) unless words.shift == 'add'
    words.each do |word|
      next if word == 'and'
      add_cd if word == 'cd'
      add_dvd if word == 'dvd'
      add_hard_disk(100000) if word == 'harddisk'
      turbo if word == 'turbo'
    end
  end
end
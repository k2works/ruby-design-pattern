require 'minitest/autorun'

class SlickButton
  attr_accessor :command

  def initialize(command)
    @command = command
  end

  def on_button_push
    @command.execute if @command
  end
end

class SaveCommand
  def execute
    puts '保存しました'
  end
end

describe SlickButton do
  # 保存ボタンを押す
  it 'should putout message when it pushed.' do
    save_button = SlickButton.new(SaveCommand.new)
    proc {save_button.on_button_push}.must_output "保存しました\n"
  end
end
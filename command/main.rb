require 'minitest/autorun'

class SlickButton
  attr_accessor :command

  def initialize(&block)
    @command = block
  end

  def on_button_push
    @command.call if @command
  end
end

describe SlickButton do
  # 保存ボタンを押す
  it 'should putout message when it pushed.' do
    new_button = SlickButton.new do
      puts '保存しました'
    end
    proc {new_button.on_button_push}.must_output "保存しました\n"
  end
end
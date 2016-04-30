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

class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute
  end
end

class CreateFile < Command
  def initialize(path, contents)
    super("Create file: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end
end

class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    File.delete(@path)
  end
end

class CopyFile < Command
  def initialize(source, target)
    super("Copy file: #{source} to #{target}")
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end
end

class CompositeCommand < Command
  def initialize
    @command = []
  end

  def add_command(cmd)
    @command << cmd
  end

  def execute
    @command.each {|cmd| cmd.execute}
  end

  def description
    description = ''
    @command.each {|cmd| description += cmd.description + "\n"}
    description
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

describe Command do
  # ファイル作成・コピー・削除コマンドを実行する
  it 'should output description of file creating,copying and delete.' do
    output =<<-EOS
Create file: file1.txt
Copy file: file1.txt to file2.txt
Delete file: file1.txt
    EOS

    cmds = CompositeCommand.new

    cmds.add_command(CreateFile.new('file1.txt', "hello world\n"))
    cmds.add_command(CopyFile.new('file1.txt', 'file2.txt'))
    cmds.add_command(DeleteFile.new('file1.txt'))

    cmds.description.must_equal output
  end
end
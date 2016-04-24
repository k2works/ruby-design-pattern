require 'minitest/autorun'

#
# == Template Methodパターン解説用レポートクラス
#
# Author:: k2works
# Version:: 0.0.2
# License:: Ruby License
#
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
    raise 'Called abstract method: output_start'
  end

  def output_head
    raise 'Called abstract method: output_head'
  end

  def output_body_start
    raise 'Called abstract method: output_body_start'
  end

  def output_line(line)
    raise 'Called abstract method: output_line'
  end

  def output_body_end
    raise 'Called abstract method: output_body_end'
  end

  def output_end
    raise 'Called abstract method: output_end'
  end
end

class HTMLReport < Report
  def output_start
    puts ('<html>')
  end

  def output_head
    puts(' <head>')
    puts(" <title>#{@title}</title>")
    puts(' </head>')
  end

  def output_body_start
    puts('<body>')
  end

  def output_line(line)
    puts(" <p>#{line}</p>")
  end

  def output_body_end
    puts('</body>')
  end

  def output_end
    puts('</html>')
  end
end

class PlaineTextReport < Report
  def output_start
  end

  def output_head
    puts("**** #{@title} ****")
    puts
  end

  def output_body_start
  end

  def output_line(line)
    puts(line)
  end

  def output_body_end
  end

  def output_end
  end
end

describe Report do
  before do

  end

  # HTMLレポートが出力される
  it 'should output HTML report.' do
    @my = HTMLReport.new

    report = <<-EOS
<html>
 <head>
 <title>月次報告</title>
 </head>
<body>
 <p>順調</p>
 <p>最高の調子</p>
</body>
</html>
    EOS
    proc {@my.output_report}.must_output report
  end

  # プレーンテキストのレポートが出力される
  it 'should output plain text report.' do
    @my = PlaineTextReport.new

    report = <<-EOS
**** 月次報告 ****

順調
最高の調子
    EOS
    proc {@my.output_report}.must_output report
  end
end
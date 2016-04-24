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
  # レポートを出力する
  # @param [String] フォーマット
  # @return [String] HTMLレポート
  def output_report(format)
    if format == :plain
      puts("*** #{@title} ***")
    elsif format == :html
      puts ('<html>')
      puts(' <head>')
      puts(" <title>#{@title}</title>")
      puts(' </head>')
      puts(' <body>')
    else
      raise "Unknown format: #{format}"
    end

    @text.each do |line|
      if format == :plain
        puts(line)
      else
        puts(" <p>#{line}</p>")
      end
    end

    if format == :html
      puts(' </body>')
      puts('</html>')
    end
  end
end

describe Report do
  before do
    @my = Report.new
  end

  # HTMLレポートが出力される
  it 'should output HTML report.' do
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
    proc {@my.output_report(:html)}.must_output report
  end

  # プレーンテキストのレポートが出力される
  it 'should output plain text report.' do
    report = <<-EOS
*** 月次報告 ***
順調
最高の調子
    EOS
    proc {@my.output_report(:plain)}.must_output report
  end
end
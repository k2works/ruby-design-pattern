require 'minitest/autorun'

#
# == Template Methodパターン解説用レポートクラス
#
# Author:: k2works
# Version:: 0.0.1
# License:: Ruby License
#
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end
  # レポートを出力する
  # @return [String] HTMLレポート
  def output_report
    puts ('<html>')
    puts(' <head>')
    puts(" <title>#{@title}</title>")
    puts(' </head>')
    puts(' <body>')
    @text.each do |line|
      puts(" <p>#{line}</p>" )
    end
    puts(' </body>')
    puts('</html>')
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
    proc {@my.output_report}.must_output report
  end
end
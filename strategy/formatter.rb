require 'minitest/autorun'

class Formatter
  def output_report( title, text)
    raise 'Abstract method called'
  end
end

class HTMLFormatter < Formatter
  def output_report(context)
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{context.title}</title>")
    puts('  </head>')
    puts('  <body>')
    context.text.each do |line|
      puts("     <p>#{line}</p>" )
    end
    puts('  </body>')
    puts('</html>')
  end
end

class PlainTextFormatter < Formatter
  def output_report(context)
    puts("***** #{context.title} *****")
    context.text.each do |line|
      puts(line)
    end
  end
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = '月次報告'
    @text = [ '順調','最高の調子' ]
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end

end

describe Formatter do
  # HTMLレポートが出力される
  it 'should output HTML report.' do
    @my = Report.new(HTMLFormatter.new)

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
    @my = Report.new(PlainTextFormatter.new)

    report = <<-EOS
***** 月次報告 *****
順調
最高の調子
    EOS
    proc {@my.output_report}.must_output report
  end
end
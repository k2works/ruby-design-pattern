require 'minitest/autorun'
require 'find'

class Expression
  # 一般的な式のコードはここに追加されます・・・
end

class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

describe All do
  # カレントディレクリにファイルが存在する
  it 'should be exist file in directory.' do
    all = All.new
    results = all.evaluate('./')
    results.wont_be_nil
  end
end
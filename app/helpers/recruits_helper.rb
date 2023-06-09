module RecruitsHelper
  def required_time_options
    [["--", ''], ["30分", 30], ["１時間", 60], ["1時間30分", 90], ["2時間", 120], ["2時間30分", 150],
     ["3時間", 180], ["3時間30分", 210], ["4時間", 240]]
  end

  def format_duration(time)
    if time == 30
      '30分'
    else
      "#{time / 60}時間"
    end
  end
end

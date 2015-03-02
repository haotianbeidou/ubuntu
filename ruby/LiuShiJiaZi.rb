require_relative 'cdate'
require_relative 'goleph.rb'
require 'time'

def main

  #天干地支
	v = {}
	v["天干"] = [ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
	v["地支"] = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]

  #六十甲子
  六十甲子 = []
  i = 0
  while i < 60
    六十甲子[i] = v["天干"][i % 10] + v["地支"][i % 12] 
    i = i + 1
  end  

  #输出公历时间
  s = Time.now
  print "公历:", s.year, "年", s.month, "月", s.day, "日", s.hour, "时", s.min, "分\n"

	#起四柱并输出
  农历 = CDate.new
  print "干支:"
	四柱 = 农历.bazi(DateTime.now)
	(0...4).each { |i|
		print "#{v["天干"][四柱[i][0]]}#{v["地支"][四柱[i][1]]} "
	}
  puts ""
  
  #起四柱旬首并输出
  print " "
  (0...4).each { |o|
  
  #确定四柱每个柱在六十甲子中的位置
    i = 59 
    x = v["天干"][四柱[o][0]] + v["地支"][四柱[o][1]]
    while i >= 0
      if 六十甲子[i] == x
        m = i
        break
      end
      i = i - 1
    end

  #确定四柱每个柱的旬首并输出
    while m < 60
      if /甲/ =~ 六十甲子[m]
        break
      end
      m = m - 1
    end  

    print "(#{六十甲子[m]}) "
  }
  print "\n"
  
  #起体用并输出
  u = []
  体号 = u[0] = s.hour - 1
  用号 = u[1] = s.min - 1
  puts ""
  print "      体           用\n"
  print "     #{六十甲子[体号]}         #{六十甲子[用号]}\n"

  #起体用的旬首
  print "    "
    (0...2).each { |o|
  
  #确定体用在六十甲子中的位置
    i = 59 
    x = 六十甲子[u[o]]
    while i >= 0
      if 六十甲子[i] == x
        m = i
        break
      end
      i = i - 1
    end

  #确定体用旬首并输出
    while m < 60
      if /甲/ =~ 六十甲子[m]
        break
      end
      m = m - 1
    end  

    print "(#{六十甲子[m]})       "
  }
  print "\n"

end

main 


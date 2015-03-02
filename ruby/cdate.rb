#encoding: utf-8 
 
  # Copyright (C) 2010 oCameLo. All rights reserved.
  
  # coding: UTF-8
  require 'date'

  class CDate
    
    # 根据不同locale保存简体或繁体的数据
    attr_accessor :天干, :地支, :生肖, :农月, :农日, :节气, :闰, :星座

    def initialize( )
      # 按年份保存的cache
      @cache = {}
      
      # 检测locale信息
      #locale
      chs

    end

    private

    # 简体
    def chs
      @闰 = '闰'

      ## 月名称,建寅
      # 春秋、战国时闰月名十三，秦汉时闰月名后九
      # 最后的那个一是武媚娘搞出来的特例
      @农月 = ['十一','十二','正','二','三','四','五','六','七','八','九','十'] + ['十三', '后九', '一']

      ## 日名称
      @农日 = ['初一','初二','初三','初四','初五','初六','初七','初八','初九','初十','十一','十二','十三','十四','十五','十六','十七','十八','十九','二十','廿一','廿二','廿三','廿四','廿五','廿六','廿七','廿八','廿九','三十','卅一']

      # 天干
      @天干 = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸']

      # 地支
      @地支 = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']

      # 生肖
      @生肖 = ['鼠','牛','虎','兔','龙','蛇','马','羊','猴','鸡','狗','猪']

      # 节气
      @节气 = ['冬至','小寒','大寒','立春','雨水','惊蛰','春分','清明','谷雨','立夏','小满','芒种','夏至','小暑','大暑','立秋','处暑','白露','秋分','寒露','霜降','立冬','小雪','大雪']

      # 星座
      @星座 = ['摩羯','水瓶','双鱼','白羊','金牛','双子','巨蟹','狮子','处女','天秤','天蝎','射手']
    end

    # 繁体
    def cht
      @闰 = '閏'
      @农月 = ['十一','十二','正','二','三','四','五','六','七','八','九','十'] + ['十三', '後九', '一']
      @农日 = ['初一','初二','初三','初四','初五','初六','初七','初八','初九','初十','十一','十二','十三','十四','十五','十六','十七','十八','十九','二十','廿一','廿二','廿三','廿四','廿五','廿六','廿七','廿八','廿九','三十','卅一']
      @天干 = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸']
      @地支 = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']
      @生肖 = ['鼠','牛','虎','兔','龍','蛇','馬','羊','猴','雞','狗','豬']
      @节气 = ['冬至','小寒','大寒','立春','雨水','驚蟄','春分','清明','穀雨','立夏','小滿','芒種','夏至','小暑','大暑','立秋','處暑','白露','秋分','寒露','霜降','立冬','小雪','大雪']
      @星座 = ['摩羯','水瓶','雙魚','白羊','金牛','雙子','巨蟹','獅子','處女','天秤','天蠍','射手']
    end

    # 使用环境变量获取locale信息
    def locale_env
      if (e = ENV['LANG'] || ENV['LC_ALL']) && e.downcase! then
        case e[0..4]
        when 'zh_sg'
          return :zh_sg
        when 'zh_tw'
          return :zh_tw
        when 'zh_hk'
          return :zh_hk
        when 'zh_mo'
          return :zh_mo
        else
          return :zh_cn
        end
      else
        return :zh_cn
      end
    end

    # 使用Windows API获取locale信息
    def locale_win32api
      begin
        require 'dl'
        require 'dl/import'
        # GetSystemDefaultLCID的返回值可以在下面这里查到
        # http://msdn.microsoft.com/en-us/library/dd318693(v=VS.85).aspx
        # (SUBLANG_ID<<10) + LANG_ID
        lcid = DL.dlopen('kernel32') do |h|
          addr = h.sym('GetSystemDefaultLCID')
          cfunc = DL::CFunc.new(addr, DL::TYPE_INT)
          func = DL::Function.new(cfunc, [DL::TYPE_VOID])
          func.call
        end
        case lcid
        when 0x404 # 台湾
          return :zh_tw
        when 0xc04 # 香港
          return :zh_hk
        when 0x1404 # 澳门
          return :zh_mo
        when 0x1004 # 新加坡
          return :zh_sg
        else # 大陆是0x804
          return :zh_cn
        end
      rescue
        return :zh_cn
      end
    end

    public

    # 根据儒略日数算公历
    def 儒转公(儒参)
      raise ArgumentError, '儒参 cannot be negative.' if 儒参 < 0

      t = 儒参 + 0.5
      z = t.floor
      f = t - z
      
      a = if z < 2299161 then
        z
      else
        t = ((z-1867216.25)/36524.25).floor
        z + 1 + t - (t/4.0).floor
      end
      b = a + 1524
      c = ((b-122.1)/365.25).floor
      d = (365.25*c).floor
      e = ((b-d)/30.6001).floor
      
      日 = b - d - (30.6001*e).floor + f
      月 = (e < 14 ? e-1 : e-13)
      年 = (月 > 2 ? c-4716 : c-4715)

      return [年, 月, 日]
    end

    # 根据公历算儒略日数
    def 公转儒(年, 月, 日)
      raise ArgumentError, '年 cannot be less than -4712' if 年 < -4712

      if 月 <= 2 then
        年 -= 1; 月 += 12
      end

      b = if 年 < 1582 or (年 == 1582 and 月 < 10) or (年 == 1582 and 月 == 10 and 日 <= 4) then
        0
      else
        a = (年/100.0).floor
        2 - a + (a/4.0).floor
      end

      return (365.25*(年+4716)).floor + (30.6001*(月+1)).floor + 日 + b - 1524.5
    end

    

    # 设置语言环境
    # loc可为:zh_cn, :zh_sg, :zh_tw, :zh_hk, :zh_mo其中之一
    # 如不给出loc则尝试自动判断
    def locale(loc = nil)
      # 默认采用简体中文
      @loc = :zh_cn

      if loc then
        @loc = loc if loc == :zh_sg or loc == :zh_tw or loc == :zh_hk or loc == :zh_mo
      else # 未给定loc，尝试自动判断
        # 有环境变量则采用
        if ENV['LANG'] || ENV['LC_ALL'] then
          @loc = locale_env
        elsif RUBY_PLATFORM =~ /cygwin|mingw|mswin/ then
          # 无环境变量并在Windows内则使用API
          @loc = locale_win32api
        end
      end

      # 目前不同locale就只有简繁体的区别
      if @loc == :zh_tw or @loc == :zh_hk or @loc == :zh_mo then
        cht
      else
        chs
      end
    end

    # 获取某年的农历数据
    #
    # 儒参为当年某日的儒略日数
    #
    # 返回一个包括实参对应日期所在年份农历数据的Hash：
    #
    # * :闰 => int # 闰月位置
    # * :春节 => 儒参 # 当年的正月初一
    # * :农月名 => [] # 农历月名
    # * :中气表 => {} # 中气表
    # * :合朔表 => [] # 合朔表
    # * :各月大小 => [] # 各月大小
    def 获农年(儒参)
      年 = 儒转公(儒参)[0] # 儒转公比Date类算起来快
      return @cache[年] if @cache.has_key?(年)

      dat = CCal::GolEph.calc_y(儒参 - CCal::GolEph::J2000)

      # 找正月初一，即春节
      i = dat[:合朔表][2] # 一般第三个月为正月
      0.upto(13) do |j|
        next if dat[:农月名][j] != 2 || (dat[:闰] == j && j != 0)
        i = dat[:合朔表][j]
      end
      dat[:春节] = i

      @cache[年] = dat
      return dat
    end

    # 获取某日的农历数据
    #
    # 儒参为该日儒略日数，
    #
    # 返回一个包括实参对应日期所在日农历数据的Hash：
    #
    # * :天干 => string # 当年天干
    # * :地支 => string # 当年地支
    # * :生肖 => string # 当年生肖
    # * :月名 => string # 月名
    # * :是否闰月 => bool # 当月是否为闰月
    # * :当月天数 => int # 当月天数，用以判断月大小
    # * :日名 => string # 日名
    # * :节气 => string # 当日所含节气，无节气为nil
    # * :星座 => string # 星座
    #
    def 获农日(儒参)
      dat = 获农年(儒参)
      儒参 -= CCal::GolEph::J2000 # 底层代码以2k年起算
      d = {}

      # 干支纪年、生肖
      i = dat[:春节]
      i -= 365 if 儒参 < i
      i += 5810 ## 计算该年春节与1984年平均春节(立春附近)相差天数估计
      i = (i/365.2422+0.5).floor ## 农历纪年(10进制,1984年起算)
      i += 9000
      # .Net的ChineseLunisolarCalendar类里边
      # 天干翻做Celestial Stem，地支翻作Terrestrial Branch
      d[:天干] = @天干[i%10]
      i = i%12; d[:地支] = @地支[i]; d[:生肖] = @生肖[i]

      # 干支纪月
      ## 1998年12月7(大雪)开始连续进行节气计数,0为甲子
      i = ((儒参-dat[:中气表][0])/ 30.43685).floor
      ## 相对大雪的月数计算,mk的取值范围0-12
      i += 1 if i<12 && 儒参>=dat[:中气表][2*i+1]
      ## 相对于1998年12月7(大雪)的月数,900000为正数基数
      i = i + ((dat[:中气表][12]+390)/365.2422).floor * 12 + 900000;
      d[:天干_月] = @天干[i%10]; d[:地支_月] = @地支[i%12]

      # 干支纪日
      ## 2000年1月7日起算
      i = 儒参 - 6 + 9000000
      d[:天干_日] = @天干[i%10]; d[:地支_日] = @地支[i%12]

      # 月
      i = ((儒参 - dat[:合朔表][0])/30).floor
      i += 1 if i<13 && dat[:合朔表][i+1]<=儒参
      d[:是否闰月] = dat[:闰] == i ? true : false # 是否闰月
      d[:当月天数] = dat[:各月大小][i] # 该月多少天，判断大小月
      d[:月名] = @农月[dat[:农月名][i]]

      d[:imonth] = (dat[:农月名][i] - 2) % 12
      d[:iday] = (儒参 - dat[:合朔表][i]).floor()

      # 日
      d[:日名] = @农日[儒参 - dat[:合朔表][i]]

      # 节气
      i = ((儒参 - dat[:中气表][0] - 7)/15.2184).floor
      i += 1 if i < 23 && 儒参 >= dat[:中气表][i+1]
      d[:节气] = 儒参 == dat[:中气表][i] ? @节气[i] : ''

      # 星座
      # 好吧，农历也弄这个蛮无聊的其实
      i = ((儒参 - dat[:中气表][0] - 15)/30.43685).floor
      i += 1 if i<11 && 儒参>=dat[:中气表][2*i+2]
      d[:星座] = @星座[i%12]

      return d
    end

    def from_ccal(cyear, cmonth, cday, 闰 = false)
      # 后端中正月是2，11月和12月分别是0和1
      cmonth += cmonth > 10 ? -11 : 1
      儒参 = 公转儒(cyear, 1, 1)
      dat = 获农年(儒参)
      m = dat[:农月名].index(2) # 正月的位置
      n = dat[:农月名].index(cmonth) # 目标月的位置
      if n < m then
        # 目标月在正月之前，说明该月属于下一年
        儒参 += 366
        dat = 获农年(儒参)
        n = dat[:农月名].index(cmonth)
      end

      if 闰 then
        # 要找的是一个闰月
        raise "#{cyear} deosn't have a 闰 月" if dat[:闰] == 0
        raise "wrong 闰 月 number" if dat[:农月名][dat[:闰]] != cmonth
        n += 1
      end

      d = 儒转公(dat[:合朔表][n] + cday - 1 + CCal::GolEph::J2000)
      d[2] -= 0.5
      return d
    end


    def to_ccal( dt ) 
      jdt = 公转儒( dt.年, dt.月 , dt.日 + 1 )
      return 获农日( jdt );
    end 


    # 时区到经度的对应值
    ZONE2LNG = {-12=>-3.141592653589793, -11=>-2.8797932657906435, -10=>-2.6179938779914944, -9=>-2.356194490192345, -8=>-2.0943951023931953, -7=>-1.832595714594046, -6=>-1.5707963267948966, -5=>-1.3089969389957472, -4=>-1.0471975511965976, -3=>-0.7853981633974483, -2=>-0.5235987755982988, -1=>-0.2617993877991494, 0=>0.0, 1=>0.2617993877991494, 2=>0.5235987755982988, 3=>0.7853981633974483, 4=>1.0471975511965976, 5=>1.3089969389957472, 6=>1.5707963267948966, 7=>1.832595714594046, 8=>2.0943951023931953, 9=>2.356194490192345, 10=>2.6179938779914944, 11=>2.8797932657906435, 12=>3.141592653589793}
    
    # 计算八字
    #
    # 参数为DateTime类型
    #
    # 算八字需要准确的经度，否则时间的部分误差会非常大，这个函数似乎还是删掉的好。
    #
    def bazi(dt)
      zone = 8
      儒参 = dt.jd - 0.5 # ruby总是返回整数，减0.5得午夜0时的儒略日数
      儒参 += (dt.hour+dt.min/60.0)/24.0 # 加上时间，ruby没算这个部分
      儒参 -= zone/24.0 # 修正时差
      儒参 -= CCal::GolEph::J2000
      lng = ZONE2LNG[zone] # 根据时区获得近似经度

      jd2 = 儒参 + CCal::GolEph.dt_t(儒参) ## 力学时
      w = CCal::GolEph.s_alon(jd2/36525.0, -1) ## 此刻太阳视黄经
      k = ((w/(Math::PI*2)*360+45+15*360)/30.0).floor ## 1984年立春起算的节气数(不含中气)
      儒参 += lng/Math::PI/2 ## 时区时间 

      儒参 += 13/24.0 ## 转为前一日23点起算
      _d = (儒参).floor; _sc = ((儒参-_d)*12).floor ## 日数与时辰

      r = []
      v = (k/12.0+6000000).floor; r.push [v%10, v%12]
      v = k+2+60000000; r.push [v%10, v%12]
      v = _d-6+9000000; r.push [v%10, v%12]
      v = (_d-1)*12+90000000+_sc; r.push [v%10, v%12]
      return r
    end
  end

 

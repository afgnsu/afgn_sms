=begin
  == Information ==
  === Copyright: WTF Public License
  === Author: Patrick Su < afgnsu@gmail.com >
  === Library Name: AfgnSms lib
  === Version: 0.1
  === Please read README file to get more information.
=end

%w|date uri cgi net/http open-uri|.each{|r| require r}
SEND_URL = "http://api.message.net.tw/send.php?"
QUERY_URL = "http://api.message.net.tw/query.php?"

class AfgnSms
  def initialize(username, password)
    @uname, @upwd = username, password
    @send_options = {
      :mtype => "G",
      :encoding => "utf8"
    }

    @query_options = {
      :columns => "mstat"
    }

    #米瑟奇『錯誤訊息代碼』
    @@errors = {
      0.to_s.to_sym => "待發送中",
      1.to_s.to_sym => "已發送",
      2.to_s.to_sym => "發送成功",
      -1.to_s.to_sym => "登入失敗",
      -2.to_s.to_sym => "點數不足",
      -21.to_s.to_sym => "國際簡訊不支援長簡訊",
      -30.to_s.to_sym => "socket開啟失敗",
      -31.to_s.to_sym => "HTTP timeout",
      -32.to_s.to_sym => "HTTP回覆失敗",
      -35.to_s.to_sym => "系統商點數餘額不足",
      -4.to_s.to_sym => "不合法來源IP",
      -41.to_s.to_sym => "限定時間已到尚未送達",
      -42.to_s.to_sym => "簡訊被刪除",
      -43.to_s.to_sym => "簡訊無法送達",
      -45.to_s.to_sym => "不明原因",
      -46.to_s.to_sym => "簡訊被拒絕",
      -47.to_s.to_sym => "不存在的訊息代號(SYNTAXE)",
      -49.to_s.to_sym => "不明代碼",
      '-4x'.to_sym => "系統傷回覆錯誤訊息",
      -5.to_s.to_sym => "簡訊內容長度超過限制",
      -51.to_s.to_sym => "無該簡訊序號",
      -52.to_s.to_sym => "該簡訊已處理",
      -53.to_s.to_sym => "未處理訊息刪除失敗",
      -100.to_s.to_sym => "系統商傳遞代碼(未知)",
      -99999.to_s.to_sym => "系統商傳遞代碼(未知)"
    }
  end

  def sendSMS(tel, msg, opt={})
    args = []
    @send_options[:tel], @send_options[:msg] = tel, msg
    @send_options.merge!(opt).each{|k, v| args << k.to_s + "=" + CGI::escape(v.to_s)}
    url = SEND_URL + "id=" + @uname + "&password=" + @upwd + "&" + args.join("&")
    self.check_send_val
    return self.check_send_resp(Net::HTTP.get(URI.parse(url)))
  end

  def querySMS()
    url ||= QUERY_URL + "id=" + @uname + "&password=" + @upwd
    url += "&columns=" + @query_options[:columns].to_s
    return self.check_query_resp(Net::HTTP.get(URI.parse(url)))
  end

  def check_query_resp(resp)
    resp = resp.split(" ").map{ |x| x.split("=") }
    if resp[0][1] != '-1'
      #回傳點數
      return "點數剩餘：#{resp[1][1].to_s}"
    else
      return '米瑟奇的帳號密碼錯誤！'
    end
  end

  def check_send_resp(resp)
    resp = resp.split(" ").map{ |x| x.split("=") }
    return @@errors[resp[0][1].to_s.to_sym]
  end

  def check_send_val()
    @send_options[:tel].gsub(/-/, "")
    return nil
  end

  protected :check_send_val, :check_send_resp, :check_query_resp
end

# afgn_sms (用米瑟奇媒體發送簡訊) - 蘇介吾 105/03/04

http://www.message.com.tw

為什麼要用這家？因為他最便宜，而且品質還不錯，一通只要 0.8x 元 :p

![參考價格](http://www.message.com.tw/uploads/images/mon.gif)

##操作
1. rvm install 1.8.7
2. rvm use 1.8.7
3. rvm gemset create rails2318
4. rvm use 1.8.7@rails2318
5. gem i rails -v 2.3.18
6. gem i pry -v 0.9.7
7. gem i pry-rails -v 0.2.0
8. gem i afgn_sms
9. rails sms
10. cd sms
11. pry -r ./config/environment
12. require 'afgn_sms'
13. m = AfgnSms.new('米瑟奇帳號','米瑟奇密碼')  #登入米瑟奇簡訊
14. m.querySMS  #查詢剩餘點數
15. m.sendSMS('手機號碼','簡訊文字')  #發送簡訊

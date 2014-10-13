require 'selenium-webdriver'
require 'pp'

S_BRANCH_CD = ''
S_ACCNT_NO  = ''
PASSWORD    = ''

driver = Selenium::WebDriver.for :firefox

driver.navigate.to 'https://direct.smbc.co.jp/aib/aibgsjsw5001.jsp?'

# ログイン

element = driver.find_element(:name, 'S_BRANCH_CD')
element.send_keys(S_BRANCH_CD)
element = driver.find_element(:name, 'S_ACCNT_NO')
element.send_keys(S_ACCNT_NO)
element = driver.find_element(:name, 'PASSWORD')
element.send_keys(PASSWORD)

driver.find_element(:name, 'bLogon.y').click

# メインページに行く(人によっては必要ないかも)

driver.find_element(:name, 'imgNext.y').click

# 給与明細ページ

details_link = driver.find_element(:link, "明細照会")
details_link.click

# 給与明細ページから利用した口座残高の増減テーブルをパース

table_head = driver.find_elements(:xpath, "//div[@class = 'section']/table[@class= 'tableStyle table02 js-even']/thead/tr/*")
keys = []
table_head.each do |row|
  keys << row.text
end

details = []

table_body = driver.find_elements(:xpath, "//div[@class = 'section']/table[@class= 'tableStyle table02 js-even']/tbody/*")
table_body.each_with_index do |row, i|
  column = driver.find_elements(:xpath, "//div[@class = 'section']/table[@class= 'tableStyle table02 js-even']/tbody/tr[#{i+1}]/*")
  detail = {}
  column.each_with_index do |elm, j|
    detail[keys[j]] = elm.text
  end
  details << detail
end

# 口座残高の増減テーブルをjson形式で表示

pp details

driver.quit

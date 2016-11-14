class Guet
  require 'net/http'
  require 'nokogiri'
  require 'logger'
  # require 'open-uri'

  BASE_URL = 'xxxxxxxxx'

  LOGIN_URL = 'xxxxxxxxx'

  DEFAULT_URL = 'xxxxxxxxx'
  USER_INFO_URL = 'xxxxxxxxx'
  USER_PHOTO_URL = 'xxxxxxxxx'


  attr_accessor :http, :headers, :user, :passwd, :log

  def initialize
    @log = Logger.new(STDOUT)
    @http = Net::HTTP.new(BASE_URL, 80)

    resp, data = http.get(LOGIN_URL)

    cookie = resp.response['set-cookie'].split('; ')[0]
    if resp.code == '200'
      log.info "get cookie: #{ cookie }"
    else
      log.warn "don\'t connect server, status code is : #{ resp.code}"
    end
    @headers = {
        'Cookie' => cookie,
        'Referer' => 'http://www.guet.edu.cn',
        'Content-Type' => 'application/x-www-form-urlencoded'
    }
  end

  def login(user , passwd)
    # login_data = LOGIN_DATA.gsub(/\{user\}/, user)
    # login_data = login_data.gsub(/\{passwd\}/, passwd)
    login_data =  "theme=default&c=7&orgcode=桂林电子科技大学&u=#{user}&p=#{passwd}"
    @user = user
    resp, data = @http.post(LOGIN_URL, login_data, @headers)

    if resp.code == '200' && resp.body == '1'
      log.info "login success :#{resp.body}"
      return 1
    elsif resp.body == '0'
      log.warn "passwd error :#{resp.body}"
      return 0
    elsif resp.body.index('6')
      log.warn "user #{@user} over login 6 #{resp.body}"
      return 3
    else
      log.warn "user not exist: #{resp.body}"
      return 2
    end
  end

  def get_user_info()
    resp, data = @http.get(USER_INFO_URL, @headers)
    info = []
    if resp.code == '200'
      log.info 'start get user Info'
      doc =  Nokogiri::HTML(resp.body, nil, 'utf8')
      content = doc.search('table td')
      content.each { |e| info.push e.text.strip }
      #
      self.get_user_photo if ! info.empty?
    else
      log.warn 'can\'t get user into : return code ' + resp.code
    end
    return info
  end
  def get_user_photo
    resp, data = @http.get(USER_PHOTO_URL + @user.to_s, @headers)
    if resp.code == '200'
      @log.info 'success open url of user photo'
      open("images/photo_#{@user}.jpeg" ,"wb") { |file|
        file.write(resp.body)
      }
    else
      @log.error 'can\'t open user photo url'
    end
  end
  def logout()
    resp, data = @http.get(LOGOUT_URL, @headers)
    true if resp.code == '200'
  end
end

require 'mysql2'

db_host = ENV['GUET_DB_HOST'] || 'localhost'
db_port = ENV['GUET_DB_PORT'] || 3306
db_user = ENV['GUET_DB_USER'] || 'root'
db_pass = ENV['GUET_DB_PASS'] || '1234'
db_name = ENV['GUET_DB_NAME'] || 'guet_std_info'

client = Mysql2::Client.new(:host => db_host, :username => db_user, :password => db_pass, :port => db_port, :database => db_name)

sqlcode = "INSERT INTO `student_info`(`sid`, `name`, `academy`, `major`, `pid`, `tell`, `sex`, `headman`, `parent`, `parent_tell`, `address`, `bank`, `birthday`)"

std = []

std.each do |s|
  d = Guet.new()
  d.login(s,'password')
  info = d.get_user_info
  if ! info.empty?
    info_sql = sqlcode + " VALUES (#{ s }, '#{info[2][3..-1].strip}', '#{info[6][3..-1].strip}', '#{info[7][3..-1].strip}', '#{info[15][4..-1].strip}', '#{info[20][4..-1].strip}', '#{info[11][3..-1].strip}', '#{info[21][4..-1].strip}', '#{info[32][5..-1].strip}', '#{info[33][7..-1].strip}', '#{info[34][5..-1].strip}', '#{info[40][6..-1].strip}', '#{info[16][5..-1].strip}')"
    puts info_sql
    begin
      client.query(info_sql)
    rescue Exception => e
      puts e.message
    end
    sleep(5)
  end
end

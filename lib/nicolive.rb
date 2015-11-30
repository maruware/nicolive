require "nicolive/version"
require "nicolive/client"
require "nicolive/thread"
require "nicolive/chat"
require "nicolive/user"

module Nicolive
  ENDPOINT_GETPLAYERSTATUS = 'http://watch.live.nicovideo.jp/api/getplayerstatus'
  ENDPOINT_LOGIN_FORM = 'https://secure.nicovideo.jp/secure/login_form'
  ENDPOINT_TOP = 'http://live.nicovideo.jp'
  ENDPOINT_USER_INFO = 'http://api.ce.nicovideo.jp/api/v1/user.info'
  def login(mail, password)
    Client.new(mail, password)
  end
  module_function :login
end
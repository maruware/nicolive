require 'mechanize'
require 'addressable/uri'

module Nicolive
  class User
    attr_reader :id, :nickname, :thumbnail_url
    def initialize(id, nickname, thumbnail_url)
      @id = id
      @nickname = nickname
      @thumbnail_url = thumbnail_url
    end
    def self.fetch(user_id)
      id = user_id.to_i
      uri = Addressable::URI(ENDPOINT_USER_INFO)
      uri.query_values = {user_id: user_id}
      page = Mechanize.new.get uri.to_s

      user_node = page.search('user').first
      nickname = user_node.xpath('nickname').first.text
      id = user_node.xpath('id').first.text
      thumbnail_url = user_node.xpath('thumbnail_url').first.text

      User.new(id, nickname, thumbnail_url)
    end

  end
end
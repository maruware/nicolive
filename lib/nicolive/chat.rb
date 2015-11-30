module Nicolive
  class Chat
    attr_reader :comment, :mail, :vpos, :date, :user_id, :premium, :anonymity, :locale, :score, :origin, :user
    def initialize(comment, mail, vpos, date, user_id, premium, anonymity, locale, score, origin)
      @comment = comment
      @mail = mail
      @vpos = vpos
      @date = date
      @user_id = user_id
      @premium = premium
      @anonymity = anonymity
      @locale = locale
      @score = score
      @origin = origin

      @user = unless anonymity
        User.fetch(user_id)
      end
    end
    def self.parse(node)
      comment = node.text
      vpos = node.attribute('vpos').value
      mail = node.attribute('mail').value if node.attribute('mail')
      date_ts = node.attribute('date').value.to_i
      date = Time.at(date_ts)
      user_id = node.attribute('user_id').value
      premium = node.attribute('premium').value  if node.attribute('premium')
      anonymity = node.attribute('anonymity').value.to_i if node.attribute('anonymity')
      score = node.attribute('score').value if node.attribute('score')
      locale = node.attribute('locale').value if node.attribute('locale')
      origin = node.attribute('origin').value if node.attribute('origin')

      Chat.new(comment, vpos, mail, date, user_id, premium, anonymity, locale, score, origin)
    end

    def hb_comment?
      return /^\/hb/ === comment
    end

    def anonymity?
      return @anonymity==1 ? true : false
    end
  end
end
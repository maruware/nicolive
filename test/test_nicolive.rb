require_relative 'minitest_helper'

class TestNicolive < Minitest::Test

  def test_simple_case
    client = Nicolive.login(ENV['MAIL'], ENV['PASSWORD'])

    channels = client.onair_channel_top3
    count = 0
    client.watch(channels.first) do |chat|
      assert_instance_of Nicolive::Chat, chat

      username = chat.user.nickname unless chat.anonymity?
      puts "[#{chat.date}] #{username} - #{chat.comment}"

      count += 1
      client.stop if count > 5
    end
  end
end

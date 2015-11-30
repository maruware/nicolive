require 'mechanize'
require 'socket'
require 'nokogiri'
require 'eventmachine'
require 'addressable/uri'

module Nicolive
  class Client
    def initialize(mail, password)

      @agent = Mechanize.new
      @agent.user_agent_alias = 'Mac Safari'

      @agent.get Addressable::URI.parse(ENDPOINT_LOGIN_FORM) do |page|
        res = page.form_with id: 'login_form' do |form|
          form.field_with(name: 'mail_tel').value = mail
          form.field_with(name: 'password').value = password
        end.click_button
      end

      @events = {}
    end

    def watch(channel, &block)
      t = fetch_thread(channel)

      if EventMachine.reactor_running?
        connect t, &block
      else
        if EventMachine.epoll?
          EventMachine.epoll
        elsif EventMachine.kqueue?
          EventMachine.kqueue
        else
          Kernel.warn('Your OS does not support epoll or kqueue.')
        end

        EventMachine.run do
          connect t, &block
        end
      end

      self
    end

    def on_disconnected(&block)
      on(:disconnected, &block)
    end

    def stop()
      EventMachine.stop_event_loop
    end

    def onair_channel_top3
      page = @agent.get Addressable::URI.parse(ENDPOINT_TOP)
      channnels = page.search('.item.onair a.item_link').map do |link|
        url = link.attribute('href').value
        r = url.match(/(?<channel>lv[0-9]+)/)
        r['channel']
      end
      channnels
    end

    private
    def fetch_thread(channel)
      uri = Addressable::URI.parse(ENDPOINT_GETPLAYERSTATUS)
      uri.query_values = {v: channel}
      page = @agent.get uri.to_s
      if page.search('error').any?
        code = page.search('error').first.search('code').text
        throw RuntimeError.new("error [#{code}]")
      end
      thread = page.search('thread').text
      addr = page.search('addr').text
      port = page.search('port').text

      Thread.new(thread, addr, port)
    end

    def connect(thread, &block)
      thread_req = "<thread thread=\"#{thread.thread}\" version=\"20061206\" res_from=\"-1\"/>\0"
      con = EventMachine::connect thread.addr, thread.port, Connection
      con.client = self
      on_disconnected do
        stop()
      end
      con.start thread_req, &block
    end

    def on(event, &block)
      if block_given?
        unless @events.has_key?(event)
          @events[event] = []
        end
        @events[event] << block
        self
      else
        @events[event]
      end
    end

    def invoke_callback(event, *args)
      if @events.has_key?(event)
        callbacks = @events[event]
        callbacks.each do |callback|
          callback.call(*args)
        end
      end
    end

    class Connection < EventMachine::Connection
      attr_accessor :client
      def start(req, &block)
        @block = block
        send_data req
      end

      def receive_data(data)
        doc = Nokogiri::HTML.parse(data)
        chat_nodes = doc.xpath('//chat')
        unless chat_nodes.any?
          return
        end

        chat_node = chat_nodes.first
        chat = Chat.parse(chat_node)

        if chat.comment == '/disconnect'
          client.send(:invoke_callback, :disconnected)
          return
        end
        @block.call(chat)
      end
    end
  end

end

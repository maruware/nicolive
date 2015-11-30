# Nicolive

An Accessor for a Nicovideo live.
This make easy to fetch comments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nicolive'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install nicolive
```

## Usage

Write credential

```ruby
client = Nicolive.login('your_mail', 'your_password')
channel = 'lv236367556' #Nicovideo live id
client.watch(channel) do |chat|
  puts "#{chat.date} #{chat.comment}"
end
```

## Contributing

1. Fork it ( https://github.com/maruware/nicolive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

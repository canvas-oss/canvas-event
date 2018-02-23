# CanvasOss::Event

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'canvas_oss-event'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install canvas_oss-event

## Usage

A quick example of this API :
```ruby
example_log = CanvasOss::Event::Logger.new('canvas_web', 1)
example_log.log('warn', 'This is the warning log text')
example_log.close
```

## Development

## Contributing

## Code of Conduct

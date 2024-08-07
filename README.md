# Rbexec

Run code inside an existing ruby process. Similar to `rbtrace -p $pid -e '...'`, but more reliable.

## Installation

    $ bundle add rbexec

## Usage

During the boot of the process you would like to execute code in (ex. config/puma.rb)

```
require "rbexec"
Rbexec::Listener.new(path: "tmp/puma.rbexec.sock")
```

This creates a socket which can be written to.

```
$ echo "GC.stat" | socat - UNIX-CONNECT:tmp/puma.rbexec.sock
rbexec pid:1176594. Enter code followed by EOF.
{:count=>57, :time=>741, ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jhawthorn/rbexec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jhawthorn/rbexec/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbexec project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jhawthorn/rbexec/blob/main/CODE_OF_CONDUCT.md).

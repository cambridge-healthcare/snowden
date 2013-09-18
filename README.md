# Snowden

Snowden is a gem for managing encrypted search indices. It can do fuzzy search
on text indices and supports pluggable backends.

## Installation

Add this line to your application's Gemfile:

    gem 'snowden'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snowden

## Usage


```
require 'snowden'

# 256 bit aes with 128 bit block
aes_key = "a"*(256/8)
aes_iv  = "b"*(128/8)

index    = Snowden.new_encrypted_index(aes_key, aes_iv, Snowden::Backends::HashBackend.new)
searcher = Snowden.new_encrypted_searcher(aes_key, aes_iv, index)

index.store("bacon", "bits")

searcher.search("bac")
# => ["bits"]
```


## Backends and namespacing

Snowden supports multiple backends for storing your encrypted search indices,
two backends are provided as part of the gem:

* An in memory hash backend `Snowden::Backends::HashBackend`
* A redis backend `Snowden::Backends::RedisBackend`

Both support taking a namespace, which allows you to store multiple different
encrypted indices in the same store. The redis backend also takes a
`Redis` object from the [redis](https://github.com/redis/redis-rb) to serve
as its connection to the redis server.

An example of the use of the redis backend is:

```ruby
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

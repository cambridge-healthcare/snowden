# Snowden

![Snowden's here](http://i.qkme.me/3uyzco.jpg)

Snowden is a gem for managing encrypted search indices. It can do fuzzy search
on text indices and supports pluggable backends.

**Snowden currently sits at version `0.9.0`, we want some feedback before
making the API concrete. That said, we're pretty happy with this and using it
in production. Please send issues/pull requests if you have problems.**

The basic idea behind Snowden is captured in
[this paper](http://www.cs.cityu.edu.hk/~congwang/papers/INFOCOM10-search.pdf).

The search algorithm works by encrypting "wildcard strings" over the key in
the index that you're trying to encrypt. When you search you construct a wildcard
set over your search term. You encrypt the search wildcard set, and this
will produce a matching encrypted value in the stored wildcard set if any
of the wildcards overlap.

An example of this can be seen below:

```
Store: "bacon"

Wildcard set (size 1):

["bacon", "*bacon", "b*acon", "ba*con", "bac*on", "baco*n", "bacon*", "*acon", "b*con", "ba*on", "bac*n", "baco*"]

Search: "baco":

Wildcard set (size 1):

["baco", "*baco", "b*aco", "ba*co", "bac*o", "baco*", "*aco", "b*co", "ba*o", "bac*"]

Matches:

["baco*"]
```

The encryption we use for keys encrypts the same string as the same value
so this match can happen without the values being decrypted.


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

index    = Snowden.new_encrypted_index(aes_key, aes_iv)
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
require "redis"

redis = Redis.new(:driver => :hiredis)
redis_backend = Snowden::Backends::RedisBackend.new("index_namespace", redis)

aes_key = OpenSSL::Random.random_bytes(256/8)
aes_iv = OpenSSL::Random.random_bytes(128/8)

index = Snowden.new_encrypted_index(aes_key, aes_iv, redis_backend)
#...
```


## Configuration

Snowden has a core configuration object that allows you to change various
aspects of the gem's operation. Examples include:


###Changing the default backend used by indices
```ruby
require "redis"

redis = Redis.new(:driver => :hiredis)
redis_backend = Snowden::Backends::RedisBackend.new("index_namespace", redis)

Snowden.configuration.backend = redis_backend

#Sometime later:
aes_key = OpenSSL::Random.random_bytes(256/8)
aes_iv = OpenSSL::Random.random_bytes(128/8)

index = Snowden.new_encrypted_index(aes_key, aes_iv)
```

###Changing the cipher used by Snowden

```ruby
Snowden.configuration.cipher_spec = "RC4"

#Sometime later:
index = Snowden.new_encrypted_index(key, iv)
```

For a complete list of possible ciphers you can use this snippet in `irb`

```ruby
OpenSSL::Cipher.ciphers.each do |c| p c end; nil
```

The default cipher in Snowden is `AES-256-CBC` which we believe to be secure
enough for our purposes, your mileage may vary.

32 bytes of random padding are added to the front of ciphertexts in Snowden to
prevent the same value stored under many different index keys being
diffentiable when encrypted under the same key and IV.

##Implementing your own backends

A Snowden backend is a ruby class that:

* Can be constructed with a namespace
* Responds to `#save(key, value)` which returns nil
* Responds to `#find(key)` which returns all the values saved under that key

The two backends built into Snowden (in `lib/snowden/backends`) serve as
reference implementations of Snowden backends.

##How it works

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

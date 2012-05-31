# Carapace Changelog

## 0.1.2: Thursday 31st May 2012

Update to the ruby code so that it works with version 1.9.3.
The change that was required was to overcome an implicit cast that stopped working. The
solution was to provide an explicit cast. Regression tested to Ruby 1.8.6 and 1.8.7.

Testing was also performed with Rails 2.3.14, the last version in the 2.x series. The
test/rails_app built with Rails 2.0.2 did not work out of the box and so it has also
been updated for rails 2.3.14 while maintaining backward compatibility with Rails 2.0.2.

The changed files are
    `script/server`, `config/environment.rb` and `config/environments/development/rb`

When using the test/rails app on versions more recent than 2.0.2 run "rake rails:update"
prior to starting the server.

This version is the final version that is tested against Ruby 1.8 and Rails 2.x.

## 0.1.1: Thursday 31st May 2012

Update to the ruby code so that it works with version 1.8.7.
The change that was required was due to OpenSSL::Cipher no longer being a module
(the directive `include Cipher` as a module has been removed)
See the [Ruby 1.8.7 release news](http://svn.ruby-lang.org/repos/ruby/tags/v1_8_7/NEWS) where it says

    Remove redundant module namespace in Cipher, Digest, PKCS7, PKCS12.
    Compatibility classes are provided which will be removed in Ruby 1.9.

## 0.1.0: Wednesday 30th May 2012

Initial gem version

Written and tested against Ruby 1.8.6 and Rails 2.0.2

## Origin

The original Carapace code was written on 10th August 2007 for Ruby 1.8.6 and Rails 2.0.2.



# Carapace                     

Carapace enables encrypted transfer of HTTP form field values from
the view (client) to the controller (server).

The data is encrypted by the browser before being posted to the server. The 
server decrypts the data ready for processing.

Example uses are transfer of user passwords or credit card numbers.

## Installation

**This gem is for Rails 3.x. For Rails 2.x please use Carapace 0.1.2.**

1. Add it to your Gemfile:

        gem carapace

2. And then:

        $ bundle install

## Usage

Client-side, Carapace uses Javascript to perform encryption. Include this like so: 

        <%= javascript_include_tag 'carapace.js' %>
        <%= carapace_javascript %>

Alternatively, add `\\= require carapace` to the `app/assets/javascripts/application.js`
file instead of using `<% javascript_include_tag 'carapace.js' %>`.

Use the `carapace_encrypt` Javascript function on any form fields that
require encryption. For example:

        function onSubmit()
        {   
            carapace_encrypt(document.getElementById("user_password"));
        }   

Then, configure the form's `submit` button to call it: 

        <%= submit_tag "Add User", :class => "submit", :onclick => "onSubmit()" %>

On the server, mix Carapace into a Rails controller (_ApplicationController_) class:

        require 'carapace'
        include Carapace
    
Then use Carapace from within action methods:

        def index
          carapace_session    
          if request.post?
            @message=params[:message]
            carapace_decrypt! @message
          end 
        end 

**Warning:** if the controller rejects a post operation and re-displays itself
the data is not encrypted when sent to the browser. To maintain security,
such fields should be cleared before rendering the view.

## Testing

Test the gem with `rake test`. There is also a self-contained rails application
in `test\dummy` for further testing and education. See `test\dummy\README.md`
for more information.

## History

Carapace was originally written as part of a larger application in 2007 that needed
to provide a degree of security for sensitive data in situations where SSL could
not be used. 

The Carapace gem was created in 2012 to make it straightforward to re-use the 
original code in new applications. This was done primarily as a learning exercise.

For revision history see `CHANGELOG.md`.

## Acknowledgement

Carapace makes use of the [JSBN Library by Tom Wu](http://www-cs-students.stanford.edu/~tjw/jsbn/)
under the terms of its license (see file `LICENCE_JSBN`).

## About the Name

A _Carapace_ is the protective shell that covers and protects animals
such as crabs and turtles.

Definitions:
    [Oxford](http://oxforddictionaries.com/definition/carapace?q=carapace)
    [Cambridge](http://dictionary.cambridge.org/dictionary/british/carapace)

In a similar vein, this gem allows a protective shell to surround data sent from
a browser to a web server.

## License

Carapace is released under the MIT License. See LICENSE for details.

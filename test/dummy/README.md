# Test Rails Application for Carapace                                                 

This is the standard Rails 3 dummy application for gem testing, modified
to test the Carapace gem.

It comprises one controller with a single `index` action and the associated
view which does two things:

1. It provides an input field into which a user can enter a message. Upon
   submit the same index action is invoked.

2. If a message had been entered previously then that message is displayed
   as well as the input field described above.

To test Carapace inside the rails app:

        $ cd test/dummy
        $ rails server

  Navigate to the application (e.g. `http://localhost:3000`), enter a message
  in the input box and press `send`. The message should be displayed on the 
  screen.

  If you watch closely when pressing `send` the encrypted message text
  will be briefly visible in the message input box.

  If the gem was installed from [RubyGems.org](https://rubygems.org/gems/carapace)
  then `test/dummy` can be found at `$GEM_HOME/gems/carapace-0.2.0`.

## Modifications to test/dummy

This section describes the changes made to the default `test/dummy`.

    $ cd test/dummy

1. Create the message controller for testing

        $ rails generate controller Message index

2. Configure routes

       Set root route in `config/routes.rb`: 

        root :to => 'message#index'

       Add a post route to `config/routes.rb`: 

        post "message/index"

3. Write code

    Write test file `app/controllers/message_controller.rb`

    Write test file `app/views/message/index.html.erb`

    See *Source Code* section below.

4. Run 

        $ rails server

## Building

This section describes how to build an application from scratch.

1. Create a basic rails application:

        $ rails new rails_app
        $ cd rails_app

2. Add Carapace to Gemfile

       add `gem 'carapace', '>= 0.2.0'` to `Gemfile`

        $ bundle install

3. Follow steps 1 thru 3 from above

4. Delete default index file

        $ rm public/index.html

5. Run

        $ rails server

## Source Files

### `app/controllers/message_controller.rb`

        class MessageController < ApplicationController
    
          require 'carapace'
          include Carapace
    
          def index
            carapace_session
            if request.post?
              @message=params[:message]
              carapace_decrypt! @message
            end 
          end 
        end

### `app/views/message/index.html.erb`


        <%= javascript_include_tag 'carapace.js' %>
        <%= carapace_javascript %>
    
        <script class=javascript>
    
          function onSubmit()
          {
            carapace_encrypt(document.getElementById("message"));
          }
        </script>
    
    
        <h1>Send a message with Carapace </h1>
     
        <% unless @message.nil? %>
    
          <p> Received message: <%= @message %> </p>
    
        <% end %>
    
        <%= form_tag do %>
          Your message: <%= text_field_tag :message %>
          <%= submit_tag "Send", :class => "submit", :onclick => "onSubmit()" %>
        <% end %>

   Instead of using `javascript_include_tag` to load the Carapace Javascript, an
   alternative method is to add `\\= require carapace` to `app/assets/javascripts/application.js`.

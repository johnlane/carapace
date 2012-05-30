## Test Rails Application for Carapace

This is a small Rails application to test the Carapace gem.

It comprises one controller with a single "index" action and the associated
view which does two things:

1. It provides an input field into which a user can enter a message. Upon
   submit the same index action is invoked.

2. If a message had been entered previously then that message is displayed
   as well as the input field described above.

This test application does not include a database component (it is explicitly
disabled in config/environment.rb).

To test Carapace inside the rails app:

1. Run the embedded tests: `rake test`

2. Run the application: `script/server`. Naviagate to the application
   (e.g. http://localhost:3000), enter a message in the input box and
   press `send`. The message should be displayed on the screen.

   If you watch closely when pressing `send` the encrypted message text
   will be briefly visible in the message input box.

### Building

This section describes how to build the test application from scratch.

1. Install the gem:

    gem install carapace

2. Create a basic rails application:

    rails rails_app

3. Configure the environment:

  Disable unwanted frameworks. Add the below line to config/environment.rb 
  after the comment about skipping frameworks:

    config.frameworks -= [ :active_record, :action_mailer ]

  Set up the application root in `config/routes.rb`:

    map.root :controller => "message"

  Delete `public/index.html`:

  Set up Carapace:

    script/generate carapace

4. Create a controller

    script/generate controller Message index

  Write code in `app/controllers/message_controller.rb`:

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

  Write code in `app/views/message/index.html.erb`:

    <%= javascript_include_tag 'carapace.js' %>
    <%= carapace_javascript %>
    
    <script class=javascript>
    
      function onSubmit()
      {
        carapace_encrypt(document.getElementById("message"));
      }
    </script>                                                                                           
    
    
    <h1>Send a message with Carapace</h1>                                                                                         
    
    <% unless @message.nil? %>
    
      <p> Received message: <%= @message %> </p>
    
    <% end %>
    
    <% form_tag do %>
      Your message: <%= text_field_tag :message %>
      <%= submit_tag "Send", :class => "submit", :onclick => "onSubmit()" %>
    <% end %>

5. Test

  Write code in `test/functional/message_controller_test.rb`:

    require File.dirname(__FILE__) + '/../test_helper'                                                  
    
    class MessageControllerTest < ActionController::TestCase
    
      def test_index
        get :index
        assert_response :success
      end 
    end

  Run the tests:

    rake test

6. Run

    script/server

### License

See LICENSE in the gem.


module Carapace
  class Engine < ::Rails::Engine
    initializer 'carapace.load_static_assets' do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/vendor"
    end 
  end 
end 

class CarapaceGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "carapace.js", "public/javascripts/carapace.js"
    end
  end
end

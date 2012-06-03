require 'test_helper'

describe "static assets integration" do
  it "provides carapace.js on the asset pipeline" do
    visit '/assets/carapace.js'
    page.text.must_include 'Carapace.js'
  end 
end 

class HomeController < ApplicationController

def home
  render({:template=> "home/home.html.erb"})
end

end

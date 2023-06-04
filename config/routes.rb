Rails.application.routes.draw do

  get("/", { :controller => "home", :action => "home" })

end

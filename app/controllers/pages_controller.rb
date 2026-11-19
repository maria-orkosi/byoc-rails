class PagesController < ActionController::Base
  layout "application"

  def home
    render html: "<h1>Byoc Rails</h1><p>Byoc Rails runs on Orkosi from its own code.</p>".html_safe
  end
end
class RapletsController < ActionController::Base

  def index
    redirect_to('https://rapportive.com/raplets?' + {:preset => raplet_base_url + '/raplet'}.to_query)
  end

  def raplet
    if params[:show] == "metadata"
      jsonp_response(metadata)
    else
      jsonp_response(raplet_request)
    end
  end

  private

    def jsonp_response(json)
      render :text=>params[:callback].to_s+"("+JSON::parse(json.to_json).merge("status" => 200).to_json+")"
    end

    def raplet_request
      {
        :html=>"Hello #{params[:email]}",
        :css => File.read(Rails.application.assets['raplet.css'].pathname),
        :js => File.read(Rails.application.assets['raplet.js'].pathname)
      }
    end

    def metadata
      {
        :name => "Pipedrive",
        :description => "Close deals with the Pipedrive CRM.",
        :welcome_text => %q{
          <p>Install the <a href='http://pipedrive.com' target='_blank'>Pipedrive.com</a> Raplet provided by <a href='https://brandfolder.com' target='_blank'><strong>Brandfolder</strong></a>.</p>
          <p><a href='https://brandfolder.com' target='_blank'><img width="100%" src='https://brandfolder.com/brandfolder/logo'></a></p>
        },
        :icon_url => "https://pipedrive.herokuapp.com/pipedrive-icon.png",
        :small_icon_url => "https://pipedrive.herokuapp.com/favicon.ico",
        :data_provider_name => "Pipedrive",
        :preview_url => "https://pipedrive.herokuapp.com/pipedrive-preview.png",
        :dava_provider_url => "http://pipedrive.com",
        :provider_name => "Brandfolder",
        :provider_url => "https://brandfolder.com"
      }
    end  

    def raplet_base_url
      "#{request.scheme}://#{request.host}"
    end

end
class RapletsController < ActionController::Base
  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end

  def index
    render "index", :layout => "application"
  end

  def redirect_to_rapportive
    redirect_to('https://rapportive.com/raplets?' + {:preset => raplet_base_url + '/raplet/' + params[:api_key]}.to_query)    
  end

  def raplet
    if params[:show] == "metadata"
      jsonp_response(metadata)
    else
      jsonp_response(raplet_request)
    end
  end

  private

    def brandfolder_json(url)
      begin
        HTTParty.get("https://brandfolder.com/api/beta/brands.json", :query => { :url => url }).to_json
      rescue
        {:slug => ""}.to_json
      end
    end

    def pipedrive_search(email, api_key)
      begin
        HTTParty.get("https://api.pipedrive.com/v1/searchResults", :query => { :term => email, :start => 0, :limit => 0, :api_token => api_key }).to_json
      rescue
        {:success => "failed"}.to_json
      end
    end

    def jsonp_response(json)
      render :text=>params[:callback].to_s+"("+JSON::parse(json.to_json).merge("status" => 200).to_json+")"
    end

    def raplet_request
      url = params[:email].present? ? params[:email].split("@").last : ""
      bf_json = JSON.parse(brandfolder_json(url))
      pipedrive_json = JSON.parse(pipedrive_search(params[:email],params[:api_key]))
      {
        :html=> render_to_string(:partial => "response", :locals => {:bf => bf_json, :pipedrive => pipedrive_json}),
        :css => File.read(Rails.application.assets['raplet.css'].pathname),
        :js => File.read(Rails.application.assets['raplet.js'].pathname)
      }
    end

    def metadata
      {
        :name => "Brandfolder + Pipedrive",
        :description => "Easily find brand assets with Brandfolder, and close deals with Pipedrive.",
        :welcome_text => %q{
          <p>Install the raplet provided by <a href='https://brandfolder.com' target='_blank'><strong>Brandfolder</strong></a>.</p>
        },
        :icon_url => "https://brandfolder.com/brandfolder/assets/6bhwtxk7",
        :small_icon_url => "https://brandfolder.com/favicon.ico",
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
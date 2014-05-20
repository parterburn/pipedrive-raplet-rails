class RapletsController < ActionController::Base
  force_ssl if: :ssl_configured?

  PERSONAL = [/\Agmail\.com\z/i, /\Ahotmail\.com\z/i]

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

    def shared_domain?(url)
      (PERSONAL).map{|r| r === url }.compact.include?(true)
    end

    def brandfolder_json(url)
      begin
        if shared_domain?(url)
          raise NoSharedEmailLookups
        end
        HTTParty.get("https://brandfolder.com/api/beta/brands.json", :query => { :url => url }).to_json
      rescue => error
        p "*"*100
        p error.backtrace
        p "*"*100
        {:slug => ""}.to_json
      end
    end

    def pipedrive_search(email, api_key)
      begin
        match = JSON::parse(HTTParty.get("https://api.pipedrive.com/v1/searchResults/field", :query => { :field_type => "personField", :field_key => "email", :return_item_ids => 1, :exact_match => 0, :start => 0, :limit => 1, :term => email, :api_token => api_key }).to_json, :symbolize_names => true)
        HTTParty.get("https://api.pipedrive.com/v1/persons/#{match[:data][0][:id]}", :query => { :api_token => api_key }).to_json
      rescue
        {:success => false}.to_json
      end
    end

    def jsonp_response(json)
      status = json[:html].present? ? 200 : 404
      render :text=>params[:callback].to_s+"("+JSON::parse(json.to_json, :symbolize_names => true).merge("status" => status).to_json+")"
    end

    def raplet_request
      url = params[:email].present? ? params[:email].split("@").last : ""
      bf_json = JSON.parse(brandfolder_json(url), :symbolize_names => true)
      p "*"*100
      p url
      p "*"*100
      pipedrive_json = JSON.parse(pipedrive_search(params[:email],params[:api_key]), :symbolize_names => true) if params[:api_key].present?
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
        :icon_url => "https://pipedrive.herokuapp.com/brandfolder_logo_100x100.png",
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
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
        RestClient.get('https://brandfolder.com/api/beta/brands.json', {:params => {:url => url}})
      rescue
        {:slug => ""}.to_json
      end
    end

    def pipeline_search(email, api_key)
      begin
        RestClient.get('https://api.pipedrive.com/v1/searchResults', {:params => {:term => email, :start => 0, :limit => 1, :api_token => api_key}})
      rescue
        {:success => false}.to_json
      end
    end

    def jsonp_response(json)
      render :text=>params[:callback].to_s+"("+JSON::parse(json.to_json).merge("status" => 200).to_json+")"
    end

    def raplet_request
      url = params[:email].present? ? params[:email].split("@").last : ""
      bf_json = JSON.parse(brandfolder_json(url))
      pipeline_json = JSON.parse(pipeline_search(params[:email],params[:api_key]))
      {
        :html=> render_to_string(:partial => "response", :locals => {:bf_json => bf_json, :pipeline_json => pipeline_json}),
        :css => File.read(Rails.application.assets['raplet.css'].pathname),
        :js => File.read(Rails.application.assets['raplet.js'].pathname)
      }
    end

    def metadata
      {
        :name => "Pipedrive",
        :description => "Close deals with the Pipedrive CRM raplet provided by Brandfolder.com",
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
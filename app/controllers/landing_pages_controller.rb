class LandingPagesController < ActionController::Base
 layout "application"

  def index
  end

  def raplet
    email=params[:email]
    res={:html=>"Hello #{email}",:status=>200, :css=>'a{color:blue} ul{padding-left:20px;margin:4px 0;} link{color:blue;cursor:hand}', :js=>"$('.details-link').click(function(){ $('#'+this.id.replace('l','a')).toggle()})"}
    render :text=>params[:callback].to_s+"("+res.to_json+")"
  end

end
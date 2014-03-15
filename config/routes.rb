PipedriveRapletRails::Application.routes.draw do
  root 'raplets#index'
  post "redirect"          => 'raplets#redirect_to_rapportive'
  get  'raplet(/:api_key)' => 'raplets#raplet'
end

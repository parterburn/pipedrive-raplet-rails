PipedriveRapletRails::Application.routes.draw do
  root             'raplets#index'
  get  'raplet(/:api_key)' => 'raplets#raplet'
  get  'config'            => 'raplets#config'
  post 'config'            => 'raplets#config_post'
end

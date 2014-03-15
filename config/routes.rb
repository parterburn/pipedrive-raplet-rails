PipedriveRapletRails::Application.routes.draw do
  root             'landing_pages#index'
  get  'raplet' => 'landing_pages#raplet'
end

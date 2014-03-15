PipedriveRapletRails::Application.routes.draw do
  root             'raplets#index'
  get  'raplet' => 'raplets#raplet'
end

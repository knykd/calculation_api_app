Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'calc', to: 'results#calc'
  get 'grouping', to: 'results#grouping'
  get 'making_bignum', to: 'results#making_bignum'
  get 'most', to: 'results#most'
end
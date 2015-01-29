PGHeroine::Engine.routes.draw do
  scope ':database_name' do
    get '', to: "home#index", as: :root

    get "indexes", to: "home#indexes"
    get "space", to: "home#space"
    get "queries", to: "home#queries"
    get "query_stats", to: "home#query_stats"
    get "system_stats", to: "home#system_stats"
    get "tune", to: "home#tune"

    post "kill", to: "home#kill"
    post "kill_all", to: "home#kill_all"
    post "enable_query_stats", to: "home#enable_query_stats"
    post "reset_query_stats", to: "home#reset_query_stats"
  end
end

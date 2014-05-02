CatarseIntellectMoney::Engine.routes.draw do
  post "/notification" => "intellect_money#notification"
  get "/:contribution_id/review", {to: "intellect_money#review", as: "review"}
end

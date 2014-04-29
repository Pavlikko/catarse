CatarseIntellectMoney::Engine.routes.draw do
  post "/payment/intellectmoney/notification" => "application#notification"
end

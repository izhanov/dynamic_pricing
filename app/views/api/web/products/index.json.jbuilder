json.products do
  json.array! @products, :id, :name, :category, :default_price, :qty
end

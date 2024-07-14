json.products do
  json.array! @products do |product|
    json.id product.id
    json.name product.name
    json.default_price product.default_price
    json.categiry product.category
    json.rank
  end
end

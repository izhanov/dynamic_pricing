json.product do
  json.id @product.id
  json.name @product.name
  json.category @product.category
  json.default_price @product.default_price
  json.qty @product.qty
end

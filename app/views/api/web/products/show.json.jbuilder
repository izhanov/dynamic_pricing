json.product do
  json.id @product.id
  json.name @product.name
  json.category @product.category
  json.current_price @product.current_price
  json.qty @product.qty
  json.rank @product.rank
end

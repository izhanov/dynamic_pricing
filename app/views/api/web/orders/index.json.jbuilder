json.orders do
  json.array! @orders do |order|
    json.id order.id
    json.user_id order.user_id
    json.note order.note
    json.items do
      json.array! order.items do |item|
        json.id item.id
        json.qty item.qty
      end
    end
  end
end

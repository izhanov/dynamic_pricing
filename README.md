# README

This is a simple e-commerce platform with a dynamic pricing engine that adjusts product prices in real-time based on demand, inventory levels, and competitor prices. Dynamic pricing is a pricing strategy in which businesses set flexible prices for products or services based on current market demands. The goal of dynamic pricing is to allow a business to adjust prices on the fly in response to market demands, inventory levels, and competitor prices. Application devide on two parts: office and web. Office part is for managing products (import, show) and web part is for viewing products and placing orders.

## Requirements
- Ruby
- Rails
- MonogoDB
- Sidekiq
- Redis

## Installation

1. Clone the repository
```
git clone https://github.com/izhanov/dynamic_pricing.git
```

2. Add to ./config folder the master.key file (you can ask me for it)

3. Build the docker compose project
```
docker-compose build
```

4. Run the docker compose project
```
docker-compose up
```

## Dynamic pricing engine

The dynamic pricing system is implemented in a very simplified manner by selecting the maximum price from four possible conditions for price changes, namely:

1. The initial price when importing products (default_price in the Product model)
2. The price by demand (price_by_demand in the Product Dymamic Price model) - the price is calculated based on the rank of the product. Rank of the product updates every time when product was added to order. Rank of the product is calculated by the formula: `rank = previous_rank + (requested_qty) / 100.0` The price follows the rule:
 - If the rank above 7 the price is increased by 1.07 times.
 – Increase price can't be more than 75% of the initial price.

3. The price by inventory (price_by_inventory in the Product Dymamic Price model) - the price is calculated based on the qty of the product. The price is calculated by the follow rules:
 - If the product quantity (qty) is below 50, the price is increased by 1.5 times.
 - If the quantity is between 50 and 100, the price is increased by 1.2 times.
 - If the quantity is 300 or more, the price is decreased by 10%.
This rule processing in the background by the Sidekiq worker every 5 minutes.

4. The price by competition prices (price_by_competition in the Product Dymamic Price model) - the price is adjust from the competitor API. The competitor API is a simple API that returns the list of the product. The competitor API is called every 1 hour by the Sidekiq worker.

## Awailable endpoints (Recommended to use Postman)

1. __GET /api/office/products/import__ - import products from CSV file. CSV must be certain format. Example of CSV file: /spec/fixtures/inventory.csv

```bash
  curl 'localhost:3000/api/office/products/import' \--form 'file=@/path/to/file_name'
```

Response example:
If the file is successfully imported, the response will be:
  ```json
  {
    "success": true
  }
  ```

If the file wasn't imported, the response will be:
  ```json
  {
    "success": false,
    "error": [
      "validation_error",
      {
        "file": [
          "is missing"
        ]
      }
    ]
  }
  ```
If the file is not in CSV, the response will be:
  ```json
  {
    "success": false,
    "error": [
      "validation_error",
      {
        "file": [
          "file format is invalid"
        ]
      }
    ]
  }
  ```
2. __GET /api/office/products/:id__ - get product by id

```bash
  curl 'localhost:3000/api/office/products/668f9f878ff8747d73fea414'
```

Response example:
```json
{
  "product": {
        "id": "668f9f878ff8747d73fea414",
        "name": "MC Hammer Pants",
        "category": "Footwear",
        "default_price": "3005.0",
        "qty": 265
  }
}
```

3. __GET /api/web/products/__ - get all products

```bash
  curl 'localhost:3000/api/web/products'
```

Response example:
```json
{
  "products": [
    {
      "id": "668f9f878ff8747d73fea414",
      "name": "MC Hammer Pants",
      "category": "Footwear",
      "current_price": "3005.0",
      "qty": 265,
      "rank": 0.0
    },
    {
      "id": "668f9f878ff8747d73fea415",
      "name": "MC Hammer Pants",
      "category": "Footwear",
      "current_price": "3005.0",
      "qty": 265,
      "rank": 0.0
    }
  ]
}
```

4. __POST /api/web/orders__ - create order

```bash
  curl -X POST 'localhost:3000/api/web/orders' \--header 'Content-Type: application/json' \--data-raw '{
    "order": {
      "user_id": 42,
      "note": "I want to buy this product",
      "items": [
        {
          "id": "668f9f878ff8747d73fea414",
          "qty": 1
        },
        {
          "id": "668f9f878ff8747d73fea415",
          "qty": 1
        }
      ]
    }
  }'
```
Examples of responses:

If the order is successfully created, the response will be:
```json
{
  "order": {
    "id": "668f9f878ff8747d73fea414",
    "user_id": 42,
    "status": "pending" // Order status can be: pending, completed, canceled, failed (when some products are not enough qty in stock)
  }
}
```

If the order wasn't created, the response will be followed structure:
```json
{
  "success": false,
  "error": [
    "validation_error",
    {
      "items": [
        "is missing"
      ]
    }
  ]
}
```

5. __GET /api/web/orders/:id__ - get order by id

```bash
  curl 'localhost:3000/api/web/orders/668f9f878ff8747d73fea414'
```

Response example:
```json
{
  "order": {
    "id": "668f9f878ff8747d73fea414",
    "user_id": 42,
    "note": "I want to buy this product",
    "items": [
      {
        "id": "668f9f878ff8747d73fea414",
        "qty": 10,
        "price": "3005.0",
        "qty": 265,
        "rank": 0.0,
        "requested_qty": 1,
        "state": "ok"
      },
      {
        "id": "668f9f878ff8747d73fea415",
        "qty": 1,
        "price": "3005.0",
        "requested_qty": 265,
        "rank": 0.0,
        "state": "not_enough_qty" // this product is not enough qty in stock
      }
    ]
  }
}
```
6. __GET /api/web/orders__ - get all orders

```bash
  curl 'localhost:3000/api/web/orders'
```

Response example:
```json
{
  "orders": [
    {
      "id": "668f9f878ff8747d73fea414",
      "user_id": 42,
      "note": "I want to buy this product",
      "status": "pending",
      "items": [
        {
          "id": "668f9f878ff8747d73fea414",
          "qty": 10,
          "price": "3005.0",
          "qty": 265,
          "rank": 0.0,
          "requested_qty": 1,
          "state": "ok"
        },
        {
          "id": "668f9f878ff8747d73fea415",
          "qty": 1,
          "price": "3005.0",
          "requested_qty": 265,
          "rank": 0.0,
          "state": "not_enough_qty"
        }
      ]
    },
    {
      "id": "668f9f878ff8747d73fea415",
      "user_id": 42,
      "note": "I want to buy this product",
      "status": "pending",
      "items": [
        {
          "id": "668f9f878ff8747d73fea414",
          "qty": 10,
          "price": "3005.0",
          "qty": 265,
          "rank": 0.0,
          "requested_qty": 10,
          "state": "ok"
        },
        {
          "id": "668f9f878ff8747d73fea415",
          "qty": 30,
          "price": "3005.0",
          "requested_qty": 5,
          "rank": 0.0,
          "state": "ok"
        }
      ]
    }
  ]
}
```

# King's Cup Coffee: UI-to-API Mapping (Laravel REST API)

This document provides a mapping between the UI components designed in Stitch and the Laravel REST API resources defined in your backend architecture.

## 1. Customer Home & Menu Catalog
**Target Screens:** `{{DATA:SCREEN:SCREEN_21}}` (Home), `{{DATA:SCREEN:SCREEN_5}}` (Menu)
**API Endpoint:** `GET /api/products` (Returns `ProductResource`)

| UI Element | API Field | Data Type |
| :--- | :--- | :--- |
| Product Name | `data[].name` | String |
| Product Price | `data[].variations[0].price` | Float (₱) |
| Product Image | `data[].image` | String (URL) |
| Category Filter | `data[].category` | String |
| Description | `data[].description` | String |
| Availability | `data[].available` | Boolean |

## 2. Product Detail & Customization
**Target Screen:** `{{DATA:SCREEN:SCREEN_23}}` (Product Detail)
**API Endpoint:** `GET /api/products/{id}`

| UI Element | API Field | Data Type |
| :--- | :--- | :--- |
| Variations (Hot/Iced) | `data.variations` | Array<Variation> |
| Modifiers (Syrups/Shots) | `GET /api/modifiers` | Array<Modifier> |
| Total Price Calculation | `(variation.price + sum(modifiers.price)) * quantity` | Logic |

## 3. Checkout & Order Placement
**Target Screen:** `{{DATA:SCREEN:SCREEN_24}}` (Checkout)
**API Endpoint:** `POST /api/orders`

| UI Payload Field | Source / Logic |
| :--- | :--- |
| `address_id` | Selected ID from `GET /api/user/addresses` |
| `items[].product_id` | Current Product ID |
| `items[].variation_id` | Selected Variation ID |
| `items[].selected_modifiers` | JSON array of selected modifier objects |
| `total_amount` | Calculated total (₱) |
| `notes` | Value from "Special Instructions" field |

## 4. Barista Dashboard (Active Queue)
**Target Screen:** `{{DATA:SCREEN:SCREEN_18}}` (Barista Dashboard)
**API Endpoint:** `GET /api/orders?status=pending,preparing` (Returns `OrderResource`)

| UI Element | API Field | Data Type |
| :--- | :--- | :--- |
| Order ID Badge | `data[].order_id` | String |
| Customer Name | `data[].customer.name` | String |
| Order Status | `data[].status` | Enum (pending, preparing, etc) |
| Items List | `data[].items` | Array<OrderItem> |
| Action Button (Ready) | `PATCH /api/orders/{id} { "status": "preparing" }` | API Call |

## 5. Inventory Management
**Target Screen:** `{{DATA:SCREEN:SCREEN_20}}` (Inventory Management)
**API Endpoint:** `GET /api/products`

| UI Element | API Field | Data Type |
| :--- | :--- | :--- |
| Stock Toggle (Available) | `data[].available` | Boolean |
| Update Status | `PATCH /api/products/{id} { "is_available": true/false }` | API Call |
| Low Stock Warning | Logic: `if (stock_level < threshold)` | UI State |

## 6. User Profile & Loyalty
**Target Screen:** `{{DATA:SCREEN:SCREEN_19}}` (User Profile)
**API Endpoint:** `GET /api/user`

| UI Element | API Field | Data Type |
| :--- | :--- | :--- |
| Royal Circle Points | `data.loyalty_points` | Integer |
| Default Address | `data.addresses.find(is_default)` | Object |
| Saved Payments | `data.payment_methods` | Array |

---

### Implementation Note for Antigravity MCP:
Use the **Laravel API Resource** structure to ensure the JSON keys in your Flutter `KingCupClient` match these mappings exactly. All price fields are handled as `Double` in Dart to support the Philippine Peso (₱) decimal values.

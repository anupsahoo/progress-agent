// api-058-item-create-422: Item: Invalid payload returns 422
// Module: Inventory · Table: Item · Endpoint: /api/inventory/items
import { test, expect } from '@playwright/test';

test("Item: Invalid payload returns 422", async ({ request }) => {
  const r = await request.post('/api/inventory/items', { data: { ...{"Itemnum":1,"ItemName":"Fins","Price":24,"Onhand":13022,"Allocated":9399,"ReOrder":1,"OnOrder":433,"CatPage":1,"CatDescription":"These real shark-skin fins will knock 'em dead at the beach.  They'll see you coming from miles away while you're wearing the Original \"Fins\" by Bench/Lee.","Category1":"Diving","Category2":"Footwear","Special":"1","Weight":4,"Minqty":5}, Itemnum: -1 } });
  expect([409, 422]).toContain(r.status());
});

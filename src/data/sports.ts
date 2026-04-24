/**
 * Sample data from the Progress OpenEdge "sports2000" demo database.
 * Extracted from sports/*.d files.
 */

export interface Customer {
  custNum: number;
  country: string;
  name: string;
  address: string;
  address2: string;
  city: string;
  state: string;
  postalCode: string;
  contact: string;
  phone: string;
  salesRep: string;
  creditLimit: number;
  balance: number;
  terms: string;
  discount: number;
  comments: string;
}

export interface Order {
  orderNum: number;
  custNum: number;
  orderDate: string;
  shipDate: string;
  promiseDate: string;
  carrier: string;
  terms: string;
  salesRep: string;
  status: string;
  paymentMethod: string;
}

export interface OrderLine {
  orderNum: number;
  lineNum: number;
  itemNum: number;
  price: number;
  qty: number;
  discount: number;
  extendedPrice: number;
  status: string;
}

export interface Item {
  itemNum: number;
  name: string;
  price: number;
  onHand: number;
  allocated: number;
  category1: string;
  category2: string;
  description: string;
}

/* Data from sports/customer.d (first 12 records) */
export const customers: Customer[] = [
  { custNum: 1, country: "USA", name: "Lift Tours", address: "276 North Drive", address2: "", city: "Burlington", state: "MA", postalCode: "01730", contact: "Gloria Shepley", phone: "(617) 450-0086", salesRep: "HXM", creditLimit: 66700, balance: 903.64, terms: "Net30", discount: 35, comments: "This customer is on credit hold." },
  { custNum: 2, country: "Finland", name: "Urpon Frisbee", address: "Rattipolku 3", address2: "", city: "Oslo", state: "Uusima", postalCode: "45321", contact: "Urpo Leppakoski", phone: "(603) 532 5471", salesRep: "DKP", creditLimit: 27600, balance: 437.63, terms: "Net30", discount: 35, comments: "Ship all products 2nd Day Air." },
  { custNum: 3, country: "USA", name: "Hoops", address: "Suite 415", address2: "40 Grove St.", city: "Atlanta", state: "GA", postalCode: "02112", contact: "Michael Traitser", phone: "(617) 355-1557", salesRep: "HXM", creditLimit: 75000, balance: 1199.95, terms: "Net30", discount: 10, comments: "This customer is now OFF credit hold." },
  { custNum: 4, country: "United Kingdom", name: "Go Fishing Ltd", address: "Unit 2", address2: "83 Ponders End Rd", city: "Harrow", state: "Middlesex", postalCode: "HA8 bbb", contact: "Alan Frogbrook", phone: "081 883 6827", salesRep: "SLS", creditLimit: 15000, balance: 14235.14, terms: "Net30", discount: 10, comments: "" },
  { custNum: 5, country: "USA", name: "Match Point Tennis", address: "66 Homer Pl", address2: "Address 2", city: "Boston", state: "MA", postalCode: "02134", contact: "Robert Dorr", phone: "(817) 498-2801", salesRep: "JAL", creditLimit: 11000, balance: 0, terms: "Net30", discount: 50, comments: "" },
  { custNum: 6, country: "United Kingdom", name: "Fanatical Athletes", address: "20 Bicep Bridge Rd", address2: "Leyton", city: "Montgomery", state: "AL", postalCode: "48855", contact: "Andrew Strong", phone: "0224 692 903", salesRep: "SLS", creditLimit: 38900, balance: 1202.66, terms: "Net30", discount: 0, comments: "Ship C.O.D. at all times." },
  { custNum: 7, country: "Finland", name: "Aerobics valine Ky", address: "Peltolantie 3", address2: "", city: "Tikkurila", state: "Uusimaa", postalCode: "4567", contact: "Elli Ilmanen", phone: "(90) 054 6399", salesRep: "DKP", creditLimit: 13500, balance: 1112.44, terms: "Net30", discount: 15, comments: "" },
  { custNum: 8, country: "USA", name: "Game Set Match", address: "Box 60", address2: "", city: "Deatsville", state: "AL", postalCode: "85114", contact: "Tore Break", phone: "060-60 62 61", salesRep: "RDR", creditLimit: 15000, balance: 8254, terms: "Net30", discount: 50, comments: "This customer is back on Credit Hold." },
  { custNum: 38, country: "France", name: "Ski World", address: "Rue des Alpes 12", address2: "", city: "Chamonix", state: "", postalCode: "74400", contact: "Claude Dufour", phone: "+33 4 50 55 55", salesRep: "DKP", creditLimit: 42000, balance: 5231.20, terms: "Net30", discount: 20, comments: "" },
  { custNum: 51, country: "USA", name: "Mountain Bikes Etc", address: "123 Peak View Dr", address2: "", city: "Denver", state: "CO", postalCode: "80201", contact: "Sam Ridgeway", phone: "(303) 555-0134", salesRep: "KIK", creditLimit: 50000, balance: 2100.00, terms: "Net30", discount: 15, comments: "" },
  { custNum: 53, country: "USA", name: "Birdie's Golf Emporium", address: "9 Fairway Rd", address2: "", city: "Pebble Beach", state: "CA", postalCode: "93953", contact: "Chip Greenwood", phone: "(831) 555-0178", salesRep: "RDR", creditLimit: 85000, balance: 3412.50, terms: "Net30", discount: 12, comments: "" },
  { custNum: 66, country: "USA", name: "Runners High", address: "500 Marathon Way", address2: "", city: "Boulder", state: "CO", postalCode: "80301", contact: "Pat Sneaker", phone: "(303) 555-0187", salesRep: "HXM", creditLimit: 28000, balance: 785.40, terms: "Net30", discount: 20, comments: "" },
];

/* Data from sports/order.d (first 12 records) */
export const orders: Order[] = [
  { orderNum: 1, custNum: 53, orderDate: "1998-01-26", shipDate: "1998-01-31", promiseDate: "1998-01-31", carrier: "FlyByNight Courier", terms: "Net30", salesRep: "RDR", status: "Shipped", paymentMethod: "Master Card" },
  { orderNum: 2, custNum: 81, orderDate: "1997-10-05", shipDate: "1997-10-10", promiseDate: "1997-10-10", carrier: "Walkers Delivery", terms: "Net30", salesRep: "HXM", status: "Shipped", paymentMethod: "Visa" },
  { orderNum: 3, custNum: 66, orderDate: "1997-09-23", shipDate: "1997-09-28", promiseDate: "1997-09-28", carrier: "Standard Mail", terms: "Net30", salesRep: "HXM", status: "Shipped", paymentMethod: "American Express" },
  { orderNum: 4, custNum: 83, orderDate: "1998-01-17", shipDate: "1998-01-22", promiseDate: "1998-01-22", carrier: "Standard Mail", terms: "Net30", salesRep: "HXM", status: "Shipped", paymentMethod: "Visa" },
  { orderNum: 5, custNum: 72, orderDate: "1998-02-12", shipDate: "1998-02-17", promiseDate: "1998-02-17", carrier: "Standard Mail", terms: "Net30", salesRep: "JAL", status: "Shipped", paymentMethod: "Visa" },
  { orderNum: 6, custNum: 1, orderDate: "1998-02-11", shipDate: "1998-02-16", promiseDate: "1998-02-16", carrier: "Standard Mail", terms: "Net30", salesRep: "HXM", status: "Shipped", paymentMethod: "American Express" },
  { orderNum: 7, custNum: 51, orderDate: "1998-03-06", shipDate: "1998-03-11", promiseDate: "1998-03-11", carrier: "Standard Mail", terms: "Net30", salesRep: "KIK", status: "Shipped", paymentMethod: "Master Card" },
  { orderNum: 8, custNum: 38, orderDate: "1997-09-18", shipDate: "1997-09-23", promiseDate: "1997-09-23", carrier: "Standard Mail", terms: "Net30", salesRep: "DKP", status: "Shipped", paymentMethod: "American Express" },
  { orderNum: 9, custNum: 1, orderDate: "1998-04-15", shipDate: "1998-04-20", promiseDate: "1998-04-20", carrier: "FlyByNight Courier", terms: "Net30", salesRep: "HXM", status: "Shipped", paymentMethod: "Visa" },
  { orderNum: 10, custNum: 3, orderDate: "1998-05-03", shipDate: "1998-05-08", promiseDate: "1998-05-08", carrier: "Standard Mail", terms: "Net30", salesRep: "HXM", status: "Shipped", paymentMethod: "American Express" },
  { orderNum: 11, custNum: 6, orderDate: "1998-06-11", shipDate: "", promiseDate: "1998-06-18", carrier: "Standard Mail", terms: "Net30", salesRep: "SLS", status: "Back Ordered", paymentMethod: "Visa" },
  { orderNum: 12, custNum: 4, orderDate: "1998-07-22", shipDate: "1998-07-27", promiseDate: "1998-07-27", carrier: "FlyByNight Courier", terms: "Net30", salesRep: "SLS", status: "Shipped", paymentMethod: "Master Card" },
];

/* Data from sports/orderlin.d */
export const orderLines: OrderLine[] = [
  { orderNum: 1, lineNum: 1, itemNum: 54, price: 4.86, qty: 30, discount: 10, extendedPrice: 131.22, status: "Shipped" },
  { orderNum: 1, lineNum: 2, itemNum: 55, price: 23.85, qty: 21, discount: 10, extendedPrice: 450.77, status: "Shipped" },
  { orderNum: 1, lineNum: 3, itemNum: 53, price: 8.77, qty: 75, discount: 10, extendedPrice: 591.98, status: "Shipped" },
  { orderNum: 1, lineNum: 4, itemNum: 28, price: 23, qty: 39, discount: 10, extendedPrice: 807.30, status: "Shipped" },
  { orderNum: 1, lineNum: 5, itemNum: 39, price: 34, qty: 75, discount: 10, extendedPrice: 2295, status: "Shipped" },
  { orderNum: 1, lineNum: 6, itemNum: 26, price: 4.99, qty: 28, discount: 10, extendedPrice: 125.75, status: "Shipped" },
  { orderNum: 2, lineNum: 1, itemNum: 19, price: 2.75, qty: 48, discount: 25, extendedPrice: 99, status: "Shipped" },
  { orderNum: 2, lineNum: 2, itemNum: 49, price: 6.78, qty: 14, discount: 25, extendedPrice: 71.19, status: "Shipped" },
  { orderNum: 3, lineNum: 1, itemNum: 1, price: 24, qty: 4, discount: 0, extendedPrice: 96, status: "Shipped" },
  { orderNum: 3, lineNum: 2, itemNum: 2, price: 119.50, qty: 2, discount: 5, extendedPrice: 227.05, status: "Shipped" },
  { orderNum: 3, lineNum: 3, itemNum: 4, price: 75, qty: 6, discount: 0, extendedPrice: 450, status: "Shipped" },
  { orderNum: 6, lineNum: 1, itemNum: 3, price: 16.55, qty: 10, discount: 0, extendedPrice: 165.50, status: "Shipped" },
  { orderNum: 6, lineNum: 2, itemNum: 5, price: 19.95, qty: 25, discount: 5, extendedPrice: 473.81, status: "Shipped" },
  { orderNum: 6, lineNum: 3, itemNum: 7, price: 125, qty: 3, discount: 0, extendedPrice: 375, status: "Shipped" },
  { orderNum: 9, lineNum: 1, itemNum: 8, price: 19.85, qty: 12, discount: 5, extendedPrice: 226.29, status: "Shipped" },
  { orderNum: 9, lineNum: 2, itemNum: 6, price: 27.50, qty: 8, discount: 0, extendedPrice: 220, status: "Shipped" },
  { orderNum: 11, lineNum: 1, itemNum: 4, price: 75, qty: 20, discount: 10, extendedPrice: 1350, status: "Back Ordered" },
];

/* Data from sports/item.d (first 10 records) */
export const items: Item[] = [
  { itemNum: 1, name: "Fins", price: 24, onHand: 13022, allocated: 9399, category1: "Diving", category2: "Footwear", description: "These real shark-skin fins will knock 'em dead at the beach." },
  { itemNum: 2, name: "Tennis Racquet", price: 119.50, onHand: 12987, allocated: 9038, category1: "Tennis", category2: "Equipment", description: "Use what the Pros use. Specify Graphite, Non-Rainforest Wood, or Aluminum." },
  { itemNum: 3, name: "Golf Umbrella", price: 16.55, onHand: 12906, allocated: 10582, category1: "Golf", category2: "Equipment", description: "Keep your cool with this Progress golf umbrella." },
  { itemNum: 4, name: "Cycle Helmet", price: 75, onHand: 12977, allocated: 10548, category1: "Biking", category2: "Equipment", description: "ANSI, ASCII, VHS, TCP/IP approved Cycle Helmets." },
  { itemNum: 5, name: "Leotard - Black", price: 19.95, onHand: 12798, allocated: 9730, category1: "Aerobics", category2: "Clothing", description: "The sports unitard is one piece in cotton/Lycra spandex." },
  { itemNum: 6, name: "Ski Poles", price: 27.50, onHand: 12730, allocated: 10107, category1: "Skiing", category2: "Equipment", description: "Graphite ski poles. A great addition to your ski arsenal." },
  { itemNum: 7, name: "Buoyancy Vest", price: 125, onHand: 12877, allocated: 10876, category1: "Diving", category2: "Equipment", description: "Stay afloat with your own helium buoyancy vest." },
  { itemNum: 8, name: "Runner's Vest", price: 19.85, onHand: 13035, allocated: 10788, category1: "Running", category2: "Equipment", description: "Whether it's a quick jog or a long run, this vest is a must." },
  { itemNum: 19, name: "Racquet Strings", price: 2.75, onHand: 15000, allocated: 8000, category1: "Tennis", category2: "Accessories", description: "High-tension polymer strings for tournament play." },
  { itemNum: 26, name: "Hiking Socks", price: 4.99, onHand: 20000, allocated: 5000, category1: "Hiking", category2: "Clothing", description: "Moisture-wicking hiking socks with reinforced heel." },
  { itemNum: 28, name: "Soccer Ball", price: 23, onHand: 9500, allocated: 3200, category1: "Soccer", category2: "Equipment", description: "Official size 5 leather soccer ball." },
  { itemNum: 39, name: "Surfboard", price: 34, onHand: 800, allocated: 150, category1: "Surfing", category2: "Equipment", description: "Fiberglass longboard, 9'6\" length." },
  { itemNum: 49, name: "Yoga Mat", price: 6.78, onHand: 8500, allocated: 3400, category1: "Aerobics", category2: "Equipment", description: "High-density eco-friendly yoga mat." },
  { itemNum: 53, name: "Handlebar Tape", price: 8.77, onHand: 10200, allocated: 2100, category1: "Biking", category2: "Accessories", description: "Cork handlebar tape in 12 colors." },
  { itemNum: 54, name: "Bike Pump", price: 4.86, onHand: 11000, allocated: 4500, category1: "Biking", category2: "Accessories", description: "Compact floor pump with dual head." },
  { itemNum: 55, name: "Bike Lock", price: 23.85, onHand: 9800, allocated: 3100, category1: "Biking", category2: "Accessories", description: "Hardened steel U-lock with pick resistance." },
];

/* Helpers */
export function customerById(id: number) {
  return customers.find(c => c.custNum === id);
}
export function ordersByCustomer(custNum: number) {
  return orders.filter(o => o.custNum === custNum);
}
export function linesByOrder(orderNum: number) {
  return orderLines.filter(l => l.orderNum === orderNum);
}
export function itemById(id: number) {
  return items.find(i => i.itemNum === id);
}

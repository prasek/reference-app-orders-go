import { writable } from 'svelte/store';

export interface Item {
	sku: string;
	description?: string;
}
export interface OrderItem extends Item {
	quantity: number;
}

export type OrderStatus =
	| 'pending'
	| 'processing'
	| 'customerActionRequired'
	| 'completed'
	| 'cancelled';

export interface Order {
	id: string;
	customerId: string;
	items: OrderItem[];
	fulfillments?: Fulfillment[];
	status: OrderStatus;
}

export type FulfillmentStatus = 'unavailable' | 'pending' | 'processing' | 'completed' | 'failed';

export interface Fulfillment {
	id: string;
	shipment?: Shipment;
	items: OrderItem[];
	payment?: Payment;
	location: string;
	status?: FulfillmentStatus;
}

export interface Shipment {
	id: string;
	status: string;
	items: OrderItem[];
	updatedAt: string;
}

export type PaymentStatus = 'pending' | 'success' | 'failed';

export interface Payment {
	shipping: number;
	tax: number;
	subTotal: number;
	total: number;
	status: PaymentStatus;
}

export type Action = 'amend' | 'cancel';

export const order = writable<Order | undefined>();

export const generateOrders = (quantity: number): Order[] => {
	const orders = [];
	for (let i = 0; i < quantity; i++) {
		const shuffledItems = shoes.sort(() => 0.5 - Math.random());
		const n = Math.floor(Math.random() * 5) + 1;
		const selected = shuffledItems.slice(0, n);
		orders.push({
			id: `A${i + 1}-${Date.now()}`,
			customerId: '1234',
			status: 'pending',
			items: selected.map((item) => ({ ...item, quantity: Math.floor(Math.random() * 3) + 1 }))
		});
	}
	return orders;
};

export const shoes: Item[] = [
	{
		sku: 'Nike Air Force Ones',
		description:
			'The Nike Air Force Ones combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Adidas Superstar',
		description: 'The Adidas Superstar is the shoe. The one you know. The one you love.'
	},
	{
		sku: 'Adidas UltraBoost',
		description:
			'The Adidas UltraBoost combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Reebok Classic Leather White',
		description:
			'The Reebok Classic Leather combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Puma Suede Classic',
		description:
			'The Puma Suede Classic combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'New Balance 574',
		description:
			'The New Balance 574 combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Vans Old Skool',
		description:
			'The Vans Old Skool combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Converse Chuck Taylor All Star',
		description:
			'The Converse Chuck Taylor All Star combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Jordan Air Jordan 1',
		description:
			'The Jordan Air Jordan 1 combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Asics GEL-Kayano',
		description:
			'The Asics GEL-Kayano combines timeless style with modern comfort, featuring premium materials and cutting-edge technology for unmatched performance.'
	},
	{
		sku: 'Nike Air Force Twos',
		description:
			'A second iteration of the classic, the Nike Air Force Twos Model 11 is redesigned for the modern athlete, offering enhanced cushioning and durability.'
	},
	{
		sku: 'Reebok Classic Leather Black',
		description:
			"Reebok's Classic Leather Model 13 is the epitome of retro chic, offering unparalleled comfort and a sleek design for everyday wear."
	},
	{
		sku: 'Vans New Skool',
		description:
			'Vans New Skool Model 16 reintroduces the classic skate shoe with updated features for enhanced performance and comfort.'
	},
	{
		sku: 'Converse Chuck Taylor Model 17',
		description:
			'Model 17 of the Converse Chuck Taylor All Star elevates the iconic silhouette with premium materials and an improved insole for all-day comfort.'
	},
	{
		sku: 'Under Armour HOVR Sonic',
		description:
			'The latest Under Armour HOVR Sonic, Model 18, offers an unparalleled ride, blending the perfect balance of cushioning and energy return.'
	},
	{
		sku: 'Jordan Air Jordan 2',
		description:
			'Jordan Air Jordan 2 Model 19 continues the legacy, integrating classic design lines with modern technology for a timeless look and feel.'
	},
	{
		sku: 'Asics GEL-Tres',
		description:
			'Asics GEL-Tres Model 20 is the latest in the series, offering improved stability and support for overpronators.'
	}
];

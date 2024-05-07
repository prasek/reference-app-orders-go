<script lang="ts">
	import { shoes, type Order, type OrderItem } from '$lib/types/order';

	export let order: Order;

	let items: OrderItem[] = shoes
		.map((s) => ({ ...s, quantity: 0 }))
		.sort((a, b) => a.sku.localeCompare(b.sku));

	$: order.items = items.filter((i) => i?.quantity > 0);
</script>

<div class="container">
	{#each items as i}
		<div class="item">
			<input type="number" max="99" min="0" bind:value={i.quantity} />
			<h3>{i.sku}</h3>
		</div>
	{/each}
</div>

<style>
	.container {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}
	.item {
		display: flex;
		flex-direction: row;
		gap: 0.5rem;
		align-items: center;
	}

	input {
		font-size: 1.25rem;
		font-weight: 900;
		border-radius: 4px;
		background-color: var(--color-theme-2);
		width: 3rem;
		height: 2rem;
		display: flex;
		justify-content: center;
		align-items: center;
		color: white;
	}
</style>

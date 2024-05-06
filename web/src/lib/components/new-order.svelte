<script lang="ts">
	import { shoes, type OrderItem } from '$lib/types/order';

	let items: OrderItem[] = [];

  const defaultItem = {
    sku: shoes[0].sku,
    quantity: 1,
    description: shoes[0].description
  }
  let item = { ...defaultItem };

  const addItem = () => {
    items = [...items, item]
    item = { ...defaultItem };
  }
</script>

<div class="details">
    <input type="number" bind:value={item.quantity} />
    <select bind:value={item.sku}>
      {#each shoes as item}
        <option value={item.sku}>{item.sku}</option>
      {/each}
    </select>
    <button on:click={addItem}>Add</button>
		{#each items as i}
			<div class="item">
        <div class="item-header">
          <div class="quantity">{i.quantity}</div>
          <div>{i.sku}</div>  
        </div>
			</div>
		{/each}
</div>

<style>
	.item {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.item-header {
		display: flex;
		gap: 1rem;
		align-items: center;
	}
</style>

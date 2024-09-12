# Services

## Billing Service

The billing service is used for all billing related operations.

See [OMS Reference Application GitHub](https://github.com/prasek/reference-app-orders-go/blob/nexus-cloud/app/billing/api.go) for details.

```go
const BillingServiceName = "billing"
const ChargeOperationName = "charge"

// Item represents an item being ordered.
type Item struct {
	SKU      string `json:"sku"`
	Quantity int32  `json:"quantity"`
}

// ChargeInput is the input for the Charge workflow.
type ChargeInput struct {
	CustomerID     string `json:"customerId"`
	Reference      string `json:"orderReference"`
	Items          []Item `json:"items"`
	IdempotencyKey string `json:"idempotencyKey,omitempty"`
}

// ChargeResult is the result for the Charge workflow.
type ChargeResult struct {
	InvoiceReference string `json:"invoiceReference"`
	SubTotal         int32  `json:"subTotal"`
	Shipping         int32  `json:"shipping"`
	Tax              int32  `json:"tax"`
	Total            int32  `json:"total"`

	Success  bool   `json:"success"`
	AuthCode string `json:"authCode"`
}
```

## Operation: charge

The `charge` operation is used to charge a customer for their purchase.

Example usage:

```go
const BillingServiceName = "billing"
const BillingServiceName = "billing"
const ChargeOperationName = "charge"

// Replace ExecuteActivity with ExecuteOperation
billingService := workflow.NewNexusClient(BillingEndpointName, BillingServiceName)
c := billingService.ExecuteOperation(ctx,
    billing.ChargeOperationName,
    &ChargeInput{
        CustomerID:     f.customerID,
        Reference:      f.ID,
        Items:          billingItems,
        IdempotencyKey: chargeKey,
    },
    workflow.NexusOperationOptions{
        ScheduleToCloseTimeout: 3600 * time.Second,
    })

if err := c.Get(ctx, &charge); err != nil {
    f.Payment.Status = PaymentStatusFailed
    return err
}

```

### Input Type

```go
// ChargeInput is the input for the `charge` operation.
type ChargeInput struct {
	CustomerID     string `json:"customerId"`
	Reference      string `json:"orderReference"`
	Items          []Item `json:"items"`
	IdempotencyKey string `json:"idempotencyKey,omitempty"`
}
```

### Output Type

```go
// ChargeResult is the result for the `charge` operation.
type ChargeResult struct {
	InvoiceReference string `json:"invoiceReference"`
	SubTotal         int32  `json:"subTotal"`
	Shipping         int32  `json:"shipping"`
	Tax              int32  `json:"tax"`
	Total            int32  `json:"total"`

	Success  bool   `json:"success"`
	AuthCode string `json:"authCode"`
}
```
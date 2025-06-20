package billing

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/nexus-rpc/sdk-go/nexus"
	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/temporalnexus"
)

// Nexus Billing Service
const BillingServiceName = "billing"
const ChargeOperationName = "charge"

// TaskQueue is the default task queue for the Billing system.
const TaskQueue = "billing"

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

// GenerateInvoiceInput is the input for the GenerateInvoice activity.
type GenerateInvoiceInput struct {
	CustomerID string `json:"customerId"`
	Reference  string `json:"orderReference"`
	Items      []Item `json:"items"`
}

// GenerateInvoiceResult is the result for the GenerateInvoice activity.
type GenerateInvoiceResult struct {
	InvoiceReference string `json:"invoiceReference"`
	SubTotal         int32  `json:"subTotal"`
	Shipping         int32  `json:"shipping"`
	Tax              int32  `json:"tax"`
	Total            int32  `json:"total"`
}

// ChargeCustomerInput is the input for the ChargeCustomer activity.
type ChargeCustomerInput struct {
	CustomerID string `json:"customerId"`
	Reference  string `json:"reference"`
	Charge     int32  `json:"charge"`
}

// ChargeCustomerResult is the result for the GenerateInvoice activity.
type ChargeCustomerResult struct {
	Success  bool   `json:"success"`
	AuthCode string `json:"authCode"`
}

// ChargeWorkflowID returns the workflow ID for a Charge workflow.
func ChargeWorkflowID(input ChargeInput) string {
	// If an idempotency key is provided, use it as the workflow ID.
	// This ensures that the same charge is not processed multiple times.
	key := input.IdempotencyKey
	if key == "" {
		// If no idempotency key is provided, generate a random one.
		// This will not offer any idempotency guarantees.
		key = uuid.NewString()
	}

	return fmt.Sprintf("Charge:%s", key)
}

// Async Nexus Operation Handler to replace handleCharge
var ChargeOperation = temporalnexus.NewWorkflowRunOperation(
	ChargeOperationName,
	Charge,
	func(ctx context.Context, input *ChargeInput, soo nexus.StartOperationOptions) (client.StartWorkflowOptions, error) {
		return client.StartWorkflowOptions{ID: ChargeWorkflowID(*input)}, nil
	},
)

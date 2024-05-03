package order

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/temporalio/orders-reference-app-go/app/internal/temporalutil"
	"go.temporal.io/api/serviceerror"
	"go.temporal.io/api/workflowservice/v1"
	"go.temporal.io/sdk/client"
)

// TaskQueue is the default task queue for the Order system.
const TaskQueue = "orders"

// StatusQuery is the name of the query to use to fetch an Order's status.
const StatusQuery = "status"

// FulfillmentWorkflowID returns the workflow ID for a Fulfillment.
func FulfillmentWorkflowID(id string) string {
	return "Fulfillment:" + id
}

// Item represents an item being ordered.
// All fields are required.
type Item struct {
	SKU      string `json:"sku"`
	Quantity int32  `json:"quantity"`
}

// OrderInput is the input for an Order workflow.
type OrderInput struct {
	ID         string  `json:"id"`
	CustomerID string  `json:"customerId"`
	Items      []*Item `json:"items"`
}

// OrderStatus holds the status of an Order workflow.
type OrderStatus struct {
	ID         string `json:"id"`
	CustomerID string `json:"customerId"`

	Status string `json:"status"`

	Fulfillments []*Fulfillment `json:"fulfillments"`
}

const (
	// OrderStatusPending is the status of a pending Order.
	OrderStatusPending = "pending"

	// OrderStatusProcessing is the status of a processing Order.
	OrderStatusProcessing = "processing"

	// OrderStatusCustomerActionRequired is the status of an Order that requires customer action.
	OrderStatusCustomerActionRequired = "customerActionRequired"

	// OrderStatusCompleted is the status of a completed Order.
	OrderStatusCompleted = "completed"

	// OrderStatusCancelled is the status of a cancelled Order.
	OrderStatusCancelled = "cancelled"
)

// ListOrderEntry is an entry in the Order list.
type ListOrderEntry struct {
	ID        string    `json:"id"`
	StartedAt time.Time `json:"startedAt"`
}

// ShipmentStatus holds the status of a Shipment.
type ShipmentStatus struct {
	ID string `json:"id"`

	Status    string    `json:"status"`
	UpdatedAt time.Time `json:"updatedAt"`
}

// PaymentStatus holds the status of a Payment.
type PaymentStatus struct {
	SubTotal int32 `json:"subTotal"`
	Tax      int32 `json:"tax"`
	Shipping int32 `json:"shipping"`
	Total    int32 `json:"total"`

	Status string `json:"status"`
}

const (
	// PaymentStatusPending is the status of a pending payment.
	PaymentStatusPending = "pending"

	// PaymentStatusSuccess is the status of a successful payment.
	PaymentStatusSuccess = "success"

	// PaymentStatusFailed is the status of a failed payment.
	PaymentStatusFailed = "failed"
)

// Fulfillment holds a set of items that will be delivered in one shipment (due to location and stock level).
type Fulfillment struct {
	// OrderID is the ID of the order that this fulfillment is part of.
	orderID string

	// CustomerID is the ID of the customer that this fulfillment is for.
	customerID string

	// ID is an identifier for the fulfillment
	ID string `json:"id"`

	// Items is the set of the items that will be part of this shipment.
	Items []*Item `json:"items"`

	// Location is the address for carrier pickup.
	Location string `json:"location,omitempty"`

	// Status is the status of the fulfillment, one of "unavailable", "pending", "processing", "dispatched", "delivered", "failed".
	Status string `json:"status"`

	// PaymentStatus is the status of the payment for this fulfillment.
	Payment *PaymentStatus `json:"payment,omitempty"`

	// ShipmentStatus is the status of the shipment for this fulfillment.
	Shipment *ShipmentStatus `json:"shipment,omitempty"`
}

const (
	// FulfillmentStatusUnavailable is the status of an unavailable Fulfillment.
	FulfillmentStatusUnavailable = "unavailable"

	// FulfillmentStatusPending is the status of a pending Fulfillment.
	FulfillmentStatusPending = "pending"

	// FulfillmentStatusProcessing is the status of a processing Fulfillment.
	FulfillmentStatusProcessing = "processing"

	// FulfillmentStatusCompleted is the status of a processing Fulfillment.
	FulfillmentStatusCompleted = "completed"

	// FulfillmentStatusFailed is the status of a failed Fulfillment.
	FulfillmentStatusFailed = "failed"
)

// CustomerActionSignalName is the name of the signal used to send customer actions.
const CustomerActionSignalName = "CustomerAction"

// CustomerActionSignal is the signal sent to the Fulfillment workflow to indicate a customer action.
type CustomerActionSignal struct {
	Action string `json:"action"`
}

const (
	// CustomerActionCancel is the action to cancel a Fulfillment.
	CustomerActionCancel = "cancel"

	// CustomerActionAmend is the action to amend a Fulfillment.
	CustomerActionAmend = "amend"
)

// OrderResult is the result of an Order workflow.
type OrderResult struct {
	Status string `json:"status"`
}

type handlers struct {
	temporal client.Client
}

// RunServer runs a Order API HTTP server on the given port.
func RunServer(ctx context.Context, port int) error {
	clientOptions, err := temporalutil.CreateClientOptionsFromEnv()
	if err != nil {
		return fmt.Errorf("failed to create client options: %v", err)
	}

	c, err := client.Dial(clientOptions)
	if err != nil {
		return fmt.Errorf("client error: %v", err)
	}
	defer c.Close()

	srv := &http.Server{
		Addr:    fmt.Sprintf("127.0.0.1:%d", port),
		Handler: Router(c),
	}

	fmt.Printf("Listening on http://127.0.0.1:%d\n", port)

	errCh := make(chan error, 1)
	go func() { errCh <- srv.ListenAndServe() }()

	select {
	case <-ctx.Done():
		srv.Close()
	case err = <-errCh:
		return err
	}

	return nil
}

// Router implements the http.Handler interface for the Billing API
func Router(c client.Client) *mux.Router {
	r := mux.NewRouter()
	h := handlers{temporal: c}

	r.HandleFunc("/orders", h.handleCreateOrder).Methods("POST")
	r.HandleFunc("/orders", h.handleListOrders).Methods("GET")
	r.HandleFunc("/orders/{id}", h.handleGetOrder)

	return r
}

func (h *handlers) handleListOrders(w http.ResponseWriter, r *http.Request) {
	orders := []ListOrderEntry{}
	var nextPageToken []byte

	for {
		resp, err := h.temporal.ListWorkflow(r.Context(), &workflowservice.ListWorkflowExecutionsRequest{
			NextPageToken: nextPageToken,
			Query:         "WorkflowType='Order' AND ExecutionStatus='Running'",
		})
		if err != nil {
			log.Printf("Failed to list order workflows: %v", err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for _, e := range resp.Executions {
			orders = append(orders, ListOrderEntry{ID: e.GetExecution().GetWorkflowId(), StartedAt: e.GetStartTime().AsTime()})
		}

		if len(resp.NextPageToken) == 0 {
			break
		}

		nextPageToken = resp.NextPageToken
	}

	w.Header().Set("Content-Type", "application/json")

	err := json.NewEncoder(w).Encode(orders)
	if err != nil {
		log.Printf("Failed to encode orders: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func (h *handlers) handleCreateOrder(w http.ResponseWriter, r *http.Request) {
	var input OrderInput

	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		log.Printf("Failed to decode order input: %v", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	_, err = h.temporal.ExecuteWorkflow(context.Background(),
		client.StartWorkflowOptions{
			TaskQueue: TaskQueue,
			ID:        fmt.Sprintf("Order:%s", input.ID),
		},
		Order,
		&input,
	)
	if err != nil {
		log.Printf("Failed to start order workflow: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
}

func (h *handlers) handleGetOrder(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

	var status OrderStatus

	q, err := h.temporal.QueryWorkflow(r.Context(),
		vars["id"], "",
		StatusQuery,
	)
	if err != nil {
		if _, ok := err.(*serviceerror.NotFound); ok {
			http.Error(w, "Order not found", http.StatusNotFound)
		} else {
			log.Printf("Failed to query order workflow: %v", err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
		return
	}

	if err := q.Get(&status); err != nil {
		log.Printf("Failed to get order query result: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")

	if err := json.NewEncoder(w).Encode(status); err != nil {
		log.Printf("Failed to encode order status: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

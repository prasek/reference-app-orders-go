package order

import (
	"context"

	"github.com/nexus-rpc/sdk-go/nexus"
	"github.com/temporalio/reference-app-orders-go/app/config"
	"github.com/temporalio/reference-app-orders-go/app/temporalutil"
	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/temporalnexus"
	"go.temporal.io/sdk/worker"
)

// RunWorker runs a Workflow and Activity worker for the Order system.
func RunWorker(ctx context.Context, config config.AppConfig, client client.Client) error {
	w := worker.New(client, TaskQueue, worker.Options{})

	s := nexus.NewService(OrderServiceName)
	s.Register(
		temporalnexus.NewSyncOperation(ShipmentNotificationOperationName, nh.handleShippingUpdateNotification),
	)
	w.RegisterNexusService(s)
	w.RegisterWorkflow(Order)
	w.RegisterActivity(&Activities{OrderURL: config.OrderURL})

	return w.Run(temporalutil.WorkerInterruptFromContext(ctx))
}

package base_events

import (
	"context"
	"encoding/json"
	"github.com/google/uuid"
	"time"
)

// BaseEvent is the base struct for all events
type BaseEvent struct {
	ID            uuid.UUID       `json:"id"`
	Timestamp     time.Time       `json:"timestamp"`
	Type          string          `json:"type"`
	AggregateID   string          `json:"aggregate_id"`
	AggregateType string          `json:"aggregate_type"`
	Version       int             `json:"version"`
	Payload       json.RawMessage `json:"payload"`
	Metadata      Metadata        `json:"metadata"`
}

// Metadata contains contextual information about the event
type Metadata struct {
	UserID        string         `json:"user_id"`
	CorrelationID string         `json:"correlation_id"`
	CausationID   string         `json:"causation_id"`
	Source        string         `json:"source"`
	Additional    map[string]any `json:"additional"`
}

// Investment domain events
const (
	EventInvestmentCreated       = "investment.created"
	EventInvestmentApproved      = "investment.approved"
	EventInvestmentRejected      = "investment.rejected"
	EventEquityAllocated         = "equity.allocated"
	EventDividendDistributed     = "dividend.distributed"
	EventCompanyValuationUpdated = "company.valuation.updated"
)

type InvestmentCreatedPayload struct {
	InvestorID   string    `json:"investor_id"`
	CompanyID    string    `json:"company_id"`
	Amount       float64   `json:"amount"`
	EquityShares float64   `json:"equity_shares"`
	Timestamp    time.Time `json:"timestamp"`
}

type EquityAllocatedPayload struct {
	InvestmentID string    `json:"investment_id"`
	InvestorID   string    `json:"investor_id"`
	CompanyID    string    `json:"company_id"`
	EquityShares float64   `json:"equity_shares"`
	SharePrice   float64   `json:"share_price"`
	Timestamp    time.Time `json:"timestamp"`
}

// EventStore defines the interface for event persistence
type EventStore interface {
	Save(ctx context.Context, events ...*BaseEvent) error
	Load(ctx context.Context, aggregateID string) ([]*BaseEvent, error)
	LoadByType(ctx context.Context, eventType string) ([]*BaseEvent, error)
}

// EventBus handles event publishing and subscription
type EventBus interface {
	Publish(ctx context.Context, event *BaseEvent) error
	Subscribe(eventType string, handler EventHandler) error
	Unsubscribe(eventType string, handler EventHandler) error
}

// EventHandler processes events
type EventHandler interface {
	Handle(ctx context.Context, event *BaseEvent) error
}

// EventPublisher combines event store and bus operations
type EventPublisher struct {
	store EventStore
	bus   EventBus
}

func NewEventPublisher(store EventStore, bus EventBus) *EventPublisher {
	return &EventPublisher{
		store: store,
		bus:   bus,
	}
}

// Publish persists and broadcasts an event
func (p *EventPublisher) Publish(ctx context.Context, events ...*BaseEvent) error {
	if err := p.store.Save(ctx, events...); err != nil {
		return err
	}
	for _, event := range events {
		if err := p.bus.Publish(ctx, event); err != nil {
			return err
		}
	}
	return nil
}

func NewEvent(eventType string, aggregateID string, aggregateType string, version string, payload interface{}) (*BaseEvent, error) {
	payloadBytes, err := json.Marshal(payload)

	if err != nil {
		return nil, err
	}
	return &BaseEvent{

		ID:            uuid.New(),
		Timestamp:     time.Now().UTC(),
		Type:          eventType,
		AggregateID:   aggregateID,
		AggregateType: aggregateType,
		Version:       1,
		Payload:       payloadBytes,
		Metadata:      Metadata{},
	}, nil
}

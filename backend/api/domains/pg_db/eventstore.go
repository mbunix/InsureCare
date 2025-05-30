package eventstore

import (
	"context"
	"database/sql"
	"encoding/json"
	"time"
)

type PostgresEventStore struct {
	db *sql.DB
}

// Event table schema
const createEventStoreTable = `
CREATE TABLE IF NOT EXISTS events (
    id              VARCHAR(36) PRIMARY KEY,
    type            VARCHAR(100) NOT NULL,
    aggregate_id    VARCHAR(36) NOT NULL,
    aggregate_type  VARCHAR(100) NOT NULL,
    version         BIGINT NOT NULL,
    timestamp       TIMESTAMP NOT NULL,
    payload         JSONB NOT NULL,
    metadata        JSONB NOT NULL,
    UNIQUE (aggregate_id, version)
);

CREATE INDEX IF NOT EXISTS idx_events_aggregate_id ON events(aggregate_id);
CREATE INDEX IF NOT EXISTS idx_events_type ON events(type);
CREATE INDEX IF NOT EXISTS idx_events_timestamp ON events(timestamp);
`

// Event represents a domain event with its metadata
type Event struct {
	ID            string          `json:"id"`
	Type          string          `json:"type"`
	AggregateID   string          `json:"aggregate_id"`
	AggregateType string          `json:"aggregate_type"`
	Version       int             `json:"version"`
	Timestamp     time.Time       `json:"timestamp"`
	Payload       json.RawMessage `json:"payload"`
	Metadata      Metadata        `json:"metadata"`
}
type Metadata struct {
	UserID        string         `json:"user_id"`
	CorrelationID string         `json:"correlation_id"`
	CausationID   string         `json:"causation_id"`
	Source        string         `json:"source"`
	Additional    map[string]any `json:"additional"`
}

func NewPostgresEventStore(db *sql.DB) (*PostgresEventStore, error) {
	if _, err := db.Exec(createEventStoreTable); err != nil {
		return nil, err
	}
	return &PostgresEventStore{db: db}, nil
}

func (s *PostgresEventStore) Save(ctx context.Context, events ...*Event) error {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	stmt, err := tx.PrepareContext(ctx, `
        INSERT INTO events (
            id, type, aggregate_id, aggregate_type, 
            version, timestamp, payload, metadata
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    `)
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, event := range events {
		metadata, err := json.Marshal(event.Metadata)
		if err != nil {
			return err
		}

		_, err = stmt.ExecContext(ctx,
			event.ID,
			event.Type,
			event.AggregateID,
			event.AggregateType,
			event.Version,
			event.Timestamp,
			event.Payload,
			metadata,
		)
		if err != nil {
			return err
		}
	}

	return tx.Commit()
}

func (s *PostgresEventStore) Load(ctx context.Context, aggregateID string) ([]*Event, error) {
	rows, err := s.db.QueryContext(ctx, `
        SELECT id, type, aggregate_id, aggregate_type, 
               version, timestamp, payload, metadata
        FROM events 
        WHERE aggregate_id = $1 
        ORDER BY version ASC
    `, aggregateID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	return s.scanEvents(rows)
}

func (s *PostgresEventStore) LoadByType(ctx context.Context, eventType string) ([]*Event, error) {
	rows, err := s.db.QueryContext(ctx, `
        SELECT id, type, aggregate_id, aggregate_type, 
               version, timestamp, payload, metadata
        FROM events 
        WHERE type = $1 
        ORDER BY timestamp ASC
    `, eventType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	return s.scanEvents(rows)
}

func (s *PostgresEventStore) scanEvents(rows *sql.Rows) ([]*Event, error) {
	var events []*Event

	for rows.Next() {
		var event Event
		var metadata []byte

		err := rows.Scan(
			&event.ID,
			&event.Type,
			&event.AggregateID,
			&event.AggregateType,
			&event.Version,
			&event.Timestamp,
			&event.Payload,
			&metadata,
		)
		if err != nil {
			return nil, err
		}

		if err := json.Unmarshal(metadata, &event.Metadata); err != nil {
			return nil, err
		}

		events = append(events, &event)
	}

	return events, nil
}

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "wallet_address" varchar UNIQUE,
  "email" varchar UNIQUE,
  "username" varchar,
  "full_name" varchar,
  "kyc_status" varchar,
  "risk_profile" jsonb,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "user_profiles" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid,
  "investment_preferences" jsonb,
  "total_portfolio_value" decimal,
  "reputation_score" decimal,
  "investment_history" jsonb,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "companies" (
  "id" uuid PRIMARY KEY,
  "name" varchar,
  "registration_number" varchar,
  "industry_type" varchar,
  "company_size" varchar,
  "valuation" decimal,
  "equity_available" decimal,
  "revenue" decimal,
  "performance_metrics" jsonb,
  "risk_score" decimal,
  "status" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "company_financials" (
  "id" uuid PRIMARY KEY,
  "company_id" uuid,
  "revenue_history" jsonb,
  "profit_margins" jsonb,
  "cash_flow_statements" jsonb,
  "balance_sheets" jsonb,
  "quarter" varchar,
  "year" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "investments" (
  "id" uuid PRIMARY KEY,
  "investor_id" uuid,
  "company_id" uuid,
  "amount" decimal,
  "equity_percentage" decimal,
  "investment_date" timestamp,
  "status" varchar,
  "smart_contract_address" varchar,
  "transaction_hash" varchar,
  "return_rate" decimal,
  "payout_frequency" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "equity_tokens" (
  "id" uuid PRIMARY KEY,
  "investment_id" uuid,
  "token_address" varchar,
  "total_supply" decimal,
  "current_price" decimal,
  "market_cap" decimal,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "crowdfunding_campaigns" (
  "id" uuid PRIMARY KEY,
  "company_id" uuid,
  "target_amount" decimal,
  "minimum_investment" decimal,
  "equity_offered" decimal,
  "campaign_start_date" timestamp,
  "campaign_end_date" timestamp,
  "status" varchar,
  "current_amount" decimal,
  "investor_count" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "campaign_investments" (
  "id" uuid PRIMARY KEY,
  "campaign_id" uuid,
  "investor_id" uuid,
  "amount" decimal,
  "equity_share" decimal,
  "investment_date" timestamp,
  "status" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "revenue_shares" (
  "id" uuid PRIMARY KEY,
  "investment_id" uuid,
  "amount" decimal,
  "distribution_date" timestamp,
  "status" varchar,
  "transaction_hash" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "risk_assessments" (
  "id" uuid PRIMARY KEY,
  "company_id" uuid,
  "risk_score" decimal,
  "risk_factors" jsonb,
  "assessment_date" timestamp,
  "ml_model_version" varchar,
  "confidence_score" decimal,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "performance_metrics" (
  "id" uuid PRIMARY KEY,
  "company_id" uuid,
  "metric_type" varchar,
  "metric_value" decimal,
  "measurement_date" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "transactions" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid,
  "trade_id" uuid,
  "transaction_type" varchar,
  "amount" decimal,
  "status" varchar,
  "transaction_hash" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "equity_market_listings" (
  "id" uuid PRIMARY KEY,
  "equity_token_id" uuid,
  "seller_id" uuid,
  "listing_price" decimal,
  "quantity" decimal,
  "minimum_purchase" decimal,
  "status" varchar,
  "listing_date" timestamp,
  "expiry_date" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "equity_trades" (
  "id" uuid PRIMARY KEY,
  "listing_id" uuid,
  "buyer_id" uuid,
  "seller_id" uuid,
  "quantity" decimal,
  "price_per_unit" decimal,
  "total_amount" decimal,
  "transaction_hash" varchar,
  "status" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "investment_portfolios" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid,
  "total_invested_amount" decimal,
  "current_value" decimal,
  "profit_loss" decimal,
  "last_updated" timestamp,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "portfolio_holdings" (
  "id" uuid PRIMARY KEY,
  "portfolio_id" uuid,
  "equity_token_id" uuid,
  "quantity" decimal,
  "average_purchase_price" decimal,
  "current_value" decimal,
  "profit_loss" decimal,
  "holding_period" interval,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "analytics_events" (
  "id" uuid PRIMARY KEY,
  "event_type" varchar,
  "event_data" jsonb,
  "user_id" uuid,
  "created_at" timestamp
);

CREATE UNIQUE INDEX ON "users" ("wallet_address");

CREATE UNIQUE INDEX ON "users" ("email");

CREATE INDEX ON "investments" ("smart_contract_address");

CREATE INDEX ON "investments" ("transaction_hash");

CREATE INDEX ON "equity_tokens" ("token_address");

CREATE INDEX ON "revenue_shares" ("transaction_hash");

CREATE INDEX ON "transactions" ("transaction_hash");

CREATE INDEX ON "transactions" ("trade_id");

CREATE INDEX ON "equity_market_listings" ("seller_id", "status");

CREATE INDEX ON "equity_market_listings" ("listing_date");

CREATE INDEX ON "equity_trades" ("transaction_hash");

CREATE INDEX ON "equity_trades" ("buyer_id", "seller_id");

CREATE INDEX ON "investment_portfolios" ("user_id");

CREATE INDEX ON "portfolio_holdings" ("portfolio_id", "equity_token_id");

ALTER TABLE "user_profiles" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "company_financials" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("id");

ALTER TABLE "investments" ADD FOREIGN KEY ("investor_id") REFERENCES "users" ("id");

ALTER TABLE "investments" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("id");

ALTER TABLE "equity_tokens" ADD FOREIGN KEY ("investment_id") REFERENCES "investments" ("id");

ALTER TABLE "crowdfunding_campaigns" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("id");

ALTER TABLE "campaign_investments" ADD FOREIGN KEY ("campaign_id") REFERENCES "crowdfunding_campaigns" ("id");

ALTER TABLE "campaign_investments" ADD FOREIGN KEY ("investor_id") REFERENCES "users" ("id");

ALTER TABLE "revenue_shares" ADD FOREIGN KEY ("investment_id") REFERENCES "investments" ("id");

ALTER TABLE "risk_assessments" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("id");

ALTER TABLE "performance_metrics" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("trade_id") REFERENCES "equity_trades" ("id");

ALTER TABLE "equity_market_listings" ADD FOREIGN KEY ("equity_token_id") REFERENCES "equity_tokens" ("id");

ALTER TABLE "equity_market_listings" ADD FOREIGN KEY ("seller_id") REFERENCES "users" ("id");

ALTER TABLE "equity_trades" ADD FOREIGN KEY ("listing_id") REFERENCES "equity_market_listings" ("id");

ALTER TABLE "equity_trades" ADD FOREIGN KEY ("buyer_id") REFERENCES "users" ("id");

ALTER TABLE "equity_trades" ADD FOREIGN KEY ("seller_id") REFERENCES "users" ("id");

ALTER TABLE "investment_portfolios" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "portfolio_holdings" ADD FOREIGN KEY ("portfolio_id") REFERENCES "investment_portfolios" ("id");

ALTER TABLE "portfolio_holdings" ADD FOREIGN KEY ("equity_token_id") REFERENCES "equity_tokens" ("id");

ALTER TABLE "analytics_events" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

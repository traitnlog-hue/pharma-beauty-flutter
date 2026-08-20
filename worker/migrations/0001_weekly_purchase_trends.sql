CREATE TABLE IF NOT EXISTS weekly_product_purchases (
  week_start TEXT NOT NULL,
  product_id INTEGER NOT NULL,
  purchase_count INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (week_start, product_id)
);

CREATE TABLE IF NOT EXISTS weekly_ingredient_rankings (
  week_start TEXT NOT NULL,
  ingredient TEXT NOT NULL,
  purchase_count INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (week_start, ingredient)
);

CREATE INDEX IF NOT EXISTS weekly_ingredient_rankings_week_count
  ON weekly_ingredient_rankings (week_start, purchase_count DESC);

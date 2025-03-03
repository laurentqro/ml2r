CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "occupations" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "major" varchar, "major_label" varchar, "sub_major" varchar, "sub_major_label" varchar, "minor" varchar, "minor_label" varchar, "unit" varchar, "description" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "people" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar, "last_name" varchar, "country_of_birth" varchar, "country_of_residence" varchar, "country_of_profession" varchar, "profession" varchar, "pep" boolean, "sanctioned" boolean, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "nationality" varchar /*application='Ml2r'*/, "date_of_birth" date /*application='Ml2r'*/);
CREATE TABLE IF NOT EXISTS "sanctions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "nature" varchar, "title" varchar, "last_name" varchar, "first_name" varchar, "sex" varchar, "date_of_birth" varchar, "place_of_birth" varchar, "nationality" varchar, "address" text, "alias" text, "authority" varchar, "motive" text, "legal_basis" varchar, "additional_info" text, "expiration_date" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "measure_id" integer /*application='Ml2r'*/);
CREATE TABLE IF NOT EXISTS "screenings" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "screenable_id" integer, "screenable_type" varchar, "query" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_screenings_on_screenable_id_and_screenable_type" ON "screenings" ("screenable_id", "screenable_type") /*application='Ml2r'*/;
CREATE TABLE IF NOT EXISTS "companies" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "sanctioned" boolean /*application='Ml2r'*/, "country" varchar /*application='Ml2r'*/);
CREATE TABLE IF NOT EXISTS "clients" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "clientable_type" varchar, "clientable_id" integer, "started_at" datetime(6), "ended_at" datetime(6), "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "notes" text /*application='Ml2r'*/);
CREATE INDEX "index_clients_on_clientable" ON "clients" ("clientable_type", "clientable_id") /*application='Ml2r'*/;
CREATE INDEX "index_clients_on_clientable_id_and_clientable_type" ON "clients" ("clientable_id", "clientable_type") /*application='Ml2r'*/;
CREATE INDEX "index_sanctions_on_measure_id" ON "sanctions" ("measure_id") /*application='Ml2r'*/;
CREATE TABLE IF NOT EXISTS "risk_factors" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "client_id" integer NOT NULL, "category" integer, "identifier" varchar, "identified_at" datetime(6), "notes" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_f25bb7d52b"
FOREIGN KEY ("client_id")
  REFERENCES "clients" ("id")
);
CREATE INDEX "index_risk_factors_on_client_id" ON "risk_factors" ("client_id") /*application='Ml2r'*/;
CREATE UNIQUE INDEX "index_risk_factors_on_client_id_and_category_and_identifier" ON "risk_factors" ("client_id", "category", "identifier") /*application='Ml2r'*/;
CREATE TABLE IF NOT EXISTS "identification_documents" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "person_id" integer NOT NULL, "document_type" varchar NOT NULL, "number" varchar NOT NULL, "expiration_date" date NOT NULL, "is_copy" boolean DEFAULT 0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_110ad86177"
FOREIGN KEY ("person_id")
  REFERENCES "people" ("id")
);
CREATE INDEX "index_identification_documents_on_person_id" ON "identification_documents" ("person_id") /*application='Ml2r'*/;
CREATE TABLE IF NOT EXISTS "risk_scoresheets" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "client_id" integer NOT NULL, "country_risk_score" integer, "client_risk_score" integer, "products_and_services_risk_score" integer, "distribution_channel_risk_score" integer, "transaction_risk_score" integer, "approved_at" datetime(6), "notes" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_c6f13812e6"
FOREIGN KEY ("client_id")
  REFERENCES "clients" ("id")
);
CREATE INDEX "index_risk_scoresheets_on_client_id" ON "risk_scoresheets" ("client_id") /*application='Ml2r'*/;
CREATE TABLE IF NOT EXISTS "matches" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "screening_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "score" integer DEFAULT 0, "external_data" json, CONSTRAINT "fk_rails_2ea8490fc6"
FOREIGN KEY ("screening_id")
  REFERENCES "screenings" ("id")
);
CREATE INDEX "index_matches_on_screening_id" ON "matches" ("screening_id") /*application='Ml2r'*/;
CREATE INDEX "index_matches_on_external_data" ON "matches" ("external_data") /*application='Ml2r'*/;
CREATE TABLE IF NOT EXISTS "risk_factor_definitions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "category" varchar NOT NULL, "description" text NOT NULL, "score" integer NOT NULL, "risk_factor_type" varchar NOT NULL, "identifier" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "idx_risk_factor_definitions_unique" ON "risk_factor_definitions" ("risk_factor_type", "category", "identifier") /*application='Ml2r'*/;
CREATE VIEW client_risk_summaries AS
      WITH latest_scoresheets AS (
        SELECT rs.*
        FROM risk_scoresheets rs
        INNER JOIN (
          SELECT client_id, MAX(created_at) as max_created_at
          FROM risk_scoresheets
          GROUP BY client_id
        ) latest ON rs.client_id = latest.client_id
        AND rs.created_at = latest.max_created_at
      )
      SELECT
        c.id AS client_id,
        c.clientable_type,
        c.clientable_id,
        CASE
          WHEN c.clientable_type = 'Person' THEN p.last_name || ', ' || p.first_name
          WHEN c.clientable_type = 'Company' THEN comp.name
        END AS display_name,
        CASE
          WHEN c.clientable_type = 'Person' AND p.pep = 1 THEN 1
          ELSE NULL
        END AS pep,
        CASE
          WHEN c.clientable_type = 'Person' THEN p.sanctioned
          ELSE comp.sanctioned
        END AS sanctioned,
        rs.country_risk_score,
        rs.client_risk_score,
        rs.products_and_services_risk_score,
        rs.distribution_channel_risk_score,
        rs.transaction_risk_score,
        (
          COALESCE(rs.country_risk_score, 0) +
          COALESCE(rs.client_risk_score, 0) +
          COALESCE(rs.products_and_services_risk_score, 0) +
          COALESCE(rs.distribution_channel_risk_score, 0) +
          COALESCE(rs.transaction_risk_score, 0)
        ) AS total_risk_score,
        rs.created_at AS scoresheet_date
      FROM clients c
      LEFT JOIN people p ON c.clientable_type = 'Person' AND c.clientable_id = p.id
      LEFT JOIN companies comp ON c.clientable_type = 'Company' AND c.clientable_id = comp.id
      LEFT JOIN latest_scoresheets rs ON c.id = rs.client_id
/* client_risk_summaries(client_id,clientable_type,clientable_id,display_name,pep,sanctioned,country_risk_score,client_risk_score,products_and_services_risk_score,distribution_channel_risk_score,transaction_risk_score,total_risk_score,scoresheet_date) */
/* client_risk_summaries(client_id,clientable_type,clientable_id,display_name,pep,sanctioned,country_risk_score,client_risk_score,products_and_services_risk_score,distribution_channel_risk_score,transaction_risk_score,total_risk_score,scoresheet_date) */;
INSERT INTO "schema_migrations" (version) VALUES
('20250228152047'),
('20250226144431'),
('20250220153250'),
('20250220152637'),
('20250207144019'),
('20250131160000'),
('20250131150854'),
('20250131100730'),
('20250128000001'),
('20250127132259'),
('20250122144707'),
('20250120150343'),
('20250120145706'),
('20250120143259'),
('20250109161210'),
('20250109160621'),
('20250109160409'),
('20250108163036'),
('20250106144351'),
('20250106142506');


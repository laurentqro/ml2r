class UpdateClientRiskSummariesView < ActiveRecord::Migration[8.0]
  def up
    execute "DROP VIEW IF EXISTS client_risk_summaries;"
    
    execute <<-SQL
      CREATE VIEW client_risk_summaries AS
      WITH latest_assessments AS (
        SELECT ra.*
        FROM risk_assessments ra
        INNER JOIN (
          SELECT client_id, MAX(created_at) as max_created_at
          FROM risk_assessments
          WHERE status = 'approved' OR status = 'completed'
          GROUP BY client_id
        ) latest ON ra.client_id = latest.client_id
        AND ra.created_at = latest.max_created_at
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
          WHEN c.clientable_type = 'Person' AND p.pep = 1 THEN true
          WHEN c.clientable_type = 'Person' AND p.pep = 0 THEN false
          ELSE NULL
        END AS pep,
        CASE
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 0 THEN false
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 0 THEN false
          ELSE NULL
        END AS sanctioned,
        ra.country_risk_score,
        ra.client_risk_score,
        ra.products_and_services_risk_score,
        ra.distribution_channel_risk_score,
        ra.transaction_risk_score,
        (
          COALESCE(ra.country_risk_score, 0) +
          COALESCE(ra.client_risk_score, 0) +
          COALESCE(ra.products_and_services_risk_score, 0) +
          COALESCE(ra.distribution_channel_risk_score, 0) +
          COALESCE(ra.transaction_risk_score, 0)
        ) AS total_risk_score,
        ra.created_at AS assessment_date
      FROM clients c
      LEFT JOIN people p ON c.clientable_type = 'Person' AND c.clientable_id = p.id
      LEFT JOIN companies comp ON c.clientable_type = 'Company' AND c.clientable_id = comp.id
      LEFT JOIN latest_assessments ra ON c.id = ra.client_id;
    SQL
  end

  def down
    execute "DROP VIEW IF EXISTS client_risk_summaries;"
    
    execute <<-SQL
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
          WHEN c.clientable_type = 'Person' AND p.pep = 1 THEN true
          WHEN c.clientable_type = 'Person' AND p.pep = 0 THEN false
          ELSE NULL
        END AS pep,
        CASE
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 0 THEN false
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 0 THEN false
          ELSE NULL
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
      LEFT JOIN latest_scoresheets rs ON c.id = rs.client_id;
    SQL
  end
end

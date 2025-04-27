class UpdateClientRiskSummariesViewForLatestApproved < ActiveRecord::Migration[8.0]
  def up
    # Drop the existing view
    execute "DROP VIEW IF EXISTS client_risk_summaries;"

    # Create the updated view using latest APPROVED assessment
    execute <<-SQL
      CREATE VIEW client_risk_summaries AS
      WITH latest_approved_assessments AS ( -- Renamed CTE and updated logic
        SELECT ra.*
        FROM risk_assessments ra
        INNER JOIN (
          SELECT client_id, MAX(approved_at) as max_approved_at -- Use MAX(approved_at)
          FROM risk_assessments
          WHERE approved_at IS NOT NULL -- Filter for approved assessments
          GROUP BY client_id
        ) latest ON ra.client_id = latest.client_id
        AND ra.approved_at = latest.max_approved_at -- Join on approved_at
      )
      SELECT
        c.id AS client_id,
        c.clientable_type,
        c.clientable_id,
        CASE
          WHEN c.clientable_type = 'Person' THEN p.last_name || ', ' || p.first_name
          WHEN c.clientable_type = 'Company' THEN comp.name
        END AS display_name,
        ra.pep_confirmed AS pep,
        CASE
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 0 THEN false
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 0 THEN false
          ELSE NULL
        END AS sanctioned,
        ra.adverse_media_confirmed AS adverse_media,
        ra.created_at AS risk_assessment_created_at,
        ra.approved_at AS risk_assessment_approved_at,
        CASE
          WHEN ra.approved_at IS NOT NULL THEN 'Approved'
          -- This case might need adjustment if we only join approved ones
          -- For now, keep it, but LEFT JOIN might be needed if not all clients have approved assessments
          WHEN ra.created_at IS NOT NULL THEN 'Pending Approval'
          ELSE 'Not Assessed'
        END AS risk_assessment_status,
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
        ra.approved_at AS assessment_date -- Changed to approved_at
      FROM clients c
      LEFT JOIN people p ON c.clientable_type = 'Person' AND c.clientable_id = p.id
      LEFT JOIN companies comp ON c.clientable_type = 'Company' AND c.clientable_id = comp.id
      LEFT JOIN latest_approved_assessments ra ON c.id = ra.client_id; -- Use LEFT JOIN and updated CTE name
    SQL
  end

  def down
    # Drop the updated view
    execute "DROP VIEW IF EXISTS client_risk_summaries;"

    # Recreate the previous version of the view (from migration 20250427105652)
    execute <<-SQL
      CREATE VIEW client_risk_summaries AS
      WITH latest_assessments AS (
        SELECT ra.*
        FROM risk_assessments ra
        INNER JOIN (
          SELECT client_id, MAX(created_at) as max_created_at
          FROM risk_assessments
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
        ra.pep_confirmed AS pep,
        CASE
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Person' AND p.sanctioned = 0 THEN false
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 1 THEN true
          WHEN c.clientable_type = 'Company' AND comp.sanctioned = 0 THEN false
          ELSE NULL
        END AS sanctioned,
        ra.adverse_media_confirmed AS adverse_media,
        ra.created_at AS risk_assessment_created_at,
        ra.approved_at AS risk_assessment_approved_at,
        CASE
          WHEN ra.approved_at IS NOT NULL THEN 'Approved'
          WHEN ra.created_at IS NOT NULL THEN 'Pending Approval'
          ELSE 'Not Assessed'
        END AS risk_assessment_status,
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
end

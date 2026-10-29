-- ==========================================
-- View: vw_trust_breach_summary
-- Description: Calculates the 18-week breach percentage
-- ==========================================

CREATE VIEW vw_trust_breach_summary AS

SELECT
    t.provider_org_name,
    s.treatment_function_name,
    d.reporting_period,
    f.total,
    f.wait_bucket_patient_count,

    ROUND(
        (
            CAST(f.wait_bucket_patient_count AS FLOAT)
            / NULLIF(f.total, 0)
        ) * 100,
        2
    ) AS breach_percentage

FROM fact_rtt_waiting_times f

JOIN dim_trust t
ON f.trust_id = t.trust_id

JOIN dim_specialty s
ON f.specialty_id = s.specialty_id

JOIN dim_date d
ON f.date_id = d.date_id;





-- ==========================================
-- View: vw_gp_appointment_summary
-- Description: GP Appointment Summary
-- ==========================================

CREATE VIEW vw_gp_appointment_summary AS

SELECT
    d.reporting_period,
    g.APPT_STATUS,
    g.APPT_MODE,

    SUM(g.COUNT_OF_APPOINTMENTS) AS total_appointments,

    AVG(g.TIME_BETWEEN_BOOK_AND_APPT) AS average_booking_time

FROM fact_gp_appointments g

JOIN dim_date d
ON g.date_id = d.date_id

GROUP BY
    d.reporting_period,
    g.APPT_STATUS,
    g.APPT_MODE;





-- ==========================================
-- View: vw_gp_dna_rate
-- Description: Calculates DNA Rate
-- ==========================================

CREATE VIEW vw_gp_dna_rate AS

SELECT
    d.reporting_period,

    SUM(
        CASE
            WHEN g.APPT_STATUS = 'DNA'
            THEN g.COUNT_OF_APPOINTMENTS
            ELSE 0
        END
    ) AS dna_count,

    SUM(g.COUNT_OF_APPOINTMENTS) AS total_appointments,

    ROUND(
        (
            CAST(
                SUM(
                    CASE
                        WHEN g.APPT_STATUS = 'DNA'
                        THEN g.COUNT_OF_APPOINTMENTS
                        ELSE 0
                    END
                ) AS FLOAT
            )
            /
            NULLIF(SUM(g.COUNT_OF_APPOINTMENTS), 0)
        ) * 100,
        2
    ) AS dna_rate

FROM fact_gp_appointments g

JOIN dim_date d
ON g.date_id = d.date_id

GROUP BY
    d.reporting_period;
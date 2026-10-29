NHS RTT Waiting List & GP Appointment Analytics Dashboard

An end-to-end analytics project built during my Data Analytics internship at Neo Skillz. It covers data inspection, star schema design, SQL views and a 3-page interactive Power BI dashboard on NHS England published data.

Tools: Power BI, DAX, Power Query, Excel, SQL

Project Overview

The NHS publishes large monthly datasets on hospital waiting lists (Referral to Treatment, RTT) and GP appointments. In raw form they are hard to compare across providers, specialties and months.

This project turns them into one dashboard that answers questions such as:

How many patients are waiting, and how is that changing month to month?
Which treatment functions and providers have the longest waits?
How is the 18-week waiting target trending?
How many GP appointments are attended, missed (DNA) or cancelled, and how long do patients wait to be seen?
Data
Dataset	Coverage	Source
RTT Waiting Times	Jan - May 2026, by provider, treatment function and wait bucket	NHS England published statistics
GP Appointments	Jan - Apr 2026, by status, mode and booking time	NHS England published statistics
Dashboard (3 pages)
Executive Overview: average wait time, patients waiting, treatment functions, providers, top 10 treatment functions and providers, monthly trend
Operational Analysis: 18-week breach rate and trend, top providers by average wait, top commissioners, patient count by wait bucket
GP Appointment Analytics: total and attended appointments, DNA rate, status distribution, monthly volume and DNA trend

Executive Overview Operational Analysis GP Appointment Analytics

My Approach

1. Defined the KPIs first. I wrote a KPI dictionary covering the business definition, formula, required fields and notes for each metric (RTT waiting time, 18-week breach rate, total incomplete pathways, mean and median wait, appointment volume, DNA rate). See docs/KPI_Dictionary.xlsx.

2. Inspected and validated the data. I audited every column (identifier, temporal, categorical or value), checked data types, looked for multi-row headers, footer metadata and suppression symbols, and completed a validation checklist. See docs/Data_Inspection_Report.xlsx and docs/Validation_Checklist.xlsx.

3. Designed a star schema. Three dimension tables (dim_trust, dim_specialty, dim_date) and two fact tables (fact_rtt_waiting_times, fact_gp_appointments) with primary and foreign key relationships. See docs/Star_Schema_Design.docx.

4. Wrote SQL views for reporting. See sql/sql_views.sql:

vw_trust_breach_summary: breach percentage by trust, specialty and period
vw_gp_appointment_summary: appointments and average booking time by status and mode
vw_gp_dna_rate: DNA count, total appointments and DNA rate by period

5. Cleaned the data and built the report in Power BI. Cleaning and transformation in Power Query and Excel, then DAX measures, KPI cards, slicers (period, provider, treatment function) and charts.

Example DAX Measures
dax
DNA Rate =
DIVIDE(
    CALCULATE(
        SUM('final_GP_dataset'[COUNT_OF_APPOINTMENTS]),
        'final_GP_dataset'[APPT_STATUS] = 2
    ),
    [Total Appointments],
    0
)

Attended Appointments =
CALCULATE(
    SUM('final_GP_dataset'[COUNT_OF_APPOINTMENTS]),
    'final_GP_dataset'[APPT_STATUS] = 0
)
Key Findings
The 18-week breach rate improved from roughly 40% in January 2026 to roughly 36% in May 2026.
Waiting list volume peaked in March 2026 and fell through April and May.
Oral Surgery and Ear, Nose and Throat had the longest average waits, at close to 19 weeks.
About 90% of GP appointments were attended, around 6% were DNA and around 4% were cancelled.
The DNA rate held steady at about 6% from February to April, and the average wait between booking and appointment was about 3 days.
Limitations
RTT and GP figures cover only the months listed above.
January GP data looks partial, so its monthly volume and DNA rate should not be compared directly with later months.
The data is published in aggregated form (wait buckets, not individual patient records), so wait time is estimated from the buckets.
Repository Structure
├── README.md
├── screenshots/        # dashboard page images
├── docs/               # KPI dictionary, data inspection, validation, schema design
└── sql/                # SQL views
Skills Demonstrated

Data cleaning and validation, KPI definition, star schema design, SQL (views, joins, aggregation, CASE, NULLIF), DAX, Power Query, dashboard design, documentation.

Contact

Benjamin Moirangthem | Data Analyst | Delhi-NCR | https://www.linkedin.com/in/moirangthem-benjamin-a1805a257/

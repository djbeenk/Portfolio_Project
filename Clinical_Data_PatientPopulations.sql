--Building patient populations.

--Requirements:
--Deemed diabetic the first time they
	--had either an A1c level >6.4% OR
	--They had aan icd9 code of 250.4
--Earliest date of any applicable qualifying ICD( diagnoses, or A1c events)
--Patient must currently be alive

--CTE of alive patients
with alive_patients as
(
select id as 	pat_id,
				birthdate,
				first,
				last,
				ethnicity,
				race
from patients
where deathdate is null
)
--CTE Query that tracks the earliest date at which the icd9=250.4 occurs
,DB_Diag as
(
select 	patient,
		min(start) as earliest_db
from conditions as cond
where cond.code = '250.4'
group by patient
)
--CTE query that tracks earliest date of A1c level > 6.4%. A1c code is 4548-4
,high_A1c as
(
select	patient,
		min(date) as earliest_high_a1c
from observations
where code = '4548-4'
	and cast(value as float) > 6.4
group by patient
)
--Join all three CTEs
select 	ap.pat_id,
		ap.birthdate,
		ap.first,
		ap.last,
		ap.ethnicity,
		ap.race,
		db.earliest_db,
		a1c.earliest_high_a1c,
		least(db.earliest_db,a1c.earliest_high_a1c) as
db_earliest_qualifying_date
from alive_patients as ap
left join DB_diag as db
	on ap.pat_id = db.patient
left join high_A1c as a1c
	on ap.pat_id = a1c.patient
where coalesce(db.earliest_db,a1c.earliest_high_a1c) is not null
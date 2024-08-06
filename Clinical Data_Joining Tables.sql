select * from encounters
order by id
	
-- Left Join patient table to encounter table. Primary key is id for patients. Foreign key is patient in encounters
select *
from encounters as enc
left join patients as pat
on enc.patient = pat.id
order by enc.id

--Show only necessary columns
select 	enc.start,
		enc.stop,
		enc.encounterclass,
		pat.first,
		pat.last,
		pat.birthdate
from encounters as enc
left join patients as pat
ON enc.patient = pat.id
order by enc.id

--Filter by inpatients that are at least 18 years of age at start of encounter
select 	enc.start,
		enc.stop,
		enc.encounterclass,
		pat.first,
		pat.last,
		pat.birthdate,
		extract(year from age(start,birthdate))
from encounters as enc
left join patients as pat
ON enc.patient = pat.id
where lower(encounterclass) = 'inpatient'
and extract(year from age(start,birthdate)) >= 18
order by enc.id

--Emergency encounters in 2022 where patient's payor was Medicare. Id from Payers table is primary key. 
select *
from encounters as enc
left join payers as pay
	on enc.payer = pay.id
where lower(pay.name) = 'medicare'
	and lower(enc.encounterclass) = 'emergency'
	and enc.stop between '2022-01-01 00:00' and '2022-12-31 23:59'

--Query encounters for patients that were younger than 18 at start of encounter and encounter was ambulatory or outpatient
select 	enc.start,
		enc.stop,
		enc.encounterclass,
		pat.first,
		pat.last,
		pat.birthdate,
		extract(year from age(start,birthdate)) as age_at_enc
from encounters as enc
left join patients as pat
	on enc.patient = pat.id
where lower(encounterclass) in ('outpatient','ambulatory')
and extract(year from age(start,birthdate)) < 18
order by enc.id

--Query encounters for patients between ages 18 and 65 at start of encounter that were inpatient and payor was Medicaid.
select 	enc.start,
		enc.stop,
		enc.encounterclass,
		pat.first,
		pat.last,
		pat.birthdate,
		pay.name as insurance,
		extract(year from age(start,birthdate)) as age_at_enc
from encounters as enc
left join patients as pat
	ON enc.patient = pat.id
left join payers as pay
	ON enc.payer = pay.id
where lower(enc.encounterclass) in ('inpatient')
	and extract(year from age(enc.start,pat.birthdate)) between 18 and 65
	and lower(pay.name) = 'medicaid'


--Query top 10 doctors in descending order measured by number of encounters in 2022 where patient's payer was medicare.
select 	prov.name as provider,
		count(*) as enc_count
from encounters as enc
left join providers as prov
	ON enc.provider = prov.id
left join payers as pay
	ON enc.payer = pay.id
where enc.start between '2022-01-01 0:00' and '2022-12-31- 23:59'
	and lower(pay.name) = 'medicare'
group by prov.name
order by count(*) desc
limit 10

--Query all encounters where patient was given albuterol in outpatient or ambulatory setting where patient is 18 years or older
select distinct enc.id,
				enc.start,
				enc.stop,
				enc.patient,
				enc.encounterclass
from encounters as enc
join medications as med
	ON enc.id = med.encounter
join patients as pat
	ON enc.patient = pat.id
where lower(med.description) like '%albuterol%'
	and extract(year from age(enc.start,pat.birthdate)) >= 18
	and lower(encounterclass in ('ambulatory','outpatient')
order by enc.id
{{ config(
     enabled = var('pmpm_enabled',var('tuva_marts_enabled',True))
   )
}}

with service_cat_2 as (
select
  patient_id
, year_month
, service_category_2
, sum(total_allowed) as total_allowed
from {{ ref('pmpm__patient_spend_with_service_categories') }}
group by 1,2,3
)

select
patient_id, 
year_month, 
{{ dbt_utils.pivot(
    column='service_category_2'
  , values=('Acute Inpatient',
            'Ambulance',
            'Ambulatory Surgery',
            'Dialysis',
            'Durable Medical Equipment',
            'Emergency Department',
            'Home Health',
            'Hospice',
            'Inpatient Psychiatric',
            'Inpatient Rehabilitation',
            'Lab',
            'Office Visit',
            'Outpatient Hospital or Clinic',
            'Outpatient Psychiatric',
            'Outpatient Rehabilitation',
            'Skilled Nursing',
            'Urgent Care'                                                 
            )
  , agg='sum'
  , then_value='total_allowed'
  , else_value= 0
  , quote_identifiers = False
  , suffix='_allowed'
) }}
-- acute_inpatient_allowed, 
-- ambulance_allowed, 
-- ambulatory_surgery_allowed, 
-- dialysis_allowed, 
-- durable_medical_equipment_allowed, 
-- emergency_department_allowed,
-- home_health_allowed, 
-- hospice_allowed, 
-- inpatient_psychiatric_allowed, 
-- inpatient_rehabilitation_allowed, 
-- lab_allowed,
-- office_visit_allowed, 
-- outpatient_hospital_or_clinic_allowed, 
-- outpatient_psychiatric_allowed, 
-- outpatient_rehabilitation_allowed,
-- skilled_nursing_allowed, 
-- urgent_care_allowed
from service_cat_2
-- pivot(sum(total_allowed) for service_category_2 in ('Acute Inpatient',
--                                                  'Ambulance',
--                                                  'Ambulatory Surgery',
--                                                  'Dialysis',
--                                                  'Durable Medical Equipment',
--                                                  'Emergency Department',
--                                                  'Home Health',
--                                                  'Hospice',
--                                                  'Inpatient Psychiatric',
--                                                  'Inpatient Rehabilitation',
--                                                  'Lab',
--                                                  'Office Visit',
--                                                  'Outpatient Hospital or Clinic',
--                                                  'Outpatient Psychiatric',
--                                                  'Outpatient Rehabilitation',
--                                                  'Skilled Nursing',
--                                                  'Urgent Care'                                                 
--                                                  )) 
--   as p (patient_id, 
--         year_month, 
--         acute_inpatient_allowed, 
--         ambulance_allowed, 
--         ambulatory_surgery_allowed, 
--         dialysis_allowed, 
--         durable_medical_equipment_allowed, 
--         emergency_department_allowed,
--         home_health_allowed, 
--         hospice_allowed, 
--         inpatient_psychiatric_allowed, 
--         inpatient_rehabilitation_allowed, 
--         lab_allowed,
--         office_visit_allowed, 
--         outpatient_hospital_or_clinic_allowed, 
--         outpatient_psychiatric_allowed, 
--         outpatient_rehabilitation_allowed,
--         skilled_nursing_allowed, 
--         urgent_care_allowed
--         )
group by 1,2
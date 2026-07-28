
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SBMO"."VW_SCHEMA_UPDATER_MANIFEST" ("VERSION", "FILE_NAME", "APPLY_ORDER") AS 
  select version,
file_name,
row_number() over (order by apply_order nulls last, build_order) apply_order
from (select m.version,
m.file_name,
m.apply_order apply_order,
to_number(NULL) build_order
from pdx_schema_updater_manifest m
union
select m.version,
m.file_name,
to_number(NULL) apply_order,
apply_order build_order
from schema_updater_manifest m
where apply_order > (select NVL(max(mi.apply_order),-1)
from schema_updater_manifest mi
join pdx_schema_updater_manifest pmi using (file_name)
)
)

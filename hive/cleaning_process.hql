-- Code to move tables to our own database
use cadms;

-- Move popbyzip2010 to cadms database
create table popbyzip2010 as select * from msba.popbyzip2010;

-- Move nyc311calls2016 to cadms database
create table nyc311calls2016 as select * from msba.nyc311calls2016;

-- Move housingviolations to cadms database
create table housingviolations as select * from msba.housingviolations;

-- Move nycrestaurants to cadms database
create table nycrestaurants as select * from msba.nycrestaurants;


-- Cleaned tables

-- New york population 2010
create or replace view nycpopbyzip as
    select substr(regexp_replace(zipcode, "[^\\d]", ""), 1, 5) as zipcode, population
    from popbyzip2010
    where substr(regexp_replace(zipcode, "[^\\d]", ""), 1, 5) > 10000 and
        substr(regexp_replace(zipcode, "[^\\d]", ""), 1, 5) < 11697;


-- NYC 311 Calls cleaned and only (possible) relevant variables
create or replace view nyc311callscleaned as
    select substr(regexp_replace(incident_zip, "[^\\d]", ""), 1, 5) as zipcode,
    substr(created_date, 1, 2) as month, complaint_type, descriptor,
    lower(location_type) as location_type,
    lower(city) as city, lower(x_coordinate_state_plane) as borough,
    y_coordinate_state_plane as x_coordinate_state_plane,
    park_facility_name as y_coordinate_state_plane,
    location as longitude, longitude as latitude
    from nyc311calls2016
    where cast(substr(regexp_replace(incident_zip, "[^\\d]", ""), 1, 5) as int) > 10000 and
          cast(substr(regexp_replace(incident_zip, "[^\\d]", ""), 1, 5) as int) <= 11697 and
          lower(location_type) regexp '(.*restaurant.*|.*residential.*|.*family.*|private house)' and
          lower(location_type) not in ('building (non-residential)');


-- Restaurant violations for 2016 only and NYC zip codes
create or replace view nycrestaurantscleaned as
    select substr(regexp_replace(zipcode, "[^\\d]", ""), 1, 5) as zipcode, dba as restaurant_name,
    substr(inspection_date, 1, 2) as month,
    lower(critical_flag) as iscritical, cuisine_description, grade, score, inspection_type
    from nycrestaurants
    where cast(substr(regexp_replace(zipcode, "[^\\d]", ""), 1, 5) as int) > 10000 and
          cast(substr(regexp_replace(zipcode, "[^\\d]", ""), 1, 5) as int) <= 11697 and
          inspection_date rlike '201[6]$';

-- Housing violations for 2016 and NYC zip codes
create or replace view housingcleaned as
    select  substr(regexp_replace(zip, "[^\\d]", ""), 1, 5) as zipcode, class, currentstatus,
    substr(inspectiondate, 1, 2) as month
    from housingviolations
    where cast(substr(regexp_replace(zip, "[^\\d]", ""), 1, 5) as int) > 10000 and
          cast(substr(regexp_replace(zip, "[^\\d]", ""), 1, 5) as int) <= 11697 and
          inspectiondate rlike '201[6]$';

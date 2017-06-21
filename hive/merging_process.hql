-- Aggregation experiments 
-- Calls filtered by restaurant location type, zipcode and month
create or replace view restaurantcallsbyzipmonth as
    select count(*) as restaurant_calls, zipcode, month
    from nyc311callscleaned
    where location_type regexp '(.*restaurant.*)'
    group by zipcode, month;


-- Calls filtered by housing location type, zipcode and month
create or replace view housingcallsbyzipmonth as
    select count(*) as housing_calls, zipcode, month
    from nyc311callscleaned
    where location_type regexp '(.*residential.*|.*family.*|private house)'
    group by zipcode, month;


-- NYC restaurant violations by zipcode and month
create or replace view restaurantsbyzipmonth as
    select count(*) as restaurant_violations, zipcode, month
    from nycrestaurantscleaned
    group by zipcode, month;

-- NYC restaurant CRITICAL violations by zipcode and month
create or replace view criticalsbyzipmonth as
    select count(*) as restaurant_violations, zipcode, month
    from nycrestaurantscleaned
    where iscritical = 'critical'
    group by zipcode, month;

-- Housing violations by zipcode and month
create or replace view housingbyzipmonth as
    select count(*) as housing_violations, zipcode, month
    from housingcleaned
    group by zipcode, month;
    
-- MERGE SECTION

-- First master file merged (I can add any other filtered views here to get number of
-- calls or violation by some filter variable like critical violations)
create or replace view allbyzipmonth as
    select A.zipcode as zipcode, A.population as population, B.month as month,
    B.housing_violations as housing_violations, C.restaurant_violation as restaurant_violations,
    D.restaurant_calls as restaurant_calls, E.housing_calls as housing_calls
    from nycpopbyzip as A
    INNER JOIN (select * from housingbyzipmonth) as B on A.zipcode = B.zipcode
    INNER JOIN (select * from restaurantsbyzipmonth) as C on B.zipcode = C.zipcode and B.month = C.month
    INNER JOIN (select * from restaurantcallsbyzipmonth) as D on D.zipcode = C.zipcode and D.month = C.month
    INNER JOIN (select * from housingcallsbyzipmonth) as E on E.zipcode = D.zipcode and E.month = D.month;


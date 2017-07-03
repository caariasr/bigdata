-- Aggregation experiments 

-- Restaurant calls
create or replace view restaurantcallsbyzipmonth as
    select count(*) as restaurant_calls, zipcode, month  
    from nyc311callscleaned
    where location_type regexp '(.*restaurant.*|.*soup.*|.*catering.*|.*food.*|.*cafeteria.*)'
    group by zipcode, month;
    
-- Housing calls 
create or replace view housingcallsbyzipmonth as
    select count(*) as housing_calls, zipcode, month
    from nyc311callscleaned
    where location_type regexp '(.*residential.*|.*family.*|private house|.*apartment.*|.*residence.*)' 
    group by zipcode, month;

-- nycrestaurants
create or replace view restaurantsbyzipmonth as
    select count(*) as restaurant_violations, zipcode, month
    from nycrestaurantscleaned
    group by zipcode, month;

-- housingviolations
create or replace view housingbyzipmonth as
    select count(*) as housing_violations, zipcode, month
    from housingcleaned
    group by zipcode, month;   
    
-- MERGE SECTION

-- First master file merged (I can add any other filtered views here to get number of
-- calls or violation by some filter variable like critical violations)

create or replace view allbyzipmonth as
    select A.zipcode as zipcode, cast(A.population as int) as population, B.month as month, 
    B.housing_violations as housing_violations, C.restaurant_violations as restaurant_violations,
    D.restaurant_calls as restaurant_calls, E.housing_calls as housing_calls
    from nycpopbyzip as A
    INNER JOIN (select * from housingbyzipmonth) as B on A.zipcode = B.zipcode
    INNER JOIN (select * from restaurantsbyzipmonth) as C on B.zipcode = C.zipcode and B.month = C.month
    INNER JOIN (select * from restaurantcallsbyzipmonth) as D on D.zipcode = C.zipcode and D.month = C.month
    INNER JOIN (select * from housingcallsbyzipmonth) as E on E.zipcode = D.zipcode and E.month = D.month;

-- SECOND STAGE (ONLY BY ZIPCODE)
-- reataurant calls
create or replace view restaurantcallsbyzip as
    select count(*) as restaurant_calls, zipcode  
    from nyc311callscleaned
    where location_type regexp '(.*restaurant.*|.*soup.*|.*catering.*|.*food.*|.*cafeteria.*)'
    group by zipcode;
    
-- housing calls
create or replace view housingcallsbyzip as
    select count(*) as housing_calls, zipcode
    from nyc311callscleaned
    where location_type regexp '(.*residential.*|.*family.*|private house|.*apartment.*|.*residence.*)' 
    group by zipcode;


-- nycrestaurants
create or replace view restaurantsbyzip as
    select count(*) as restaurant_violations, zipcode
    from nycrestaurantscleaned
    group by zipcode;

-- housingviolations
create or replace view housingbyzip as
    select count(*) as housing_violations, zipcode
    from housingcleaned
    group by zipcode;
        
-- MERGE SECTION
create or replace view allbyzip as
    select A.zipcode as zipcode, cast(A.population as int) as population,
    B.housing_violations as housing_violations, C.restaurant_violations as restaurant_violations,
    D.restaurant_calls as restaurant_calls, E.housing_calls as housing_calls, 
    F.restaurant_critical_violations as restaurant_critical_violations
    from nycpopbyzip as A
    INNER JOIN (select * from housingbyzip) as B on A.zipcode = B.zipcode
    INNER JOIN (select * from restaurantsbyzip) as C on B.zipcode = C.zipcode
    INNER JOIN (select * from restaurantcallsbyzip) as D on D.zipcode = C.zipcode
    INNER JOIN (select * from housingcallsbyzip) as E on E.zipcode = D.zipcode;

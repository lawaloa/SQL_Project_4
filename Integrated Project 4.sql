/*1. Are there any specific provinces, or towns where some sources are more abundant?
2. We identified that tap_in_home_broken taps are easy wins. Are there any towns where this is a particular problem?

To answer question 1, we will need province_name and town_name from the location table. 
We also need to know type_of_water_source and number_of_people_served from the water_source table.

The problem is that the location table uses location_id while water_source only has source_id. 
So we won't be able to join these tables directly. 
But the visits table maps location_id and source_id. 
So if we use visits as the table we query from, we can join location where the location_id matches, 
and water_source where the source_id matches.

Before we can analyse, we need to assemble data into a table first. It is quite complex, 
but once we're done, the analysis is much simpler.

Start by joining location to visits.
Then join the water_source table on the key shared between water_source and visits.*/

USE md_water_services;

SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    s.type_of_water_source,
    s.number_of_people_served
FROM location AS l
JOIN visits AS v
ON l.location_id = v.location_id
JOIN water_source AS s
ON v.source_id = s.source_id;

/*Note that there are rows where visit_count > 1. These were the sites our surveyors collected additional 
information for, but they happened at the same source/location. 
For example, add this to your query: WHERE visits.location_id = 'AkHa00103'*/

SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    s.type_of_water_source,
    s.number_of_people_served
FROM location AS l
JOIN visits AS v
ON l.location_id = v.location_id
JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.location_id = 'AkHa00103';

/*There you can see what I mean. For one location, there are multiple AkHa00103 records for the same location. 
If we aggregate, we will include these rows, so our results will be incorrect. 
To fix this, we can just select rows where visits.visit_count = 1.
Remove WHERE visits.location_id = 'AkHa00103' and add the visits.visit_count = 1 as a filter.*/

SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    s.type_of_water_source,
    s.number_of_people_served
FROM location AS l
JOIN visits AS v
ON l.location_id = v.location_id
JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;

/*Ok, now that we verified that the table is joined correctly, we can remove the location_id and visit_count columns.
Add the location_type column from location and time_in_queue from visits to our results set.*/

SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    s.type_of_water_source,
    s.number_of_people_served,
    l.location_type,
    v.time_in_queue
FROM location AS l
JOIN visits AS v
ON l.location_id = v.location_id
JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;

/*Last one! Now we need to grab the results from the well_pollution table.
This one is a bit trickier. The well_pollution table contained only data for well. 
If we just use JOIN, we will do an inner join, so that only records that are in well_pollution AND visits will be 
joined. We have to use a LEFT JOIN to join theresults from the well_pollution table for well sources, 
and will be NULL for all of the rest. 
Play around with the different JOIN operations to make sure you understand why we used LEFT JOIN.*/

SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    s.type_of_water_source,
    s.number_of_people_served,
    l.location_type,
    v.time_in_queue,
    w.results
FROM visits AS v
LEFT JOIN
	well_pollution AS w
ON v.source_id = w.source_id
INNER JOIN location AS l
ON v.location_id = l.location_id
INNER JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;

/*So this table contains the data we need for this analysis. Now we want to analyse the data in the results set. 
We can either create a CTE, and then query it, or in my case, I'll make it a VIEW so it is easier to share with you. 
I'll call it the combined_analysis_table.*/


CREATE VIEW combined_analysis_table AS 
SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id,
    s.type_of_water_source AS source_type,
    s.number_of_people_served AS people_served,
    l.location_type,
    v.time_in_queue,
    w.results
FROM visits AS v
LEFT JOIN
	well_pollution AS w
ON v.source_id = w.source_id
INNER JOIN location AS l
ON v.location_id = l.location_id
INNER JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;

/*The last analysis
We're building another pivot table! This time, we want to break down our data into provinces or towns and source types. 
If we understand where the problems are, and what we need to improve at those locations, 
we can make an informed decision on where to send our repair teams.
We did most of this before, so I'll give you the queries I used, explain them a bit, 
and then we'll look at the results.
The queries I am sharing with you today are not formatted well because I am trying to fit them into my chat messages,
 but make sure you add comments, and document your code well so you can use it again.*/
 
 -- This is the query I used:
WITH province_totals AS (-- This CTE calculates the population of each province
SELECT
province_name,
SUM(people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
)
SELECT
ct.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN
province_totals pt ON ct.province_name = pt.province_name
GROUP BY
ct.province_name
ORDER BY
ct.province_name;

/*province_totals is a CTE that calculates the sum of all the people surveyed grouped by province. 
If you replace the query above with this one:
SELECT
*
FROM
province_totals;

You should get a table of province names and summed up populations for each province.

The main query selects the province names, and then like we did last time, we create a bunch of columns for each type
of water source with CASE statements, sum each of them together, and calculate percentages.
We join the province_totals table to our combined_analysis_table so that the correct value for each province's 
pt.total_ppl_serv value is used.

Finally we group by province_name to get the provincial percentages.*/

WITH province_totals AS (-- This CTE calculates the population of each province
SELECT
province_name,
SUM(people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
)

SELECT
*
FROM
province_totals;

/*Run the query and see if you can spot any of the following patterns:
• Look at the river column, Sokoto has the largest population of people drinking river water. We should send our 
drilling equipment to Sokoto first, so people can drink safe filtered water from a well.
• The majority of water from Amanzi comes from taps, but half of these home taps don't work because the 
infrastructure is broken. We need to send out engineering teams to look at the infrastructure in Amanzi first. 
Fixing a large pump, treatment plant or reservoir means that thousands of people will have running water. 
This means they will also not have to queue for water, so we improve two things at once.
Spot any other interesting patterns?*/

/*Let's aggregate the data per town now. You might think this is simple, but one little town makes this hard. 
Recall that there are two towns in Maji Ndogo called Harare. One is in Akatsi, and one is in Kilimani. 
Amina is another example. So when we just aggregate by town, SQL doesn't distinguish between the different Harare's, 
so it combines their results.

To get around that, we have to group by province first, then by town, so that the duplicate towns are distinct 
because they are in different towns*/

-- Here is the query:

WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT 
	province_name, 
	town_name, 
	SUM(people_served) AS total_ppl_serv
FROM 
	combined_analysis_table
GROUP BY 
	province_name,
	town_name
)
SELECT
	ct.province_name,
	ct.town_name,
	ROUND((SUM(CASE WHEN source_type = 'river'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
	ROUND((SUM(CASE WHEN source_type = 'shared_tap'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
	ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
	ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
	ROUND((SUM(CASE WHEN source_type = 'well'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table AS ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals AS tt 
ON ct.province_name = tt.province_name 
AND ct.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;

/*Here the CTE calculates town_totals which returns three columns:
province_name,
town_name,
total_ppl_serv.

In the main query we select the province_name and the town_name and then calculate the percentage of people using 
each source type, using the CASE statements.
Then we join town_totals to combined_analysis_table, but this time the town_names are not unique, so we have 
to join town_totals, but we check that both the province_name and town_name matches the values in 
combined_analysis_table.

Then we group it by province_name, then town_name. This query can take a while to calculate, so hopefully, 
you start to see how a query can quickly become slow as it becomes more complex.

This query can take a while to calculate, so hopefully you start to see how a query can quickly become slow as it 
becomes more complex.

Before we jump into the data, let's store it as a temporary table first, so it is quicker to access.*/


/*Temporary tables in SQL are a nice way to store the results of a complex query. We run the query once, and the 
results are stored as a table. The catch? If you close the database connection, it deletes the table, so you have 
to run it again each time you start working in MySQL. The benefit is that we can use the table to do more 
calculations, without running the whole query each time.

To do it, add this to the start of your query:
CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS*/

CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT 
	province_name, 
	town_name, 
	SUM(people_served) AS total_ppl_serv
FROM 
	combined_analysis_table
GROUP BY 
	province_name,
	town_name
)
SELECT
	ct.province_name,
	ct.town_name,
	ROUND((SUM(CASE WHEN source_type = 'river'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
	ROUND((SUM(CASE WHEN source_type = 'shared_tap'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
	ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
	ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
	ROUND((SUM(CASE WHEN source_type = 'well'
	THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table AS ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals AS tt 
ON ct.province_name = tt.province_name 
AND ct.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;

/*So, let's order the results set by each column. If we order river DESC it confirms what we saw on a provincial level; People are drinking river water
in Sokoto.
But look at the tap_in_home percentages in Sokoto too. Some of our citizens are forced to drink unsafe water from a 
river, while a lot of people have running water in their homes in Sokoto. Large disparities in water access like 
this often show that the wealth distribution in Sokoto is very unequal.
We should mention this in our report. We should also send our drilling teams to Sokoto first to drill some wells 
for the people who are drinking river water, specifically the rural parts and the city of Bahari.

Next, sort the data by province_name next and look at the data for Amina in Amanzi. Here only 3% of Amina's citizens 
have access to running tap water in their homes. More than half of the people in Amina have taps installed in 
their homes, but they are not working. We should send out teams to go and fix the infrastructure in Amina first. 
Fixing taps in people's homes, means those people don't have to queue for water anymore, so the queues in Amina will
also get shorter!

There are still many gems hidden in this table. For example, which town has the highest ratio of people who have 
taps, but have no running water?
Running this:*/

SELECT
	province_name,
	town_name,
	ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100,0) AS Pct_broken_taps
FROM
	town_aggregated_water_access;

/*We can see that Amina has infrastructure installed, but almost none of it is working, and only the capital city, 
Dahabu's water infrastructure works.
Strangely enough, all of the politicians of the past government lived in Dahabu, so they made sure they had water. 
The point is, look how simple our query is now! It's like we're back at the beginning of our journey!

It would be so nice to see this data, right? But because there are so many sources, and so many towns, it is hard to
explain this visually without some better tools. Imagine we could have a graph where we do this kind of filtering 
and sorting of data in the graph!! Well, you will meet Dalila soon, and she will help us to build something like 
that!

Check up the Summary report, Plan of action and Practical Solutions in Part4 pdf

A practical plan

Our final goal is to implement our plan in the database.
We have a plan to improve the water access in Maji Ndogo, so we need to think it through, and as our final task, 
create a table where our teams have the information they need to fix, upgrade and repair water sources. They will 
need the addresses of the places they should visit (street address, town, province), the type of water source they 
should improve, and what should be done to improve it.
We should also make space for them in the database to update us on their progress. We need to know if the repair is 
complete, and the date it was completed, and give them space to upgrade the sources. Let's call this table 
Project_progress.*/

CREATE TABLE Project_progress (
Project_id SERIAL PRIMARY KEY,
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
Address VARCHAR(50),
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50),
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
Date_of_completion DATE,
Comments TEXT
);

/*At a high level, the Improvements are as follows:
1. Rivers → Drill wells
2. wells: if the well is contaminated with chemicals → Install RO filter
3. wells: if the well is contaminated with biological contaminants → Install UV and RO filter
4. shared_taps: if the queue is longer than 30 min (30 min and above) → Install X taps nearby where X number of taps 
is calculated using X = FLOOR(time_in_queue / 30).
5. tap_in_home_broken → Diagnose local infrastructure

Can you see that for wells and shared taps we have some IF logic, so we should be thinking CASE functions! Let's 
take the various Improvements one by one, then combine them into one query at the end.
To make this simpler, we can start with this query:

−− Project_progress_query*/

SELECT
	l.address,
	l.town_name,
	l.province_name,
	s.source_id,
	s.type_of_water_source,
	w.results
FROM
water_source AS s
LEFT JOIN
well_pollution AS w 
ON s.source_id = w.source_id
INNER JOIN
visits AS v ON s.source_id = v.source_id
INNER JOIN
location AS l ON l.location_id = v.location_id;

/*It joins the location, visits, and well_pollution tables to the water_source table. Since well_pollution only has 
data for wells, we have to join those records to the water_source table with a LEFT JOIN and we used visits to link 
the various id's together.

First things first, let's filter the data to only contain sources we want to improve by thinking through the logic
first.
1. Only records with visit_count = 1 are allowed.
2. Any of the following rows can be included:
a. Where shared taps have queue times over 30 min.
b. Only wells that are contaminated are allowed -- So we exclude wells that are Clean
c. Include any river and tap_in_home_broken sources.*/

SELECT
	l.address,
	l.town_name,
	l.province_name,
	s.source_id,
	s.type_of_water_source,
	w.results
FROM
water_source AS s
LEFT JOIN
well_pollution AS w 
ON s.source_id = w.source_id
INNER JOIN
visits AS v ON s.source_id = v.source_id
INNER JOIN
location AS l ON l.location_id = v.location_id
WHERE
v.visit_count = 1
AND (w.results != 'Clean'
OR s.type_of_water_source IN ('tap_in_home_broken', 'river')
OR (s.type_of_water_source = 'shared_tap' AND v.time_in_queue > 30));

/*Let's start with wells. Depending on whether they are chemically contaminated, or biologically contaminated — we'll 
decide on the interventions.

Use some control flow logic to create Install UV filter or Install RO filter values in the Improvement column where 
the results of the pollution tests were Contaminated: Biological and Contaminated: Chemical respectively. 
Think about the data you'll need, and  which table to find it in. Use ELSE NULL for the final alternative.

If you did it right, there should be Install RO filter and Install UV and RO filter values in the Improvements column
now, and lots of NULL values.

Step 2: Rivers
Now for the rivers. We upgrade those by drilling new wells nearby.

Add Drill well to the Improvements column for all river sources.

Check your records to make sure you see Drill well for river sources.

Step 3: Shared taps
Next up, shared taps. We need to install one tap near each shared tap for every 30 min of queue time.
This is my logic:
CASE
...
WHEN type_of_water_source = ... AND ... THEN CONCAT("Install ", FLOOR(...), " taps nearby")
ELSE NULL
I am using FLOOR() here because I want to round the calculation down. Say the queue time is 45 min. The result of 
45/30 = 1.5, which could round up to 2. We only want to install a second tap if the queue is > 60 min. Using FLOOR()
will round down  everything below 59 mins to one extra tap, and if the queue is 60 min, we will install two taps, and
so on.

Use this code, and fill in the blanks to update the Improvement column for shared_taps with long queue times.

Check to make sure you're getting Installed x taps values in the Improvement column.
Step 4: In-home taps
Lastly, let's look at in-home taps, specifically broken ones. These taps indicate broken infrastructure. So these 
need to be inspected by our engineers.

Add a case statement to our query updating broken taps to Diagnose local infrastructure.

So our final query should now return 25398 rows of data, with rivers, various wells, shared taps and broken taps 
flagged for improvement, and importantly, no NULL values!

Step 6: Add the data to Project_progress*/

SELECT
    s.source_id,
    l.address,
    l.town_name,
    l.province_name,
    s.type_of_water_source AS source_type,
    
    -- CASE logic for Improvement
    CASE
        -- Chemical contamination
        WHEN w.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        
        -- Biological contamination
        WHEN w.results = 'Contaminated: Biological' THEN 'Install UV filter'
        
        -- Rivers
        WHEN s.type_of_water_source = 'river' THEN 'Drill well'
        
        -- Shared taps with long queue time
        WHEN s.type_of_water_source = 'shared_tap' AND v.time_in_queue > 30
            THEN CONCAT('Install ', FLOOR(v.time_in_queue / 30), ' taps nearby')
        
        -- Broken in-home taps
        WHEN s.type_of_water_source = 'tap_in_home_broken' THEN 'Diagnose local infrastructure'
        
        ELSE NULL
    END AS Improvement,
    
    w.results AS source_status,  -- You can decide to default this to 'Backlog' if needed
    NULL AS date_of_completion,
    NULL AS comments

FROM
    water_source AS s
LEFT JOIN
    well_pollution AS w ON s.source_id = w.source_id
INNER JOIN
    visits AS v ON s.source_id = v.source_id
INNER JOIN
    location AS l ON l.location_id = v.location_id

WHERE
    v.visit_count = 1
    AND (
        w.results != 'Clean'
        OR s.type_of_water_source IN ('tap_in_home_broken', 'river')
        OR (s.type_of_water_source = 'shared_tap' AND v.time_in_queue > 30)
    );


/*Step 2: Insert the Results into Project_progress
Since your Project_id column is SERIAL PRIMARY KEY, you don't need to insert values for it (it will auto-increment).*/

INSERT INTO Project_progress (
    source_id,
    Address,
    Town,
    Province,
    Source_type,
    Improvement,
    Source_status,
    Date_of_completion,
    Comments
)
SELECT
    s.source_id,
    l.address,
    l.town_name,
    l.province_name,
    s.type_of_water_source AS source_type,
    
    CASE
        WHEN w.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN w.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN s.type_of_water_source = 'river' THEN 'Drill well'
        WHEN s.type_of_water_source = 'shared_tap' AND v.time_in_queue > 30
            THEN CONCAT('Install ', FLOOR(v.time_in_queue / 30), ' taps nearby')
        WHEN s.type_of_water_source = 'tap_in_home_broken' THEN 'Diagnose local infrastructure'
        ELSE NULL
    END AS Improvement,
    
    CASE
        WHEN w.results IN ('Contaminated: Chemical', 'Contaminated: Biological')
            OR s.type_of_water_source = 'river'
            OR (s.type_of_water_source = 'shared_tap' AND v.time_in_queue > 30)
            OR s.type_of_water_source = 'tap_in_home_broken'
        THEN 'In progress'
        ELSE 'Backlog'
    END AS Source_status,
    
    NULL AS Date_of_completion,
    NULL AS Comments

FROM
    water_source AS s
LEFT JOIN
    well_pollution AS w ON s.source_id = w.source_id
INNER JOIN
    visits AS v ON s.source_id = v.source_id
INNER JOIN
    location AS l ON l.location_id = v.location_id

WHERE
    v.visit_count = 1
    AND (
        w.results != 'Clean'
        OR s.type_of_water_source IN ('tap_in_home_broken', 'river')
        OR (s.type_of_water_source = 'shared_tap' AND v.time_in_queue > 30)
    );
    


# 💧 SQL Project 4 | Maji Ndogo Water Crisis – Charting the Course for Maji Ndogo’s Water Future
---

## 👤 Author
---

**Omotola Lawal**  
📅 _20th October, 2025_  
🔗 [LinkedIn](https://www.linkedin.com/in/omotola-lawal-541b9b131)

---

## 📑 Table of Contents
---

- [🗣️ Message from President Aziza Naledi](#%EF%B8%8F-message-from-president-aziza-naledi)
- [🏁 Introduction: Starting the Final Journey](#-introduction-starting-the-final-journey)
- [🔗 Joining Pieces Together: Finding the Data We Need Across Tables](#-joining-pieces-together-finding-the-data-we-need-across-tables)
- [📊 The Last Analysis: Finding the Final Insights from Our Data](#-the-last-analysis-finding-the-final-insights-from-our-data)
- [📋 Summary Report: Sharing Our Knowledge with Decision Makers](#-summary-report-sharing-our-knowledge-with-decision-makers)
- [🧭 A Practical Plan: From Analysis to Action](#-a-practical-plan-from-analysis-to-action)
- [📑 Reference](#-reference)

---

## 🗣️ Message from President Aziza Naledi
---

> Dear Team,  
> I would like to thank the team for uncovering the corruption of our field workers and letting me know. As you all know, I have no tolerance for people who look after themselves first, at the cost of everyone else, so I have taken the necessary steps!  
>
> Our journey continues, as we aim to convert our data into actionable knowledge. Understanding the situation is one thing, but translating that understanding into informed decisions will truly make a difference.  
>
> As we step into this next phase, you will be shaping our raw data into meaningful views—providing essential information to decision-makers. This will enable us to discern the materials we need, plan our budgets, and identify the areas requiring immediate attention.  
>
> Remember, each step you take contributes to a larger goal—the transformation of Maji Ndogo.  
> Your diligence and dedication are instrumental in shaping a brighter future for our community.  
>
> — **President Aziza Naledi**

---

## 🏁 Introduction: Starting the Final Journey
---

Hey there! 👋  
It’s been quite a journey working on the Maji Ndogo Water Crisis analysis. As I prepare to move on to my next project, I wanted to share this final reflection with you.  

![Picture showing corrupt surveyors](https://github.com/lawaloa/SQL_Project_4/blob/main/Image.png)

> It feels rewarding to see justice finally take the front seat.  
> Maji Ndogo is truly changing — and I believe it’s because President Naledi understands the power of data.  
> Her commitment to transparency and accountability gives me hope for the future. 🌍  
>
> This project has reminded me why I’m passionate about data storytelling — transforming raw numbers into meaningful insights that can shape real-world outcomes.

> ## ✅ Skills Applied  
>  
> - **SQL Mastery**: Joins · Aggregations · Filtering · Conditional logic · Case statements  
> - **Data Cleaning & Validation**: Detecting inconsistencies · Ensuring data integrity · Handling nulls and duplicates  
> - **Exploratory Data Analysis (EDA)**: Exploring provincial water patterns · Investigating queue times · Spotting contamination trends  
> - **Analytical Thinking**: Building stepwise queries · Simplifying logic with CTEs · Iterative testing for accuracy  
> - **Data Storytelling**: Turning query outputs into actionable insights · Communicating findings through visuals and reports  
> - **Problem-Solving**: Debugging queries · Structuring efficient logic · Balancing readability and scalability  
> - **Transparency & Accountability Focus**: Applying data to drive equitable water access · Supporting governance with evidence-based insights  
>
> _These skills were applied throughout the Maji Ndogo Water Access project to identify improvement priorities and guide data-driven decision-making._

---

## 🔗 Joining Pieces Together: Finding the Data We Need Across Tables
---

At this stage of the **Maji Ndogo Water Crisis** project, I was determined to bring together all the scattered pieces of data into a single, insightful view.  

When I first started exploring the dataset, I often made the rookie mistake of merging *every* table and column into one large table before analyzing. It worked on smaller datasets, but with one this size — performance dropped, queries lagged, and the whole process became inefficient.  

So this time, I took a step back and thought carefully about the questions I needed to answer.  
That mindset shift — from *"get everything"* to *"get only what I need"* — changed the game for me.

---

### 🔍 Questions I Wanted to Answer
---

1. Are there any specific provinces or towns where certain types of water sources are more common?  
2. We previously identified **`tap_in_home_broken`** taps as easy wins — are there any towns where this problem is particularly bad?

To answer these, I needed data from:
- `location` → province and town names  
- `water_source` → type of source and number of people served  
- `visits` → connection between sources and locations  
- `well_pollution` → quality data for wells only  

---

### 🧠 My Thinking Process
---

Because `location` and `water_source` can’t be directly joined, I realized the **`visits`** table would act as the bridge between them.  
Once I understood that, building the query felt like solving a puzzle — piece by piece.

---

### 🧩 Step 1: Joining `location` to `visits`
---

<details>
<summary>🧾 Click to view SQL Query</summary>

```sql
USE md_water_services;

SELECT
	l.province_name,
    l.town_name,
    v.visit_count,
    v.location_id 
FROM location AS l
JOIN visits AS v
ON l.location_id = v.location_id;
```

</details>


</details> <details> <summary>📊 Click to view result table</summary>

| province_name | town_name | visit_count | location_id |
| ------------- | --------- | ----------- | ----------- |
| Sokoto        | Ilanga    | 1           | SoIl32582   |
| ...           | ...       | ...         | ...         |

</details>


### 🔗 Step 2: Adding `water_source`
---

Next, I joined the `water_source` table to include details about each water source.

<details> 
<summary>🧾 Click to view SQL Query</summary>

```sql
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
```

</details> 

<details> 
<summary>📊 Click to view result table</summary>
  
| province_name | town_name | visit_count | location_id | type_of_water_source | number_of_people_served |
| ------------- | --------- | ----------- | ----------- | -------------------- | ----------------------- |
| Akatsi        | Harare    | 1           | AkHa00000   | tap_in_home          | 956                     |
| Akatsi        | Harare    | 1           | AkHa00001   | tap_in_home_broken   | 930                     |
| Akatsi        | Harare    | 1           | AkHa00002   | tap_in_home_broken   | 486                     |
| Akatsi        | Harare    | 1           | AkHa00003   | well                 | 364                     |
| ...           | ...       | ...         | ...         | ...                  | ...                     |

</details>


### ⚠️ Step 3: Handling Duplicates
---

When I filtered for a specific location, I noticed something interesting — the same `location_id` appeared multiple times with different `visit_count` values.

<details>
<summary>🧾 Click to view SQL Query</summary>

```sql
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
```

</details> 

<details> 
<summary>📊 Click to view result table</summary>
  
| province_name | town_name | visit_count | location_id | type_of_water_source | number_of_people_served |
| ------------- | --------- | ----------- | ----------- | -------------------- | ----------------------- |
| Akatsi        | Harare    | 1           | AkHa00103   | shared_tap           | 3340                    |
| Akatsi        | Harare    | 2           | AkHa00103   | shared_tap           | 3340                    |
| Akatsi        | Harare    | 3           | AkHa00103   | shared_tap           | 3340                    |
| ...           | ...       | ...         | ...         | ...                  | ...                     |

</details>

This duplication would inflate results during aggregation. To fix it, I filtered for `visit_count = 1`  to ensure only the first survey record was used.

### 🧩 Step 4: Final Join and Filtering
---

<details> 
<summary>🧾 Click to view SQL Query</summary>

```sql
SELECT 
	l.province_name,
    l.town_name,
    s.type_of_water_source,
    l.location_type,
    s.number_of_people_served,
    v.time_in_queue
FROM location AS l
JOIN visits AS v
ON l.location_id = v.location_id
JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;
```

</details> 

<details> 
<summary>📊 Click to view result table</summary>

| province_name | town_name | type_of_water_source | location_type | number_of_people_served | time_in_queue |
| ------------- | --------- | -------------------- | ------------- | ----------------------- | ------------- |
| Sokoto        | Ilanga    | river                | Urban         | 402                     | 15            |
| Kilimani      | Rural     | well                 | Rural         | 252                     | 0             |
| Hawassa       | Rural     | shared_tap           | Rural         | 542                     | 62            |
| Akatsi        | Lusaka    | well                 | Urban         | 210                     | 0             |
| ...           | ...       | ...                  | ...           | ...                     | ...           |

</details>

### 💧 Step 5: Integrating `well_pollution`
---

For this part, I had to remind myself that `well_pollution` only contains data about wells. Using an `INNER JOIN` would exclude non-well sources, so I opted for a `LEFT JOIN` instead to retain all sources and add pollution data where available.

<details> 
<summary>🧾 Click to view SQL Query</summary>

```sql
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
LEFT JOIN well_pollution AS w
ON v.source_id = w.source_id
INNER JOIN location AS l
ON v.location_id = l.location_id
INNER JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;
```

</details>

### 🏗️ Step 6: Creating a View for Reuse
---

I decided to turn the final query into a view so I could easily reuse it across other analyses and visualizations.

<details> 
<summary>🧾 Click to view SQL Query</summary>

```sql
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
LEFT JOIN well_pollution AS w
ON v.source_id = w.source_id
INNER JOIN location AS l
ON v.location_id = l.location_id
INNER JOIN water_source AS s
ON v.source_id = s.source_id
WHERE v.visit_count = 1;
```

</details>

### 💭 Reflection
---

This part of the project reminded me why I love data analysis. It’s not just about writing SQL — it’s about **understanding relationships**, **optimizing queries**, and **making data tell a coherent story**.

Every join felt like connecting the dots in a mystery, and when the final table came together, it finally made sense.
It was a small but satisfying victory in my journey toward becoming a better data storyteller.

---


## 📊 The Last Analysis: Finding the Final Insights from Our Data
---

his part of the project felt different for me — more personal.
I wasn’t just querying data anymore; I was uncovering stories hidden in the numbers. Every percentage, every row, was a reflection of real people’s lives.

So, I decided to take a closer look — province by province, and then town by town — to understand who had access to clean water and who didn’t.

### 💧 Provincial Overview — Spotting the Big Picture
---

Before jumping into towns, I wanted to see the broader picture across provinces.
Here’s the query I wrote to aggregate the data.

<details> 
<summary>👩‍💻 <b>Click to view my SQL Query</b></summary>

```sql
WITH province_totals AS ( -- This CTE calculates the population of each province
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
    ROUND((SUM(CASE WHEN source_type = 'river' THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
    ROUND((SUM(CASE WHEN source_type = 'shared_tap' THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
    ROUND((SUM(CASE WHEN source_type = 'tap_in_home' THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
    ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken' THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
    ROUND((SUM(CASE WHEN source_type = 'well' THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM
    combined_analysis_table ct
JOIN
    province_totals pt ON ct.province_name = pt.province_name
GROUP BY
    ct.province_name
ORDER BY
    ct.province_name;
```

</details> 

<details> 
<summary>📊 <b>Click to view provincial result table</b></summary>

| province_name | river     | shared_tap  | tap_in_home | tap_in_home_broken | well |
| ------------- |-----------| ----------- | ----------- | ------------------ | ---- |
| Sokoto        | 45        | 18          | 25          | 9                  | 3    |
| Amanzi        | 3         | 28          | 48          | 21                 | 0    |
| Akatsi        | 7         | 15          | 30          | 32                 | 16   |

</details>

### 📈 Visualizing the Provincial Pattern
---

Here’s what the data looks like when visualized — clearer, more emotional, and more powerful.

![Population Percentage by Source of Water, per Province](https://github.com/lawaloa/SQL_Project_4/blob/main/Pattern_image.png)

> 🧩 This graph confirmed what I saw in the query — **Sokoto** stands out with a very high percentage of people depending on river water.
> **Amanzi**, on the other hand, shows a worrying number of broken taps.
> These patterns helped me prioritize where to send repair teams first.


### 🏘 Town-Level Insights — Getting Personal
---

Next, I zoomed in further. But it wasn’t easy — I realized that some town names repeat (like Harare in both Akatsi and Kilimani).
So I grouped my data by both province and town, to get the right picture.

<details> 
<summary>👩‍💻 <b>Click to view my Town Aggregation Query</b></summary>

```sql
WITH town_totals AS (
    SELECT 
        province_name, 
        town_name, 
        SUM(people_served) AS total_ppl_serv
    FROM 
        combined_analysis_table
    GROUP BY 
        province_name, town_name
)
SELECT
    ct.province_name,
    ct.town_name,
    ROUND((SUM(CASE WHEN source_type = 'river' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
    ROUND((SUM(CASE WHEN source_type = 'shared_tap' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
    ROUND((SUM(CASE WHEN source_type = 'tap_in_home' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
    ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
    ROUND((SUM(CASE WHEN source_type = 'well' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
    combined_analysis_table AS ct
JOIN
    town_totals AS tt 
    ON ct.province_name = tt.province_name 
    AND ct.town_name = tt.town_name
GROUP BY
    ct.province_name, ct.town_name
ORDER BY
    ct.town_name;
```

</details> 

<details>
<summary>📊 <b>Click to view sample Town Result Table</b></summary>

| province_name | town_name   | tap_in_home | tap_in_home_broken | shared_Tap | well | river |
| ------------- | ----------- | ----------- | ------------------ | ---------- | ---- | ----- |
| Akatsi        | Harare      | 28          | 27                 | 17         | 27   | 2     |
| Amanzi        | Amina       | 3           | 56                 | 24         | 9    | 8     |
| Amanzi        | Dahabu      | 55          | 1                  | 37         | 4    | 3     |

</details>

While reading through these results, one town stood out — **Amina** in Amanzi.
Only 3% of its people have running water, yet more than half have taps installed that don’t work.

That hit me.
I wrote in my notes:

> “If I could deploy one repair team today, I’d send them to Amina first.”

### 🧾 Finding Patterns — Telling Data Stories
---

I also calculated which towns had the highest share of **broken taps** relative to total installed taps:

<details> 
<summary>👩‍💻 <b>Click to view Query</b></summary>

```sql
SELECT
    province_name,
    town_name,
    ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100, 0) AS Pct_broken_taps
FROM
    town_aggregated_water_access;
```

</details> 

<details>
<summary>📊 <b>Click to view Result Table</b></summary>

| province_name | town_name  | Pct_broken_taps |
| ------------- | ---------- | --------------- |
| Amanzi        | Amina      | 95              |
| Amanzi        | Bello      | 52              |
| Akatsi        | Kintampo   | 46              |


</details>

Amina again. Almost all taps broken.
It was clear now — this wasn’t just data; it was evidence.
I could visualize the inequality: Dahabu (the capital, where past politicians lived) had perfectly working taps, while surrounding towns struggled to find clean water.

This realization shaped my final summary and recommendations.

### 💭 My Takeaway
---

This part of the project reminded me why I love data.
It’s not just about numbers and queries — it’s about using data to *see people, spot injustice, and propose solutions that matter*.

Every `CTE`, every `JOIN`, every percentage — they all told a story.
And now, I was ready to turn those insights into action.

---

## 📋 Summary Report: Sharing Our Knowledge with Decision Makers
--- 

### 💡 Insights  

Alright, let’s wrap up what I’ve discovered from this project.  
A few weeks ago, I dug into the data, and here’s what stood out to me:  

1. Most of **Maji Ndogo’s** water sources are rural.  
2. About **43% of our people rely on shared taps** — sometimes as many as **2,000 people per tap**.  
3. Around **31% of households** have water infrastructure at home, but within that group,  
4. Nearly **45% face non-functional systems** — mostly due to faulty **pipes, pumps, and reservoirs**.  
   - Towns like **Amina**, rural **Amanzi**, and parts of **Akatsi** and **Hawassa** are among the worst hit.  
5. About **18% of the population use wells**, but only **28% of those wells are clean** — especially in **Hawassa**, **Kilimani**, and **Akatsi**.  
6. Water access also comes with long waits — often **over 120 minutes** on average:  
   - Queues stretch the longest on **Saturdays**.  
   - They peak in the **mornings and evenings**.  
   - **Wednesdays and Sundays** tend to be the easiest days to fetch water.  

Seeing all this laid out made me realize just how much everyday life in Maji Ndogo depends on a few key sources — and how much impact a small fix can make.  

---

### 🧩 Plan of Action  

Based on the data, here’s the approach I’d take moving forward:  

1. **Tackle shared taps first** — improving them will help the largest number of people immediately.  
2. **Clean up wells** — they’re a good source, but contamination is widespread.  
3. **Repair broken infrastructure** — one fix here can benefit hundreds of homes and reduce queuing elsewhere.  
4. **Hold off on new home installations (for now)** — focusing resources where they’ll have the biggest impact.  
5. **Prepare rural teams** — most work will happen outside urban centers, where logistics and access are tougher.  

---

### 🛠️ Practical Solutions  

1. **Rivers:** For communities still depending on rivers, I’d start by sending water trucks as a short-term solution while we drill wells for a permanent fix. **Sokoto** would be my first target.  
2. **Wells:** I’d install filters — **RO (Reverse Osmosis) filters** for chemical pollution and **Ultra Violent (UV) filters** for biological contamination. Long-term, I’d investigate the root causes of these pollutants.  
3. **Shared taps:**  
   - In the short term, send **extra tankers** to the busiest taps on the busiest days (guided by the queue-time data).  
   - In the medium term, **install additional taps** where demand is highest — starting with **Bello**, **Abidjan**, and **Zuri**.  
   - The goal: bring average queue times **below 30 minutes**, following **UN standards**.  
4. **Low-queue taps:** Taps with short wait times (<30 min) don’t need immediate upgrades — installing home taps here will be a longer-term goal.  
5. **Broken infrastructure:** Repairing one reservoir or major pipe can restore access for hundreds. I’d prioritize **Amina**, **Lusaka**, **Zuri**, **Djenne**, and the rural parts of **Amanzi**.  

---

I’ve really enjoyed diving deep into this project — it’s been more than just SQL queries and dashboards; it’s about understanding how **data can tell human stories**.  
Every row and column pointed back to real people waiting in real queues — and that’s what keeps me motivated to keep building, one dataset at a time. 💧📊  

---

## 🧭 A Practical Plan: From Analysis to Action
---

Now that I’ve wrapped up my analysis, it’s time to **put the plan into action** — right inside the database.

I’ve come a long way with this project, and this part feels like the most meaningful one.  
It’s where all the insights, numbers, and logic finally become **real, trackable steps** that can help our engineers improve water access across **Maji Ndogo**.  

The goal is simple:  
I want to build a table that gives our field teams everything they need — **where to go, what to fix, and how to report back**.  

They’ll need:
- The **address** of each location (street, town, province).  
- The **type of water source**.  
- The **specific action** needed (repair, upgrade, or replacement).  
- Space to **update progress** and record **completion dates**.  

So, I created a table called **`Project_progress`**.  

---

<details>
<summary>🧱 <b>Click to view the CREATE TABLE query</b></summary>

```sql
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
```

</details> 

Once the structure is ready, I moved on to design the query that actually fills this table — using everything I’ve learned so far.


### 🧠 My Thought Process
---

The diagram below illustrates the logical flow of my query construction and data-filtering steps:
  
![](https://github.com/lawaloa/SQL_Project_4/blob/main/Flow_chart.png)

At a high level, my improvement logic looks like this:

1. **Rivers** → Drill wells.

2. **Wells**:
   - If chemically contaminated → Install **RO filter**.
   - If biologically contaminated → **Install UV + RO filters**.

3. **Shared taps**:
   - If queue time ≥ 30 minutes → Install **X extra taps**, where `X = FLOOR(time_in_queue / 30)`.

4. **In-home taps (broken)**: Diagnose local infrastructure.

The logic felt like a perfect use case for `CASE statements` — my favourite SQL control flow tool.

### 🧩 Combining the Data
---

To make this work, I joined together the `water_source`, `well_pollution`, `visits`, and `location` tables.
Then I filtered out any data that wasn’t relevant — keeping only the first visit to each site and the sources that actually need improvement.

Here’s the initial query logic:

<details> 
<summary>🪄 <b>Click to view the filtering query</b></summary>

```sql

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
```

</details>

### 🧩 Final Query
---

After layering in all the logic with `CASE` statements, here’s the final query that generates the data for `Project_progress`.

<details> 
<summary>📊 <b>Click to view the final query</b></summary>

```sql
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
```

</details>

### 📥 Inserting the Results into the Table
---

After verifying the query results (about **25,398 rows**), I inserted them directly into the new table.

<details> 
<summary>🗂️ <b>Click to view the INSERT query</b></summary>

```sql
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
```

</details>

### 🪶 Wrapping Up
---

And that’s it — my `Project_progress` table is ready to guide the repair teams!
It will let us track repairs, upgrades, and completions — and give President Naledi a clear picture of progress as it happens.

This was a long journey — from **joins** to **window** functions, and even a few debugging marathons.
But looking back, I can honestly say I’ve learned how to **think in SQL**, not just write it.

---

## 📑 Reference  
---

- 📚 **ALX Data Program:** *Querying Data: Integrated Project 4 – Maji Ndogo: Charting the Course for Maji Ndogo’s Water Future.*  

- 🗂️ **Dataset:** *Maji Ndogo Water Services* – a fictional yet realistic dataset designed for SQL practice, data cleaning, and exploratory analysis.  

- ✍️ **Author’s Contribution:** Every SQL query, data-cleaning step, and analytical insight presented here was personally executed and refined by **me**, as part of the **ALX Data Program** capstone project.  

- 🖼️ **Image Credits:** All images and visual assets used in this documentation are courtesy of the **ALX Data Program**.



## 💾 Repository Info

If you found this project insightful, feel free to ⭐ the repo and connect with me on [LinkedIn](https://www.linkedin.com/in/omotola-lawal-541b9b131) for collaboration.

---


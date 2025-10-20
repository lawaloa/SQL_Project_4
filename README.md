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

Here, we move from exploration to **decision-oriented insights**:
- Identifying regions most affected by water shortages  
- Highlighting inefficiencies and corruption among field workers  
- Prioritizing interventions for equitable resource distribution  

---

## 📋 Summary Report: Sharing Our Knowledge with Decision Makers
The summarized report transforms our data into a narrative that policymakers can understand at a glance.  
Through tables, charts, and SQL summaries, we highlight:
- Regions needing urgent attention  
- Budgetary gaps and material needs  
- Recommendations for transparency and accountability  

---

## 🧭 A Practical Plan: From Analysis to Action
This final stage turns insight into **action** by developing:
- Job lists for engineers and project managers  
- Material and budget requirement sheets  
- Strategic plans for long-term water sustainability  

---



### 💾 Repository Info
If you found this project insightful, feel free to ⭐ the repo and connect with me on [LinkedIn](https://www.linkedin.com/in/omotola-lawal-541b9b131) for collaboration.

---


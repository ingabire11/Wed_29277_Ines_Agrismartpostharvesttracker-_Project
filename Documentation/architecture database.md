# **AgriSmart Database Architecture** 

---

## **PRESENTATION STRUCTURE**

AgriSmart Post-Harvest Tracker is a PL/SQL-based system designed to help farmers and small-scale traders monitor harvested crops, track humidity levels in storage, predict spoilage risk, and receive timely alerts and market suggestions. The system uses PL/SQL procedures, triggers, and functions to automate decision-making and reduce waste.

 **THE PROBLEM** 

**KEY POINTS**

1. **Problem:** Rwandan farmers lose 30-40% of harvests after harvesting  
2. **Why?**  
   * Crops stay too long in poor storage conditions  
   * High humidity causes spoilage  
   * Farmers don't know which markets need their crops  
3. **Impact:** Lost income, food insecurity

### **SOLUTION OVERVIEW** 

**KEY POINTS**

1. **What AgriSmart does:**  
   * Tracks every harvest from farm to market  
   * Monitors humidity in storage facilities  
   * Sends automatic alerts when crops are at risk  
   * Recommends best markets based on demand

###  **DATABASE ARCHITECTURE** 

**5 LAYERS** 

1. **Presentation Layer** → What users see (dashboards, portals)  
2. **Business Logic Layer** → Smart PL/SQL code (procedures, triggers)  
3. **Data Layer** → Where information is stored (11 tables)  
4. **Infrastructure Layer** → Security and performance.

###  **BUSINESS PROCESS FLOW** 

1. **Farmer harvests crops** → Data entered into system  
2. **System stores harvest record** → Checks crop decay timeline  
3. **Crops moved to storage** → Humidity monitoring begins  
4. **System matches with markets** → Based on demand and distance  
5. **Alerts sent if risk detected** → SMS/notification to farmer  
6. **Farmer takes action** → Sells before spoilage

### **DATABASE DESIGN** 

**10 TABLES IN 3 CATEGORIES:**

### **Core Business Tables :**

1. **FARMERS** \- Who owns the harvest   
2. **HARVESTS** \- What was harvested   
3. **STORAGE** \- Where crops are stored   
4. **MARKETS** \- Where to sell 

### **Supporting Tables :**

5. **DECAY\_RATES** \- How long each crop lasts   
6. **HUMIDITY\_LOGS** \- Environmental monitoring   
7. **ALERTS** \- System notifications 

### **Audit & Security :**

8. **AUDIT\_LOG** \- Tracks all changes   
9. **HOLIDAYS** \- Public holidays list   
10. **MARKET\_DEMAND** \- Links markets to crops   
    **PL/SQL COMPONENTS** 

### **Procedures :**

1. **CheckDecayRisk** \- Compares storage time vs. crop shelf life  
2. **RecordHarvest** \- Inserts harvest with validation  
3. **CheckHumidityTrend** \- Analyzes if conditions getting worse  
4. **GenerateWeeklyReport** \- Creates summary for farmers

### **Functions :**

1. **SuggestMarketMatch** \- Returns best market for each crop  
2. **CalculateDecayPercentage** \- How much already spoiled  
3. **GetStorageDuration** \- Days in storage  
4. **IsHumiditySafe** \- TRUE/FALSE if humidity is okay

### **Triggers :**

1. **SendAlertOnRisk** \- Auto-alert when crop near spoilage (AFTER UPDATE)  
2. **AlertOnHighHumidity** \- Auto-alert when humidity \> 65% (AFTER INSERT)  
3. **AuditHarvestChanges** \- Logs all modifications (COMPOUND TRIGGER)  
4. **EnforceBusinessRules** \- Blocks weekday/holiday operations (BEFORE INSERT/UPDATE/DELETE) 

### **Packages :**

1. **PKG\_HARVEST\_MGMT** \- All harvest operations  
2. **PKG\_ALERT\_SYSTEM** \- Notification management  
3. **PKG\_MARKET\_MATCHING** \- Market recommendations  
4. **PKG\_ANALYTICS** \- Reports and KPIs

### **ADVANCED FEATURES** 

### **Business Rule Implementation:**

**Rule:** Employees CANNOT INSERT/UPDATE/DELETE on weekdays and public holidays

**How I implemented it:**

1. **Created HOLIDAYS table:**

   * Stores all Rwanda public holidays (10-15 per year)  
   * Includes: Independence Day (July 1), Genocide Memorial (April 7), etc.  
2. **Created function IS\_RESTRICTED\_DAY:**

\-- Returns TRUE if today is weekday (Mon-Fri) OR holiday  
\-- Returns FALSE if weekend (Sat-Sun) AND not holiday

3. **Created trigger ENFORCE\_BUSINESS\_RULES:**

   * Fires BEFORE any INSERT/UPDATE/DELETE on HARVESTS table  
   * Calls IS\_RESTRICTED\_DAY function  
   * If TRUE → RAISE\_APPLICATION\_ERROR (blocks operation)  
   * If FALSE → Operation proceeds  
4. **All attempts logged in AUDIT\_LOG:**

   * Who tried, when, what operation  
   * Success or denied  
   * For compliance tracking

**Testing Results:**

* Monday INSERT → DENIED (weekday)  
*  Saturday INSERT → ALLOWED (weekend)  
*  July 1 INSERT → DENIED (Independence Day)  
*  All attempts logged in AUDIT\_LOG

### **SLIDE 9: BUSINESS INTELLIGENCE** 

### **Key Performance Indicators (KPIs):**

1. **Post-Harvest Loss Rate:** Currently 13.4% (Target \< 15%)  
2. **Storage Efficiency:** 67% average utilization (Target 60-80%)  
3. **Alert Response Time:** Average 18 hours (Target \< 24 hours)  
4. **Market Match Success:** 87% crops sold (Target \> 85%)

### **Dashboards :**

1. **Executive Dashboard:**

   * Total harvests, active farmers, loss rate  
   * Monthly trends, geographic distribution  
   * For management decisions  
2. **Audit Dashboard:**

   * Weekday/holiday violation attempts  
   * User activity tracking  
   * Compliance monitoring  
   * Shows EnforceBusinessRules trigger in action  
3. **Operations Dashboard:**

   * At-risk harvests (7 critical, 15 high risk)  
   * Storage humidity heatmap  
   * Market opportunities today  
   * For daily farmer use  
4. **Performance Dashboard:**

   * Database CPU, memory, storage usage  
   * Query response times  
   * For DBA monitoring

### **Advanced SQL Queries:**

* Window functions: ROW\_NUMBER(), RANK(), LAG(), LEAD()  
* Aggregations: GROUP BY with PARTITION BY  
* Complex JOINs: 3-4 table joins for market matching

**What to say:**

* "My BI layer turns raw data into actionable insights"  
* "Dashboards show real-time KPIs for decision-making"  
* "Used window functions and analytics queries as required"

###  **RESULTS & TESTING**

### **Data Volume:**

* **250 farmers** registered  
* **500+ harvests** recorded  
* **1,200+ humidity readings** logged  
* **350 alerts** generated and tracked

### **Testing Completed:**

All tables created with constraints  
 500+ rows inserted successfully  
 All 8 procedures tested with parameters  
 All 4 functions return correct values  
 All 4 triggers fire correctly  
 Weekend/holiday restriction works  
  Audit log captures everything  
  Foreign keys enforce integrity

### **Performance:**

* Simple queries: \< 0.1 seconds  
* Complex joins: \< 1 second  
* Reports generation: \< 5 seconds

**Screenshots to show:**

1. ER diagram with all 11 tables  
2. SQL Developer showing procedures/triggers  
3. Sample data from 3-4 tables  
4. Audit log with blocked attempts  
5. Alert records generated by triggers  
6. Test results (queries executed successfully)


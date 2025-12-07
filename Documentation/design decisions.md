# **AgriSmart Design Decisions** 

## **KEY DESIGN DECISIONS** 

###  **WHY THIS PROBLEM?** 

I chose post-harvest losses because Rwandan farmers lose 30-40% of crops after harvesting. Two main causes: crops stay too long in poor storage, and high humidity causes spoilage. My database solution tracks storage time, monitors humidity, and sends automatic alerts before losses occur.

**Key Point:** Real problem \+ Database solution \= Perfect capstone project

### **2\. WHY 7 TABLES?** 

1. **FARMERS** \- Who owns the crops (250 farmers)  
2. **HARVESTS** \- What was harvested (500+ records)  
3. **STORAGE** \- Where crops are stored with conditions  
4. **MARKETS** \- Where to sell crops  
5. **DECAY\_RATES** \- How long each crop lasts (reference data)  
6. **HUMIDITY\_LOGS** \- Environmental readings over time  
7. **ALERTS** \- System notifications to farmers

**Plus 3 audit tables:** AUDIT\_LOG, HOLIDAYS, USER\_ROLES (Phase VII)

**Key Point:** Each table \= one business entity, fully normalized to 3NF

### **WHY DECAY\_RATES SEPARATE TABLE?** 

**The Table:**

DECAY\_RATES:  
\- Pepper: 14 days (very perishable)  
\- Potatoes: 90 days (moderate)    
\- Maize: 180 days (long shelf life)

**How I Use It:** "My **CheckDecayRisk** procedure compares 'days in storage' against 'days to decay' from this table. If Pepper stored for 14 days , it triggers an alert."

**Why Smart:**

* Update once, affects all tomatoes  
* Easy to add new crops  
* All procedures reference this single source

**Key Point:** Single source of truth prevents redundancy

### **WHY STORE ALL HUMIDITY READINGS?** 

**What to Say:** "I don't just store current humidity—I store EVERY reading with a timestamp  in the HUMIDITY \_LOGS table."

**Example:**

Storage \#1:  
12:00 \- 62% (safe)  
2:00 \- 64% (safe)  
4:00 \- 68% (warning)  
6:00 \- 72% (critical\!)

**Why This Matters:**

* See if humidity rising (bad trend) or was one-time spike  
* My **CheckHumidityTrend** procedure analyzes last 7 days  
* Supports LAG/LEAD window functions (Phase VI requirement)

**Key Point:** Historical data reveals patterns, not just current state

### **WHY THESE PL/SQL COMPONENTS?**

### **MY PROCEDURES :**

1. **CheckDecayRisk** \- Compares storage time vs decay timeline  
2. **RecordHarvest** \- Inserts new harvest with validation  
3. **CheckHumidityTrend** \- Analyzes if conditions worsens.

### **MY FUNCTIONS (return values):**

1. **SuggestMarketMatch** \- Returns best market for crop type  
2. **CalculateDecayPercentage** \- Returns spoilage estimate (0-100%)  
3. **GetStorageDuration** \- Returns days in storage  
4. **IsHumiditySafe** \- Returns TRUE/FALSE for safe conditions

**Why Procedures vs Functions:**

* Procedures \= INSERT/UPDATE data  
* Functions \= Calculate/return values, can use in WHERE clause

### **MY TRIGGERS (automatic actions):**

1. **SendAlertOnRisk** \- AFTER UPDATE on STORAGE → auto-alert if decay risk high  
2. **AlertOnHighHumidity** \- AFTER INSERT on HUMIDITY\_LOGS → alert if \> 65%  
3. **AuditHarvestChanges** \- COMPOUND on HARVESTS → logs all changes  
4. **EnforceBusinessRules** \- BEFORE on HARVESTS → blocks weekday operations 

**Key Point:** Triggers make system intelligent—no manual checking needed

###  **WHY BEFORE TRIGGER FOR PHASE VII?** 

**What to Say:** "Phase VII requires employees CANNOT modify data on weekdays and holidays. I used BEFORE trigger because it's the ONLY way to truly prevent operations."

**My Implementation:**

CREATE TRIGGER EnforceBusinessRules  
BEFORE INSERT OR UPDATE OR DELETE ON HARVESTS  
BEGIN  
    IF is\_weekday() OR is\_holiday() THEN  
        \-- Log the attempt  
        INSERT INTO AUDIT\_LOG ...  
          
        \-- Block the operation  
        RAISE\_APPLICATION\_ERROR(-20001,   
            'Operations not allowed on weekdays/holidays');  
    END IF;  
END;

**BEFORE vs AFTER:**

**BEFORE** \= Blocks operation BEFORE data touched

 **AFTER** \= Logs AFTER data already changed (too late\!)

**Testing Results:**

* Monday INSERT → **BLOCKED**   
* Saturday INSERT → **ALLOWED**   
* July 1 (Independence Day) → **BLOCKED**   
* All attempts logged in AUDIT\_LOG

**Key Point:** Phase VII says "CANNOT" \= must prevent, not warn. BEFORE trigger is the only correct choice.

###  **WHY HOLIDAYS TABLE?** 

 I store Rwanda public holidays in a HOLIDAYS table so I can add new holidays without changing code.

**The Table:**

HOLIDAYS:  
2025-01-01 | New Year's Day  
2025-04-07 | Genocide Memorial Day    
2025-07-01 | Independence Day  
2025-12-25 | Christmas Day

**How It Works:** "My EnforceBusinessRules trigger queries:

SELECT COUNT(\*) FROM HOLIDAYS   
WHERE holiday\_date \= TRUNC(SYSDATE) AND is\_active \= 'Y'

If count \> 0, it's a holiday → block operation."

**Why Data-Driven:**

* DBA adds 2026 holidays with simple INSERT  
* No code changes needed  
* No redeployment required

**Key Point:** Flexible, maintainable design

### **WHY MARKET MATCHING LOGIC?** 

My **SuggestMarketMatch** function automatically recommends the best market for each crop.

**How It Works:**

FUNCTION SuggestMarketMatch(p\_crop\_type VARCHAR2)   
RETURN VARCHAR2 IS  
BEGIN  
    \-- Find markets with HIGH demand for this crop  
    \-- Within 50km distance  
    \-- Return closest market name  
    SELECT market\_name INTO v\_best\_market  
    FROM MARKETS m  
    JOIN MARKET\_DEMAND md ON m.market\_id \= md.market\_id  
    WHERE md.crop\_type \= p\_crop\_type  
      AND md.demand\_level \= 'HIGH'  
      AND m.distance\_from\_center\_km \< 50  
    ORDER BY m.distance\_from\_center\_km  
    FETCH FIRST 1 ROW ONLY;  
      
    RETURN v\_best\_market;  
END;

**Key Point:** Smart matching \= farmers get to market faster \= less spoilage


# **AgriSmart Post-Harvest Tracker — Data Dictionary**

## **Farmers Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| farmer\_id | NUMBER | PK | Unique farmer identifier |
| farmer\_name | VARCHAR2(100) | NOT NULL | Full name of the farmer |
| location | VARCHAR2(100) | NOT NULL | Farmer location |

## **Harvests Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| harvest\_id | NUMBER | PK | Unique harvest record ID |
| crop\_type | VARCHAR2(50) | NOT NULL | Type of harvested crop |
| quantity | NUMBER | NOT NULL | Amount harvested |
| harvest\_date | DATE | NOT NULL | Date of harvest |
| farmer\_id | NUMBER | FK  | Farmer who performed harvest |

## **Storage Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| storage\_id | NUMBER | PK | Unique storage record ID |
| harvest\_id | NUMBER | FK  | Linked harvest |
| location | VARCHAR2(100) | NOT NULL | Storage location |
| date\_stored | DATE | NOT  NULL | Date crop was stored |

## **DecayRates Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| crop\_type | VARCHAR2(50) | PK | Type of crop |
| days\_to\_decay | NUMBER | NOT NULL | Days before spoilage |

## **Markets Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| market\_id | NUMBER | PK | Unique market identifier |
| location | VARCHAR2(100) | NOT NULL | Market location |
| crop\_type | VARCHAR2(50) | NOT NULL | Crop in demand |
| demand\_level | NUMBER | CHECK1-10 | Demand rating |

## **HumidityLogs Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| log\_id | NUMBER | PK | Humidity log record ID |
| storage\_id | NUMBER | FK  | Linked storage unit |
| humidity\_percent | NUMBER(5,2) | NOT NULL | Humidity percentage |
| reading\_time | DATE | NOT NULL | Timestamp of reading |

## **Alerts Table**

| Field | Type | Constraints | Description |
| :---- | :---- | :---- | :---- |
| alert\_id | NUMBER | PK | Alert record ID |
| harvest\_id | NUMBER | FK  | Harvest that triggered alert |
| alert\_type | VARCHAR2(100) | NOT NULL | Type of generated alert |
| date\_sent | DATE | NOT NULL | When alert was sent |


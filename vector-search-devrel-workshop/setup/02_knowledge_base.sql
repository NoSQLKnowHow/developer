-- ============================================================================
-- Vector Search Workshop: City Knowledge Base Extension
-- ============================================================================
-- Run this AFTER the main CityPulse setup (01_schema_and_data.sql).
-- This script adds the city_knowledge_base table with operational documents
-- that will be used for vector search, chunking, and RAG exercises.
--
-- Prerequisites:
--   - CityPulse schema already created (01_schema_and_data.sql executed)
--   - Running as the CITYPULSE user
-- ============================================================================

-- ============================================================================
-- CITY KNOWLEDGE BASE TABLE
-- ============================================================================

CREATE TABLE city_knowledge_base (
    doc_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title          VARCHAR2(200) NOT NULL,
    category       VARCHAR2(50) NOT NULL,
    content        CLOB NOT NULL,
    author         VARCHAR2(100),
    publish_date   DATE DEFAULT SYSDATE
);

-- ============================================================================
-- INSPECTION REPORTS
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Harbor Bridge Annual Structural Inspection Report 2025',
    'Inspection Report',
    'The Harbor Bridge annual structural inspection was conducted over a three-day period in October 2025. The inspection team evaluated all primary structural members including the main span girders, deck plates, bearing assemblies, expansion joints, and substructure elements. Load-bearing capacity was tested using calibrated weight vehicles at multiple positions across the bridge deck.

Overall, Harbor Bridge remains in serviceable condition with a structural sufficiency rating of 78.3 out of 100. However, several areas of concern were identified that require monitoring and eventual remediation. The western bearing assembly shows early signs of corrosion-induced section loss, with approximately 8% reduction in flange thickness compared to the 2023 baseline measurement. This degradation rate, if unchecked, could impact load distribution within 3-5 years.

Vibration monitoring data from sensors HB-VIB-01 and HB-VIB-02 was reviewed as part of the inspection. Baseline vibration amplitude for the Harbor Bridge under normal traffic conditions is 2.5 mm/s. The sensors have recorded intermittent spikes reaching 8-12 mm/s over the past quarter, which correlates with heavy vehicle crossings but occasionally exceeds expected thresholds. The inspection team recommends increasing the monitoring frequency from quarterly to monthly until the source of the elevated readings is conclusively identified.

Deck surface condition is rated as fair. Approximately 15% of the deck area shows surface cracking consistent with freeze-thaw cycling. Two areas of spalling were identified near the northern abutment, each approximately 0.5 square meters. These do not currently affect structural integrity but should be patched before the next winter season to prevent water infiltration and reinforcement corrosion.

The bridge railing system was found to be compliant with current safety standards. All drainage systems were functional, though the southern drain showed reduced flow capacity due to sediment accumulation. Cleaning was performed during the inspection.

Recommendations: (1) Increase vibration monitoring frequency for HB-VIB-01 and HB-VIB-02 to monthly intervals. (2) Schedule bearing assembly treatment for the western bearing within 6 months. (3) Patch identified deck spalling areas before November. (4) Re-inspect southern drainage system in 6 months.',
    'Chen Wei, P.E., Structural Division',
    DATE '2025-10-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Downtown Overpass Quarterly Inspection Summary Q3 2025',
    'Inspection Report',
    'The Downtown Overpass quarterly inspection for Q3 2025 was completed on September 8, 2025. This overpass carries an average of 12,000 vehicles per day and is monitored by vibration sensor DT-VIB-01 mounted on the primary span.

Structural condition remains good with no significant changes from the previous quarter. The vibration sensor DT-VIB-01 continues to report readings within normal parameters, with a baseline amplitude of approximately 2.5 mm/s and no anomalous spikes detected during the review period.

Expansion joints on the east and west approaches are functioning normally. Minor debris accumulation was noted in the east joint channel and cleared during the inspection. The deck surface shows normal wear patterns consistent with traffic volume. No new cracking or deterioration was observed.

Substation Alpha, which powers the overpass lighting and traffic signals, was confirmed operational. The electrical feed from Substation Alpha to the overpass control systems tested within specification. Signal timing at Central Intersection, which the overpass feeds into, was verified as synchronized.

The Main Water Trunk that runs under the Downtown Overpass was visually inspected from accessible points. No signs of leakage, settlement, or disturbance were observed at the crossing point.

Recommendation: Continue standard quarterly inspection cycle. No immediate action items identified.',
    'Maria Santos, Structural Technician',
    DATE '2025-09-08'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'River Crossing Bridge Load Capacity Assessment',
    'Inspection Report',
    'A focused load capacity assessment was performed on River Crossing Bridge following the Riverside district''s request to evaluate the structure for potential heavy construction vehicle routing. The bridge connects the Riverside district to the University district and feeds into University Crossing intersection.

Current posted load limit is 40 metric tons. The assessment used finite element modeling calibrated against field measurements from vibration sensor RV-VIB-01 and strain gauge data collected during controlled load testing. Results indicate the bridge can safely accommodate loads up to 45 metric tons for occasional single-vehicle crossings, but sustained heavy traffic would accelerate fatigue at the midspan connection plates.

The Riverside Pipeline runs beneath the bridge along the eastern bank. Ground vibration measurements taken during load testing confirmed that heavy vehicle crossings do not produce ground-borne vibration levels sufficient to impact the pipeline integrity. Maximum recorded ground vibration was 0.8 mm/s, well below the 5.0 mm/s threshold for buried pipeline concern.

Recommendation: Approve occasional heavy vehicle routing with a per-vehicle permit system. Do not increase the posted load limit. Install temporary traffic counting equipment for 60 days to establish a baseline of actual heavy vehicle usage before making permanent routing decisions.',
    'Carlos Rivera, P.E., Structural Division',
    DATE '2025-08-22'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Substation Gamma Bi-Annual Electrical Inspection',
    'Inspection Report',
    'Substation Gamma serves as the primary power distribution node for the Harbor district, providing electrical service to Harbor Bridge, Harbor Junction intersection, and Harbor Water Supply pumping station. This bi-annual inspection covers all major electrical components, protection systems, and control interfaces.

Transformer oil analysis indicates normal aging with dissolved gas concentrations within acceptable limits. The main power transformer rated at 25 MVA is operating at approximately 62% capacity during peak demand periods. Thermal imaging revealed no hot spots on busbar connections or cable terminations.

Protection relay settings were verified against the current coordination study. All relays operated correctly during simulated fault testing. The automated transfer switch between the primary and backup feed tested successfully with a transfer time of 3.2 seconds, within the 5-second specification.

Temperature sensor HB-TEMP-02 mounted at the substation reported consistent ambient readings throughout the inspection period. The climate control system for the control room maintained temperatures within the 18-24°C operating range for sensitive electronic equipment.

Battery backup systems were load-tested and found adequate. Battery bank A showed 94% capacity retention, while Bank B showed 89%. Bank B should be scheduled for replacement within 12 months as it approaches the 85% threshold for reliable backup operation.

SCADA communication links to the central operations center were verified. Data latency measured at 1.2 seconds, within the 3-second requirement for real-time monitoring.

Recommendations: (1) Schedule Battery Bank B replacement within 12 months. (2) Review transformer loading trends — if peak capacity exceeds 75%, initiate planning for supplemental capacity. (3) Continue bi-annual inspection cycle.',
    'James Chen, Electrical Technician',
    DATE '2025-07-20'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Industrial Pipeline Pressure Test Results',
    'Inspection Report',
    'Annual hydrostatic pressure testing was conducted on the Industrial Pipeline serving the Industrial district. The pipeline originates from the Riverside Pipeline and distributes treated water to industrial facilities and fire suppression systems throughout the district.

Test methodology followed AWWA C600 standards. The pipeline was isolated, pressurized to 150% of normal operating pressure (525 kPa test pressure against 350 kPa operating), and held for 4 hours. Pressure sensors IN-PRES-01 and IN-PRES-02 provided continuous monitoring during the test, supplemented by portable test gauges at each end of the test section.

Results: The pipeline held test pressure with a total pressure drop of 2.1 kPa over the 4-hour test period. This falls within the acceptable loss threshold of 3.0 kPa, indicating no significant leaks. Flow sensors IN-FLOW-01 and IN-FLOW-02 confirmed zero flow during the pressurized hold period.

One minor concern was identified: the pressure reading from IN-PRES-02 showed a consistent 1.8 kPa offset compared to the portable reference gauge. This sensor should be recalibrated at the next scheduled maintenance window. Sensor IN-PRES-01 was within 0.3 kPa of the reference, which is within acceptable accuracy.

The pipeline coating condition was assessed at three excavation points. Coating adhesion and thickness were within specification at all points. No evidence of external corrosion was found.

Recommendations: (1) Recalibrate pressure sensor IN-PRES-02. (2) Continue annual pressure testing cycle. (3) Pipeline is cleared for continued service at rated operating pressure.',
    'Aisha Patel, Hydraulic Technician',
    DATE '2025-09-30'
);

-- ============================================================================
-- MAINTENANCE PROCEDURES & SOPs
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Standard Operating Procedure: Vibration Sensor Calibration',
    'Maintenance Procedure',
    'This procedure covers the calibration of vibration monitoring sensors used throughout the CityPulse network. Vibration sensors are deployed on bridges, overpasses, and other structures to detect abnormal movement patterns that may indicate structural distress.

Calibration Frequency: Every 90 days under normal conditions. Immediately after any sensor reports readings exceeding 3x baseline amplitude, or after any firmware update.

Required Equipment: Certified vibration reference source (NIST-traceable), portable data logger, calibration software (v4.2 or later), torque wrench set, weatherproof sealant.

Pre-Calibration Checks: (1) Verify sensor mounting bolt torque is within 15-20 N·m specification. Loose mounting is the most common cause of erratic readings. (2) Inspect cable connections for corrosion or moisture intrusion. (3) Check sensor housing seal integrity. (4) Record current sensor firmware version.

Calibration Steps: (1) Connect portable data logger in parallel with sensor. (2) Apply reference vibration source at 1.0 mm/s amplitude, 10 Hz frequency. Record sensor output — should read 1.0 ±0.05 mm/s. (3) Apply reference at 5.0 mm/s amplitude, 10 Hz frequency. Record sensor output — should read 5.0 ±0.15 mm/s. (4) Apply reference at 2.5 mm/s amplitude (typical baseline for bridge sensors) at frequencies of 5, 10, 20, and 50 Hz. Record all outputs. (5) If any reading exceeds ±3% tolerance, perform a zero adjustment and repeat. If still out of tolerance, replace the sensor.

Post-Calibration: Update the maintenance log with calibration results, sensor firmware version, and next scheduled calibration date. If the sensor was replaced, record the old and new sensor serial numbers.

Special Notes for Harbor Bridge Sensors: Sensors HB-VIB-01 and HB-VIB-02 are mounted in an exposed marine environment and may require more frequent calibration due to salt spray exposure. If corrosion is observed on the mounting hardware, replace with marine-grade stainless steel fasteners.',
    'Structural Maintenance Division',
    DATE '2025-01-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Standard Operating Procedure: Flow Sensor Maintenance',
    'Maintenance Procedure',
    'This procedure covers routine maintenance and troubleshooting for flow sensors deployed on CityPulse water infrastructure. Flow sensors monitor water movement through pipelines and are critical for leak detection, demand forecasting, and water quality management.

Maintenance Frequency: Every 120 days for routine maintenance. Immediately if flow readings deviate more than 10% from expected values without a known cause.

Applicable Sensors: All flow sensors including RV-FLOW-01, RV-FLOW-02, IN-FLOW-01, IN-FLOW-02, HB-FLOW-01, HB-FLOW-02, and UN-FLOW-01. The baseline flow rate for main trunk lines is approximately 150 L/s.

Routine Maintenance Steps: (1) Inspect sensor intake screen for debris accumulation. Debris is the most common cause of inaccurate readings, particularly after storm events. (2) Clean intake screen with approved brush tool. Do not use compressed air, which can damage the ultrasonic transducer. (3) Verify sensor alignment — the flow sensor element must be perpendicular to the pipe wall within 2 degrees. (4) Check signal cable for damage, rodent activity, or moisture intrusion at junction boxes. (5) Run a diagnostic self-test from the sensor control panel. All parameters should show green status.

Troubleshooting Intermittent Readings: If a flow sensor reports intermittent or erratic readings, follow this diagnostic sequence: (a) Check for air entrainment in the pipeline — air pockets passing the sensor cause momentary reading spikes. (b) Inspect the ultrasonic transducer face for mineral deposits. Clean with dilute citric acid solution if buildup is present. (c) Verify that no nearby pump start/stop cycling is creating pressure transients that affect the sensor.

Integration Notes: Flow sensor readings feed into the CityPulse monitoring dashboard and contribute to the hourly rollup aggregations stored in the materialized view. Sensor downtime should be reported immediately so that affected time periods can be flagged in analytical queries.',
    'Hydraulic Maintenance Division',
    DATE '2025-02-10'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Procedure: HNSW Vector Index Rebuild for CityPulse Search',
    'Maintenance Procedure',
    'This procedure documents the steps to rebuild HNSW (Hierarchical Navigable Small World) vector indexes used by the CityPulse operational search system. Vector indexes enable fast approximate nearest neighbor search against embedded document vectors in the knowledge base.

When to Rebuild: (1) After bulk loading more than 500 new documents to the knowledge base. (2) If search quality degrades — users report that relevant documents are not appearing in search results. (3) After changing the embedding model or re-embedding existing documents. (4) As part of quarterly maintenance.

Pre-Rebuild Checks: (1) Verify current index parameters by querying USER_INDEXES and related views. Record the current NEIGHBORS (M), EFCONSTRUCTION, and distance metric settings. (2) Confirm that all documents in the knowledge base have valid, non-null vector embeddings. (3) Schedule the rebuild during a low-usage maintenance window, as the index will be unavailable during creation.

Rebuild Steps: (1) Drop the existing vector index. (2) Recreate using CREATE VECTOR INDEX with HNSW organization. (3) Standard parameters for the CityPulse knowledge base: NEIGHBORS 32, EFCONSTRUCTION 200, distance metric COSINE. (4) Verify creation by checking the query plan for a sample similarity search — it should show VECTOR INDEX access. (5) Test search quality by running the standard validation queries and confirming expected documents appear in the top-5 results.

Performance Tuning: If query latency increases after a rebuild, check the efSearch parameter at query time. Higher values improve recall but increase latency. For the CityPulse knowledge base (under 1000 documents), efSearch of 40-100 provides good results. For larger document sets, values of 200+ may be needed.

Rollback: If the new index performs worse than expected, recreate with the previously recorded parameters. Keep a log of parameter changes and their effect on search quality.',
    'CityPulse Data Engineering Team',
    DATE '2025-06-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Standard Operating Procedure: Air Quality Sensor Network Maintenance',
    'Maintenance Procedure',
    'This procedure covers the maintenance of the CityPulse air quality monitoring sensor network. Air quality sensors measure the Air Quality Index (AQI), particulate matter (PM2.5 and PM10), carbon monoxide (CO), and nitrogen dioxide (NO2) levels across all five districts.

Applicable Sensors: DT-AIR-01, DT-AIR-02 (Downtown), RV-AIR-01 (Riverside), IN-AIR-01, IN-AIR-02 (Industrial), UN-AIR-01, UN-AIR-02 (University), HB-AIR-01 (Harbor). Normal AQI baseline is approximately 42 across the network.

Maintenance Frequency: Every 60 days for particulate matter sensor cleaning. Every 180 days for gas sensor element replacement. Immediately after any AQI reading exceeds 150 (unhealthy threshold).

Routine Maintenance: (1) Remove the protective inlet cap and inspect the PM2.5 and PM10 impactor plates. Replace impactor substrate if discolored or loaded. (2) Clean the optical chamber with lint-free wipes and approved cleaning solution. (3) Run the internal zero-check function — the sensor should read PM2.5 < 1.0 μg/m³ with clean air supply. (4) Verify fan speed and airflow rate. Reduced airflow causes under-reporting of particulate concentrations. (5) Check the weatherproof enclosure seal and desiccant cartridge.

Industrial District Special Considerations: Sensors IN-AIR-01 and IN-AIR-02 operate in an environment with higher baseline particulate concentrations due to industrial activity. These sensors require 30-day cleaning intervals rather than the standard 60-day cycle. Additionally, the gas sensor elements in Industrial district sensors should be replaced every 120 days instead of 180 due to accelerated chemical degradation from industrial emissions.

Data Quality Notes: Air quality readings are reported as JSON payloads containing AQI, PM2.5, PM10, CO, and NO2 values. The JSON telemetry structure allows flexible querying — for example, filtering for readings where the PM2.5 exceeds 35 μg/m³ (EPA 24-hour standard) can be done with a JSON path expression in SQL.',
    'Environmental Monitoring Division',
    DATE '2025-03-01'
);

-- ============================================================================
-- EMERGENCY RESPONSE PROTOCOLS
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Emergency Response Protocol: Structural Vibration Anomaly',
    'Emergency Protocol',
    'This protocol defines the response procedure when a structural vibration sensor reports readings that exceed normal operational thresholds. Elevated vibration on bridges and overpasses may indicate structural distress, bearing failure, foundation settlement, or unusual loading conditions. Timely response is critical to ensure public safety.

Alert Thresholds: Level 1 Alert — sustained readings exceeding 2x baseline amplitude (e.g., above 5.0 mm/s for bridge sensors with 2.5 mm/s baseline) for more than 15 minutes. Level 2 Alert — any single reading exceeding 4x baseline amplitude (e.g., above 10.0 mm/s) regardless of duration. Level 3 Alert — multiple sensors on the same structure simultaneously exceeding 2x baseline.

Level 1 Response: (1) The automated monitoring system generates an alert and notifies the on-call structural technician. (2) The technician reviews the sensor data remotely, checking for patterns that indicate sensor malfunction versus genuine structural response. (3) If sensor malfunction is suspected, schedule a site visit within 24 hours for sensor inspection and calibration. (4) If genuine structural response is indicated, escalate to Level 2 procedures.

Level 2 Response: (1) Notify the structural engineer on call and the district emergency coordinator. (2) Deploy a structural technician to the site within 2 hours for visual inspection. (3) If the technician observes visible structural distress (cracking, displacement, deformation), initiate traffic restriction procedures. (4) Install supplemental temporary monitoring equipment if available. (5) The structural engineer must provide a preliminary assessment within 4 hours of notification.

Level 3 Response: (1) Immediately notify the city emergency management office. (2) Initiate precautionary traffic closure on the affected structure. (3) Deploy structural engineering team for emergency assessment. (4) Use the CityPulse infrastructure graph to identify all dependent infrastructure — for example, if Harbor Bridge is affected, query the graph to find that Harbor Junction and Harbor Water Supply are downstream dependencies. (5) Notify operators of dependent infrastructure. (6) Maintain closure until the structural engineering team provides clearance.

Post-Event Documentation: All vibration anomaly responses must be documented in the maintenance log with the sensor ID, alert level triggered, response actions taken, and outcome. This data feeds into the trend analysis that informs future inspection scheduling.',
    'City Emergency Management Office',
    DATE '2025-04-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Emergency Response Protocol: Water Main Break',
    'Emergency Protocol',
    'This protocol defines the response procedure for a suspected or confirmed water main break in the CityPulse service area. Water main breaks can cause flooding, road damage, service disruption, and contamination risks. The CityPulse sensor network provides early detection through pressure drop and flow anomaly monitoring.

Detection Indicators: (1) Sudden pressure drop detected by pressure sensors (e.g., DT-PRES-01, RV-PRES-01, IN-PRES-01, HB-PRES-01). Normal operating pressure is approximately 350 kPa — a drop exceeding 50 kPa warrants investigation. (2) Unexpected flow increase detected by flow sensors without corresponding demand increase. (3) Pressure differential between upstream and downstream sensors exceeding 30 kPa on the same pipeline segment.

Immediate Response: (1) The monitoring system flags the anomaly and alerts the on-call hydraulic technician. (2) Cross-reference pressure and flow data from adjacent sensors to isolate the approximate break location. For example, if RV-PRES-01 shows a drop but IN-PRES-01 does not, the break is likely on the Riverside Pipeline between these monitoring points. (3) Dispatch a field crew to visually confirm the break.

Isolation Procedure: (1) Identify isolation valves upstream and downstream of the confirmed break using the infrastructure dependency map. (2) Close isolation valves to stop water loss. (3) Check the CityPulse infrastructure graph for dependent systems — the Main Water Trunk supplies both the Riverside Pipeline and Harbor Water Supply, so a break on the trunk line affects both districts. (4) Notify affected customers and facilities. (5) If a fire suppression system is served by the affected main, notify the fire department immediately.

Repair and Restoration: (1) Excavate and assess the break. (2) Perform repair per AWWA standards. (3) Flush and disinfect the repaired section. (4) Perform a pressure test before returning to service. (5) Gradually restore pressure while monitoring all sensors on the affected segment. (6) Confirm sensor readings return to normal baselines.

Contamination Protocol: If the break occurs in an area where groundwater contamination is possible, collect water samples upstream and downstream of the repair. Do not restore service until bacteriological test results confirm the water meets drinking water standards.',
    'Water Operations Division',
    DATE '2025-03-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Emergency Response Protocol: Power Grid Failure',
    'Emergency Protocol',
    'This protocol addresses response procedures when a CityPulse substation experiences partial or complete failure. The city operates three substations — Substation Alpha (Downtown), Substation Beta (Industrial), and Substation Gamma (Harbor) — each serving critical infrastructure.

Detection: Substation failures are detected through (1) loss of SCADA telemetry from the substation, (2) temperature sensor anomalies at the substation location, (3) reports of power loss from dependent infrastructure, or (4) automated protection relay trip notifications.

Critical Dependencies by Substation:
- Substation Alpha powers: Downtown Overpass (lighting, signals), Central Intersection (traffic controls), Main Water Trunk (pumping station).
- Substation Beta powers: Industrial Hub intersection (traffic controls), Industrial Pipeline (pumping and monitoring).
- Substation Gamma powers: Harbor Bridge (lighting, monitoring), Harbor Junction (traffic controls), Harbor Water Supply (pumping station).

A failure at any substation impacts not only the directly powered infrastructure but also downstream systems. For example, if Substation Alpha fails and the Main Water Trunk pumping station loses power, water supply to both Riverside Pipeline and Harbor Water Supply may be affected due to reduced pressure.

Immediate Response: (1) Confirm the failure scope — partial (single feeder) vs. complete (entire substation). (2) Verify that automatic transfer to backup power has engaged for critical systems. (3) Dispatch an electrical technician to the substation. (4) For traffic signal outages, notify police for manual traffic control at affected intersections. (5) For water pumping station outages, check if gravity-fed backup supply is sufficient and notify water operations.

The infrastructure dependency graph should be queried immediately during any substation event to map the full impact scope. This is especially important for Substation Alpha, which has the most extensive downstream dependency chain.',
    'Electrical Operations Division',
    DATE '2025-05-01'
);

-- ============================================================================
-- ENGINEERING SPECS & EQUIPMENT GUIDES
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'CityPulse Sensor Network Architecture Guide',
    'Engineering Guide',
    'The CityPulse sensor network consists of 50 sensors deployed across 5 districts, monitoring 6 sensor types: vibration, temperature, flow, traffic, pressure, and air quality. This guide provides the technical architecture overview for developers and engineers working with the sensor network.

Sensor Identification: Each sensor follows the naming convention [DISTRICT]-[TYPE]-[SEQ], where DISTRICT is a two-letter code (DT=Downtown, RV=Riverside, IN=Industrial, UN=University, HB=Harbor), TYPE indicates the measurement type (VIB, TEMP, FLOW, TRAF, PRES, AIR), and SEQ is a sequential number within that district-type combination.

Data Flow: Sensors transmit readings at approximately 30-minute intervals. Each reading includes a numeric value in the sensor''s native unit and a JSON telemetry payload containing additional measurements specific to the sensor type. For example, a vibration sensor payload includes frequency_hz, amplitude_mm, axis (X/Y/Z), and temperature_c, while a traffic sensor payload includes vehicle_count, avg_speed_kmh, and congestion_level.

Storage Architecture: Readings are stored in the readings table, which is interval-partitioned by reading_time on a daily basis. This partitioning enables efficient time-range queries and automatic partition management. The JSON payload column uses Oracle''s native JSON data type, enabling SQL/JSON path queries without deserialization overhead.

Aggregation: A materialized view (hourly_sensor_rollup_mv) pre-computes hourly statistics including average, min, max, count, and standard deviation for each sensor. This supports dashboard queries without scanning the full readings table.

Graph Integration: The sensor network is represented in the city_infrastructure_graph property graph. Sensors that are mounted on infrastructure nodes have MONITORS edges, and all sensors have LOCATED_IN edges to their district. This graph enables dependency analysis — querying which sensors monitor which infrastructure, and what downstream systems are affected when infrastructure status changes.',
    'CityPulse Engineering Team',
    DATE '2025-01-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Vibration Sensor Technical Specifications',
    'Engineering Guide',
    'Model: CityPulse VS-3000 Industrial Vibration Sensor. Deployed on bridges, overpasses, and structural elements throughout the CityPulse network.

Measurement Range: 0.01 to 50.0 mm/s velocity (RMS). Frequency Response: 2 Hz to 1000 Hz (±3dB). Resolution: 0.001 mm/s. Accuracy: ±2% of reading or ±0.05 mm/s, whichever is greater.

Operating Conditions: Temperature range -40°C to +85°C. Humidity 0-100% (condensing). IP67 ingress protection. Designed for outdoor structural monitoring in all weather conditions.

Output Format: Each reading produces a JSON payload with the following fields: frequency_hz (dominant vibration frequency), amplitude_mm (peak-to-peak displacement in mm/s), axis (measurement axis: X, Y, or Z — sensors rotate through axes on successive readings), temperature_c (sensor housing temperature for thermal compensation), and is_anomaly (binary flag set by on-sensor edge processing when amplitude exceeds 3x baseline).

Baseline Values by Installation: Bridge sensors (HB-VIB-01, HB-VIB-02, DT-VIB-01, RV-VIB-01) have a normal baseline of approximately 2.5 mm/s under typical traffic loading. University Crossing sensor (UN-VIB-01) has a slightly lower baseline of 2.0 mm/s due to lighter traffic patterns. Industrial sensor (IN-VIB-01) at Substation Beta has a baseline of 3.0 mm/s due to transformer hum.

Mounting Requirements: Sensors must be mounted on a clean, flat surface with a minimum contact area of 50 cm². Mounting bolts must be torqued to 15-20 N·m. In marine environments (Harbor district), use marine-grade stainless steel mounting hardware and apply anti-seize compound to prevent galvanic corrosion.

Calibration: Required every 90 days. Refer to SOP: Vibration Sensor Calibration for the detailed procedure.',
    'CityPulse Engineering Team',
    DATE '2025-01-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Traffic Sensor Deployment and Configuration Guide',
    'Engineering Guide',
    'CityPulse traffic sensors monitor vehicle flow at key intersections and road segments. This guide covers deployment standards, configuration, and data interpretation.

Sensor Locations: DT-TRAF-01 and DT-TRAF-02 at Central Intersection (Downtown), RV-TRAF-01 and RV-TRAF-02 in the Riverside district, IN-TRAF-01 at Industrial Hub intersection, UN-TRAF-01 at University Crossing, HB-TRAF-01 and HB-TRAF-02 at Harbor Junction.

Measurement Method: Inductive loop detection with supplemental radar verification. Sensors count vehicles per hour and estimate average speed using dual-loop time-of-flight calculation.

Data Format: Each reading produces a JSON payload containing vehicle_count (vehicles per hour), avg_speed_kmh (average vehicle speed), and congestion_level (derived classification: "low" for under 600 veh/hr, "moderate" for 600-1000, "high" for over 1000). The baseline traffic volume across the network is approximately 800 vehicles per hour during daytime.

Congestion Level Classification: The congestion_level field in the JSON payload is computed on-sensor using the following thresholds: low (vehicle_count < 600), moderate (600 ≤ vehicle_count ≤ 1000), high (vehicle_count > 1000). These thresholds were established during the initial deployment calibration period and may need adjustment as traffic patterns evolve.

Integration with Traffic Management: Traffic sensor data feeds into the CityPulse dashboard for real-time congestion monitoring. The data also supports historical trend analysis through the hourly rollup materialized view. When traffic signals at an intersection are disrupted (e.g., due to a power failure at a substation), traffic sensors at that intersection provide the data needed to assess the operational impact.',
    'Traffic Engineering Division',
    DATE '2025-02-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Water Quality Monitoring Parameters and Thresholds',
    'Engineering Guide',
    'This document defines the water quality parameters monitored by CityPulse flow sensors and their associated compliance thresholds. Water quality monitoring is performed by flow sensors that include secondary measurement capabilities for pH and turbidity.

Monitored Parameters: Flow sensors (RV-FLOW-01, RV-FLOW-02, IN-FLOW-01, IN-FLOW-02, HB-FLOW-01, HB-FLOW-02, UN-FLOW-01) report JSON payloads containing flow_rate_lps (liters per second), pressure_kpa (pipeline pressure), ph_level, and turbidity_ntu.

pH Monitoring: Normal operating range is 6.5-8.5 per EPA drinking water standards. The sensor network reports a typical pH of 7.0 ±0.5. An excursion below 6.5 or above 8.5 triggers an automated alert to the Water Quality division. Persistent pH deviation may indicate chemical contamination or treatment process failure.

Turbidity Monitoring: Measured in Nephelometric Turbidity Units (NTU). Normal operating range is 0.5-2.5 NTU. The EPA maximum contaminant level for turbidity is 1.0 NTU for 95% of monthly samples. Turbidity spikes above 4.0 NTU trigger an immediate investigation. Common causes include pipeline disturbance during maintenance, upstream construction activity, or source water events.

Pressure Monitoring: Normal operating pressure is approximately 350 kPa across the distribution system. The JSON payload reports both static_kpa and dynamic_kpa values. A difference exceeding 30 kPa between static and dynamic pressure may indicate a partially closed valve or pipeline obstruction.

Seasonal Considerations: During spring snowmelt, source water turbidity naturally increases. The monitoring team should review turbidity trends in the Riverside and Harbor districts, which receive water from the Main Water Trunk that is most affected by seasonal source variations.',
    'Water Quality Division',
    DATE '2025-03-01'
);

-- ============================================================================
-- INCIDENT REPORTS & POST-MORTEMS
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Incident Report: Harbor Bridge Vibration Anomaly Event — January 2025',
    'Incident Report',
    'Incident Summary: On January 14, 2025, vibration sensor HB-VIB-01 on Harbor Bridge reported sustained elevated readings exceeding Level 1 alert thresholds for approximately 45 minutes. Peak amplitude reached 11.2 mm/s, approximately 4.5x the normal baseline of 2.5 mm/s.

Timeline: 14:23 — HB-VIB-01 triggers Level 1 alert (sustained readings above 5.0 mm/s for 15 minutes). 14:35 — On-call technician Ahmed Hassan reviews data remotely. Sensor HB-VIB-02, located 15 meters from HB-VIB-01, shows slightly elevated but sub-threshold readings (3.8 mm/s). 14:42 — Ahmed determines the pattern is inconsistent with structural distress (one sensor elevated, adjacent sensor near-normal) and suspects sensor malfunction or localized loading event. 14:55 — Harbor Bridge traffic cameras reviewed. An overweight construction vehicle (later confirmed at 52 metric tons, exceeding the 40-ton posted limit) is identified making repeated crossings. 15:08 — Vehicle identified and stopped by traffic enforcement. 15:15 — HB-VIB-01 readings return to baseline within 10 minutes of the vehicle being removed.

Root Cause: An overweight construction vehicle exceeded the bridge''s posted load limit by 30%. The vehicle''s repeated crossings (at least 6 in the 45-minute window) produced resonant vibration patterns that were amplified by the sensor''s proximity to the midspan bearing assembly.

Why HB-VIB-02 Showed Lower Readings: HB-VIB-02 is mounted at the northern quarter-point of the span, while HB-VIB-01 is at the midspan. Vibration amplitude is naturally highest at midspan for this loading pattern, explaining the difference between sensors.

Corrective Actions: (1) Issued citation to the vehicle operator. (2) Installed portable weight restriction signage with electronic enforcement notification. (3) Calibrated HB-VIB-01 and HB-VIB-02 to confirm accurate readings post-event. Both sensors verified within specification. (4) Added the event to the Harbor Bridge structural monitoring baseline for future trend analysis.

Lessons Learned: The sensor network performed as designed. The differential response between HB-VIB-01 and HB-VIB-02 provided diagnostic value that helped distinguish between structural distress and localized loading.',
    'Ahmed Hassan, Structural Technician',
    DATE '2025-01-18'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Incident Report: Riverside Pipeline Pressure Drop Event — March 2025',
    'Incident Report',
    'Incident Summary: On March 7, 2025, pressure sensor RV-PRES-01 on the Riverside Pipeline detected a sudden pressure drop of 65 kPa (from 350 kPa to 285 kPa) over a 20-minute period. This triggered an automated alert under the Water Main Break protocol.

Timeline: 09:12 — RV-PRES-01 registers a 65 kPa pressure drop. 09:14 — Automated alert dispatched to on-call hydraulic technician Aisha Patel. 09:18 — Aisha reviews cross-sensor data. RV-PRES-02 (on River Crossing Bridge pipeline section) shows normal pressure. IN-PRES-01 (downstream on Industrial Pipeline) shows a smaller 15 kPa drop. 09:25 — Flow sensors RV-FLOW-01 and RV-FLOW-02 show a 22% increase in flow rate, consistent with a downstream leak. 09:30 — Based on sensor triangulation, the likely break location is isolated to a 200-meter section between the Riverside Pipeline main valve and the Industrial Pipeline junction. 09:45 — Field crew arrives and confirms a circumferential crack on the pipeline at a joint fitting.

Repair: The affected section was isolated using upstream and downstream valves. The infrastructure dependency graph confirmed that the Industrial Pipeline would lose supply during isolation, and the Harbor Water Supply would remain unaffected (served directly by the Main Water Trunk). Industrial facilities were notified. The joint was repaired and the section was pressure-tested before restoration. Service was fully restored by 16:30.

Root Cause: The joint fitting showed signs of fatigue cracking consistent with cyclic pressure fluctuations. Review of historical pressure data from RV-PRES-01 revealed micro-fluctuations (5-10 kPa oscillations) over the preceding two months that were within normal alert thresholds but indicated a developing issue.

Corrective Actions: (1) Replaced the failed joint fitting with an upgraded design rated for higher cyclic loading. (2) Added a new monitoring rule to flag pressure micro-fluctuation patterns even when individual readings are within thresholds. (3) Scheduled inspection of similar joint fittings throughout the system.',
    'Aisha Patel, Hydraulic Technician',
    DATE '2025-03-10'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Post-Mortem: Industrial District Air Quality Exceedance — June 2025',
    'Incident Report',
    'On June 22, 2025, air quality sensors IN-AIR-01 and IN-AIR-02 simultaneously reported AQI readings exceeding 150 (unhealthy threshold) for 4 consecutive hours. Peak AQI reached 189 at IN-AIR-01. PM2.5 concentrations peaked at 68 μg/m³, well above the EPA 24-hour standard of 35 μg/m³.

Investigation: Environmental technician Yuki Tanaka responded to the alert. Review of the JSON telemetry payloads showed that while AQI and PM2.5 were elevated, CO and NO2 levels remained normal. This pattern was inconsistent with vehicular or industrial combustion sources and pointed to a particulate-specific event.

Root Cause: A construction demolition project at a site adjacent to the Industrial district had inadequate dust suppression. Prevailing winds carried particulate matter directly across both sensor locations. The construction site did not have a current air quality mitigation plan on file.

Sensor Performance Notes: The fact that both IN-AIR-01 and IN-AIR-02 showed correlated readings increased confidence that this was a genuine environmental event rather than a sensor malfunction. Nearby sensors in other districts (DT-AIR-01, RV-AIR-01) showed slightly elevated but sub-threshold readings, consistent with particulate dispersion modeling.

Corrective Actions: (1) Issued a compliance notice to the construction project requiring dust suppression measures. (2) Added the construction site to the monitoring watch list with daily telemetry review. (3) Proposed a new alert rule that correlates multiple air quality sensors within a district to differentiate between localized sensor events and district-wide air quality events.',
    'Yuki Tanaka, Environmental Technician',
    DATE '2025-06-25'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Incident Report: Substation Alpha Partial Outage — August 2025',
    'Incident Report',
    'On August 3, 2025, Substation Alpha experienced a partial outage when Feeder Circuit 2 tripped due to an insulation failure on the underground cable serving Central Intersection. The outage lasted 2 hours and 14 minutes.

Impact: Feeder Circuit 2 serves Central Intersection traffic signals and a portion of the Downtown Overpass lighting. Traffic signals at Central Intersection went dark, requiring police manual traffic control. The overpass structural monitoring system (sensor DT-VIB-01) continued operating on battery backup. Temperature sensor DT-TEMP-03, which is located at the substation itself, recorded a brief temperature spike in the cable vault where the failure occurred.

The Main Water Trunk pumping station, served by Feeder Circuit 1, was unaffected. This is a critical design feature — water and structural monitoring systems are on separate feeder circuits from traffic systems to maintain priority services during partial outages.

Response: Electrical technician James Chen responded within 40 minutes. The failed cable section was isolated and service was restored via an alternate routing. Permanent cable replacement was scheduled for the following weekend.

Graph Analysis: The infrastructure dependency graph was queried to assess the full impact scope. The query confirmed that Substation Alpha''s dependencies include Downtown Overpass (partially affected), Central Intersection (fully affected), and Main Water Trunk (unaffected). No cascading effects reached other districts.',
    'James Chen, Electrical Technician',
    DATE '2025-08-05'
);

-- ============================================================================
-- SAFETY BULLETINS & COMPLIANCE
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Safety Bulletin: Working Near Energized Substations',
    'Safety Bulletin',
    'All CityPulse technicians and contractors must follow these safety requirements when performing work within 15 meters of an energized substation. This bulletin applies to work at Substation Alpha (Downtown), Substation Beta (Industrial), and Substation Gamma (Harbor).

Personal Protective Equipment: Arc-rated clothing (minimum 8 cal/cm²), safety glasses with side shields, voltage-rated gloves appropriate for the voltage class, hard hat, and steel-toed boots. Additional PPE may be required based on the specific task.

Approach Boundaries: Maintain a minimum approach distance of 3.0 meters from exposed energized conductors rated 15 kV and below. For work within the restricted approach boundary (1.0 meter), a qualified electrical worker must be present and an energized work permit must be obtained.

Sensor Maintenance Near Substations: Temperature sensors HB-TEMP-02 (at Substation Gamma) and DT-TEMP-03 (at Substation Alpha) require periodic maintenance. These sensors are located within the substation fence line. Maintenance must be coordinated with the substation operator and scheduled during reduced load periods when possible. Never touch sensor cables without first verifying de-energized status with a proximity voltage detector.

Emergency Procedures: If an electrical arc flash or equipment failure occurs, evacuate to the designated safe zone (minimum 30 meters from the substation). Call 911 and then notify the CityPulse operations center. Do not attempt to isolate or de-energize equipment unless you are a qualified electrical worker and it is safe to do so.',
    'Safety and Compliance Division',
    DATE '2025-02-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Safety Bulletin: Confined Space Entry for Pipeline Inspection',
    'Safety Bulletin',
    'Pipeline inspections within the CityPulse water distribution system occasionally require entry into confined spaces such as valve chambers, pump stations, and access manholes. This bulletin outlines the safety requirements for confined space entry.

Applicability: This procedure applies to any entry into the Main Water Trunk access chambers, Riverside Pipeline inspection points, Industrial Pipeline valve vaults, and Harbor Water Supply pump station wet well.

Pre-Entry Requirements: (1) Obtain a confined space entry permit from the Safety division. (2) Conduct atmospheric testing for oxygen level (19.5-23.5%), lower explosive limit (below 10% LEL), carbon monoxide (below 25 ppm), and hydrogen sulfide (below 10 ppm). (3) Establish continuous forced-air ventilation. (4) Station a trained attendant outside the entry point with rescue equipment. (5) Ensure communication capability between the entrant and attendant.

Sensor Considerations: When working near flow sensors (RV-FLOW-01, IN-FLOW-01, HB-FLOW-01, etc.) during confined space entry, be aware that sensor maintenance may require pipeline isolation. Coordinate with the operations center before isolating any pipeline section, as the infrastructure dependency map may reveal downstream impacts.

Rescue Procedures: If an entrant becomes incapacitated, the attendant must NOT enter the confined space. Call 911, activate the site rescue plan, and use the retrieval system to extract the entrant from outside the space.',
    'Safety and Compliance Division',
    DATE '2025-04-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Regulatory Compliance: Environmental Sensor Data Retention Policy',
    'Safety Bulletin',
    'This policy governs the retention and archival of environmental monitoring data collected by the CityPulse sensor network, ensuring compliance with EPA and state environmental regulatory requirements.

Retention Periods: Air quality data (from AQI sensors DT-AIR, RV-AIR, IN-AIR, UN-AIR, HB-AIR) must be retained for a minimum of 5 years per EPA 40 CFR Part 58. Water quality data (pH, turbidity from flow sensors) must be retained for a minimum of 10 years per Safe Drinking Water Act requirements. Structural monitoring data (vibration sensors) must be retained for the life of the structure plus 5 years.

Storage Implementation: The readings table with its interval partitioning supports efficient time-based data management. Older partitions can be compressed and moved to archive storage while remaining queryable. The JSON payload format ensures that all sensor-specific measurements are preserved alongside the primary reading value.

Reporting Requirements: Monthly air quality summaries must be submitted to the state environmental agency. Quarterly water quality reports must be submitted to the state health department. Annual structural monitoring summaries must be filed with the transportation department.

Data Integrity: All sensor readings include timestamps generated by the sensor hardware. The database enforces referential integrity between readings and sensor metadata. The hourly rollup materialized view provides pre-computed statistics for regulatory reporting without requiring full table scans of the raw data.',
    'Compliance and Regulatory Affairs',
    DATE '2025-01-30'
);

-- ============================================================================
-- SEASONAL & ENVIRONMENTAL ADVISORIES
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Seasonal Advisory: Winter Preparation for Bridge Monitoring Systems',
    'Seasonal Advisory',
    'As the winter season approaches, CityPulse bridge monitoring systems require specific preparation to ensure reliable operation through cold weather, freeze-thaw cycles, and de-icing chemical exposure.

Affected Sensors: All vibration sensors on bridge structures — HB-VIB-01, HB-VIB-02 (Harbor Bridge), DT-VIB-01 (Downtown Overpass), RV-VIB-01 (River Crossing Bridge), IN-VIB-01 (at Substation Beta). Temperature sensors at bridge locations are also affected.

Pre-Winter Checklist: (1) Inspect all sensor cable connections for moisture intrusion. Apply fresh weatherproof sealant to any junction boxes showing deterioration. (2) Verify battery backup systems for remote sensors — cold weather reduces battery capacity by 20-30%. Replace batteries below 80% capacity. (3) Calibrate vibration sensors — thermal contraction of bridge structures changes the baseline vibration characteristics. Establish winter baselines for comparison. (4) Confirm de-icing chemical compatibility — the sensor housing and mounting hardware at Harbor Bridge must be inspected for corrosion from salt spray and applied de-icing agents.

Winter-Specific Monitoring Adjustments: Bridge vibration baselines shift during cold weather due to thermal contraction of structural members. Typical winter baseline for bridge vibration sensors increases by 10-15% compared to summer values. Alert thresholds should be adjusted accordingly to prevent false alarms while maintaining sensitivity to genuine anomalies.

Ice Loading Concerns: When ice formation is reported on bridge structures, increase monitoring frequency from the standard 30-minute interval to 15-minute intervals for the duration of the ice event. Ice loading adds dead weight that affects vibration characteristics and can mask or mimic structural distress signals.',
    'Structural Maintenance Division',
    DATE '2025-10-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Seasonal Advisory: Summer Heat Impact on Sensor Network',
    'Seasonal Advisory',
    'Extended high-temperature periods during summer affect multiple components of the CityPulse sensor network. This advisory outlines monitoring adjustments and maintenance actions for the summer season.

Temperature Effects on Electronics: Temperature sensors DT-TEMP-01, DT-TEMP-02, DT-TEMP-03, RV-TEMP-01, RV-TEMP-02, IN-TEMP-01, IN-TEMP-02, UN-TEMP-01, UN-TEMP-02, HB-TEMP-01, and HB-TEMP-02 are designed to operate up to 85°C, but sustained ambient temperatures above 40°C can cause measurement drift in associated sensors sharing the same mounting location. When ambient temperature exceeds 35°C, increase attention to readings from co-located sensors.

Power Grid Impact: During heat waves, Substation Alpha, Beta, and Gamma experience peak loading as air conditioning demand increases. Substation Gamma, which already operates at 62% peak capacity, may approach 75% during extreme heat events. Temperature sensor HB-TEMP-02 at Substation Gamma should be monitored closely — rising transformer oil temperature is an early warning of thermal overload.

Water System Effects: Increased water demand during summer can reduce pipeline pressures. Normal operating pressure of 350 kPa may drop to 310-330 kPa during peak demand hours without indicating a leak. Pressure sensor alert thresholds should be temporarily adjusted during declared heat events to prevent false alerts.

Air Quality: Summer heat promotes ground-level ozone formation and increases wildfire risk. Air quality sensors across the network may see seasonal AQI increases. The normal baseline AQI of 42 may rise to 55-65 during summer without indicating a local pollution source.',
    'Environmental Monitoring Division',
    DATE '2025-05-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Seasonal Advisory: Storm Season Preparation and Response',
    'Seasonal Advisory',
    'This advisory covers preparation and response procedures for the CityPulse sensor network during severe weather events including heavy rain, high winds, and flooding.

Pre-Storm Preparation: (1) Verify all sensor enclosures are sealed and drainage paths are clear. (2) Check backup battery levels on all remote sensors. (3) Confirm SCADA communication links are operational and redundant paths are available. (4) Review the infrastructure dependency graph to identify critical monitoring points that must remain operational.

During-Storm Monitoring Priorities: (1) Bridge vibration sensors — high winds can induce vortex shedding on bridge structures, causing oscillating vibration patterns. This is distinct from traffic-induced vibration and should not be confused with structural distress. Wind-induced vibration typically shows a characteristic frequency pattern in the JSON telemetry. (2) Flow sensors — heavy rain increases stormwater infiltration into the water system, causing temporary flow increases. (3) Pressure sensors — flooding can affect buried pressure sensor junction boxes and cause erratic readings.

Post-Storm Assessment: (1) Survey all sensor locations for physical damage. (2) Run diagnostic self-tests on all sensors. (3) Compare post-storm baselines to pre-storm values — any persistent shift in baseline may indicate structural movement (for vibration sensors) or pipeline displacement (for flow/pressure sensors). (4) Clean air quality sensor inlets, which may be contaminated by storm debris. (5) Flush any flow sensor intake screens.

Flood-Specific Concerns: If water levels reach the Harbor district sensor installations, HB-FLOW-01, HB-FLOW-02, and HB-PRES-01 may be submerged beyond their rated water depth. These sensors should be inspected and potentially recalibrated after any flood event.',
    'Emergency Management Division',
    DATE '2025-04-01'
);

-- ============================================================================
-- TRAINING MATERIALS
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'New Technician Orientation: CityPulse System Overview',
    'Training Material',
    'Welcome to the CityPulse infrastructure monitoring team. This document provides an overview of the system you will be working with daily.

What is CityPulse? CityPulse is an integrated smart city monitoring platform that uses a network of 50 sensors across 5 districts (Downtown, Riverside, Industrial, University, and Harbor) to track the health and performance of critical infrastructure including bridges, water systems, power distribution, traffic flow, and air quality.

The Five Districts: Downtown is the most densely populated district (185,000 residents, 12.5 sq km) with heavy traffic and the highest concentration of infrastructure. Riverside (92,000 residents, 18.3 sq km) is primarily residential with major water infrastructure. Industrial (34,000 residents, 25.1 sq km) has specialized environmental monitoring needs. University (67,000 residents, 8.7 sq km) has lighter infrastructure loading. Harbor (48,000 residents, 15.9 sq km) has marine exposure challenges for sensor equipment.

Your Role: As a CityPulse technician, you are responsible for maintaining sensors, responding to alerts, and performing scheduled inspections. You will work with the monitoring dashboard that displays real-time data from all sensors, and you will follow standard operating procedures for each type of maintenance task.

Key Systems to Learn: (1) The sensor network — understand the six sensor types and what each measures. (2) The alert system — know the alert levels and response protocols. (3) The infrastructure graph — understand which infrastructure depends on which other infrastructure. (4) The maintenance log — document all work performed on sensors and infrastructure.

Your First Week: You will shadow an experienced technician for your first five shifts. During this time, you will observe sensor calibrations, dashboard monitoring, and at least one scheduled inspection. You will complete the CityPulse safety orientation before any field work.',
    'Training and Development Division',
    DATE '2025-01-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Training Guide: Understanding CityPulse Sensor Data and JSON Telemetry',
    'Training Material',
    'This training guide helps CityPulse technicians and analysts understand how to read and interpret sensor data, with a focus on the JSON telemetry payloads that provide detailed measurements beyond the primary reading value.

Why JSON Telemetry? Each sensor reading has a primary numeric value (e.g., vibration amplitude in mm/s), but the full picture requires additional context. The JSON payload captures sensor-specific details that vary by sensor type. A vibration sensor reports frequency, amplitude, axis, and temperature. A flow sensor reports flow rate, pressure, pH, and turbidity. This flexible structure means we can add new measurement parameters without changing the database schema.

Reading Vibration Data: When you see a vibration reading of 2.5 mm/s, the JSON payload tells you more. Check the frequency_hz field — a reading at 10 Hz is typical traffic-induced vibration, while a reading at 50 Hz might indicate machinery or wind-induced resonance. Check the axis field — vibration on the vertical (Z) axis is most common for traffic loading, while horizontal (X or Y) vibration may indicate wind effects. Check the is_anomaly flag — if set to 1, the on-sensor processing has flagged this reading as unusual.

Reading Flow Data: A flow rate of 150 L/s is the normal baseline. But the JSON payload also shows pressure_kpa, ph_level, and turbidity_ntu. If flow rate is normal but pressure is dropping, this could indicate a downstream demand increase or a developing leak. If turbidity spikes while flow is stable, this could indicate a water quality event upstream.

Reading Traffic Data: The vehicle_count tells you how busy a road is, but the avg_speed_kmh and congestion_level fields provide the operational picture. A vehicle count of 900 with an average speed of 45 km/h indicates flowing traffic, while the same count with 15 km/h indicates congestion.

Reading Air Quality Data: The AQI value gives the overall index, but the individual pollutant measurements (PM2.5, PM10, CO, NO2) help identify the source. Elevated PM2.5 with normal CO suggests particulate sources like construction dust. Elevated CO with normal particulates suggests combustion sources like vehicle exhaust.',
    'Training and Development Division',
    DATE '2025-02-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Training Guide: Using the CityPulse Infrastructure Dependency Graph',
    'Training Material',
    'The CityPulse infrastructure dependency graph is one of the most powerful tools available to technicians and engineers. It maps the relationships between sensors, infrastructure nodes, and districts, enabling rapid impact analysis during incidents.

What the Graph Contains: The graph has three types of vertices (nodes): sensors, infrastructure nodes (bridges, substations, water mains, intersections), and districts. It has several types of edges (relationships): MONITORS (sensor → infrastructure), LOCATED_IN (sensor/node → district), DEPENDS_ON/POWERS/SUPPLIES/FEEDS_INTO (infrastructure → infrastructure).

When to Use the Graph: Any time you need to answer the question "what else is affected?" Examples: (1) Substation Gamma goes offline — what infrastructure loses power? Query the graph for all nodes where Substation Gamma has a POWERS relationship. Answer: Harbor Bridge, Harbor Junction, Harbor Water Supply. (2) Harbor Bridge needs emergency closure — what traffic is affected? Query for FEEDS_INTO relationships. Answer: Harbor Junction loses bridge traffic. (3) Main Water Trunk needs repair — who loses water? Query SUPPLIES relationships. Answer: Riverside Pipeline and Harbor Water Supply.

Multi-Hop Analysis: The real power of the graph is multi-hop traversal. If Substation Alpha fails, you know it powers the Main Water Trunk pump station. But the Main Water Trunk supplies both Riverside Pipeline and Harbor Water Supply. And Riverside Pipeline supplies Industrial Pipeline. So a Substation Alpha failure has a cascading effect that reaches the Industrial district — even though they are served by a different substation (Beta) for electrical power. This cascading dependency analysis is nearly impossible to do correctly with traditional relational queries but is natural in a graph.

SQL/PGQ: The graph is queried using SQL/PGQ (Property Graph Query), which is standard SQL with graph pattern matching extensions. You don''t need to learn a separate graph query language — it is all SQL.',
    'CityPulse Engineering Team',
    DATE '2025-03-01'
);

-- ============================================================================
-- OPERATIONAL PLANNING & ANALYSIS
-- ============================================================================

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Capital Planning: Harbor District Infrastructure Upgrade Proposal',
    'Planning Document',
    'This proposal outlines a phased infrastructure upgrade plan for the Harbor district, prioritized by risk assessment and sensor data trends from the CityPulse monitoring network.

Current State Assessment: The Harbor district has the highest concentration of aging infrastructure in the CityPulse network. Harbor Bridge, the district''s primary vehicle crossing, has a structural sufficiency rating of 78.3 (below the 80.0 target). Substation Gamma operates at 62% peak capacity with Battery Bank B approaching replacement threshold. Harbor Water Supply serves the district from a single pipeline connection to the Main Water Trunk, creating a single point of failure.

Phase 1 — Critical Maintenance (0-6 months, estimated $1.2M): (1) Harbor Bridge western bearing assembly treatment. (2) Substation Gamma Battery Bank B replacement. (3) Installation of redundant vibration sensor on Harbor Bridge midspan for improved anomaly detection.

Phase 2 — Resilience Improvements (6-18 months, estimated $4.5M): (1) Harbor Water Supply secondary feed connection, eliminating the single point of failure. (2) Substation Gamma capacity expansion to accommodate future growth. (3) Upgrade of Harbor Junction traffic signal equipment to modern LED with backup battery power.

Phase 3 — Modernization (18-36 months, estimated $8.0M): (1) Harbor Bridge deck rehabilitation including surface repair and drainage improvements. (2) Replacement of all Harbor district sensors with next-generation models featuring edge computing capability. (3) Installation of fiber-optic monitoring on Harbor Bridge for distributed strain sensing.

Justification: The CityPulse sensor network has provided 18 months of baseline data that supports this prioritization. The vibration anomaly incident on Harbor Bridge in January 2025 demonstrated both the value of the monitoring system and the vulnerability of aging infrastructure. Substation Gamma''s approaching capacity limits pose a risk to all Harbor district operations during peak demand events.',
    'Infrastructure Planning Division',
    DATE '2025-09-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Analysis: Sensor Network Coverage Gaps and Expansion Recommendations',
    'Planning Document',
    'This analysis identifies monitoring gaps in the current CityPulse sensor network and recommends targeted expansion to improve coverage.

Current Coverage Summary: The network has 50 sensors across 5 districts monitoring 6 parameters. Downtown has the most sensors (10) appropriate for its infrastructure density. University district has the fewest sensors (8), which is appropriate for its lighter infrastructure loading. Each district has at least one sensor of each type, ensuring baseline monitoring capability.

Identified Gaps: (1) No water quality monitoring at the Main Water Trunk source intake. All flow sensors are on downstream distribution lines. A source water quality event could propagate through the entire system before being detected. (2) The University district has no pressure sensor on a pipeline — only UN-PRES-01 on a non-pipeline installation. This limits leak detection capability. (3) No vibration sensors on Substation Beta, despite it serving heavy industrial loads that may cause structural vibration. (4) Traffic sensors at University Crossing (UN-TRAF-01) provide count data but no speed measurement, limiting congestion analysis.

Recommended Additions: (1) Install a flow/water quality sensor at the Main Water Trunk intake point. Estimated cost: $45,000 installed. (2) Install a pressure sensor on the University district pipeline section. Estimated cost: $15,000 installed. (3) Install a vibration sensor at Substation Beta. Estimated cost: $12,000 installed. (4) Upgrade UN-TRAF-01 to a dual-loop configuration for speed measurement. Estimated cost: $8,000 installed.

Data Integration: All recommended additions use standard CityPulse sensor configurations and will automatically integrate with the existing readings table, JSON telemetry format, dashboard, and alert system. The infrastructure graph will need to be updated to include new MONITORS edges for sensors placed on infrastructure nodes.',
    'CityPulse Engineering Team',
    DATE '2025-08-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Performance Analysis: Sensor Network Reliability Metrics Q1-Q3 2025',
    'Planning Document',
    'This report summarizes the reliability performance of the CityPulse sensor network for the first three quarters of 2025.

Overall Availability: The network achieved 99.2% overall sensor availability, defined as the percentage of expected 30-minute reading intervals that produced valid data. This exceeds the 98.5% target established in the network service level agreement.

By Sensor Type: Vibration sensors achieved 99.5% availability — the highest of any type, attributable to their simple measurement mechanism and robust construction. Air quality sensors achieved 98.4% availability, slightly below target, driven by particulate buildup requiring more frequent cleaning in the Industrial district. Temperature sensors achieved 99.6% availability. Flow sensors achieved 99.1% availability, with two brief outages during pipeline maintenance operations. Pressure sensors achieved 99.3% availability. Traffic sensors achieved 99.0% availability, with one extended outage at UN-TRAF-01 due to a controller firmware bug that has since been patched.

By District: Downtown achieved 99.4% availability, the highest district score, reflecting the newer sensor installations and easier maintenance access. Industrial achieved 98.7%, the lowest, reflecting the harsher operating environment. Harbor achieved 99.0%, with the vibration anomaly event in January causing a brief data quality flag (not a true outage). Riverside achieved 99.3%. University achieved 99.2%.

Maintenance Impact: Of the 0.8% total downtime, approximately 60% was due to scheduled maintenance (calibration, cleaning, replacement) and 40% was due to unplanned events. The most common unplanned downtime cause was communication link interruption (15 events), followed by sensor malfunction requiring replacement (3 events).

Trend: Network reliability has improved each quarter as the team has refined maintenance schedules and identified environment-specific challenges (e.g., the accelerated cleaning cycle for Industrial district air quality sensors).',
    'CityPulse Operations Division',
    DATE '2025-10-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Technical Brief: CityPulse Data Architecture for Developers',
    'Engineering Guide',
    'This brief is for developers building applications on top of the CityPulse data platform. It covers the data model, access patterns, and best practices for efficient queries.

Core Tables: The relational core consists of districts (5 rows), sensor_types (6 rows), sensors (50 rows), infrastructure_nodes (14 rows), technicians (10 rows), and maintenance_log. These tables use standard normalized relational design with foreign key relationships.

Time Series Data: The readings table stores all sensor measurements with TIMESTAMP precision. It is interval-partitioned by reading_time on a daily basis, meaning the database automatically creates new partitions as data arrives. When querying readings, always include a time range predicate — this enables partition pruning and avoids full table scans. For example, querying the last 24 hours will only scan the most recent partition.

JSON Access: The readings.payload column stores JSON telemetry. Use Oracle''s JSON path expressions for efficient querying. For example, to find all vibration readings where the is_anomaly flag is set: SELECT * FROM readings WHERE JSON_VALUE(payload, ''$.is_anomaly'' RETURNING NUMBER) = 1. The JSON search index enables these queries to use an index scan rather than a full table scan.

Graph Queries: The city_infrastructure_graph can be queried with SQL/PGQ. Use the GRAPH_TABLE function to project graph traversals into tabular results that can be joined with other tables. For example, you can traverse the dependency graph to find all infrastructure affected by a substation failure, then join with the sensors table to identify which sensors monitor that infrastructure, then query the readings table for the latest data from those sensors — all in one SQL statement.

Materialized Views: The hourly_sensor_rollup_mv provides pre-computed hourly statistics. Use this for dashboard and reporting queries rather than aggregating raw readings. Refresh the view after bulk data loads or before generating reports.

The Knowledge Base: The city_knowledge_base table stores operational documents — inspection reports, procedures, safety bulletins, and more. This table is designed for vector search: documents can be chunked, embedded, and searched using Oracle''s AI vector search capabilities. See the vector search workshop materials for implementation details.',
    'CityPulse Engineering Team',
    DATE '2025-06-15'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'University District Environmental Monitoring Report — Spring 2025',
    'Inspection Report',
    'The University district environmental monitoring report for Spring 2025 covers air quality and noise considerations relevant to the campus environment and surrounding residential areas.

Air quality sensors UN-AIR-01 and UN-AIR-02 reported consistent AQI readings in the 35-50 range throughout the spring semester, below the city-wide average of 42. The University district benefits from extensive tree canopy cover and lower traffic volumes compared to Downtown and Industrial districts. PM2.5 concentrations averaged 10.2 μg/m³, well within EPA standards.

A brief AQI elevation to 78 was recorded on April 12, correlated with prescribed agricultural burning in the region. The event was short-lived (approximately 6 hours) and did not reach the unhealthy threshold. Both sensors showed correlated readings, confirming the regional nature of the event.

Traffic sensor UN-TRAF-01 at University Crossing showed expected seasonal patterns: increased vehicle counts during the academic semester (average 650 veh/hr) with significant reductions during spring break (average 280 veh/hr). Vibration sensor UN-VIB-01 at the University Crossing intersection showed a corresponding reduction in vibration amplitude during break periods, confirming the traffic-vibration correlation.

Noise Concerns: While CityPulse does not directly measure noise, the traffic density data from UN-TRAF-01 can serve as a proxy for noise modeling. The University administration has requested that traffic data be shared with their campus planning team to support noise mitigation planning for a new library building near the intersection.

Recommendation: The University district monitoring network is performing well for its intended purpose. No additional sensors are recommended at this time, though the upgrade of UN-TRAF-01 to a speed-measuring configuration (recommended in the network coverage gap analysis) would enhance traffic impact studies.',
    'Environmental Monitoring Division',
    DATE '2025-06-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Operational Guide: Interpreting Multi-Sensor Correlation Patterns',
    'Training Material',
    'This guide teaches CityPulse operators how to interpret situations where multiple sensors show correlated changes. Multi-sensor correlation is a powerful diagnostic tool that helps distinguish between real events and sensor malfunctions.

Principle: A single sensor showing an unusual reading could be a malfunction. Two or more sensors showing correlated unusual readings almost certainly indicate a real event. The type and location of the correlated sensors helps identify what is happening.

Pattern 1 — Co-located Sensors Agreement: When two sensors of the same type at the same location show correlated changes (e.g., HB-VIB-01 and HB-VIB-02 on Harbor Bridge both show elevated vibration), this strongly confirms a real event affecting that structure. If only one sensor changes while the other remains at baseline, suspect a sensor issue with the one that changed.

Pattern 2 — Cross-Type Correlation at One Location: When different sensor types at the same location correlate (e.g., elevated vibration AND elevated temperature on Harbor Bridge), this suggests an environmental event affecting the structure as a whole, such as extreme heat causing thermal expansion or an earthquake. Check for similar patterns at other structures to assess the geographic scope.

Pattern 3 — Sequential Sensor Activation Along Infrastructure: When sensors activate in sequence along a pipeline or dependency chain (e.g., pressure drop at RV-PRES-01 followed minutes later by flow change at IN-FLOW-01), this indicates an event propagating through connected infrastructure. Use the dependency graph to predict which sensors should be affected next and monitor proactively.

Pattern 4 — District-Wide Elevation: When all sensors of one type across a district show correlated changes (e.g., all air quality sensors in the Industrial district show elevated AQI), this indicates a district-level environmental event rather than a localized equipment issue. Compare with neighboring districts to determine if the event is even broader.

Anti-Pattern — Uncorrelated Spikes: A single sharp spike on one sensor with no correlation to any nearby sensor, followed by a return to normal, is almost always electrical noise, communication error, or momentary sensor malfunction. These should be logged but do not require an emergency response.',
    'CityPulse Operations Division',
    DATE '2025-05-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Technical Advisory: Embedding Model Selection for CityPulse Knowledge Search',
    'Engineering Guide',
    'This advisory provides guidance on selecting and configuring embedding models for vector search over the CityPulse operational knowledge base.

Current Configuration: The CityPulse knowledge base uses an ONNX embedding model loaded directly into Oracle Database. This approach eliminates network latency for embedding generation and keeps all data processing within the database boundary. The current model produces embeddings with a fixed dimensionality that captures semantic meaning of technical operational text.

Model Selection Criteria: When selecting an embedding model for operational knowledge search, consider: (1) Domain relevance — models trained on or fine-tuned with technical and engineering text will produce better embeddings for infrastructure documents. (2) Dimensionality — higher dimensions capture more nuance but require more storage and slower distance calculations. For the CityPulse knowledge base (under 1000 documents), the performance difference is negligible, but for larger deployments this becomes a real cost factor. (3) Token limit — the model''s maximum input length determines the maximum effective chunk size. Chunks exceeding the token limit will be truncated, losing information.

Chunking Interaction: The embedding model and chunking strategy must be aligned. If the model has a 512-token limit, chunks should be sized to stay within that limit. The VECTOR_CHUNKS function''s MAX parameter controls chunk size. A good starting point is 80% of the model''s token limit, leaving headroom for tokenization variance between words and tokens.

Distance Metric: Cosine similarity is the default recommendation for text embeddings because it normalizes for vector magnitude, focusing purely on directional similarity. Dot product may be preferred when document length should influence relevance (longer, more detailed documents score higher). Euclidean distance is rarely the best choice for text embeddings but may be appropriate for numeric or sensor data embeddings.

Quality Validation: After deploying an embedding model, validate search quality with a set of known-good queries. For example, search "bridge vibration anomaly response" and verify that the Emergency Response Protocol for structural vibration anomalies appears in the top-3 results. Maintain a query validation set and re-run it after any model change or re-embedding operation.',
    'CityPulse Data Engineering Team',
    DATE '2025-07-01'
);

INSERT INTO city_knowledge_base (title, category, content, author, publish_date) VALUES (
    'Quarterly Maintenance Schedule: Q4 2025',
    'Planning Document',
    'The following maintenance activities are scheduled for Q4 2025 (October-December) across the CityPulse sensor network. All activities follow their respective standard operating procedures.

October 2025:
- Week 1: Harbor Bridge vibration sensor calibration (HB-VIB-01, HB-VIB-02). This is a priority item following the annual inspection recommendation to increase monitoring frequency.
- Week 2: Downtown Overpass quarterly inspection and DT-VIB-01 calibration.
- Week 2: Substation Gamma Battery Bank B replacement (scheduled in response to bi-annual inspection finding of 89% capacity).
- Week 3: Industrial district air quality sensor cleaning (IN-AIR-01, IN-AIR-02) per the accelerated 30-day schedule.
- Week 4: Flow sensor maintenance for Riverside district (RV-FLOW-01, RV-FLOW-02).

November 2025:
- Week 1: Winter preparation for all bridge sensors per Seasonal Advisory.
- Week 1: River Crossing Bridge quarterly inspection.
- Week 2: Pressure sensor recalibration for IN-PRES-02 (identified offset during pipeline pressure test).
- Week 3: Industrial district air quality sensor cleaning cycle.
- Week 4: University district sensor inspection and UN-TRAF-01 diagnostic (firmware patch verification).

December 2025:
- Week 1: Harbor Bridge western bearing assembly treatment (Phase 1 capital project).
- Week 2: Quarterly HNSW vector index rebuild for knowledge base search system.
- Week 3: Industrial district air quality sensor cleaning cycle.
- Week 4: Holiday period — skeleton crew, emergency response only. All routine maintenance deferred to January.

Coordination Requirements: The Harbor Bridge bearing treatment in December requires temporary traffic restrictions. Coordinate with traffic management for timing. The Substation Gamma battery replacement requires a scheduled maintenance outage — coordinate with Harbor district facilities for backup power arrangements.',
    'CityPulse Operations Division',
    DATE '2025-09-15'
);

COMMIT;

-- Verify the load
SELECT category, COUNT(*) AS doc_count
FROM city_knowledge_base
GROUP BY category
ORDER BY doc_count DESC;

SELECT 'Total documents: ' || COUNT(*) AS summary FROM city_knowledge_base;

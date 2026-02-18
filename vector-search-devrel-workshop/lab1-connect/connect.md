# Lab 1: Connect & Explore the Knowledge Base

## Introduction

In this lab, you'll connect to Oracle Autonomous Database and explore the CityPulse knowledge base — a collection of operational documents including inspection reports, maintenance procedures, emergency protocols, and engineering guides. You'll also see firsthand why traditional keyword search fails for semantic queries, setting up the problem that vector search will solve in the remaining labs.

**Estimated Time:** 4 minutes

### Objectives

In this lab, you will:

* Connect to Oracle Autonomous Database using the Python `oracledb` driver
* Explore the `city_knowledge_base` table and its document categories
* Attempt a keyword search and see why it fails for semantic queries
* Understand the problem that vector search solves

### Prerequisites

This lab assumes you have:

* Completed the Introduction
* Access to the workshop Jupyter notebook environment
* The CityPulse schema pre-loaded in your database

## Task 1: Connect to Oracle Autonomous Database

Open the **Lab1\_Connect.ipynb** notebook in your Jupyter environment.

1. Run the first cell to establish your database connection:

    ```python
    <copy>
    import oracledb

    # ============================================================
    # UPDATE THESE WITH YOUR CONNECTION DETAILS
    # ============================================================
    DB_USER     = "citypulse"
    DB_PASSWORD = "YourPasswordHere"   # <-- Change this
    DB_DSN      = "your-adb-host:1522/your_service_tp.adb.oraclecloud.com"  # <-- Change this

    # Connect in thin mode — no Oracle Client installation needed
    connection = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    print(f"Connected to Oracle Database {connection.version}")
    print(f"User: {DB_USER}")
    </copy>
    ```

2. You should see output confirming the connection:

    ```
    Connected to Oracle Database 26.x.x.x.x
    User: citypulse
    ```

    <!-- TODO: Add screenshot of successful connection output -->
    ![Connection Success](../images/lab1/connection-success.png " ")

3. Run the next cell to create a helper function we'll reuse throughout the workshop:

    ```python
    <copy>
    def run_query(sql, params=None, headers=True):
        """Run a SQL query and print results in a formatted table."""
        with connection.cursor() as cursor:
            cursor.execute(sql, params or {})
            columns = [col[0] for col in cursor.description]
            rows = cursor.fetchall()

            if headers:
                widths = [max(len(str(col)), max((len(str(row[i])) for row in rows), default=0))
                          for i, col in enumerate(columns)]
                header = " | ".join(str(col).ljust(widths[i]) for i, col in enumerate(columns))
                print(header)
                print("-" * len(header))
                for row in rows:
                    print(" | ".join(str(val).ljust(widths[i]) for i, val in enumerate(row)))

            print(f"\n({len(rows)} rows)")
            return rows

    print("Helper function ready.")
    </copy>
    ```

## Task 2: Explore the Knowledge Base

Now let's see what's in the CityPulse knowledge base.

1. Run the following cell to see the document categories and counts:

    ```python
    <copy>
    print("=== KNOWLEDGE BASE OVERVIEW ===\n")
    run_query("""
        SELECT category, COUNT(*) AS doc_count
        FROM city_knowledge_base
        GROUP BY category
        ORDER BY doc_count DESC
    """)
    </copy>
    ```

    You should see a variety of categories — inspection reports, maintenance procedures, emergency protocols, engineering guides, and more.

    <!-- TODO: Add screenshot of category counts -->
    ![Knowledge Base Overview](../images/lab1/kb-overview.png " ")

2. Let's look at the documents themselves — titles, categories, authors, and content length:

    ```python
    <copy>
    print("=== KNOWLEDGE BASE DOCUMENTS ===\n")
    run_query("""
        SELECT doc_id,
               SUBSTR(title, 1, 55) AS title,
               category,
               LENGTH(content) AS content_length
        FROM city_knowledge_base
        ORDER BY doc_id
    """)
    </copy>
    ```

    Notice how the documents vary in length — some are short safety bulletins (a few hundred characters), while others are detailed inspection reports (several thousand characters). This will matter when we chunk them in Lab 2.

3. Let's read one document to get a feel for the content:

    ```python
    <copy>
    print("=== SAMPLE DOCUMENT ===\n")
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT title, category, author, content
            FROM city_knowledge_base
            WHERE title LIKE '%Vibration Anomaly%' AND category = 'Emergency Protocol'
        """)
        row = cursor.fetchone()
        print(f"Title:    {row[0]}")
        print(f"Category: {row[1]}")
        print(f"Author:   {row[2]}")
        print(f"\n{row[3][:500]}...")
    </copy>
    ```

    This is the *Structural Vibration Anomaly Response Protocol* — a document that describes what to do when a bridge sensor reports elevated vibration readings. Remember this document. You're about to search for it.

## Task 3: The Keyword Search Problem

Here's the scenario: a CityPulse operator notices elevated vibration readings on a bridge sensor and wants to find the relevant response procedure. They search for "bridge shaking."

1. Try a keyword search:

    ```python
    <copy>
    print("=== KEYWORD SEARCH: 'bridge shaking' ===\n")
    results = run_query("""
        SELECT doc_id, title, category
        FROM city_knowledge_base
        WHERE LOWER(content) LIKE '%bridge shaking%'
    """)

    if len(results) == 0:
        print("\n⚠️  Zero results. The operator found nothing.")
    </copy>
    ```

    **Zero results.** The document about vibration anomaly response exists — you just read it — but it never uses the phrase "bridge shaking." It uses technical terms like "structural vibration," "elevated readings," and "anomaly thresholds."

    <!-- TODO: Add screenshot of zero keyword results -->
    ![Keyword Search Fails](../images/lab1/keyword-fail.png " ")

2. We can prove the document is there by searching for terms that *are* in it:

    ```python
    <copy>
    print("=== KEYWORD SEARCH: 'vibration anomaly' ===\n")
    run_query("""
        SELECT doc_id, SUBSTR(title, 1, 60) AS title, category
        FROM city_knowledge_base
        WHERE LOWER(content) LIKE '%vibration anomaly%'
    """)
    </copy>
    ```

    Now we get results — but only because we happened to guess the right terminology. A real user searching for "bridge shaking" would walk away thinking there's no relevant procedure.

3. **This is the problem vector search solves.** Instead of matching exact keywords, vector search compares the *meaning* of the query against the *meaning* of the documents. "Bridge shaking" and "structural vibration anomaly response protocol" mean similar things, even though they share no words in common.

    In the next lab, you'll chunk these documents, generate vector embeddings, and build a search system where "bridge shaking" finds exactly the right document.

## Summary

In this lab, you:

* Connected to Oracle Autonomous Database
* Explored the CityPulse knowledge base with 36 operational documents
* Demonstrated that keyword search fails when the user's terminology doesn't match the document's terminology
* Established the problem that vector search will solve in the remaining labs

You may now **proceed to the next lab**.

## Acknowledgements

* **Author** — Kirk Kirkconnell, Oracle Developer Relations
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026

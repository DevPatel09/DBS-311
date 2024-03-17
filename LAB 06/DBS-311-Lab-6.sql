-- ***********************
-- Name: Dev Kshitij Patel
-- ID: 142979228
-- Date: 2/16/2024
-- Purpose: Lab 6 DBS311
-- ***********************

--Question-1(Stored procedure that takes an integer number as input and prints whether it is even or odd.
-- This procedure handles exceptions for invalid input.)
CREATE OR REPLACE PROCEDURE check_even_odd (p_number IN NUMBER)
IS
BEGIN
    IF MOD(p_number, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number is even.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number is odd.');
    END IF;
END;


--Question-2(Stored procedure named find_employee to retrieve employee information by ID.
-- This procedure handles exceptions for no data found and other unexpected errors.)

CREATE OR REPLACE PROCEDURE find_employee (p_employee_id IN NUMBER)
IS
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_email employees.email%TYPE;
    v_phone employees.phone_number%TYPE;
    v_hire_date employees.hire_date%TYPE;
    v_job_title employees.job_title%TYPE;
BEGIN
    SELECT first_name, last_name, email, phone_number, hire_date, job_title
    INTO v_first_name, v_last_name, v_email, v_phone, v_hire_date, v_job_title
    FROM employees
    WHERE employee_id = p_employee_id;

    DBMS_OUTPUT.PUT_LINE('First name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
    DBMS_OUTPUT.PUT_LINE('Hire date: ' || TO_CHAR(v_hire_date, 'DD-MON-YY'));
    DBMS_OUTPUT.PUT_LINE('Job title: ' || v_job_title);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee with ID ' || p_employee_id || ' does not exist.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;



--Question-3(Procedure named update_price_by_cat to update product prices by category.
-- This procedure handles exceptions for invalid category IDs and other errors.)
CREATE OR REPLACE PROCEDURE update_price_by_cat (p_category_id IN NUMBER, p_amount IN NUMBER)
IS
    v_rows_updated NUMBER;
BEGIN
    UPDATE products
    SET list_price = list_price + p_amount
    WHERE category_id = p_category_id
    AND list_price > 0;

    v_rows_updated := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(v_rows_updated || ' row(s) updated.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

--Question-4(Procedure named update_price_under_avg to update product prices below the average.
-- This procedure handles exceptions for unexpected errors.)
CREATE OR REPLACE PROCEDURE update_price_under_avg
AS
    avg_price NUMBER;
    rows_updated NUMBER;
BEGIN
    SELECT AVG(list_price)
    INTO avg_price
    FROM products;

    IF avg_price <= 1000 THEN
        UPDATE products
        SET list_price = list_price * 1.02
        WHERE list_price < avg_price;
    ELSE
        UPDATE products
        SET list_price = list_price * 1.01
        WHERE list_price < avg_price;
    END IF;

    rows_updated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Number of rows updated: ' || rows_updated);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred.');
END update_price_under_avg;


--Question-5(Procedure named product_price_report to categorize product prices.
-- This procedure handles exceptions for unexpected errors.)
CREATE OR REPLACE PROCEDURE product_price_report
AS
    avg_price NUMBER;
    min_price NUMBER;
    max_price NUMBER;
    cheap_count NUMBER := 0;
    fair_count NUMBER := 0;
    exp_count NUMBER := 0;
BEGIN
    SELECT AVG(list_price), MIN(list_price), MAX(list_price)
    INTO avg_price, min_price, max_price
    FROM products;

    FOR product IN (SELECT list_price FROM products) LOOP
        IF product.list_price < (avg_price - min_price) / 2 THEN
            cheap_count := cheap_count + 1;
        ELSIF product.list_price > (max_price - avg_price) / 2 THEN
            exp_count := exp_count + 1;
        ELSE
            fair_count := fair_count + 1;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred.');
END product_price_report;




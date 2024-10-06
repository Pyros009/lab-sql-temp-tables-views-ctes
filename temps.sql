# 1: create a view that summarizes rental information for each customer. The view should include the 
# customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_count AS
SELECT
	c.customer_id,
    CONCAT(c.first_name, " ", c.last_name) AS client_name, 
    c.email, 
    COUNT(r.rental_id) AS rental_count
FROM rental AS r
INNER JOIN customer AS c ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

# 2 create a Temporary Table that calculates the total amount paid by each customer (total_paid). Use the rental summary view
# created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE pay_resume AS
SELECT rc.*, SUM(p.amount) as total_paid
FROM rental_count as rc
JOIN payment as p ON p.customer_id = rc.customer_id
GROUP BY rc.customer_id, rc.client_name, rc.email, rc.rental_count
;

# 3 Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
# The CTE should include the customer's name, email address, rental count, and total amount paid.  Create Customer Summary Report

WITH customer_summary_report AS (
SELECT client_name, email, rental_count, total_paid 
FROM pay_resume)
SELECT *, ROUND(AVG(total_paid/rental_count),2) As average_payment_per_rental 
FROM customer_summary_report
GROUP BY client_name, email, rental_count, total_paid
;

/*
Highest paying customer is Karl Seal with 221.55 dollars paid, but the highest average payment per rental is from Brittany Riley
 with 5.70 dollars per rental.
Highest number of rentals is from Eleanor Hunt with 46 rentals at 4.71 dollar average per rental.
*/
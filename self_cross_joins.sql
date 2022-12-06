use sakila;

#1
SELECT A.actor_id AS 'Actor1 ID', B.actor_id AS 'Actor2 ID', C.title AS 'Film'
FROM film_actor A, film_actor B
CROSS JOIN film C ON B.film_id = C.film_id
WHERE A.actor_id <> B.actor_id
AND A.film_id = B.film_id
ORDER BY A.film_id;

#2
SELECT film.film_id AS 'Film ID', film.title AS 'Film', count(distinct(rental.customer_id)) AS 'Diferent Customers', count(rental.rental_id) AS 'Number of rentals'
FROM rental
CROSS JOIN inventory ON rental.inventory_id = inventory.inventory_id
CROSS JOIN film ON inventory.film_id = film.film_id
GROUP BY inventory.film_id
HAVING count(rental.rental_id) - count(distinct(rental.customer_id)) >= 3 ;
/* 
This last query finds the films that were rented more times than the number of different customers who rented it.

count(rental.rental_id) is the number of rentals of a film;
count(distinct(rental.customer_id)) is the number of different customers who rented that film.

The value of the difference between these numbers can never be negative, since when exists a rent implies that exists a customer 
(since rental_id's are unique).
This eliminates the necessity to use the function ABS() to find the true value.

When the difference is zero, we have as many different customers as rentals, this implies that there is only one rental per customer.

When the difference is equal to 1, it means only 1 customer rented a film 2 times (2x).

When the difference is equal to 2, we have 2 possible outcomes:
- 1 customer rented a film 3x;
- 2 customers rented a film 2x each.

When the difference is equal to 3, we have 3 possible outcomes:
- 1 customer rented a film 4x;
- 2 customers rented a film more than once (3x customer_1 and 2x customer_2);
- 3 customers rented a film 2x each.

When the value is greater then 3, the query returns zero rows, meaning that kind of combinations didn't occurred.

This means that the existence of a pair of (different) customers renting the same film more than 3 times each didn't occurred.

However, we have the possibility of a single customer renting a film more than 3 times. (when the difference = 3)

The film_id's where this could occur are: 111, 869 and 973. So we only have to check if this condition occurred in the renting of this 3 films.
*/

SELECT DISTINCT(A.customer_id) AS 'Customer\'s ID', COUNT(C.rental_id) AS 'Number of rentals', E.film_id AS 'Film ID'
FROM customer A, customer B
CROSS JOIN rental C ON B.customer_id = C.customer_id
CROSS JOIN inventory D ON C.inventory_id = D.inventory_id
CROSS JOIN film E ON D.film_id = E.film_id
WHERE A.customer_id = B.customer_id
AND 
(E.film_id = 111 
OR E.film_id = 973
OR E.film_id = 869)
GROUP BY A.customer_id,E.film_id
ORDER BY E.film_id ASC,COUNT(C.rental_id) DESC;
/* 
This last query checks the number of rentals of each customer for the 3 films.
for film_id = 111 we have the case: - 2 customers rented a film more than once (3x customer_1 and 2x customer_2);
for film_id = 869 we have the case: - 3 customers rented a film 2x each
for film_id = 973 we have the case: - 3 customers rented a film 2x each

We conclued that none customer rented a film more than 3 times.
*/

#3

# all possible pairs of actors
SELECT A.first_name AS 'Actor 1', B.first_name AS 'Actor 2'
FROM actor A, actor B
WHERE A.actor_id <> B.actor_id;


# all possible pairs of films
SELECT A.title AS 'Film 1', B.title AS 'Film 2'
FROM film A, film B
WHERE A.film_id <> B.film_id;

# all possible pairs of actor-film
SELECT A.first_name AS 'Actor', B.title AS 'Film'
FROM actor A, film B
WHERE A.actor_id <> B.film_id;





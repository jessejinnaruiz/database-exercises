USE world;
SHOW TABLES;
DESCRIBE country;

-- What languages are spoken in Santa Monica?
SELECT * 
FROM countrylanguage
WHERE CountryCode = 'USA'
ORDER BY Percentage DESC;

-- How many different countries are in each region?
SELECT COUNT(Region), Region
FROM country
GROUP BY Region
ORDER BY COUNT(Region);


-- What is the population for each region?
SELECT SUM(Population), Region
FROM country
GROUP BY Region
ORDER BY SUM(Population) DESC;

-- What is the population for each continent?
SELECT SUM(Population), Continent
FROM country
GROUP BY Continent
ORDER BY SUM(Population) DESC;

-- What is the average life expectancy globally?
SELECT AVG(LifeExpectancy)
FROM country;

-- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest
SELECT AVG(LifeExpectancy), Region
FROM country
GROUP BY Region
ORDER BY AVG(LifeExpectancy);

SELECT AVG(LifeExpectancy), Continent
FROM country
GROUP BY Continent
ORDER BY AVG(LifeExpectancy);

-- Bonus
-- Find all the countries whose local name is different from the official name
SELECT * 
FROM country
WHERE Name <> LocalName;


-- How many countries have a life expectancy less than x?
SELECT COUNT(Name)
FROM country
WHERE LifeExpectancy > 75;

-- What state is city x located in? x = Santa Monic
SELECT District
FROM city
WHERE Name = 'Santa Monica';

-- What region of the world is city x located in?
SELECT country.Region
FROM country
JOIN city ON country.Code = city.CountryCode
WHERE city.Name = 'Santa Monica';

-- What country (use the human readable name) city x located in?
SELECT country.Name
FROM country
JOIN city ON country.Code = city.CountryCode
WHERE city.Name = 'Santa Monica';

-- What is the life expectancy in city x?
SELECT country.LifeExpectancy
FROM country
JOIN city ON country.Code = city.CountryCode
WHERE city.Name = 'Santa Monica';


-- Sakila Database
USE sakila;
SHOW TABLES;
-- 1. Display the first and last names in all lowercase of all the actors.
DESCRIBE actor;
SELECT LOWER(first_name), LOWER(last_name)
FROM actor;

-- 2. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you could use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 3. Find all actors whose last name contain the letters "gen":
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%gen%';

-- 4. Find all actors whose last names contain the letters "li". This time, order the rows by last name and first name, in that order.
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name;


-- 5. Using IN, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 6. List the last names of all the actors, as well as how many actors have that last name.
SELECT last_name,COUNT(last_name)
FROM actor
GROUP BY last_name;

-- ?? 7. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(last_name)
FROM actor
GROUP BY last_name
WHERE COUNT(last_name) >= 2;

-- 8. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- ??

-- 9. Use JOIN to display the first and last names, as well as the address, of each staff member.
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON address.address_id = staff.address_id;

-- 10. Use JOIN to display the total amount rung up by each staff member in August of 2005.
SELECT SUM(payment.amount), CONCAT(staff.first_name, ' ', staff.last_name) AS staff_name
FROM payment
JOIN staff ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.first_name, staff.last_name;

-- 11. List each film and the number of actors who are listed for that film.
SELECT film.title, COUNT(actor.actor_id)
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.title;

-- 12. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*)
FROM inventory
JOIN film on film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- 13. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE language_id IN (
	SELECT language_id
	FROM language
	WHERE language_id = 1
) AND title LIKE 'k%' OR title LIKE  'q%';

-- 14. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name, film.title
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title IN (
	SELECT title
	FROM film
	WHERE title = 'Alone Trip'
);

-- 15. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
-- 16. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
-- 17. Write a query to display how much business, in dollars, each store brought in.
-- 18. Write a query to display for each store its store ID, city, and country.
-- 19. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
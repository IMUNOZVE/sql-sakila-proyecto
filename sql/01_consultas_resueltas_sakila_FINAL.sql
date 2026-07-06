/*
===============================================================================
DataProject: Lógica Consultas SQL - Proyecto Sakila (versión final revisada)
Base de datos: Sakila / PostgreSQL
Herramienta recomendada: DBeaver

Instrucciones:
1) Importa primero el archivo BBDD_Proyecto_shakila_sinuser.sql en PostgreSQL.
2) Ejecuta este script consulta por consulta en DBeaver.
3) Las consultas están numeradas según el enunciado oficial.
4) Se evita SELECT * salvo en consultas exploratorias justificadas.
===============================================================================
*/

-- =============================================================================
-- 1. Crea el esquema de la BBDD.
-- =============================================================================
-- En DBeaver: importar el archivo BBDD_Proyecto_shakila_sinuser.sql.
-- El archivo de BBDD contiene los CREATE TABLE, claves primarias, claves foráneas,
-- secuencias, tipos y datos necesarios para construir el esquema relacional.
-- Si necesitas crear un esquema separado antes de importar, puedes usar:
CREATE SCHEMA IF NOT EXISTS sakila;
-- Nota: si ya has importado las tablas en public, trabaja sobre public.
-- SET search_path TO public;

-- =============================================================================
-- 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'.
-- =============================================================================
SELECT
    f.title
FROM film AS f
WHERE f.rating = 'R'
ORDER BY f.title;

-- =============================================================================
-- 3. Encuentra los nombres de los actores que tengan un actor_id entre 30 y 40.
-- =============================================================================
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.actor_id BETWEEN 30 AND 40
ORDER BY a.actor_id;

-- =============================================================================
-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
-- =============================================================================
-- En la base de datos Sakila, original_language_id puede venir vacío en muchas
-- películas. Por eso se usa LEFT JOIN: así la consulta es robusta y permite ver
-- si existe idioma original informado. El filtro final mantiene únicamente las
-- películas donde el idioma principal coincide con el idioma original.
SELECT
    f.film_id,
    f.title,
    l.name AS language_name,
    ol.name AS original_language_name
FROM film AS f
INNER JOIN language AS l
    ON f.language_id = l.language_id
LEFT JOIN language AS ol
    ON f.original_language_id = ol.language_id
WHERE f.original_language_id IS NOT NULL
  AND f.language_id = f.original_language_id
ORDER BY f.title;

-- =============================================================================
-- 5. Ordena las películas por duración de forma ascendente.
-- =============================================================================
SELECT
    f.title,
    f.length
FROM film AS f
ORDER BY f.length ASC NULLS LAST, f.title;

-- =============================================================================
-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
-- =============================================================================
SELECT
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.last_name ILIKE '%Allen%'
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 7. Cantidad total de películas en cada clasificación de la tabla film.
-- =============================================================================
SELECT
    f.rating,
    COUNT(*) AS total_peliculas
FROM film AS f
GROUP BY f.rating
ORDER BY total_peliculas DESC, f.rating;

-- =============================================================================
-- 8. Título de películas que son PG-13 o tienen duración mayor a 3 horas.
-- =============================================================================
SELECT
    f.title,
    f.rating,
    f.length
FROM film AS f
WHERE f.rating = 'PG-13'
   OR f.length > 180
ORDER BY f.title;

-- =============================================================================
-- 9. Variabilidad del coste de reemplazo de las películas.
-- =============================================================================
SELECT
    MIN(f.replacement_cost) AS coste_minimo,
    MAX(f.replacement_cost) AS coste_maximo,
    ROUND(AVG(f.replacement_cost), 2) AS coste_promedio,
    ROUND(STDDEV(f.replacement_cost), 2) AS desviacion_estandar,
    ROUND(VARIANCE(f.replacement_cost), 2) AS varianza
FROM film AS f;

-- =============================================================================
-- 10. Mayor y menor duración de una película de la BBDD.
-- =============================================================================
SELECT
    MIN(f.length) AS menor_duracion,
    MAX(f.length) AS mayor_duracion
FROM film AS f;

-- =============================================================================
-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
-- =============================================================================
SELECT
    r.rental_id,
    r.rental_date,
    p.amount AS coste_alquiler
FROM rental AS r
INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC, r.rental_id DESC
LIMIT 1 OFFSET 2;

-- =============================================================================
-- 12. Título de películas que no sean ni NC-17 ni G en clasificación.
-- =============================================================================
SELECT
    f.title,
    f.rating
FROM film AS f
WHERE f.rating NOT IN ('NC-17', 'G')
ORDER BY f.title;

-- =============================================================================
-- 13. Promedio de duración de películas por clasificación.
-- =============================================================================
SELECT
    f.rating,
    ROUND(AVG(f.length), 2) AS duracion_promedio
FROM film AS f
GROUP BY f.rating
ORDER BY duracion_promedio DESC;

-- =============================================================================
-- 14. Título de películas con duración mayor a 180 minutos.
-- =============================================================================
SELECT
    f.title,
    f.length
FROM film AS f
WHERE f.length > 180
ORDER BY f.length DESC, f.title;

-- =============================================================================
-- 15. ¿Cuánto dinero ha generado en total la empresa?
-- =============================================================================
SELECT
    ROUND(SUM(p.amount), 2) AS ingresos_totales
FROM payment AS p;

-- =============================================================================
-- 16. Muestra los 10 clientes con mayor valor de id.
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customer AS c
ORDER BY c.customer_id DESC
LIMIT 10;

-- =============================================================================
-- 17. Actores que aparecen en la película con título 'Egg Igby'.
-- =============================================================================
SELECT
    a.first_name,
    a.last_name,
    f.title
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film AS f
    ON fa.film_id = f.film_id
WHERE f.title = 'Egg Igby'
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 18. Selecciona todos los nombres de las películas únicos.
-- =============================================================================
SELECT DISTINCT
    f.title
FROM film AS f
ORDER BY f.title;

-- =============================================================================
-- 19. Películas de comedia con duración mayor a 180 minutos.
-- =============================================================================
SELECT
    f.title,
    c.name AS categoria,
    f.length
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180
ORDER BY f.length DESC, f.title;

-- =============================================================================
-- 20. Categorías con promedio de duración superior a 110 minutos.
-- =============================================================================
SELECT
    c.name AS categoria,
    ROUND(AVG(f.length), 2) AS duracion_promedio
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_promedio DESC;

-- =============================================================================
-- 21. Media de duración del alquiler de las películas.
-- =============================================================================
SELECT
    ROUND(AVG(f.rental_duration), 2) AS media_duracion_alquiler_dias
FROM film AS f;

-- =============================================================================
-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
-- =============================================================================
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
FROM actor AS a
ORDER BY nombre_completo;

-- =============================================================================
-- 23. Número de alquileres por día, ordenados por cantidad descendente.
-- =============================================================================
SELECT
    DATE(r.rental_date) AS fecha_alquiler,
    COUNT(*) AS numero_alquileres
FROM rental AS r
GROUP BY DATE(r.rental_date)
ORDER BY numero_alquileres DESC, fecha_alquiler;

-- =============================================================================
-- 24. Películas con duración superior al promedio.
-- =============================================================================
SELECT
    f.title,
    f.length
FROM film AS f
WHERE f.length > (
    SELECT AVG(length)
    FROM film
)
ORDER BY f.length DESC, f.title;

-- =============================================================================
-- 25. Número de alquileres registrados por mes.
-- =============================================================================
SELECT
    DATE_TRUNC('month', r.rental_date)::date AS mes,
    COUNT(*) AS numero_alquileres
FROM rental AS r
GROUP BY DATE_TRUNC('month', r.rental_date)
ORDER BY mes;

-- =============================================================================
-- 26. Promedio, desviación estándar y varianza del total pagado.
-- =============================================================================
SELECT
    ROUND(AVG(p.amount), 2) AS promedio_pagado,
    ROUND(STDDEV(p.amount), 2) AS desviacion_estandar,
    ROUND(VARIANCE(p.amount), 2) AS varianza
FROM payment AS p;

-- =============================================================================
-- 27. Películas que se alquilan por encima del precio medio.
-- =============================================================================
SELECT
    f.title,
    f.rental_rate
FROM film AS f
WHERE f.rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
)
ORDER BY f.rental_rate DESC, f.title;

-- =============================================================================
-- 28. ID de actores que han participado en más de 40 películas.
-- =============================================================================
SELECT
    fa.actor_id,
    COUNT(fa.film_id) AS numero_peliculas
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) > 40
ORDER BY numero_peliculas DESC, fa.actor_id;

-- =============================================================================
-- 29. Todas las películas y cantidad disponible en inventario.
-- =============================================================================
SELECT
    f.film_id,
    f.title,
    COUNT(i.inventory_id) AS cantidad_disponible
FROM film AS f
LEFT JOIN inventory AS i
    ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY cantidad_disponible DESC, f.title;

-- =============================================================================
-- 30. Actores y número de películas en las que han actuado.
-- =============================================================================
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS numero_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY numero_peliculas DESC, a.last_name, a.first_name;

-- =============================================================================
-- 31. Todas las películas y actores asociados, incluso películas sin actores.
-- =============================================================================
SELECT
    f.film_id,
    f.title,
    a.actor_id,
    a.first_name,
    a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa
    ON f.film_id = fa.film_id
LEFT JOIN actor AS a
    ON fa.actor_id = a.actor_id
ORDER BY f.title, a.last_name, a.first_name;

-- =============================================================================
-- 32. Todos los actores y películas asociadas, incluso actores sin películas.
-- =============================================================================
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    f.film_id,
    f.title
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
LEFT JOIN film AS f
    ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name, f.title;

-- =============================================================================
-- 33. Todas las películas disponibles y todos los registros de alquiler.
-- =============================================================================
SELECT
    f.film_id,
    f.title,
    i.inventory_id,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM film AS f
FULL OUTER JOIN inventory AS i
    ON f.film_id = i.film_id
FULL OUTER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date;

-- =============================================================================
-- 34. Los 5 clientes que más dinero se han gastado.
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(p.amount), 2) AS total_gastado
FROM customer AS c
INNER JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

-- =============================================================================
-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
-- =============================================================================
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.first_name = 'Johnny'
ORDER BY a.last_name;

-- =============================================================================
-- 36. Renombra first_name como Nombre y last_name como Apellido.
-- =============================================================================
SELECT
    a.first_name AS "Nombre",
    a.last_name AS "Apellido"
FROM actor AS a
ORDER BY "Apellido", "Nombre";

-- =============================================================================
-- 37. ID del actor más bajo y más alto.
-- =============================================================================
SELECT
    MIN(a.actor_id) AS actor_id_minimo,
    MAX(a.actor_id) AS actor_id_maximo
FROM actor AS a;

-- =============================================================================
-- 38. Cuenta cuántos actores hay en la tabla actor.
-- =============================================================================
SELECT
    COUNT(*) AS total_actores
FROM actor;

-- =============================================================================
-- 39. Selecciona todos los actores y ordénalos por apellido ascendente.
-- =============================================================================
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
ORDER BY a.last_name ASC, a.first_name ASC;

-- =============================================================================
-- 40. Selecciona las primeras 5 películas de la tabla film.
-- =============================================================================
SELECT
    f.film_id,
    f.title,
    f.release_year,
    f.rating
FROM film AS f
ORDER BY f.film_id
LIMIT 5;

-- =============================================================================
-- 41. Agrupa actores por nombre y cuenta repeticiones. Nombre más repetido.
-- =============================================================================
SELECT
    a.first_name,
    COUNT(*) AS total_actores
FROM actor AS a
GROUP BY a.first_name
ORDER BY total_actores DESC, a.first_name
LIMIT 1;

-- =============================================================================
-- 42. Todos los alquileres y nombres de los clientes que los realizaron.
-- =============================================================================
SELECT
    r.rental_id,
    r.rental_date,
    c.customer_id,
    c.first_name,
    c.last_name
FROM rental AS r
INNER JOIN customer AS c
    ON r.customer_id = c.customer_id
ORDER BY r.rental_date, r.rental_id;

-- =============================================================================
-- 43. Todos los clientes y sus alquileres si existen.
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
ORDER BY c.last_name, c.first_name, r.rental_date;

-- =============================================================================
-- 44. CROSS JOIN entre film y category. ¿Aporta valor? Respuesta incluida.
-- =============================================================================
SELECT
    f.title,
    c.name AS categoria
FROM film AS f
CROSS JOIN category AS c
ORDER BY f.title, c.name;

/*
Respuesta 44:
Esta consulta no aporta valor analítico directo para responder preguntas de negocio,
porque combina cada película con todas las categorías posibles, aunque esas relaciones
no existan realmente. El resultado es un producto cartesiano. En esta BBDD la relación
real entre películas y categorías debe consultarse mediante film_category. El CROSS JOIN
solo sería útil para generar todas las combinaciones teóricas posibles o para detectar
combinaciones faltantes, pero no para representar la categorización real de las películas.
*/

-- =============================================================================
-- 45. Actores que han participado en películas de la categoría 'Action'.
-- =============================================================================
SELECT DISTINCT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc
    ON fa.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 46. Actores que no han participado en películas.
-- =============================================================================
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 47. Nombre de actores y cantidad de películas en las que han participado.
-- =============================================================================
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY cantidad_peliculas DESC, actor;

-- =============================================================================
-- 48. Crea una vista actor_num_peliculas.
-- =============================================================================
DROP VIEW IF EXISTS actor_num_peliculas;

CREATE VIEW actor_num_peliculas AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(fa.film_id) AS numero_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Comprobación de la vista creada:
SELECT
    actor_id,
    actor,
    numero_peliculas
FROM actor_num_peliculas
ORDER BY numero_peliculas DESC, actor;

-- =============================================================================
-- 49. Número total de alquileres realizados por cada cliente.
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC, c.last_name, c.first_name;

-- =============================================================================
-- 50. Duración total de películas en la categoría 'Action'.
-- =============================================================================
SELECT
    c.name AS categoria,
    SUM(f.length) AS duracion_total_minutos
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Action'
GROUP BY c.name;

-- =============================================================================
-- 51. Tabla temporal cliente_rentas_temporal con total de alquileres por cliente.
-- =============================================================================
DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT
    customer_id,
    first_name,
    last_name,
    total_alquileres
FROM cliente_rentas_temporal
ORDER BY total_alquileres DESC, last_name, first_name;

-- =============================================================================
-- 52. Tabla temporal peliculas_alquiladas con películas alquiladas al menos 10 veces.
-- =============================================================================
DROP TABLE IF EXISTS peliculas_alquiladas;

CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS total_alquileres
FROM film AS f
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

SELECT
    film_id,
    title,
    total_alquileres
FROM peliculas_alquiladas
ORDER BY total_alquileres DESC, title;

-- =============================================================================
-- 53. Películas alquiladas por Tammy Sanders y no devueltas.
-- =============================================================================
SELECT DISTINCT
    f.title
FROM customer AS c
INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
    ON i.film_id = f.film_id
WHERE c.first_name = 'Tammy'
  AND c.last_name = 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;

-- =============================================================================
-- 54. Actores en al menos una película de categoría 'Sci-Fi'.
-- =============================================================================
SELECT DISTINCT
    a.first_name,
    a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc
    ON fa.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 55. Actores en películas alquiladas después del primer alquiler de 'Spartacus Cheaper'.
-- =============================================================================
SELECT DISTINCT
    a.first_name,
    a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film AS f
    ON fa.film_id = f.film_id
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM film AS f2
    INNER JOIN inventory AS i2
        ON f2.film_id = i2.film_id
    INNER JOIN rental AS r2
        ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 56. Actores que no han actuado en ninguna película de categoría 'Music'.
-- =============================================================================
SELECT
    a.first_name,
    a.last_name
FROM actor AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor AS fa
    INNER JOIN film_category AS fc
        ON fa.film_id = fc.film_id
    INNER JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE fa.actor_id = a.actor_id
      AND c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

-- =============================================================================
-- 57. Título de películas alquiladas por más de 8 días.
-- =============================================================================
SELECT DISTINCT
    f.title
FROM film AS f
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
  AND (r.return_date - r.rental_date) > INTERVAL '8 days'
ORDER BY f.title;

-- =============================================================================
-- 58. Películas que son de la misma categoría que 'Animation'.
-- =============================================================================
-- Se resuelve mediante subconsulta para ajustarse literalmente al enunciado:
-- primero se localiza el category_id de 'Animation' y después se recuperan las
-- películas asociadas a esa misma categoría.
SELECT
    f.title,
    c.name AS categoria
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE fc.category_id IN (
    SELECT category_id
    FROM category
    WHERE name = 'Animation'
)
ORDER BY f.title;

-- =============================================================================
-- 59. Películas con la misma duración que 'Dancing Fever'.
-- =============================================================================
SELECT
    f.title,
    f.length
FROM film AS f
WHERE f.length = (
    SELECT length
    FROM film
    WHERE title = 'Dancing Fever'
)
  AND f.title <> 'Dancing Fever'
ORDER BY f.title;

-- =============================================================================
-- 60. Clientes que han alquilado al menos 7 películas distintas.
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT i.film_id) AS peliculas_distintas_alquiladas
FROM customer AS c
INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;

-- =============================================================================
-- 61. Cantidad total de películas alquiladas por categoría.
-- =============================================================================
SELECT
    c.name AS categoria,
    COUNT(r.rental_id) AS recuento_alquileres
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY recuento_alquileres DESC, c.name;

-- =============================================================================
-- 62. Número de películas por categoría estrenadas en 2006.
-- =============================================================================
SELECT
    c.name AS categoria,
    COUNT(f.film_id) AS numero_peliculas_2006
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY numero_peliculas_2006 DESC, c.name;

-- =============================================================================
-- 63. Todas las combinaciones posibles de trabajadores con tiendas.
-- =============================================================================
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    st.store_id
FROM staff AS s
CROSS JOIN store AS st
ORDER BY s.staff_id, st.store_id;

-- =============================================================================
-- 64. Total de películas alquiladas por cada cliente.
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY cantidad_peliculas_alquiladas DESC, c.last_name, c.first_name;

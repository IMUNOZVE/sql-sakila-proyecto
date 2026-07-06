# Revisión final del proyecto SQL

Esta versión final está preparada para entregar el DataProject de SQL sobre la base de datos Sakila.

## Comprobaciones aplicadas

- Las 64 consultas están numeradas siguiendo el enunciado oficial.
- Se mantiene una estructura clara por bloques y con comentarios antes de cada ejercicio.
- Se utilizan alias legibles para tablas y columnas.
- Se evita `SELECT *` salvo que fuera estrictamente exploratorio; en esta entrega se especifican columnas.
- Se incluyen consultas con `WHERE`, `JOIN`, `LEFT JOIN`, `FULL OUTER JOIN`, `CROSS JOIN`, agregaciones, `GROUP BY`, `HAVING`, subconsultas, vistas y tablas temporales.
- La consulta 44 incluye respuesta razonada sobre el valor analítico del `CROSS JOIN`.
- La consulta 4 se ha ajustado para contemplar que `original_language_id` puede venir vacío en Sakila.
- La consulta 58 se ha reformulado con subconsulta para ajustarse mejor al enunciado.

## Recomendación de ejecución

Ejecutar el archivo `sql/01_consultas_resueltas_sakila_FINAL.sql` en DBeaver, consulta por consulta, después de importar `bbdd/BBDD_Proyecto_shakila_sinuser.sql`.

Si alguna consulta devuelve 0 filas, no implica necesariamente error: algunas preguntas dependen de si existen registros concretos en la base de datos importada.

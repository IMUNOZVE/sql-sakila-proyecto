# Instrucciones de ejecución en DBeaver

## 1. Importar la base de datos

1. Abre DBeaver.
2. Conéctate a PostgreSQL.
3. Crea una base de datos nueva o utiliza una base existente para el proyecto.
4. Abre el archivo:

```text
bbdd/BBDD_Proyecto_shakila_sinuser.sql
```

5. Ejecuta el script completo para crear las tablas, claves, secuencias y datos de Sakila.

## 2. Verificar que la BBDD está cargada

Comprueba que aparecen tablas como:

- `actor`
- `film`
- `film_actor`
- `category`
- `film_category`
- `customer`
- `inventory`
- `rental`
- `payment`
- `staff`
- `store`

## 3. Ejecutar las consultas del proyecto

Abre el archivo:

```text
sql/01_consultas_resueltas_sakila_FINAL.sql
```

Ejecuta las consultas una a una, siguiendo la numeración del enunciado.

## 4. Consultas especiales

Hay tres consultas que crean objetos:

- Consulta 48: crea la vista `actor_num_peliculas`.
- Consulta 51: crea la tabla temporal `cliente_rentas_temporal`.
- Consulta 52: crea la tabla temporal `peliculas_alquiladas`.

Estas consultas incluyen `DROP VIEW IF EXISTS` o `DROP TABLE IF EXISTS` para poder ejecutarse de nuevo sin error.

## 5. Entrega recomendada

Subir a GitHub la carpeta completa del proyecto con esta estructura:

```text
proyecto_sql_sakila_10/
├── README.md
├── sql/
├── bbdd/
└── docs/
```

En la plataforma del curso, pegar el enlace público del repositorio de GitHub.

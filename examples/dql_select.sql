
-- 1. Cliente con más alquileres en los últimos 6 meses
SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(*) AS total_alquileres
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.id_cliente
ORDER BY total_alquileres DESC
LIMIT 1;

-- 2. Cinco películas más alquiladas durante el último año
SELECT p.id_pelicula, p.titulo, COUNT(*) AS veces_alquilada
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.id_pelicula
ORDER BY veces_alquilada DESC
LIMIT 5;

-- 3. Total de ingresos y cantidad de alquileres por categoría
SELECT cat.nombre AS categoria, COUNT(*) AS total_alquileres, SUM(p.total) AS ingresos_totales
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
JOIN pago p ON p.id_alquiler = a.id_alquiler
GROUP BY cat.nombre;

-- 4. Total de clientes que han alquilado por idioma en un mes específico (ejemplo: junio 2025)
SELECT i.id_idioma, COUNT(DISTINCT a.id_cliente) AS total_clientes
FROM alquiler a
JOIN inventario inv ON a.id_inventario = inv.id_inventario
JOIN pelicula p ON inv.id_pelicula = p.id_pelicula
JOIN idioma i ON p.id_idioma = i.id_idioma
WHERE MONTH(a.fecha_alquiler) = 6 AND YEAR(a.fecha_alquiler) = 2025
GROUP BY i.id_idioma;

-- 5. Clientes que han alquilado todas las películas de una misma categoría
SELECT c.id_cliente, c.nombre, c.apellidos, cat.nombre AS categoria
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
GROUP BY c.id_cliente, cat.id_categoria
HAVING COUNT(DISTINCT p.id_pelicula) = (
    SELECT COUNT(*) FROM pelicula_categoria WHERE id_categoria = cat.id_categoria
);

-- 6. Tres ciudades con más clientes activos en el último trimestre
SELECT ci.nombre AS ciudad, COUNT(DISTINCT c.id_cliente) AS clientes_activos
FROM cliente c
JOIN direccion d ON c.id_direccion = d.id_direccion
JOIN ciudad ci ON d.id_ciudad = ci.id_ciudad
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY ci.nombre
ORDER BY clientes_activos DESC
LIMIT 3;

-- 7. Cinco categorías con menos alquileres en el último año
SELECT cat.nombre AS categoria, COUNT(*) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY cat.id_categoria
ORDER BY total_alquileres ASC
LIMIT 5;

-- 8. Promedio de días que tarda un cliente en devolver las películas
SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS promedio_dias_devolucion
FROM alquiler a
WHERE a.fecha_devolucion IS NOT NULL;

-- 9. Cinco empleados con más alquileres en la categoría Acción
SELECT e.id_empleado, e.nombre, e.apellidos, COUNT(*) AS total
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
JOIN empleado e ON a.id_empleado = e.id_empleado
WHERE cat.nombre = 'Acción'
GROUP BY e.id_empleado
ORDER BY total DESC
LIMIT 5;

-- 10. Informe de clientes con alquileres más recurrentes
SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(*) AS total_alquileres
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente
ORDER BY total_alquileres DESC;

-- 11. Costo promedio de alquiler por idioma
SELECT idi.id_idioma, idi.nombre AS idioma, AVG(p.rental_rate) AS costo_promedio
FROM pelicula p
JOIN idioma idi ON p.id_idioma = idi.id_idioma
GROUP BY idi.id_idioma;

-- 12. Cinco películas con mayor duración alquiladas en el último año
SELECT DISTINCT p.id_pelicula, p.titulo, p.duracion
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.duracion DESC
LIMIT 5;

-- 13. Clientes que más alquilaron películas de Comedia
SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(*) AS total
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Comedia'
GROUP BY c.id_cliente
ORDER BY total DESC
LIMIT 5;

-- 14. Días totales alquilados por cliente en el último mes
SELECT c.id_cliente, c.nombre, c.apellidos, SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS dias_alquilados
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND a.fecha_devolucion IS NOT NULL
GROUP BY c.id_cliente;

-- 15. Alquileres diarios por almacén en el último trimestre
SELECT a.id_almacen, DATE(alq.fecha_alquiler) AS fecha, COUNT(*) AS total_alquileres
FROM alquiler alq
JOIN inventario i ON alq.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE alq.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.id_almacen, fecha
ORDER BY a.id_almacen, fecha;

-- 16. Ingresos totales por almacén en el último semestre
SELECT a.id_almacen, SUM(p.total) AS ingresos_totales
FROM pago p
JOIN alquiler alq ON p.id_alquiler = alq.id_alquiler
JOIN inventario i ON alq.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE alq.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY a.id_almacen;

-- 17. Cliente con el alquiler más caro en el último año
SELECT c.id_cliente, c.nombre, c.apellidos, p.total AS monto
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.total DESC
LIMIT 1;

-- 18. Cinco categorías con más ingresos en los últimos tres meses
SELECT cat.nombre AS categoria, SUM(p.total) AS ingresos
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula pel ON i.id_pelicula = pel.id_pelicula
JOIN pelicula_categoria pc ON pel.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY cat.id_categoria
ORDER BY ingresos DESC
LIMIT 5;

-- 19. Cantidad de películas alquiladas por idioma en el último mes
SELECT idi.nombre AS idioma, COUNT(*) AS total
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN idioma idi ON p.id_idioma = idi.id_idioma
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY idi.id_idioma;

-- 20. Clientes sin alquileres en el último año
SELECT c.id_cliente, c.nombre, c.apellidos
FROM cliente c
LEFT JOIN alquiler a ON c.id_cliente = a.id_cliente
  AND a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE a.id_alquiler IS NULL;

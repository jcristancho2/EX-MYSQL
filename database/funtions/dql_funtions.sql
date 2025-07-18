-- 1. TotalIngresosCliente(ClienteID, Año)
DELIMITER //
CREATE FUNCTION TotalIngresosCliente(clienteID INT, anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT IFNULL(SUM(total), 0)
  INTO total
  FROM pago
  WHERE id_cliente = clienteID AND YEAR(fecha_pago) = anio;
  RETURN total;
END;//
DELIMITER ;

-- 2. PromedioDuracionAlquiler(PeliculaID)
DELIMITER //
CREATE FUNCTION PromedioDuracionAlquiler(peliculaID INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE promedio DECIMAL(5,2);
  SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler))
  INTO promedio
  FROM alquiler a
  JOIN inventario i ON a.id_inventario = i.id_inventario
  WHERE i.id_pelicula = peliculaID;
  RETURN promedio;
END;//
DELIMITER ;

-- 3. IngresosPorCategoria(CategoriaID)
DELIMITER //
CREATE FUNCTION IngresosPorCategoria(categoriaID TINYINT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT IFNULL(SUM(p.total), 0)
  INTO total
  FROM pago p
  JOIN alquiler a ON p.id_alquiler = a.id_alquiler
  JOIN inventario i ON a.id_inventario = i.id_inventario
  JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
  WHERE pc.id_categoria = categoriaID;
  RETURN total;
END;//
DELIMITER ;

-- 4. DescuentoFrecuenciaCliente(ClienteID)
DELIMITER //
CREATE FUNCTION DescuentoFrecuenciaCliente(clienteID INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
BEGIN
  DECLARE cantidad INT;
  DECLARE descuento DECIMAL(4,2);
  SELECT COUNT(*) INTO cantidad FROM alquiler WHERE id_cliente = clienteID;
  IF cantidad >= 50 THEN
    SET descuento = 0.20;
  ELSEIF cantidad >= 20 THEN
    SET descuento = 0.10;
  ELSE
    SET descuento = 0.00;
  END IF;
  RETURN descuento;
END;//
DELIMITER ;

-- 5. EsClienteVIP(ClienteID)
DELIMITER //
CREATE FUNCTION EsClienteVIP(clienteID INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE total_ingresos DECIMAL(10,2);
  DECLARE total_alquileres INT;
  SELECT SUM(total) INTO total_ingresos FROM pago WHERE id_cliente = clienteID;
  SELECT COUNT(*) INTO total_alquileres FROM alquiler WHERE id_cliente = clienteID;
  RETURN (total_ingresos > 500 AND total_alquileres > 40);
END;//
DELIMITER ;

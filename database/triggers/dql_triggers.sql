-- 1. ActualizarTotalAlquileresEmpleado
DELIMITER //
CREATE TRIGGER trg_actualizar_total_alquileres_empleado
AFTER INSERT ON alquiler
FOR EACH ROW
BEGIN
  INSERT INTO empleado_estadisticas (id_empleado, total_alquileres)
  VALUES (NEW.id_empleado, 1)
  ON DUPLICATE KEY UPDATE total_alquileres = total_alquileres + 1;
END;//
DELIMITER ;

-- 2. AuditarActualizacionCliente
DELIMITER //
CREATE TRIGGER trg_auditar_actualizacion_cliente
BEFORE UPDATE ON cliente
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_cliente (id_cliente, nombre_viejo, apellidos_viejo, email_viejo, fecha)
  VALUES (OLD.id_cliente, OLD.nombre, OLD.apellidos, OLD.email, NOW());
END;//
DELIMITER ;

-- 3. RegistrarHistorialDeCosto
DELIMITER //
CREATE TRIGGER trg_registrar_historial_costo
BEFORE UPDATE ON pelicula
FOR EACH ROW
BEGIN
  IF OLD.rental_rate <> NEW.rental_rate THEN
    INSERT INTO historial_costos (id_pelicula, costo_anterior, costo_nuevo, fecha)
    VALUES (OLD.id_pelicula, OLD.rental_rate, NEW.rental_rate, NOW());
  END IF;
END;//
DELIMITER ;

-- 4. NotificarEliminacionAlquiler
DELIMITER //
CREATE TRIGGER trg_notificar_eliminacion_alquiler
BEFORE DELETE ON alquiler
FOR EACH ROW
BEGIN
  INSERT INTO notificaciones (id_alquiler, mensaje, fecha)
  VALUES (OLD.id_alquiler, CONCAT('Alquiler eliminado por el cliente ', OLD.id_cliente), NOW());
END;//
DELIMITER ;

-- 5. RestringirAlquilerConSaldoPendiente 
DELIMITER //
CREATE TRIGGER trg_restringir_alquiler_saldo
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
  DECLARE saldo DECIMAL(5,2);
  SELECT saldo INTO saldo FROM saldo_cliente WHERE id_cliente = NEW.id_cliente;
  IF saldo > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente tiene saldo pendiente y no puede alquilar';
  END IF;
END;//
DELIMITER ;
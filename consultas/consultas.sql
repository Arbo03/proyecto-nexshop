-- ============================================================
--  NexShop Group S.A. — consultas.sql
--  14 consultas comentadas sobre la base de datos
-- ============================================================

USE nexshop;

-- 1. Mostrar todos los empleados registrados en el sistema
SELECT * FROM Empleado;

-- 2. Mostrar solo el nombre, email corporativo y fecha de incorporación de los empleados
SELECT nombre, email_corporativo, fecha_incorporacion FROM Empleado;

-- 3. Mostrar solo los pedidos online que están en estado 'pendiente'
SELECT * FROM Pedido_Online
WHERE estado = 'pendiente';

-- 4. Buscar productos cuyo nombre contenga la palabra 'portátil' (insensible a mayúsculas)
SELECT * FROM Producto
WHERE nombre LIKE '%ortátil%';

-- 5. Mostrar clientes registrados (no anónimos) cuyo nombre empiece por 'A'
SELECT * FROM Cliente
WHERE es_anonimo = 0 AND nombre LIKE 'A%';

-- 6. Mostrar pedidos online realizados entre el 1 de enero y el 28 de febrero de 2025
SELECT * FROM Pedido_Online
WHERE fecha BETWEEN '2025-01-01' AND '2025-02-28 23:59:59';

-- 7. Mostrar productos cuyo precio de venta al público esté entre 100 y 1000 euros
SELECT id_producto, nombre, pvp_actual FROM Producto
WHERE pvp_actual BETWEEN 100 AND 1000;

-- 8. Mostrar líneas de pedido online con cantidad superior a 1 unidad
SELECT * FROM Linea_Pedido_Online
WHERE cantidad > 1;

-- 9. Mostrar todos los pedidos online ordenados por fecha, del más antiguo al más reciente
SELECT * FROM Pedido_Online
ORDER BY fecha ASC;

-- 10. Mostrar todos los productos ordenados por precio de mayor a menor
SELECT id_producto, nombre, pvp_actual FROM Producto
ORDER BY pvp_actual DESC;

-- 11. Mostrar todos los clientes registrados ordenados alfabéticamente por nombre
SELECT * FROM Cliente
WHERE es_anonimo = 0
ORDER BY nombre ASC;

-- 12. Actualizar el estado del pedido número 4 a 'confirmado' (ha sido confirmado por el sistema)
UPDATE Pedido_Online
SET estado = 'confirmado'
WHERE id_pedido = 4;

-- 13. Actualizar el email del cliente con id 3 porque ha cambiado su dirección de correo
UPDATE Cliente
SET email = 'ana.martinez.nuevo@email.com'
WHERE id_cliente = 3;

-- 14. Mostrar el nombre del cliente junto con sus pedidos online (JOIN entre Cliente y Pedido_Online)
SELECT
    c.id_cliente,
    c.nombre,
    c.apellidos,
    p.id_pedido,
    p.fecha,
    p.estado
FROM Cliente c
JOIN Pedido_Online p ON c.id_cliente = p.id_cliente
ORDER BY c.nombre, p.fecha;

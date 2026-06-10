-- ============================================================
--  NexShop Group S.A. — datos.sql
--  Datos de prueba realistas para todas las tablas
-- ============================================================

USE nexshop;

-- SEDES
INSERT INTO Sede VALUES (1,'Almacén Central Valencia','Valencia','almacen_central');
INSERT INTO Sede VALUES (2,'Tienda Valencia','Valencia','tienda');
INSERT INTO Sede VALUES (3,'Tienda Madrid','Madrid','tienda');
INSERT INTO Sede VALUES (4,'Tienda Barcelona','Barcelona','tienda');

-- EMPLEADOS
INSERT INTO Empleado VALUES (1,'Laura Pons','12345678A','l.pons@nexshop.es','2019-03-01',1);
INSERT INTO Empleado VALUES (2,'David Cano','23456789B','d.cano@nexshop.es','2018-06-15',1);
INSERT INTO Empleado VALUES (3,'Ana Ferrer','34567890C','a.ferrer@nexshop.es','2015-09-01',1);
INSERT INTO Empleado VALUES (4,'Carlos Vidal','45678901D','c.vidal@nexshop.es','2020-01-10',2);
INSERT INTO Empleado VALUES (5,'Marta Gil','56789012E','m.gil@nexshop.es','2021-05-20',3);
INSERT INTO Empleado VALUES (6,'Sergio Blanco','67890123F','s.blanco@nexshop.es','2017-11-01',1);
INSERT INTO Empleado VALUES (7,'Rosa Camps','78901234G','r.camps@nexshop.es','2022-02-14',4);

-- CATEGORÍAS (padre → hijo)
INSERT INTO Categoria VALUES (1,'Informática',NULL);
INSERT INTO Categoria VALUES (2,'Portátiles',1);
INSERT INTO Categoria VALUES (3,'Portátiles Gaming',2);
INSERT INTO Categoria VALUES (4,'Portátiles Oficina',2);
INSERT INTO Categoria VALUES (5,'Portátiles Ultraligeros',2);
INSERT INTO Categoria VALUES (6,'Periféricos',1);
INSERT INTO Categoria VALUES (7,'Ratones',6);
INSERT INTO Categoria VALUES (8,'Teclados',6);
INSERT INTO Categoria VALUES (9,'Electrónica',NULL);
INSERT INTO Categoria VALUES (10,'Smartphones',9);

-- PRODUCTOS
INSERT INTO Producto VALUES (1,'ASUS ROG Strix G15 RTX 4060','Portátil gaming 15.6" 144Hz',1299.99,3,1);
INSERT INTO Producto VALUES (2,'Lenovo ThinkPad X1 Carbon','Portátil ultraligero empresarial',1599.00,5,1);
INSERT INTO Producto VALUES (3,'HP EliteBook 840','Portátil oficina 14" i7',999.00,4,1);
INSERT INTO Producto VALUES (4,'Logitech MX Master 3S','Ratón inalámbrico premium',99.99,7,1);
INSERT INTO Producto VALUES (5,'Keychron K2 Pro','Teclado mecánico compacto',129.00,8,1);
INSERT INTO Producto VALUES (6,'Samsung Galaxy S24','Smartphone 256GB',849.00,10,1);
INSERT INTO Producto VALUES (7,'Apple iPhone 15','Smartphone 128GB',999.00,10,1);

-- HISTORIAL PRECIOS
INSERT INTO Historial_Precio VALUES (1,1,1399.99,'2024-01-01','2024-06-30');
INSERT INTO Historial_Precio VALUES (2,1,1299.99,'2024-07-01',NULL);
INSERT INTO Historial_Precio VALUES (3,2,1699.00,'2024-01-01','2024-09-30');
INSERT INTO Historial_Precio VALUES (4,2,1599.00,'2024-10-01',NULL);

-- PROMOCIONES
INSERT INTO Promocion VALUES (1,'Black Friday 2024',20.00,'2024-11-29','2024-12-01');
INSERT INTO Promocion VALUES (2,'Rebajas Enero 2025',15.00,'2025-01-07','2025-01-31');
INSERT INTO Promocion VALUES (3,'Vuelta al Cole 2024',10.00,'2024-09-01','2024-09-30');

-- PRODUCTO_PROMOCION
INSERT INTO Producto_Promocion VALUES (1,1);
INSERT INTO Producto_Promocion VALUES (3,1);
INSERT INTO Producto_Promocion VALUES (1,2);
INSERT INTO Producto_Promocion VALUES (2,3);
INSERT INTO Producto_Promocion VALUES (3,3);

-- PROVEEDORES
INSERT INTO Proveedor VALUES (1,'TechDistrib SL','info@techdistrib.es','912345678',2);
INSERT INTO Proveedor VALUES (2,'Importex Europa','contacto@importex.eu','934567890',2);
INSERT INTO Proveedor VALUES (3,'GlobalTech Parts','sales@globaltech.com','910000001',6);

-- PRODUCTO_PROVEEDOR (con histórico)
INSERT INTO Producto_Proveedor VALUES (1,1,3,1050.00,7,'2024-01-01',NULL);
INSERT INTO Producto_Proveedor VALUES (2,1,2,980.00,10,'2024-01-01','2024-06-30');
INSERT INTO Producto_Proveedor VALUES (3,1,2,920.00,10,'2024-07-01',NULL);
INSERT INTO Producto_Proveedor VALUES (4,2,2,1300.00,14,'2024-01-01',NULL);
INSERT INTO Producto_Proveedor VALUES (5,4,3,45.00,5,'2024-01-01',NULL);

-- STOCK
INSERT INTO Stock VALUES (1,1,1,50),(2,1,2,10),(3,1,3,5),(4,1,4,3);
INSERT INTO Stock VALUES (5,2,1,80),(6,2,2,15),(7,2,3,8),(8,2,4,6);
INSERT INTO Stock VALUES (9,3,1,30),(10,3,2,12),(11,3,3,4),(12,3,4,9);
INSERT INTO Stock VALUES (13,4,1,200),(14,4,2,40),(15,4,3,25),(16,4,4,30);
INSERT INTO Stock VALUES (17,5,1,150),(18,5,2,35),(19,5,3,20),(20,5,4,22);
INSERT INTO Stock VALUES (21,6,1,60),(22,6,2,18),(23,6,3,12),(24,6,4,15);
INSERT INTO Stock VALUES (25,7,1,40),(26,7,2,10),(27,7,3,8),(28,7,4,11);

-- TRANSFERENCIAS STOCK
INSERT INTO Transferencia_Stock VALUES (1,1,1,2,5,'2025-01-10',2);
INSERT INTO Transferencia_Stock VALUES (2,4,1,3,20,'2025-02-01',2);
INSERT INTO Transferencia_Stock VALUES (3,2,3,4,3,'2025-02-15',2);

-- CLIENTES REGISTRADOS
INSERT INTO Cliente VALUES (1,'María','López Sanz','maria.lopez@email.com','hash1','1990-05-12',NOW(),0,NULL);
INSERT INTO Cliente VALUES (2,'Jordi','Puig Roca','jordi.puig@email.com','hash2','1985-08-23',NOW(),0,NULL);
INSERT INTO Cliente VALUES (3,'Ana','Martínez Gil','ana.martinez@email.com','hash3','1995-11-30',NOW(),0,NULL);
INSERT INTO Cliente VALUES (4,'Luis','Fernández','luis.fernandez@email.com','hash4','1978-03-17',NOW(),0,NULL);
-- CLIENTE ANÓNIMO (compra en tienda)
INSERT INTO Cliente VALUES (5,NULL,NULL,NULL,NULL,NULL,NOW(),1,NULL);
INSERT INTO Cliente VALUES (6,NULL,NULL,NULL,NULL,NULL,NOW(),1,NULL);

-- DIRECCIONES
INSERT INTO Direccion_Cliente VALUES (1,1,'domicilio','Calle Mayor','15','3A','46001','Valencia','España');
INSERT INTO Direccion_Cliente VALUES (2,1,'trabajo','Av. Aragón','30',NULL,'46021','Valencia','España');
INSERT INTO Direccion_Cliente VALUES (3,2,'domicilio','Passeig de Gràcia','55','2B','08007','Barcelona','España');
INSERT INTO Direccion_Cliente VALUES (4,3,'domicilio','Gran Vía','100','5C','28013','Madrid','España');
INSERT INTO Direccion_Cliente VALUES (5,4,'domicilio','Calle Serrano','22','1A','28001','Madrid','España');

-- PEDIDOS ONLINE
INSERT INTO Pedido_Online VALUES (1,1,1,'2025-01-15 10:30:00','entregado',0);
INSERT INTO Pedido_Online VALUES (2,1,2,'2025-02-20 14:00:00','enviado',500);
INSERT INTO Pedido_Online VALUES (3,2,3,'2025-01-28 09:15:00','entregado',0);
INSERT INTO Pedido_Online VALUES (4,3,4,'2025-03-05 16:45:00','pendiente',0);
INSERT INTO Pedido_Online VALUES (5,4,5,'2025-03-10 11:00:00','confirmado',0);

-- LÍNEAS DE PEDIDO ONLINE
INSERT INTO Linea_Pedido_Online VALUES (1,1,1,1,1299.99,0);
INSERT INTO Linea_Pedido_Online VALUES (2,1,4,2,99.99,0);
INSERT INTO Linea_Pedido_Online VALUES (3,2,5,1,129.00,15.00);
INSERT INTO Linea_Pedido_Online VALUES (4,3,2,1,1599.00,0);
INSERT INTO Linea_Pedido_Online VALUES (5,3,6,1,849.00,0);
INSERT INTO Linea_Pedido_Online VALUES (6,4,7,1,999.00,0);
INSERT INTO Linea_Pedido_Online VALUES (7,5,3,1,999.00,20.00);

-- ENVÍOS
INSERT INTO Envio VALUES (1,1,'ES-TRK-001','SEUR','2025-01-18','2025-01-17','entregado',1);
INSERT INTO Envio VALUES (2,2,'ES-TRK-002','MRW','2025-02-25',NULL,'en_transito',1);
INSERT INTO Envio VALUES (3,3,'ES-TRK-003','Correos Express','2025-02-01','2025-01-31','entregado',1);
INSERT INTO Envio VALUES (4,4,'ES-TRK-004','GLS','2025-03-10',NULL,'preparando',3);

-- LÍNEAS DE ENVÍO
INSERT INTO Linea_Envio VALUES (1,1,1,1),(2,1,2,2);
INSERT INTO Linea_Envio VALUES (3,2,3,1);
INSERT INTO Linea_Envio VALUES (4,3,4,1),(5,3,5,1);
INSERT INTO Linea_Envio VALUES (6,4,6,1);

-- VENTAS PRESENCIALES
INSERT INTO Venta_Presencial VALUES (1,2,5,4,'2025-01-20 11:00:00');
INSERT INTO Venta_Presencial VALUES (2,3,6,5,'2025-02-10 17:30:00');
INSERT INTO Venta_Presencial VALUES (3,4,1,7,'2025-02-28 12:00:00');

-- LÍNEAS VENTA PRESENCIAL
INSERT INTO Linea_Venta_Presencial VALUES (1,1,4,3,99.99);
INSERT INTO Linea_Venta_Presencial VALUES (2,1,5,1,129.00);
INSERT INTO Linea_Venta_Presencial VALUES (3,2,6,1,849.00);
INSERT INTO Linea_Venta_Presencial VALUES (4,3,7,2,999.00);

-- DEVOLUCIONES PRESENCIALES
INSERT INTO Devolucion_Presencial VALUES (1,1,5,1,'2025-01-25','Producto defectuoso');

-- TICKETS DE INCIDENCIA
INSERT INTO Ticket_Incidencia VALUES (1,1,1,1,'Retraso en entrega','El pedido llegó 2 días tarde','2025-01-18 09:00:00','resuelto','2025-01-20 10:00:00','Se aplicó descuento en próximo pedido');
INSERT INTO Ticket_Incidencia VALUES (2,2,3,1,'Producto incorrecto','Me enviaron un modelo distinto al pedido','2025-02-02 08:30:00','en_gestion',NULL,NULL);
INSERT INTO Ticket_Incidencia VALUES (3,3,NULL,1,'Consulta sobre garantía',NULL,'2025-03-06 14:00:00','abierto',NULL,NULL);

-- VALORACIONES
INSERT INTO Valoracion VALUES (1,1,1,5,'Portátil excelente, muy buena relación calidad-precio','2025-01-25 10:00:00',1);
INSERT INTO Valoracion VALUES (2,1,4,4,'Ratón muy cómodo, la batería dura mucho','2025-01-25 10:05:00',1);
INSERT INTO Valoracion VALUES (3,2,2,5,'El ThinkPad es increíble para trabajar, muy ligero','2025-02-05 16:00:00',1);
INSERT INTO Valoracion VALUES (4,3,7,3,'Buen móvil pero caro para lo que ofrece','2025-03-08 09:00:00',1);

-- PUNTOS DE FIDELIZACIÓN
INSERT INTO Puntos_Fidelizacion VALUES (1,1,1,'ganado',14999,'2025-01-17 00:00:00','Pedido #1 — 1499.97€ × 10');
INSERT INTO Puntos_Fidelizacion VALUES (2,1,2,'ganado',1290,'2025-02-20 00:00:00','Pedido #2 — 129€ × 10');
INSERT INTO Puntos_Fidelizacion VALUES (3,1,2,'canjeado',500,'2025-02-20 00:00:00','Canje aplicado en pedido #2');
INSERT INTO Puntos_Fidelizacion VALUES (4,2,3,'ganado',24480,'2025-01-28 00:00:00','Pedido #3 — 2448€ × 10');
INSERT INTO Puntos_Fidelizacion VALUES (5,4,5,'ganado',9990,'2025-03-10 00:00:00','Pedido #5 — 999€ × 10');

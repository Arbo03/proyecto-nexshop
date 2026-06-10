-- ============================================================
--  NexShop Group S.A. — schema.sql
--  Creación de tablas, claves primarias, foráneas y restricciones
-- ============================================================

DROP DATABASE IF EXISTS nexshop;
CREATE DATABASE nexshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexshop;

-- ------------------------------------------------------------
-- SEDE (tiendas físicas + almacén central)
-- Lo pide el cliente: se mencionan 3 tiendas físicas y sede central
-- ------------------------------------------------------------
CREATE TABLE Sede (
    id_sede       INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    ciudad        VARCHAR(100) NOT NULL,
    tipo          VARCHAR(20)  NOT NULL CHECK (tipo IN ('tienda', 'almacen_central'))
);

-- ------------------------------------------------------------
-- EMPLEADO
-- Lo pide el cliente: nombre, DNI, email, fecha incorporación, sede
-- ------------------------------------------------------------
CREATE TABLE Empleado (
    id_empleado       INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    dni               VARCHAR(20)  NOT NULL UNIQUE,
    email_corporativo VARCHAR(100) NOT NULL UNIQUE,
    fecha_incorporacion DATE        NOT NULL,
    id_sede           INT          NOT NULL,
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

-- ------------------------------------------------------------
-- CLIENTE
-- Lo pide el cliente: clientes registrados online + anónimos en tienda
-- Se permite id_cliente_anonimo para vincular compras presenciales
-- ------------------------------------------------------------
CREATE TABLE Cliente (
    id_cliente        INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(100),
    apellidos         VARCHAR(100),
    email             VARCHAR(150) UNIQUE,
    contrasena_hash   VARCHAR(255),
    fecha_nacimiento  DATE,
    fecha_registro    DATETIME DEFAULT CURRENT_TIMESTAMP,
    es_anonimo        TINYINT(1) NOT NULL DEFAULT 0,  -- 1 = comprador en tienda sin cuenta
    id_cliente_vinculado INT NULL,                    -- para vincular histórico presencial a cuenta online
    FOREIGN KEY (id_cliente_vinculado) REFERENCES Cliente(id_cliente)
);

-- ------------------------------------------------------------
-- DIRECCION_CLIENTE
-- Lo pide el cliente: múltiples direcciones por cliente (domicilio, trabajo, otras)
-- ------------------------------------------------------------
CREATE TABLE Direccion_Cliente (
    id_direccion  INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT          NOT NULL,
    tipo          VARCHAR(50)  NOT NULL,  -- domicilio, trabajo, otra
    calle         VARCHAR(200) NOT NULL,
    numero        VARCHAR(10),
    piso          VARCHAR(20),
    codigo_postal VARCHAR(10)  NOT NULL,
    ciudad        VARCHAR(100) NOT NULL,
    pais          VARCHAR(100) NOT NULL DEFAULT 'España',
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- ------------------------------------------------------------
-- CATEGORIA
-- Lo pide el cliente: categorías y subcategorías (jerarquía con auto-referencia)
-- ------------------------------------------------------------
CREATE TABLE Categoria (
    id_categoria     INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    id_categoria_padre INT NULL,
    FOREIGN KEY (id_categoria_padre) REFERENCES Categoria(id_categoria)
);

-- ------------------------------------------------------------
-- PRODUCTO
-- Lo pide el cliente: más de 2000 referencias, pertenece a una subcategoría
-- ------------------------------------------------------------
CREATE TABLE Producto (
    id_producto   INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(200) NOT NULL,
    descripcion   TEXT,
    pvp_actual    DECIMAL(10,2) NOT NULL CHECK (pvp_actual >= 0),
    id_categoria  INT          NOT NULL,
    activo        TINYINT(1)   NOT NULL DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- ------------------------------------------------------------
-- HISTORIAL_PRECIO
-- Lo pide el cliente: el PVP puede variar con el tiempo, guardar histórico
-- ------------------------------------------------------------
CREATE TABLE Historial_Precio (
    id_historial  INT AUTO_INCREMENT PRIMARY KEY,
    id_producto   INT          NOT NULL,
    pvp           DECIMAL(10,2) NOT NULL,
    fecha_inicio  DATE          NOT NULL,
    fecha_fin     DATE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ------------------------------------------------------------
-- PROMOCION
-- Lo pide el cliente: descuento porcentual por producto y rango de fechas
-- ------------------------------------------------------------
CREATE TABLE Promocion (
    id_promocion    INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    descuento_pct   DECIMAL(5,2) NOT NULL CHECK (descuento_pct > 0 AND descuento_pct <= 100),
    fecha_inicio    DATE         NOT NULL,
    fecha_fin       DATE         NOT NULL
);

-- ------------------------------------------------------------
-- PRODUCTO_PROMOCION (N:M entre Producto y Promocion)
-- Lo pide el cliente: un producto puede tener varias promociones
-- ------------------------------------------------------------
CREATE TABLE Producto_Promocion (
    id_producto    INT NOT NULL,
    id_promocion   INT NOT NULL,
    PRIMARY KEY (id_producto, id_promocion),
    FOREIGN KEY (id_producto)  REFERENCES Producto(id_producto),
    FOREIGN KEY (id_promocion) REFERENCES Promocion(id_promocion)
);

-- ------------------------------------------------------------
-- PROVEEDOR
-- Lo pide el cliente: proveedores que suministran productos
-- ------------------------------------------------------------
CREATE TABLE Proveedor (
    id_proveedor    INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    email           VARCHAR(150),
    telefono        VARCHAR(30),
    id_empleado_rep INT,  -- representante comercial de NexShop
    FOREIGN KEY (id_empleado_rep) REFERENCES Empleado(id_empleado)
);

-- ------------------------------------------------------------
-- PRODUCTO_PROVEEDOR (N:M con histórico de condiciones pactadas)
-- Lo pide el cliente: precio de coste y plazo de entrega por combinación,
-- con histórico porque cambian periódicamente
-- ------------------------------------------------------------
CREATE TABLE Producto_Proveedor (
    id_pp           INT AUTO_INCREMENT PRIMARY KEY,
    id_producto     INT          NOT NULL,
    id_proveedor    INT          NOT NULL,
    precio_coste    DECIMAL(10,2) NOT NULL,
    plazo_entrega_dias INT        NOT NULL,
    fecha_inicio    DATE          NOT NULL,
    fecha_fin       DATE,
    FOREIGN KEY (id_producto)  REFERENCES Producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

-- ------------------------------------------------------------
-- STOCK (por ubicación: tienda o almacén central)
-- Lo pide el cliente: cada sede tiene su propio nivel de stock
-- ------------------------------------------------------------
CREATE TABLE Stock (
    id_stock      INT AUTO_INCREMENT PRIMARY KEY,
    id_producto   INT NOT NULL,
    id_sede       INT NOT NULL,
    cantidad      INT NOT NULL DEFAULT 0 CHECK (cantidad >= 0),
    UNIQUE (id_producto, id_sede),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_sede)     REFERENCES Sede(id_sede)
);

-- ------------------------------------------------------------
-- TRANSFERENCIA_STOCK
-- Lo pide el cliente: transferencias internas con fecha, origen, destino,
-- producto, cantidad y empleado autorizador
-- ------------------------------------------------------------
CREATE TABLE Transferencia_Stock (
    id_transferencia  INT AUTO_INCREMENT PRIMARY KEY,
    id_producto       INT  NOT NULL,
    id_sede_origen    INT  NOT NULL,
    id_sede_destino   INT  NOT NULL,
    cantidad          INT  NOT NULL CHECK (cantidad > 0),
    fecha             DATE NOT NULL,
    id_empleado_auth  INT  NOT NULL,
    FOREIGN KEY (id_producto)      REFERENCES Producto(id_producto),
    FOREIGN KEY (id_sede_origen)   REFERENCES Sede(id_sede),
    FOREIGN KEY (id_sede_destino)  REFERENCES Sede(id_sede),
    FOREIGN KEY (id_empleado_auth) REFERENCES Empleado(id_empleado)
);

-- ------------------------------------------------------------
-- PEDIDO_ONLINE
-- Lo pide el cliente: pedidos realizados en nexshop.es por clientes registrados
-- ------------------------------------------------------------
CREATE TABLE Pedido_Online (
    id_pedido     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT          NOT NULL,
    id_direccion  INT          NOT NULL,
    fecha         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado        VARCHAR(30)  NOT NULL CHECK (estado IN ('pendiente','confirmado','en_proceso','enviado','entregado','cancelado')),
    puntos_canjeados INT       NOT NULL DEFAULT 0,
    FOREIGN KEY (id_cliente)   REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_direccion) REFERENCES Direccion_Cliente(id_direccion)
);

-- ------------------------------------------------------------
-- LINEA_PEDIDO_ONLINE
-- Lo pide el cliente: productos y cantidades dentro de un pedido online
-- ------------------------------------------------------------
CREATE TABLE Linea_Pedido_Online (
    id_linea      INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido     INT          NOT NULL,
    id_producto   INT          NOT NULL,
    cantidad      INT          NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_pct   DECIMAL(5,2)  NOT NULL DEFAULT 0,
    FOREIGN KEY (id_pedido)   REFERENCES Pedido_Online(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ------------------------------------------------------------
-- ENVIO
-- Lo pide el cliente: un pedido puede generar varios envíos parciales
-- cada uno con número de seguimiento, transportista y fecha estimada
-- ------------------------------------------------------------
CREATE TABLE Envio (
    id_envio            INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido           INT          NOT NULL,
    numero_seguimiento  VARCHAR(100) NOT NULL UNIQUE,
    transportista       VARCHAR(100) NOT NULL,
    fecha_estimada      DATE,
    fecha_entrega_real  DATE,
    estado              VARCHAR(30)  NOT NULL CHECK (estado IN ('preparando','enviado','en_transito','entregado','recogida')),
    id_sede_origen      INT          NOT NULL,
    FOREIGN KEY (id_pedido)      REFERENCES Pedido_Online(id_pedido),
    FOREIGN KEY (id_sede_origen) REFERENCES Sede(id_sede)
);

-- ------------------------------------------------------------
-- LINEA_ENVIO (qué productos van en cada envío)
-- Lo propongo yo: necesario para saber qué líneas van en qué envío
-- ------------------------------------------------------------
CREATE TABLE Linea_Envio (
    id_linea_envio INT AUTO_INCREMENT PRIMARY KEY,
    id_envio       INT NOT NULL,
    id_linea       INT NOT NULL,
    cantidad       INT NOT NULL CHECK (cantidad > 0),
    FOREIGN KEY (id_envio) REFERENCES Envio(id_envio),
    FOREIGN KEY (id_linea) REFERENCES Linea_Pedido_Online(id_linea)
);

-- ------------------------------------------------------------
-- VENTA_PRESENCIAL
-- Lo pide el cliente: ventas en tienda física (sin proceso de pedido online)
-- ------------------------------------------------------------
CREATE TABLE Venta_Presencial (
    id_venta      INT AUTO_INCREMENT PRIMARY KEY,
    id_sede       INT       NOT NULL,
    id_cliente    INT,      -- NULL si cliente anónimo
    id_empleado   INT       NOT NULL,
    fecha         DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sede)     REFERENCES Sede(id_sede),
    FOREIGN KEY (id_cliente)  REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- ------------------------------------------------------------
-- LINEA_VENTA_PRESENCIAL
-- Lo pide el cliente: productos y cantidades dentro de una venta presencial
-- ------------------------------------------------------------
CREATE TABLE Linea_Venta_Presencial (
    id_linea      INT AUTO_INCREMENT PRIMARY KEY,
    id_venta      INT          NOT NULL,
    id_producto   INT          NOT NULL,
    cantidad      INT          NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta)    REFERENCES Venta_Presencial(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ------------------------------------------------------------
-- DEVOLUCION_PRESENCIAL
-- Lo pide el cliente: devoluciones en tienda vinculadas al ticket de venta
-- ------------------------------------------------------------
CREATE TABLE Devolucion_Presencial (
    id_devolucion INT AUTO_INCREMENT PRIMARY KEY,
    id_venta      INT  NOT NULL,
    id_producto   INT  NOT NULL,
    cantidad      INT  NOT NULL CHECK (cantidad > 0),
    fecha         DATE NOT NULL,
    motivo        TEXT,
    FOREIGN KEY (id_venta)    REFERENCES Venta_Presencial(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ------------------------------------------------------------
-- TICKET_INCIDENCIA
-- Lo pide el cliente: asunto, descripción, fecha apertura, estado, agente,
-- puede o no estar vinculado a un pedido
-- ------------------------------------------------------------
CREATE TABLE Ticket_Incidencia (
    id_ticket       INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT,
    id_pedido       INT,
    id_empleado_agente INT NOT NULL,
    asunto          VARCHAR(200) NOT NULL,
    descripcion     TEXT,
    fecha_apertura  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado          VARCHAR(20)  NOT NULL CHECK (estado IN ('abierto','en_gestion','resuelto')),
    fecha_cierre    DATETIME,
    nota_resolucion TEXT,
    FOREIGN KEY (id_cliente)        REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_pedido)         REFERENCES Pedido_Online(id_pedido),
    FOREIGN KEY (id_empleado_agente) REFERENCES Empleado(id_empleado)
);

-- ------------------------------------------------------------
-- VALORACION
-- Lo pide el cliente: puntuación 1-5 y comentario, una por producto por cliente,
-- con flag de compra verificada
-- ------------------------------------------------------------
CREATE TABLE Valoracion (
    id_valoracion   INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT  NOT NULL,
    id_producto     INT  NOT NULL,
    puntuacion      INT  NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario      TEXT,
    fecha           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verificada      TINYINT(1) NOT NULL DEFAULT 0,  -- 1 = compra confirmada
    UNIQUE (id_cliente, id_producto),
    FOREIGN KEY (id_cliente)  REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ------------------------------------------------------------
-- PUNTOS_FIDELIZACION
-- Lo pide el cliente: historial completo de movimientos de puntos
-- El saldo se calcula siempre desde el histórico (sin campo saldo_actual)
-- ------------------------------------------------------------
CREATE TABLE Puntos_Fidelizacion (
    id_movimiento   INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT          NOT NULL,
    id_pedido       INT,
    tipo            VARCHAR(10)  NOT NULL CHECK (tipo IN ('ganado','canjeado')),
    cantidad        INT          NOT NULL CHECK (cantidad > 0),
    fecha           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion     VARCHAR(200),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_pedido)  REFERENCES Pedido_Online(id_pedido)
);

 Create table clientes (
 idCliente serial primary key,
 nombre varchar(100),
 fecha_nacimiento date,
 correo varchar(100) unique
);
Create table mesas (
 idMesa serial primary key,
 capacidad int,
 disponibilidad boolean
);
Create table reservas (
 idReserva serial primary key,
 idCliente int references clientes(idCliente),
 idMesa int references mesas(idMesa),
 fecha date,
 hora time,
 num_comensales int
);
Create table platos (
 idPlato serial primary key,
 nombre varchar(100),
 descripcion varchar(200),
 precio decimal(10, 2),
 estado boolean
);
Create table pedidos (
 idPedido serial primary key,
 idCliente int references clientes(idCliente),
 fecha timestamp,
 total decimal(10, 2)
);
Create table detalle_pedidos (
 idDetalle serial primary key,
 idPedido int references pedidos(idPedido),
 idPlato int references platos(idPlato),
 cantidad int,
 precio_unitario decimal(10, 2),
 total decimal(10, 2) generated always as (cantidad * precio_unitario) stored,
 fecha timestamp,
 estado boolean
);
Create table usuarios (
 idUsuario serial primary key,
 nombre_usuario varchar(100) unique not null,
 contrasena varchar(255) not null,
 idCliente int references clientes(idCliente),
 rol varchar(50) check (rol in ('cliente', 'empleado', 'administrador')) not null
);
Create role cliente;
Create role empleado;
Create role administrador;

Grant select on platos to cliente;
Grant insert on reservas to cliente;
Grant insert on pedidos to cliente;

Create view v_reservas_empleado as
select * from reservas where idCliente = (select idCliente from clientes where nombre = current_user);
Create view v_pedidos_empleado as
select * from pedidos where idCliente = (select idCliente from clientes where nombre = current_user)

Grant select, update on v_reservas_empleado to empleado;
Grant select, update on v_pedidos_empleado to empleado;

Grant all privileges on database "asados_anita_db" to administrador;

CREATE OR REPLACE FUNCTION borrar_registros_inactivos()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM reservas WHERE disponibilidad = false;
    DELETE FROM pedidos WHERE disponibilidad = false;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_borrar_registros_inactivos_reservas
AFTER INSERT OR UPDATE ON reservas
FOR EACH STATEMENT
EXECUTE FUNCTION borrar_registros_inactivos();

CREATE TRIGGER trigger_borrar_registros_inactivos_pedidos
AFTER INSERT OR UPDATE ON pedidos
FOR EACH STATEMENT
EXECUTE FUNCTION borrar_registros_inactivos();

//visualizar tablas
SELECT * FROM clientes
ORDER BY idreserva ASC 

SELECT * FROM public.mesas
ORDER BY idmesa ASC

//borrar tablas
DELETE FROM clientes;
DELETE FROM detalle_pedidos;
DELETE FROM reservas;

//agregar columnas a tablas 
ALTER TABLE reservas ADD COLUMN disponibilidad boolean not null default true;
ALTER TABLE pedidos ADD COLUMN disponibilidad boolean not null default true;
ALTER TABLE clientes ADD COLUMN contraseña VARCHAR(100);

//insertar valores a tablas
INSERT INTO Clientes (nombre, fecha_nacimiento, correo) VALUES ('Pepito', '1990-01-01', 'pepito@gmail.com');

INSERT INTO reservas (idcliente, idmesa, fecha, hora, num_comensales) VALUES (1, 1, '2025-01-01', '14:30:00', 4);

INSERT INTO reservas (idcliente, idmesa, fecha, hora, num_comensales) VALUES (1, 1, '2025-01-01', '14:30:00', 4


INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (1, 3, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (2, 2, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (3, 3, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (4, 6, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (5, 12, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (6, 6, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (7, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (8, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (9, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (10, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (11, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (12, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (13, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (14, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (15, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (16, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (17, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (18, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (19, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (20, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (21, 4, true);
INSERT INTO mesas (idmesa, capacidad, disponibilidad)
VALUES (22, 4, true);

CREATE OR REPLACE FUNCTION actualizar_disponibilidad_mesa()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE mesas
    SET disponibilidad = false
    WHERE idMesa = NEW.idMesa;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_disponibilidad_mesa
AFTER INSERT ON reservas
FOR EACH ROW
EXECUTE FUNCTION actualizar_disponibilidad_mesa();

INSERT INTO platos (nombre, descripcion, precio, estado) VALUES 
('Patacones con Hogao', '6 patacones fritos acompañados con hogao', 10.000, true),
('Mini Empanadas 4 unid', '4 empanadas pequeñas fritas acampañadas conhogao.',  8.000, true),
('Platano Picado con queso', '5 troncos de platano asados con un bloque de queso en pincho.', 9.000, true),
('Bandeja Paisa', 'Frijoles, arroz, ensalada, platano, huevo, chicharrón, costilla, morcilla, chorizo, arepa, aguacate. acompañado con salsa chimichurri.', 25.000, true),
('Bandeja MiniPaisa', 'Frijoles, arroz, ensalada, platano, huevo, chorizo, chicharrón, arepa, aguacate. acompañado con salsachimichurri', 20.000, true),
('Sancocho de Pollo', 'Pollo acompañado con arroz, ensalada, banano, arepa, aguacate.', 20.000, true),
('Sancocho de Espinazo', 'Espinazo acompañado con arroz, ensalada, banano, arepa, aguacate.', 20.000, true),
('Mondongo', 'Mondongo acompañado con arroz, ensalada, banano, arepa, aguacate.', 20.000, true),
('Ajiaco', 'Ajiaco acompañado con arroz, ensalada, banano, arepa, aguacate.', 25.000, true),
('Cazuela de Frijol', 'Frijoles, arroz, ensalada, plátano, chicharrón, papa criolla, aguacate.', 25.000, true),
('Trucha', 'Patacón, arroz, ensalada, aguacate, trucha asada o frita, papa criolla', 32.000, true),
('Mojarra', 'Patacón, arroz, ensalada, aguacate, Mojarra asada o frita, papa criolla', 25.000, true),
('Tazas de Sancocho', 'Sancocho con revuelto.', 8.000, true),
('Lomo de Res', '300gr de carne, aguacate, arepa, limón, plátano asado', 22.000, true),
('Churrasco', '300gr de carne, aguacate, arepa, limón, plátano asado', 40.000, true),
('Punta de Anca', '300gr de carne, aguacate, arepa, limón, plátano asado', 50.000, true),
('Platano con Queso ', 'Platano abierto asado, mantequilla, queso, bocadillo', 8.000, true),
('Chorizo', 'Chorizo, arepa, limón, tomate, platanito, papa criolla.', 8.000, true),
('Morcilla', 'Morcilla, arepa, limón, tomate, platanito, papa criolla', 15.000, true),
('Costilla', 'Costilla, arepa, limón, tomate, platanito, papa criolla', 20.000, true),
('Chicharrón', 'Chicharrón, arepa, limón, tomate, platanito, papa criolla', 20.000, true),
('Chunchulla', 'Chunchulla, arepa, limón, tomate, platanito, papa criolla.', 20.000, true),
('Picada Personal', 'Costilla, chorizo, chicharrón, morcilla, arepa, limón, tomate, plátano, papa criolla.',  30.000, true),
('Picada Familiar', 'Costilla, chorizo, chicharrón, morcilla, arepa, limón, tomate, plátano, papa criolla.', 70.000, true),
('Cocacola', 'Original, zero, quatro, premio.',  5.000, true),
('Gaseosas Postobon', 'Colombiana, naranja, manzana, pepsi, uva.', 3.000, true),
('Soda', 'Bretaña, Glacial.', 5.000, true),
('Mr.tea', 'Amarillo, verde.', 5.000, true),
('Agua', 'Glacial', 3.000, true),
('Hit', 'Mango, mora, tropicales, naranja piña.',  4.000, true),
('Cerveza', 'Poker', 8.000, true),
('Aguapanela con Queso', 'Queso campesino.', 8.000, true),
('Chocolate con Queso', 'Queso campesino', 9.000, true),
('Café', 'Aguapanela con cafe instantaneo.', 2.000, true),
('Aguapanela', 'En taza.', 4.000, true),
('Chocolate', 'En taza.', 5.000, true),
('Milo', 'En taza.',  10.000, true),
('Aromática', 'Manzanilla, limoncillo', 2.000, true),
('Jugos Naturales', 'Mango, mora, guanabana, lulo, maracuya',  9.000, true),
('Limonada Natural', 'Limón, azucar', 7.000, true),
('Limonada de Coco', 'Limón, azucar, coco rallado', 10.000, true),
('Limonada Cerezada', 'Limón, azucar, cerezas', 9.000, true),
('Malteada Coco', '300 ml', 12.000, true),
('Malteada Cereza', '300 ml', 12.000, true),
('Malteada Mango Biche', '300 ml', 12.000, true),
('Malteada Piña Colada', '300 ml', 12.000, true),
('Malteada Hierbabuena', '300 ml', 12.000, true),
('Malteada Frutos Rojos', '300 ml', 12.000, true),
('Malteada Fresa', '300 ml', 10.000, true),
('Malteada Chocolate', '300 ml', 10.000, true),
('Malteada Vainilla', '300 ml', 10.000, true),
('Malteada Café', '300 ml', 10.000, true),
('Malteada Oreo', '300 ml', 10.000, true),
('Malteada Maracuya', '300 ml', 10.000, true),
('Jarra Jugos Naturales', '1250 ml.', 20.000, true),
('Jarra Panelada', '1250 ml.', 15.000, true),
('Jarra Limonada natural', '1250 ml.', 15.000, true),
('Jarra Limonada de coco', '1250 ml.', 20.000, true),
('Jarra Limonada cerezada', '1250 ml.', 18.000, true);



CREATE OR REPLACE FUNCTION insertar_detalle_pedidos()
RETURNS TRIGGER AS $$
BEGIN
    -- Aquí puedes insertar la lógica para llenar la tabla detalle_pedidos
    -- Por ejemplo, podrías insertar un detalle por cada plato en el pedido
    INSERT INTO detalle_pedidos (idPedido, idPlato, cantidad, precio_unitario, fecha, estado)
    VALUES (NEW.idPedido, NEW.idPlato, NEW.cantidad, NEW.precio_unitario, NEW.fecha, NEW.estado);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insertar_detalle_pedidos
AFTER INSERT ON pedidos
FOR EACH ROW
EXECUTE FUNCTION insertar_detalle_pedidos();
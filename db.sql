CREATE DATABASE IF NOT EXISTS sakilacampus;

USE sakilacampus;

--pais
CREATE TABLE pais (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP
);

--ciudad
CREATE TABLE ciudad (
    id_ciudad INT PRIMARY KEY,
    nombre VARCHAR(50),
    id_pais INT,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

--direccion
CREATE TABLE direccion (
    id_direccion INT PRIMARY KEY,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    id_ciudad INT,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

--idioma
CREATE TABLE idioma (
    id_idioma INT PRIMARY KEY,
    nombre VARCHAR(20),
    ultima_actualizacion TIMESTAMP
);

--empleado
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion INT,
    imagen BLOB,
    email VARCHAR(50),
    id_almacen INT,
    activo INT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);

--almacen
CREATE TABLE almacen (
    id_almacen INT PRIMARY KEY,
    id_empleado_jefe INT,
    id_direccion INT,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_empleado_jefe) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);

--cliente
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    id_almacen INT,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    email VARCHAR(50),
    id_direccion INT,
    activo INT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen),
    FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);

--pelicula
CREATE TABLE pelicula (
    id_pelicula INT PRIMARY KEY,
    titulo VARCHAR(255),
    descripcion TEXT,
    ano_lanzamiento YEAR,
    id_idioma INT,
    id_idioma_original INT,
    duracion_alquiler INT,
    rental_rate DECIMAL(4,2),
    duracion INT,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma),
    FOREIGN KEY (id_idioma_original) REFERENCES idioma(id_idioma)
);

--inventario
CREATE TABLE inventario (
    id_inventario MEDIUMINT PRIMARY KEY,
    id_pelicula INT,
    id_almacen INT,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen)
);

--alquiler
CREATE TABLE alquiler (
    id_alquiler INT PRIMARY KEY,
    fecha_alquiler DATETIME,
    id_inventario MEDIUMINT,
    id_cliente INT,
    fecha_devolucion DATETIME,
    id_empleado INT,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

--pago
CREATE TABLE pago (
    id_pago INT PRIMARY KEY,
    id_cliente INT,
    id_empleado INT,
    id_alquiler INT,
    total DECIMAL(5,2),
    fecha_pago DATETIME,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_alquiler) REFERENCES alquiler(id_alquiler)
);

--categoria
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(25),
    ultima_actualizacion TIMESTAMP
);

--pelicula_categoria
CREATE TABLE pelicula_categoria (
    id_pelicula INT,
    id_categoria INT,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_pelicula, id_categoria),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

--actor
CREATE TABLE actor (
    id_actor INT PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ultima_actualizacion TIMESTAMP
);

--pelicula_actor
CREATE TABLE pelicula_actor (
    id_actor INT,
    id_pelicula INT,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_actor, id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES actor(id_actor),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);

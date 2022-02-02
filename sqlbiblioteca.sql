-- crear database biblioteca
CREATE DATABASE biblioteca;

-- Accedo a la Base de Datos Bivlioteca
\c biblioteca;

---  Creación de Tablas

CREATE TABLE IF NOT EXISTS ciudades
(

    id serial,
    nombreciudad VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)

);
----poblando tabla ciudades
INSERT INTO ciudades (nombreciudad) VALUES ('SANTIAGO');

CREATE TABLE IF NOT EXISTS comunas
(

    id serial,
    nombrecomuna VARCHAR(255) NOT NULL,
    ciudad_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (ciudad_id) REFERENCES ciudades(id)

);
-- insert comuna de Santiago
--INSERT INTO comunas (nombrecomuna, ciudad_id) VALUES ('SANTIAGO', select id from ciudades where nombreciudad = 'SANTIAGO');
INSERT INTO comunas (nombrecomuna, ciudad_id) VALUES ('SANTIAGO', 1);


CREATE TABLE IF NOT EXISTS direcciones
(

    id serial,
    calle VARCHAR(255) NOT NULL,
    numero integer NOT NULL,
    comuna_id integer NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (comuna_id) REFERENCES comunas(id)

);

-- poblar tabla direcciones con datos entregados

INSERT INTO direcciones (calle, numero, comuna_id) values ('AVENIDA',1,1);
INSERT INTO direcciones (calle, numero, comuna_id) values ('PASAJE',2,1);
INSERT INTO direcciones (calle, numero, comuna_id) values ('AVENIDA',2,1);
INSERT INTO direcciones (calle, numero, comuna_id) values ('AVENIDA',3,1);
INSERT INTO direcciones (calle, numero, comuna_id) values ('PASAJE',3,1);

CREATE TABLE IF NOT EXISTS socios
(
    id integer NOT NULL,
    rut VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255),
    direccion_id integer NOT NULL,
    telefono VARCHAR(255),
    PRIMARY KEY (id),
    FOREIGN KEY (direccion_id) REFERENCES direcciones (id)
);

-- cargo datos de los socios tabla csv
\copy socios from socios.csv csv header;


CREATE TABLE IF NOT EXISTS libros
(
    isbn numeric NOT NULL,
    titulo VARCHAR(255),
    numpagina integer NOT NULL DEFAULT 0,
    diasprestamo integer NOT NULL DEFAULT 0,
    PRIMARY KEY (isbn)
);

-- cargo datos de los libros tabla csv
\copy libros from libros.csv csv header;


CREATE TABLE IF NOT EXISTS prestamos
(
    id integer NOT NULL,
    socio_id integer NOT NULL DEFAULT 0,
    libro_isbn numeric NOT NULL DEFAULT 0,
    fechainicio date NOT NULL DEFAULT now(),
    fechadevolucion date,
    PRIMARY KEY (id),
    FOREIGN KEY (socio_id) REFERENCES socios (id),
    FOREIGN KEY (libro_isbn) REFERENCES libros (isbn)
);

\copy PRESTAMOS from PRESTAMOS.csv csv header;


CREATE TABLE IF NOT EXISTS autores
(
    codigo integer NOT NULL,
    nombre  VARCHAR(255) NOT NULL,
    apellido  VARCHAR(255),
    fechanacimiento date NOT NULL,
    fechamuerte date,
    PRIMARY KEY (codigo)
);

-- poblo datos autores
INSERT INTO autores (codigo, nombre, apellido, fechanacimiento, fechamuerte) values (3,'JOSE','SALGADO', '01-01-1968', '01-01-2020');
INSERT INTO autores (codigo, nombre, apellido, fechanacimiento) values (4,'ANA','SALGADO','01-01-1972');
INSERT INTO autores (codigo, nombre, apellido, fechanacimiento) values (1,'ANDRÉS','ULLOA','01-01-1982');
INSERT INTO autores (codigo, nombre, apellido, fechanacimiento, fechamuerte) values (2,'SERGIO','MARDONES','01-01-1950','01-01-2012');
INSERT INTO autores (codigo, nombre, apellido, fechanacimiento) values (5,'MARTIN','PORTA','01-01-1976');


CREATE TABLE IF NOT EXISTS libros_autores
(
    libro_isbn numeric NOT NULL,
    autor_codigo integer NOT NULL,
    tipo_autor VARCHAR(255) NOT NULL DEFAULT 'PRINCIPAL',
    PRIMARY KEY (autor_codigo,libro_isbn),
    FOREIGN KEY (autor_codigo) REFERENCES autores (codigo),
    FOREIGN KEY (libro_isbn) REFERENCES libros (isbn)
);

\copy libros_autores from libros_autores.csv csv header;

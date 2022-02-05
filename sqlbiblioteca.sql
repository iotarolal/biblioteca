-- crear database biblioteca
CREATE DATABASE biblioteca;

-- Accedo a la Base de Datos Bivlioteca
\c biblioteca;

---  Creación de Tablas

begin transaction;

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
        id serial,
        rut VARCHAR(255) NOT NULL,
        nombre VARCHAR(255) NOT NULL,
        apellido VARCHAR(255),
        direccion_id integer NOT NULL,
        telefono VARCHAR(255),
        PRIMARY KEY (id),
        FOREIGN KEY (direccion_id) REFERENCES direcciones (id)
    );

    -- inserto registro socios
    INSERT INTO socios (rut, nombre, apellido, direccion_id, telefono ) values ('1111111-1','JUAN','SOTO',1,911111111);
    INSERT INTO socios (rut, nombre, apellido, direccion_id, telefono ) values ('2222222-2','ANA','PEREZ',2,922222222);
    INSERT INTO socios (rut, nombre, apellido, direccion_id, telefono ) values ('3333333-3','SANDRA','AGUILAR',3,933333333);
    INSERT INTO socios (rut, nombre, apellido, direccion_id, telefono ) values ('4444444-4','ESTEBAN','JEREZ',4,944444444);
    INSERT INTO socios (rut, nombre, apellido, direccion_id, telefono ) values ('5555555-5','SILVANA','MUÑOZ',5,955555555);


    -- cargo datos de los socios tabla csv
    --\copy socios from socios.csv csv header;


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
        id serial,
        socio_id integer NOT NULL DEFAULT 0,
        libro_isbn numeric NOT NULL DEFAULT 0,
        fechainicio date NOT NULL DEFAULT now(),
        fechadevolucion date,
        PRIMARY KEY (id),
        FOREIGN KEY (socio_id) REFERENCES socios (id),
        FOREIGN KEY (libro_isbn) REFERENCES libros (isbn)
    );

    -- inserto registro prestamos
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (1,1111111111111,'20-01-2020','27-01-2020');
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (5,2222222222222,'20-01-2020','30-01-2020');
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (3,3333333333333,'22-01-2020','30-01-2020');
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (4,4444444444444,'23-01-2020','30-01-2020');
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (2,1111111111111,'27-01-2020','04-02-2020');
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (1,4444444444444,'31-01-2020','12-02-2020');
    INSERT INTO prestamos (socio_id, libro_isbn, fechainicio, fechadevolucion) values (3,2222222222222,'31-01-2020','12-02-2020');


    CREATE TABLE IF NOT EXISTS autores
    (
        codigo integer NOT NULL,
        nombre  VARCHAR(255) NOT NULL,
        apellido  VARCHAR(255),
        fechanacimiento date NOT NULL,
        fechamuerte date,
        PRIMARY KEY (codigo)
    );

    -- inserto datos autores
    INSERT INTO autores (codigo, nombre, apellido, fechanacimiento, fechamuerte) values (3,'JOSE','SALGADO', '01-01-1968', '01-01-2020');
    INSERT INTO autores (codigo, nombre, apellido, fechanacimiento) values (4,'ANA','SALGADO','01-01-1972');
    INSERT INTO autores (codigo, nombre, apellido, fechanacimiento) values (1,'ANDRES','ULLOA','01-01-1982');
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

commit;
end transaction;

--3. Realizar las siguientes consultas:
--a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)

SELECT * FROM libros WHERE numpagina < 300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970.

SELECT * FROM autores WHERE fechanacimiento > '01-01-1970';

--c. ¿Cuál es el libro más solicitado? (0.5 puntos).

SELECT  libro_isbn, COUNT(libro_isbn) as cantidad_prestamo FROM prestamos  GROUP BY libro_isbn ORDER BY cantidad_prestamo DESC;


--d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
--debería pagar cada usuario que entregue el préstamo después de 7 días.

SELECT socios.nombre, socios.apellido, prestamos.libro_isbn, prestamos.socio_id, prestamos.fechainicio, prestamos.fechadevolucion, libros.diasprestamo,(((prestamos.fechadevolucion - prestamos.fechainicio) - libros.diasprestamo) * 100) AS montodeuda   FROM prestamos, libros, socios WHERE prestamos.libro_isbn = libros.isbn AND prestamos.socio_id = socios.id AND (((prestamos.fechadevolucion - prestamos.fechainicio) - libros.diasprestamo) * 100) >= 100;

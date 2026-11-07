SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL
);

CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL
);

CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    id_coleccion INT NOT NULL,
    titulo VARCHAR(120) NOT NULL,
    paginas INT NOT NULL,
    ejemplares_vendidos INT NOT NULL,
    anio INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

INSERT INTO colecciones (titulo, fecha_publicacion) VALUES 
('Colección Diamante', '2022-03-15'),
('Colección Zafiro', '2023-08-10');

INSERT INTO autores (nombre, pais, genero) VALUES 
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) VALUES 
(1, 1, 'Cielo de Enero', 210, 1500, 2024),
(1, 2, 'Marea Baja', 185, 800, 2023),
(1, 1, 'El Norte', 200, 2200, 2024),
(2, 2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 1, 'Máquinas', 215, 450, 2024),
(3, 2, 'Luz Artificial', 300, 1200, 2024),
(3, 1, 'Ruido Blanco', 280, 600, 2023),
(4, 2, 'El Barrio de Lila', 190, 5000, 2024),
(4, 1, 'Antes del Amanecer', 205, 2700, 2024),
(4, 2, 'La Calle 8', 175, 900, 2023),
(5, 1, 'Flor de Hierro', 195, 4100, 2024),
(5, 2, 'Hora Dorada', 220, 1800, 2022);

INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES 
(1, '2024-01-15', 150000.50),
(1, '2024-06-20', 85000.00),
(4, '2024-05-10', 320500.75);

SELECT nombre, genero 
FROM autores 
WHERE pais <> 'Chile' OR pais IS NULL 
ORDER BY nombre;

SELECT titulo, paginas 
FROM libros 
WHERE paginas BETWEEN 190 AND 220 
ORDER BY paginas ASC;

SELECT 
    COUNT(*) AS total_libros, 
    SUM(ejemplares_vendidos) AS suma_vendidos, 
    AVG(paginas) AS promedio_paginas, 
    MIN(anio) AS anio_mas_antiguo, 
    MAX(ejemplares_vendidos) AS max_vendidos 
FROM libros;

SELECT DISTINCT genero 
FROM autores 
ORDER BY genero ASC;

SELECT a.nombre, COUNT(l.id_libro) AS cantidad_libros 
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(l.id_libro) > 1
ORDER BY a.nombre;

SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE anio = 2024 AND ejemplares_vendidos > 2000 
ORDER BY ejemplares_vendidos DESC 
LIMIT 3;

INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) 
VALUES (3, 1, 'Papel Mojado', 260, 50, 2024);

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

DELETE FROM libros WHERE titulo = 'Papel Mojado';

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

SELECT * FROM libros WHERE titulo = 'Cielo de Enero';

UPDATE libros 
SET ejemplares_vendidos = ejemplares_vendidos + 100 
WHERE titulo = 'Cielo de Enero';

SELECT * FROM libros WHERE titulo = 'Cielo de Enero';

SELECT l.titulo AS titulo_libro, c.titulo AS titulo_coleccion, c.fecha_publicacion 
FROM libros l
JOIN colecciones c ON l.id_coleccion = c.id_coleccion;

SELECT a.nombre, p.fecha_pago, p.monto 
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor;

SELECT a.nombre, SUM(p.monto) AS total_pagado 
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre;
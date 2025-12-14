DROP DATABASE IF EXISTS spotify;
CREATE DATABASE spotify;
USE spotify;

-- CREACIÓN DE TABLAS
-- Tabla artista. Almacena el ID autonumérico, nombre, genero principal, nacionalidad y biografía
CREATE TABLE artistas (
    id_artista INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(50) NOT NULL, 
    genero_principal VARCHAR(50) NOT NULL, 
    nacionalidad VARCHAR(50), 
    biografia TEXT
);

-- Tabla cancion. Almacena el ID autonumérico, titulo, duracion, reproducciones y el género.
-- Además, al tratarse de una relación 1:N, la canción almacena el ID del artista autor.
-- En este modelo la cancion solo puede ser creada por un artista principal
CREATE TABLE canciones (
    id_cancion INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    duracion INT NOT NULL,
    reproducciones INT DEFAULT 0,
    genero VARCHAR(50),
    id_artista INT NOT NULL -- Referencia al id del autor
);

-- Tabla usuario. Se almacena el ID autonumérico, nombre, email, tipo de suscripción y la fecha de creación de la cuenta.
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    tipo_sub ENUM('Gratis', 'Premium') DEFAULT 'Gratis',
    fecha_registro DATETIME NOT NULL
);

-- Tabla playlist. Se almacena el ID autonumérico, nombre, fecha de creación, si es privada y el número de canciones.
-- Además, como una playlist solo puede ser creada por un usuario (no se contemplan playlists colaborativas) 
-- y un usuario puede crear muchas, se almacena aquí el ID del usuario.
CREATE TABLE playlists (
    id_playlist INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_creacion DATE NOT NULL,
    es_privada BOOLEAN DEFAULT 0,
    num_canciones INT DEFAULT 0,
    id_usuario INT NOT NULL -- Relación 1:N, se almacena el ID del usuario creador
);

-- Tabla album. Almacena el ID autonumerio, titulo, fecha de lanzamiento, genero musical y el num de canciones.
-- Además, debido a que un albúm solo puede ser de un artista, pero este puede tener múltiples albumes, 
-- el ID del artista creador se propaga a esta tabla
CREATE TABLE albumes (
    id_album INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    fecha_lanzamiento DATE NOT NULL,
    genero VARCHAR(50),
    num_canciones INT NOT NULL,
    id_artista INT NOT NULL -- Relación 1:N, se almacena el ID del artista creador
);


-- TABLA PARA MANEJAR LA RELACIÓN N:M DE PLAYLIST - CANCIONES
-- Requerimos de una tabla para manejar las relaciones N:M
-- Esta contiene las 2 claves primarias, la fecha de introduccion de una cancion en la playlist,
-- el orden de reproduccion y las veces que se ha escuchado la canción en la playlist.
CREATE TABLE agrega (
    id_playlist INT NOT NULL,
    id_cancion INT NOT NULL,
    fecha_agregacion DATETIME NOT NULL,
    orden_reproduccion INT, 
    veces_escuchada_en_playlist INT DEFAULT 0,
    PRIMARY KEY (id_playlist, id_cancion)
);


-- CLAVES FORÁNEAS
-- Relación 1:N entre artistas y canciones (un artista puede tener muchas canciones)
ALTER TABLE canciones
ADD CONSTRAINT FOREIGN KEY (id_artista)
REFERENCES artistas(id_artista)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Relación 1:N entre usuarios y playlists (un usuario puede crear varias playlists)
ALTER TABLE playlists
ADD CONSTRAINT FOREIGN KEY (id_usuario)
REFERENCES usuarios(id_usuario)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Relación 1:N entre artistas y álbumes (un artista puede publicar varios álbumes)
ALTER TABLE albumes
ADD CONSTRAINT FOREIGN KEY (id_artista) 
REFERENCES artistas(id_artista)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Relación N:M entre playlists y canciones (una playlist contiene varias canciones 
-- y una canción puede estar en varias playlists)
ALTER TABLE agrega
ADD CONSTRAINT FOREIGN KEY (id_playlist)
REFERENCES playlists(id_playlist)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Relación N:M entre canciones y playlists (controla la pertenencia de canciones a playlists)
ALTER TABLE agrega
ADD CONSTRAINT FOREIGN KEY (id_cancion)
REFERENCES canciones(id_cancion)
ON DELETE CASCADE ON UPDATE CASCADE;

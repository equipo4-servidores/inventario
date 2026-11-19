-- ============================================================
--  Script de inicialización de la base de datos "inventario"
--  MySQL lo ejecuta automáticamente SOLO la primera vez,
--  cuando el volumen datos_mysql está vacío.
-- ============================================================

SET NAMES utf8mb4;
USE inventario;

CREATE TABLE IF NOT EXISTS equipos (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    tipo            ENUM('Switch','Keycap','PCB','Carcasa','Placa','Estabilizador','Kit completo') NOT NULL,
    marca           VARCHAR(50)  NOT NULL,
    numero_serie    VARCHAR(50)  NOT NULL UNIQUE,
    ubicacion       VARCHAR(100) NOT NULL,
    estado          ENUM('Disponible','Reservado en preventa','En tránsito','Agotado','Defectuoso') NOT NULL DEFAULT 'Disponible',
    fecha_registro  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lotes de ejemplo de KeyHub MX (marcas reales; lotes, cantidades y ubicaciones ficticios)
INSERT INTO equipos (nombre, tipo, marca, numero_serie, ubicacion, estado) VALUES
('Switch lineal Gateron Yellow',            'Switch',        'Gateron',  'SW-2026-001',  'Estante A-1',          'Disponible'),
('Switch táctil Kailh Box Brown',           'Switch',        'Kailh',    'SW-2026-002',  'Estante A-2',          'Agotado'),
('Switch lineal Cherry MX Red',             'Switch',        'Cherry',   'SW-2026-003',  'Estante A-3',          'Disponible'),
('Juego de keycaps PBT perfil Cherry',      'Keycap',        'Akko',     'KC-2026-001',  'Estante B-1',          'Reservado en preventa'),
('Juego de keycaps ABS de doble inyección', 'Keycap',        'GMK',      'KC-2026-002',  'Por recibir',          'En tránsito'),
('PCB 65 % hot-swap',                       'PCB',           'KBDfans',  'PCB-2026-001', 'Estante C-1',          'Disponible'),
('Carcasa de aluminio 75 %',                'Carcasa',       'Keychron', 'CAR-2026-001', 'Estante D-1',          'Reservado en preventa'),
('Placa de latón 65 %',                     'Placa',         'KBDfans',  'PLA-2026-001', 'Área de devoluciones', 'Defectuoso'),
('Estabilizadores atornillables',           'Estabilizador', 'Durock',   'EST-2026-001', 'Estante C-2',          'Disponible'),
('Kit completo 75 %',                       'Kit completo',  'Keychron', 'KIT-2026-001', 'Estante E-1',          'Disponible');

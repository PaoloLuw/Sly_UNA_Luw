CREATE DATABASE empresa;
USE empresa;

CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    salario DECIMAL(10,2),
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES empleados(id)
);

CREATE TABLE proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE empleados_proyectos (
    empleado_id INT,
    proyecto_id INT,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
);

CREATE TABLE auditoria_salarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT,
    salario_anterior DECIMAL(10,2),
    fecha_cambio DATETIME
);


INSERT INTO empleados (nombre, salario, supervisor_id) VALUES
('Juan Pérez', 60000, NULL),
('María López', 70000, 1),
('Carlos Ruiz', 50000, 1),
('Ana Martínez', 80000, 2);

INSERT INTO proyectos (nombre) VALUES
('Proyecto A'),
('Proyecto B');

INSERT INTO empleados_proyectos (empleado_id, proyecto_id) VALUES
(1, 1),
(2, 1),
(2, 2),
(3, 2);


CREATE FUNCTION calcular_promedio_salarios()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(salario) INTO promedio FROM empleados;
    RETURN promedio;
END;

drop FUNCTION calcular_promedio_salarios;
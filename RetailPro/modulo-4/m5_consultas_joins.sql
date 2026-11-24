
USE Ventas_Tech_DB;
GO

-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- Proposito: unir las ventas con los datos de
-- clientes, productos y categorias para Power BI.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Hallazgo: Las 10 ventas registradas suman $6444.
-- La categoria Computacion fue la que mas facturo,
-- con un total de $4950.




-- CONSULTA 2: CLIENTES SIN VENTAS
-- Proposito: identificar clientes registrados
-- que nunca realizaron compras para el area de CRM.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: No se encontraron clientes sin ventas.
-- Para el area de CRM, los 5 clientes registrados
-- tienen al menos una compra realizada.






-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- Proposito: identificar productos del catalogo
-- que nunca se vendieron para el area de producto.

SELECT
    p.nombre_producto,
    c.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias c
    ON p.id_categoria = c.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: No se encontraron productos sin ventas.
-- Para el area de producto, los 6 articulos del
-- catalogo tienen al menos una venta registrada.






-- CONSULTA 4: CONSOLIDADO CON UNION ALL
-- Proposito: comparar la facturacion de dos
-- periodos utilizando UNION ALL.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primer periodo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-01' AND '2024-03-07'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segundo periodo' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-08' AND '2024-03-15'
) AS consolidado
GROUP BY canal
ORDER BY canal;


-- Hallazgo: El segundo periodo facturo $3454,
-- superando al primero por $464.
-- En total, ambos periodos sumaron $6444.




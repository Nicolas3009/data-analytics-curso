
USE Ventas_Tech_DB;
GO


-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;





-- CONSULTA 2: RANKING DE PRODUCTOS

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC, id_producto;





-- CONSULTA 3: CLIENTES RECURRENTES

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;




-- CONSULTA 4: PRODUCTOS POR ENCIMA O POR DEBAJO DEL PROMEDIO

WITH facturacion_productos AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado >= (
            SELECT AVG(total_facturado)
            FROM facturacion_productos
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_productos
ORDER BY total_facturado DESC;


-- =====================================
-- CONCLUSIONES DEL ANALISIS
-- =====================================

-- 1. En marzo de 2024 se realizaron 10 ventas,
--    con una facturacion total de $6444 y un
--    ticket promedio de $644,40.

-- 2. El producto 1 fue el que mas facturo,
--    con un total de $3600 y 3 unidades vendidas.

-- 3. De los 6 productos vendidos, solamente
--    los productos 1 y 3 superaron el promedio
--    de facturacion por producto de $1074.
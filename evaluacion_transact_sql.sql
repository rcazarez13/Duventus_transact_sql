
	/*Transact-SQL DuVENTUS*/

	/*Facturas*/			SELECT [Factura],[Fecha],[SlprsnId] FROM #TmpFacturas;
	/*Facturas detalle*/	SELECT [Factura],[ItemNmbr],[Monto],[Cajas] FROM #TmpFacturasDet;
	/*Productos*/			SELECT [ItemNmbr],[ItemDesc],[Modelo],[Voltaje],[BTU],[Tipo],[Orden] 
							FROM #TmpProductos;

	SELECT 
    'SET' + SUBSTRING(td.ItemNmbr, 2, LEN(td.ItemNmbr)) AS Item,
    p.Modelo + ' / ' + p.Voltaje + ' / ' + p.BTU + ' / ' + p.Tipo AS Descripción,
    SUM(td.Monto) AS MontoTotalFactura,
    SUM(CASE WHEN LEFT(td.ItemNmbr, 1) = 'O' 
		THEN td.Cajas 
		ELSE 0 
		END) AS Unidades
	FROM 
		#TmpFacturas f
	JOIN 
		#TmpFacturasDet td ON f.Factura = td.Factura
	JOIN 
		#TmpProductos p ON td.ItemNmbr = p.ItemNmbr
	WHERE 
		LEFT(td.ItemNmbr, 1) IN ('I', 'O')
	GROUP BY 
		SUBSTRING(td.ItemNmbr, 2, LEN(td.ItemNmbr)),
		p.Modelo, p.Voltaje, p.BTU, p.Tipo,
		f.SlprsnId
	ORDER BY 
		f.SlprsnId, Item;


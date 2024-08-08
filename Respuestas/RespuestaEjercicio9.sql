Use PruebaEficacia
go
/*
9. Escribe una funci�n en PL/SQL que reciba una fecha y devuelva el n�mero de empleados contratados en esa fecha.

    Tabla: TB_EMPLOYEES
    - Campo1: CONTRACT_ID (C�digo del empleado)
    - Campo2: START_DATE (Fecha inicio contrato)
	
CREATE OR REPLACE FUNCTION ContarEmpleadosPorFecha(p_fecha IN DATE)  
RETURN cantidad  
IS  
    v_contador cantidad; 
BEGIN  
    SELECT COUNT(*)  
    INTO v_contador  
    FROM TB_EMPLOYEES with(nolock)  
    WHERE START_DATE = p_fecha;  

    RETURN v_contador; 
EXCEPTION  
    WHEN OTHERS THEN  
        RETURN NULL;
END ContarEmpleadosPorFecha;  
/
*/
CREATE Or Alter FUNCTION dbo.ContarEmpleadosPorFecha (@p_fecha DATE)  
RETURNS INT  
AS  
BEGIN  
    DECLARE @v_contador INT;
    
    Set @v_contador  = 
		(
		SELECT  COUNT(*)  
		FROM dbo.TB_CONTRACT with(nolock)   -- TB_EMPLOYEES
		WHERE FECHA_INI = @p_fecha
		)

    RETURN @v_contador;
END;

--Validacion 
SELECT dbo.ContarEmpleadosPorFecha('20021011') as CantidadEmpleadosContratados;
select * from dbo.TB_CONTRACT
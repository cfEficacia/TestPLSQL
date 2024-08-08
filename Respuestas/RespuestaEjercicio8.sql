use PruebaEficacia
/*8. En la base de datos del sistema de n�mina se tiene una tabla donde se guardan los periodos de vacaciones que ha ido acumulando un empleado a lo largo de su contrato laboral 
(campo CYCLE_VACATION de la tabla TB_CYCLE_VACATION). Por cada a�o laborado se tiene un registro en la tabla, con estas columnas:
    ![](images/img05.png)

    La tabla presenta el c�digo del empleado (campo CONTRACT_ID), la fecha de inicio y fin de cada ciclo, 
	el n�mero de d�as de vacaciones que tiene el empleado por cada ciclo (campo DAY_CYCLE) y el ciclo de vacaci�n a que corresponde cada registro (campo CYCLE_VACATION).

    Se requiere desarrollar un procedimiento que pueda crear los registros correspondientes al empleado 1196989 quien tiene fecha de ingreso laboral 2016-12-05. 
	Por cada a�o laborado el empleado tiene derecho a 15 d�as de vacaciones y 
	actualmente la tabla tiene creados los registros correspondientes a los periodos 2016-2017, 2017-2018, 2018-2019.

    El procedimiento a desarrollar debe validar como fecha de corte el 31 de diciembre de 2023 y poder crear los registros correspondientes a los a�os laborados que faltan hasta el ciclo 2022-2023. Esto significa que el �ltimo periodo a insertar en la tabla debe ser el correspondiente a 05/12/2022 � 04/12/2023.

    El procedimiento debe crear los registros correspondientes a los siguientes ciclos de vacaciones:
    - 2019-2020
    - 2020-2021
    - 2021-2022
    - 2022-2023

Truncate table TB_CYCLE_VACATION
INSERT INTO TB_CYCLE_VACATION (CONTRACT_ID, CYCLE_VACATION, DAY_CYCLE, START_DATE_CYCLE, END_DATE_CYCLE) VALUES  
(1196989, 20162017, 15, '2016-12-05', '2017-04-12'),  
(1196989, 20172018, 15, '2017-12-05', '2018-04-12'),  
(1196989, 20182019, 15, '2018-12-05', '2019-04-12');

	
	select * from dbo.TB_CYCLE_VACATION
	select * from dbo.tb_contract
*/
go
CREATE Or alter PROCEDURE ActualizarCiclosVacaciones  
    @contract_id INT,  
    @fecha_corte DATE  
AS  
BEGIN  
    DECLARE @dias_ciclo				INT 
    DECLARE @ultimo_ciclo_fecha		DATE  
    DECLARE @ciclo_inicio			DATE  
    DECLARE @ciclo_fin				DATE  
    DECLARE @registros_insertados	INT 

	Set @dias_ciclo			  = 15
	Set @registros_insertados = 0

    -- obtenemos  la ultima fecha validada de vacaciones
    Set @ultimo_ciclo_fecha = 
		(
		SELECT TOP 1  START_DATE_CYCLE --se puede cambiar por end_date dependiendo del RQ o en el contrato la fecha inicio
		FROM TB_CYCLE_VACATION   With(nolock)
		WHERE CONTRACT_ID = @contract_id   
		ORDER BY END_DATE_CYCLE DESC
		)

    IF @ultimo_ciclo_fecha IS NOT NULL  
    BEGIN  
        SET @ciclo_inicio = @ultimo_ciclo_fecha
    END  
    ELSE  
    BEGIN  
        SET @ciclo_inicio =  
					(
		SELECT min(START_DATE_CYCLE)
		FROM TB_CYCLE_VACATION With(nolock)   
		WHERE CONTRACT_ID = @contract_id  
					)
    END  
	
	Set @ciclo_fin = @ciclo_inicio

    -- Calcular la suma de a�os desde el ciclo de inicio hasta la fecha de corte  
    WHILE DATEDIFF (YEAR,@ciclo_fin,@fecha_corte ) >= 1 
    BEGIN  
        SET @ciclo_fin = DATEADD(YEAR, 1, @ciclo_inicio); --a�o siguiente

        -- Verificar si el ciclo ya existe  
        IF NOT EXISTS (SELECT 1 FROM TB_CYCLE_VACATION   With(nolock)
                       WHERE CONTRACT_ID = @contract_id   
                       AND START_DATE_CYCLE = @ciclo_inicio)  
        BEGIN  
            -- Insertar el nuevo ciclo de vacaciones  
            INSERT INTO TB_CYCLE_VACATION (CONTRACT_ID, CYCLE_VACATION, DAY_CYCLE, START_DATE_CYCLE, END_DATE_CYCLE)   
            VALUES (@contract_id,   
                    CAST(CONVERT(VARCHAR(10), YEAR(@ciclo_inicio)) + CONVERT(VARCHAR(10), YEAR(@ciclo_fin)) AS INT),   
                    @dias_ciclo,   
                    @ciclo_inicio,   
                    @ciclo_fin);  
            SET @registros_insertados = @registros_insertados + 1;  
        END  

        -- Avanzar al siguiente ciclo  
        SET @ciclo_inicio = DATEADD(YEAR, 1, @ciclo_inicio);  
    END;  

    -- Mensaje de resultado  
    IF @registros_insertados > 0  
    BEGIN  
        PRINT CAST(@registros_insertados AS VARCHAR(10)) + ' ciclo de vacaciones agregados y se actualizaron las vacaciones.';  
    END  
    ELSE  
    BEGIN  
        PRINT 'Contrato no necesitaba ser actualizado, est� al d�a.';  
    END  
END;

--Validar
EXEC 
	ActualizarCiclosVacaciones
		@contract_id = 1196989, 
		@fecha_corte = '2023-12-31';
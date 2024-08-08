
-- Respuesta punto 1
/*
    Un tablespace es una estructura logica que agrupa objetos en base de datos, pueden ser tablas o indices, 
    es un contenedor, organiza el almacenamiento en base de datos, gestiona espacio disponible
    se componen de uno o mas datafiles y existen varios tipos como de usuario, sistema o temporales
*/

-- Respuesta punto 2
/*
    La principal diferencia es que la funcion retorna un valor y el procedimiento no, el procedimiento
    realiza una acción específica, como actualizar una tabla o procesar datos mientras la funcion
    realiza una acción y devuelve un valor
*/

-- Respuesta punto 3
/*
    Encapsular y agrupar objetos relacionados como lo pueden ser procedimientos, funciones, variables y/o
    tipos de datos
*/

--Respuesta punto 4
/*
    Es una lista de valores previamente definidos que se usan para proporcionar opciones en campos de formularios
    o elementos de seleccion, pueden ser estaticos que se definen manualmente en la aplicacion o dinamicos
    generados por una consulta
*/

--Respuesta punto 5
/*
    SYS y SYSTEM, SYS tiene permisos completos sobre la base de datos mientras que SYSTEM tiene amplios permisos 
    administrativos tambien pero en menor medida que SYS
*/

--Respuesta punto 6
/*
    Es un campo que sirve para establecer relacion entre otra tabla, puede ser una o varias en una misma tabla
*/

-- Respuesta punto 7
SELECT 
    TBC.CONTRACT_ID,
    TBI.NUMBER_ID,
    TBI.FIRST_NAME || ' ' || TBI.last_name1 || ' ' || TBI.last_name2 AS FULL_NAME,
    TBI.birth_date AS BIRTHDATE,
    FLOOR(MONTHS_BETWEEN(SYSDATE, TBI.birth_date) / 12) AS AGE,
    tbi.address,
    tbi.CELL_PHONE1,
    tbe.name as CLIENT_NAME,
    tbe.number_fiscal AS NIT,
    tbc.fecha_ini AS CONTRACT_INI_DATE,
    FLOOR(MONTHS_BETWEEN(SYSDATE, TBC.FECHA_INI) / 12) AS OLD,
    tbcom.salario AS SALARY
FROM
    TB_IDENTITY TBI
INNER JOIN
    TB_CONTRACT TBC ON TBC.number_id = TBI.NUMBER_ID
INNER JOIN 
    tb_entity TBE ON tbe.entity = tbc.entity
INNER JOIN
    tb_compensation TBCOM ON tbcom.contract_id = tbc.contract_id;

-- Respuesta punto 8
CREATE OR REPLACE PROCEDURE ADD_VACATION_CYCLES IS
    v_start_date DATE := TO_DATE('2019-12-05', 'YYYY-MM-DD');
    v_end_date   DATE;
    v_cycle      VARCHAR2(10);
    v_contract_id NUMBER := 1196989;
    v_day_cycle  NUMBER := 15;
BEGIN
    FOR i IN 2019..2022 LOOP
        v_end_date := ADD_MONTHS(v_start_date, 12) - 1;
        v_cycle := TO_CHAR(i) || TO_CHAR(i+1);
        
        INSERT INTO TB_CYCLE_VACATION (CONTRACT_ID, CYCLE_VACATION, DAY_CYCLE, START_DATE_CYCLE, END_DATE_CYCLE)
        VALUES (v_contract_id, v_cycle, v_day_cycle, v_start_date, v_end_date);
        
        v_start_date := v_end_date + 1;
    END LOOP;

    COMMIT;
END ADD_VACATION_CYCLES;
/

-- Respuesta punto 9
CREATE OR REPLACE FUNCTION GET_EMPLOYEES_BY_START_DATE(p_start_date IN DATE)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM TB_EMPLOYEES
    WHERE START_DATE = p_start_date;
    RETURN v_count;
END GET_EMPLOYEES_BY_START_DATE;
/

--Respuesta punto 10
SELECT CONTRACT_ID, MAX(SALARIO) AS MAX_SALARIO
FROM TB_SALARIOS
GROUP BY CONTRACT_ID;
use PruebaEficacia

/*

10. Desarrolle una consulta SQL que tome los datos de la siguiente tabla TB_SALARIOS y presente el código del contrato con su mayor asignación salarial.
    ![](images/img06.png)

    El resultado esperado es el siguiente:

    ![](images/img07.png)

	select * FROM dbo.TB_SALARIOS  
	
*/

SELECT 
	CONTRACT_ID,
	'$ ' + Format(max(SALARIO),'N2') as Salario
	FROM dbo.TB_SALARIOS  
group by CONTRACT_ID



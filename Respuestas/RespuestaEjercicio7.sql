use PruebaEficacia

----select * from dbo.TB_CONTRACT
----select * from dbo.TB_IDENTITY
----select * from dbo.TB_ENTITY
----select * from dbo.TB_SALARIOS
----select * from dbo.TB_CYCLE_VACATION
----select * from dbo.TB_COMPENSATION

Declare @fecha_Hoy datetime = Getdate();

	select 
	 b.CONTRACT_ID		as 'ID de contrato'					 ,
     a.NUMBER_ID	    as 'N�mero de c�dula del empleado'	 ,
		 FIRST_NAME  + ' ' + 
		 OTHERS_NAME + ' ' + 
		 LAST_NAME1  + ' ' + 
		 LAST_NAME2		as 'Nombres y apellidos del empleado',
     a.BIRTH_DATE		as 'Fecha de nacimiento'			 ,
     DATEDIFF(YEAR
		,a.BIRTH_DATE,
		@fecha_Hoy)		as 'Edad'		 ,
     a.[ADDRESS]		as 'Direcci�n'							 ,
     a.CELL_PHONES		as 'N�mero de tel�fono'					 ,
     a.PERSONAL_MAIL	as 'Email'								 ,
     c.[NAME]			as 'Nombre del cliente'						 ,
     c.NUMBER_FISCAL	as 'Nit del cliente'					 ,
     b.FECHA_INI		as 'Fecha de inicio de contrato'			 ,
     DATEDIFF(YEAR
		,b.FECHA_INI,
		@fecha_Hoy)		as 'Antig�edad en a�os'							 ,
     d.SALARIO			as 'Salario'
	from 
		dbo.TB_IDENTITY			a With(nolock) -- datos personales del empleado 
		inner join 
		dbo.TB_CONTRACT			b With(nolock) on (a.NUMBER_ID = b.NUMBER_ID)		--Informaci�n contrato del empleado
		inner join 
		dbo.TB_ENTITY			c With(nolock) on (b.CONTRACT_ID =b.CONTRACT_ID)	--Informaci�n Clientes
		inner join		
		dbo.TB_COMPENSATION		d With(nolock) on (b.CONTRACT_ID = d.CONTRACT_ID)	--Informaci�n de salarios del empleado
	
	

    
    
    
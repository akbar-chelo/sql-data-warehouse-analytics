USE	master;
GO

--create "DataWarehouse" DATABASE 
CREATE DATABASE DataWarehouse;
GO

use DataWarehouse;
GO

--Create "SCHEMAS"
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
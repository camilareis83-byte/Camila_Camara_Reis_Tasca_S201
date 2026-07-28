-- Nivell 1
-- Exercici 1
-- A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
-- Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
-- Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

-- Las características principales del esquema:
USE transactions;
SHOW TABLES;

-- Las características de la tabla company:
USE transactions;
DESCRIBE company;

-- Las características de la tabla transaction:
USE transactions;
DESCRIBE transaction;


-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:

-- Llistat dels països que estan generant vendes.
USE transactions;
SELECT DISTINCT c.country 
FROM company AS c
INNER JOIN transaction AS t
ON c.id = t.company_id
WHERE declined = 0 AND c.country IS NOT NULL;

-- Des de quants països es generen les vendes.
USE transactions;
SELECT COUNT(DISTINCT c.country) AS total_countries
FROM company AS c
INNER JOIN transaction AS t
ON c.id = t.company_id
WHERE declined = 0;

-- Identifica la companyia amb la mitjana més gran de vendes.
USE transactions;
SELECT c.company_name, ROUND(AVG(t.amount), 2) AS avg_amount
FROM transaction AS t
INNER JOIN company AS c
ON t.company_id = c.id
WHERE declined = 0
GROUP BY c.company_name
ORDER BY avg_amount DESC LIMIT 1;


-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):

-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
USE transactions;
SELECT * FROM transaction AS t
WHERE t.company_id IN (SELECT id from company AS c 
						WHERE c.country = "Germany");

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes 
-- les transaccions.
USE transactions;					
SELECT c.id, c.company_name 
FROM company as c
WHERE c.id IN (
		SELECT t.company_id
		FROM transaction AS t
		WHERE declined = 0 AND amount > (
			SELECT AVG(t.amount) 
			FROM transaction as t));

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
USE transactions;
SELECT c.id, c.company_name
FROM company AS c
WHERE NOT EXISTS (SELECT t.company_id
					FROM transaction AS t
					WHERE t.company_id = c.id);


-- Exercici 4
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de 
-- crèdit. La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres 
-- dues taules ("transaction" -- i "company"). Després de crear la taula serà necessari que ingressis la informació del document 
-- denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

-- Creando la Tabla credit_card:
USE transactions;
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(50),
    pin CHAR(4),
    cvv CHAR(3),
    expiring_date VARCHAR(8)  
);

-- -- Insertamos datos de credit_card:
USE transactions;
INSERT INTO credit_card (...

-- Estabelecendo la relación entre las tablas credit_card y transaction:
USE transactions;
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

-- Las características de la tabla credit_card: 
USE transactions;
DESCRIBE credit_card;

-- Las características de la tabla transaction: 
USE transactions;
DESCRIBE transaction;


-- Exercici 5
-- El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

-- Haciendo el cambio del iban:
USE transactions;
UPDATE credit_card 
SET iban = "TR323456312213576817699999" 
WHERE id = "CcU-2938";

-- Mostrando el cambio realizado:
USE transactions;
SELECT * 
FROM credit_card
WHERE id = "CcU-2938";


-- Exercici 6
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:
-- "Id 108B1D1D-5B23-A76C-55EF-C568E49A99DD - credit_card_id CcU-9999 - company_id b-9999 - user_id 9999 - lat 829.999 
-- longitude -117.999 - amount - 111.11 - declined 0"

-- Debido a las restricciones de integridad referencial de la base de datos (las Foreign Keys), fue necesario crear previamente 
-- los registros correspondientes en las tablas company y credit_card, ya que los identificadores b-9999 y CcU-9999 no existían

-- Creando el registro del id 'b-9999' en la tabla company:
USE transactions;
INSERT INTO company (id) VALUES ('b-9999');

-- Creando el registro del id 'CcU-9999' en la tabla credit_card:
USE transactions;
INSERT INTO credit_card (id) VALUES ('CcU-9999');

-- Creando el registro de la nueva transación solicitada en la tabla transaction:
USE transactions;
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

-- Mostrando el cambio realizado:
USE transactions;
SELECT * FROM transaction
WHERE id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";


-- Exercici 7
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

-- Eliminando la columna "pan":
USE transactions;
ALTER TABLE credit_card
DROP COLUMN pan;

-- Mostrando el cambio realizado:
USE transactions;
DESCRIBE credit_card;


-- Exercici 8
-- Descarrega els arxius CSV que trobaràs a l'apartat de recursos:
-- american_users.csv
-- european_users.csv
-- companies.csv
-- credit_cards.csv
-- transactions.csv
-- Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les 
-- següents consultes:
-- La taula de products.csv l'utilitzarem més endavant.

-- Creando la Base de Datos:
CREATE DATABASE IF NOT EXISTS new_transactions;

-- Creando la Tabla all_users, donde después importaremos los datos de american_users y european_users juntos:
USE new_transactions;
CREATE TABLE IF NOT EXISTS all_users (
	id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(25),
    email VARCHAR(100),
    birth_date VARCHAR(20),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(15),
    address VARCHAR(100),
    signup_date DATE,
    user_segment VARCHAR(25),
    income_band VARCHAR(25),
    region VARCHAR(25)
);

-- Creando la Tabla companies:
USE new_transactions;
CREATE TABLE IF NOT EXISTS companies (
	company_id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(25),
    email VARCHAR(100),
    country VARCHAR(100),
    website VARCHAR(100),
    merchant_category VARCHAR(50),
    merchant_price_position VARCHAR(50)
);

-- Creando la Tabla credit_cards y estabelecendo la Foreing Key con la tabla all_users:
USE new_transactions;
CREATE TABLE IF NOT EXISTS credit_cards (
	id VARCHAR(15) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(50),
    pan VARCHAR(50),
    pin CHAR(4),
    cvv CHAR(3),
    track1 VARCHAR(150),
    track2 VARCHAR(150),
    expiring_date VARCHAR(8),
    card_type VARCHAR(15),
    card_renewal_flag TINYINT,
    CONSTRAINT fk_all_users FOREIGN KEY (user_id) REFERENCES all_users(id)
);

-- Creando la Tabla transactions y estabelecendo las Foreing Keys con la otras tablas:
USE new_transactions;
CREATE TABLE IF NOT EXISTS transactions (
	id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(15),
    business_id VARCHAR(20),
    timestamp TIMESTAMP,
    amount DECIMAL(10,2),
    declined TINYINT,
    product_ids VARCHAR(255),
    user_id INT,
    lat FLOAT,
    longitude FLOAT,
    discount_amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    shipping_amount DECIMAL(10,2),
    channel VARCHAR(50),
    campaign_id VARCHAR(50),
    device_type VARCHAR(15),
    is_international TINYINT,
    decline_reason VARCHAR(50),
    distance_km DECIMAL(10,2),
	CONSTRAINT fk_credit_cards FOREIGN KEY (card_id) REFERENCES credit_cards(id),
	CONSTRAINT fk_companies FOREIGN KEY (business_id) REFERENCES companies(company_id),
	CONSTRAINT fk_users FOREIGN KEY (user_id) REFERENCES all_users(id)
);

-- Importando los datos del archivo "N1-Ex.8__american_users.csv" para la tabla all_users:
USE new_transactions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__american_users.csv'
INTO TABLE all_users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(    id,
    name,
    surname,
    phone,
    email,
    birth_date,
    country,
    city,
    postal_code,
    address,
    signup_date,
    user_segment,
    income_band )
SET region = 'USA';

-- Importando los datos del archivo "N1-Ex.8__european_users.csv" para la tabla all_users:
USE new_transactions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__european_users.csv'
INTO TABLE all_users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS
(    id,
    name,
    surname,
    phone,
    email,
    birth_date,
    country,
    city,
    postal_code,
    address,
    signup_date,
    user_segment,
    income_band )
SET region = 'Europe';

-- Importando los datos del archivo "N1-Ex.8__companies.csv" para la tabla companies:
USE new_transactions;
LOAD DATA
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Importando los datos del archivo "N1-Ex.8__credit_cards.csv" para la tabla credit_cards:
USE new_transactions;
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Importando los datos del archivo "N1-Ex.8__transactions.csv" para la tabla transactions:
USE new_transactions;
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- Exercici 9
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
USE new_transactions;
SELECT a.id, a.name, a.surname
FROM all_users AS a
WHERE a.id IN (SELECT t.user_id 
				FROM transactions AS t
				GROUP BY t.user_id
				HAVING COUNT(*) > 80);


-- Exercici 10
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
USE new_transactions;
SELECT co.company_name, cr.iban, ROUND(AVG(tr.amount), 2) AS valor_medio 
FROM transactions AS tr
	INNER JOIN companies AS co
	ON tr.business_id = co.company_id
	INNER JOIN credit_cards as cr
	ON cr.id = tr.card_id
GROUP BY cr.iban, co.company_name
HAVING co.company_name = "Donec Ltd";


-- Nivell 2

-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data 
-- de cada transacció juntament amb el total de les vendes.

USE new_transactions;
SELECT DATE(timestamp) AS day, SUM(amount) AS total_sales
FROM transactions
GROUP BY DATE(timestamp)
ORDER BY total_sales DESC LIMIT 5;


-- Exercici 2
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès 
-- entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. 
-- Ordena els resultats de major a menor quantitat.

USE new_transactions;
SELECT co.company_name, co.phone, co.country, DATE(tr.timestamp) AS day, tr.amount
FROM companies as co
	INNER JOIN transactions AS tr
	ON co.company_id = tr.business_id
WHERE tr.amount BETWEEN 350 AND 400
	AND (DATE(tr.timestamp) = "2015-04-29" 
		OR DATE(tr.timestamp) = "2018-07-20" 
		OR DATE(tr.timestamp) = "2024-03-13")
ORDER BY amount DESC;


-- Exercici 3
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa 
-- et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos 
-- humans és exigent i vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys.

USE new_transactions;
SELECT co.company_id, co.company_name, COUNT(tr.id) AS sales_quantity,
CASE
	WHEN COUNT(tr.id) < 400 THEN "No"
    ELSE "Yes"
END AS higher_400
FROM companies AS co
INNER JOIN transactions AS tr
ON co.company_id = tr.business_id
GROUP BY co.company_id, co.company_name;


-- Exercici 4
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

-- Eliminando la transacción:
USE new_transactions;
DELETE FROM transactions 
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD"; 

-- Mostrando el cambio realizado:
USE new_transactions;
SELECT * FROM transactions 
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";


-- Exercici 5
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà 
-- necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
-- Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, 
-- ordenant les dades de major a menor mitjana de compra.

-- Creando la vista “VistaMarketing”:
USE new_transactions; 
CREATE VIEW VistaMarketing AS
SELECT co.company_name, co.phone, co.country, ROUND(AVG(tr.amount), 2) AS avg_sales
FROM companies AS co
INNER JOIN transactions AS tr
ON co.company_id = tr.business_id
GROUP BY co.company_name, co.phone, co.country
ORDER BY avg_sales DESC;

-- Presentando la vista creada:
USE new_transactions;
SELECT * FROM VistaMarketing;


-- Nivell 3

-- Exercici 1
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han 
-- estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon: 
-- Quantes targetes estan actives?

-- Creando la tabla:
USE new_transactions;
CREATE TABLE IF NOT EXISTS credit_card_status AS
SELECT tr1.card_id,
CASE 
	WHEN SUM(tr1.declined) = 3 THEN "inactive"
	ELSE "active"    
    END AS card_status
FROM transactions AS tr1
WHERE (SELECT COUNT(*)
    FROM transactions AS tr2
    WHERE tr2.card_id = tr1.card_id
      AND tr2.timestamp > tr1.timestamp
) < 3
GROUP BY tr1.card_id
ORDER BY tr1.card_id;

-- Contando las tarjetas activas:
USE new_transactions;
SELECT COUNT(*) AS active_cards
FROM credit_card_status
WHERE card_status = "active";


-- Exercici 2
-- Crea una taula amb la qual puguem unir les dades de l'arxiu de products.csv amb la base de dades creada (ja que fins ara no podíem fer-ho), tenint en compte que des de transaction tens product_ids. Genera la següent consulta: Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

-- Creando la tabla:
USE new_transactions;
CREATE TABLE IF NOT EXISTS products (
	id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    colour VARCHAR(15),
    weight DECIMAL(10,1),
    warehouse_id VARCHAR(15),
    category VARCHAR(15),
    brand VARCHAR(15),
    cost DECIMAL(10,2),
    launch_date DATE
);

-- Importando los datos del archivo “N1-Ex.8__products.sql” para la tabla products:
USE new_transactions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(   id,
    product_name,
    @price,
    colour,
    weight,
    warehouse_id,
    category,
    brand,
    @cost,
    launch_date)
SET
    price = REPLACE(@price, '$', ''),
    cost = REPLACE(@cost, '$', '');

-- Para establecer la relación entre las tablas transactions y products, es necesario crear una tabla intermedia 
-- (transactions_products) que conecte los ids de los productos listados en products.id con los listados en transactions.product_ids.
-- De esta manera, se puede establecer una relación N:N (muchos a muchos) entre ellos.

-- Creando la tabla transactions_products:
USE new_transactions;
CREATE TABLE IF NOT EXISTS transactions_products (
	transaction_id VARCHAR(255),
    product_id INT,
    PRIMARY KEY (transaction_id, product_id),
    CONSTRAINT fk_transaction FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insertando los datos de las tablas transactions y products en la tabla transactions_products:
USE new_transactions;
INSERT INTO transactions_products (transaction_id, product_id)
SELECT tr.id, jst.product_id
FROM transactions AS tr
JOIN JSON_TABLE(
		CONCAT('["', REPLACE(tr.product_ids, ', ', '","'),'"]'),
		'$[*]' 
		COLUMNS (product_id INT PATH '$')) AS jst;

-- Genera la següent consulta: Necessitem conèixer el nombre de vegades que s'ha venut cada producte.
USE new_transactions;
SELECT tp.product_id, COUNT(tp.product_id) AS number_sales
FROM transactions_products AS tp
JOIN transactions AS tr
ON tp.transaction_id = tr.id
WHERE tr.declined = 0
GROUP BY tp.product_id
ORDER BY tp.product_id;
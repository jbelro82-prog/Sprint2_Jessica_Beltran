NIVELL 1

EXERCICI 1:

A partir dels documents adjunts (estructura_dades i dades_introduir)
importa les dues taules. Mostra les característiques principals de
l'esquema creat i explica les diferents taules i variables que existeixen
Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

(Executem el codi dels erxius)

USE transactions;
DESCRIBE company;
DESCRIBE credit_card;

comprovem que les dades s'han afegit correctament a la taula company:
SELECT * FROM company;

comprovem que les dades s'han afegit correctament a la taula credit_card:
SELECT * FROM credit_card;

EXERCICI 2 :

Utilitzant JOIN realitzaràs les següents consultes:

2.1:
Llistat dels països que estan generant vendes.

SELECT DISTINCT c.country FROM company AS c
INNER JOIN transaction AS t 
ON c.id = t.company_id
WHERE t.declined = 0
	AND c.country IS NOT NULL
ORDER BY c.country;

2.2:
Des de quants països es generen les vendes.

USE transactions;
SELECT COUNT( DISTINCT country) AS total_paisos
FROM company  AS c
INNER JOIN transaction AS t ON 
c.id = t.company_id
WHERE t.declined = 0;

2.3:
Identifica la companyia amb la mitjana més gran de vendes.

SELECT c.company_name, ROUND(AVG(t.amount), 2) AS mitjana_vendes
FROM transaction AS t
INNER JOIN company AS c ON t.company_id = c.id 
WHERE t.declined = '0'
GROUP BY c.company_name
ORDER BY mitjana_vendes DESC
LIMIT 1;


EXERCICI 3:

Utilitzant només subconsultes (sense utilitzar JOIN)


3.1
Mostra totes les transaccions realitzades per empreses d'Alemanya


SELECT * FROM transaction AS t
WHERE t.declined = 0  
  AND EXISTS (
      SELECT 1
      FROM company AS c 
      WHERE c.id = t.company_id
        AND c.country = 'Germany'
  );

3.2
Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT c.company_name
FROM company AS c
WHERE EXISTS
(
    SELECT 1
	FROM transaction AS t
    WHERE t.company_id = c.id
    AND t.declined = 0
    AND t.amount > (SELECT ROUND(AVG(amount), 2) 
    FROM transaction)
);

3.3
Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT c.company_name
FROM company AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM transaction AS t
    WHERE t.company_id = c.id
)
    
EXERCICI 4:
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. La nova taula
ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company").
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el
diagrama i realitzar una breu descripció d'aquest.

Creació de la taula credit_card:

USE transactions;
CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(50) PRIMARY KEY,
    iban VARCHAR(50),
    pan INT,
    pin INT,
    cvv INT,
    expiring_date TIMESTAMP
);


Afegim les dades a la taula credit_card:
INSERT INTO credit_card (id, iban, (toda la tabla con los datos proporcionados)

Comprovem que les dades s'han afegit correctament:
SELECT * FROM credit_card;

Afegim FK i PK a la taula transaction:

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id),
ADD FOREIGN KEY (company_id) REFERENCES company(id);

comprovem que les FK s'han afegit correctament:
DESCRIBE credit_card;

EXERCICI 5:

El departament de Recursos Humans ha identificat un error en el número de compte associat a la 
targeta de crèdit amb id 'CcU-2938'. El número de compte actual és incorrecte i necessita ser actualitzat. 
El nou número de compte que s'ha de registrar és TR323456312213576817699999.
Recorda mostras el canvi realitzat.



UPDATE credit_card 
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT cc.iban, cc.id
FROM credit_card AS cc
WHERE cc.id = 'CcU-2938';

EXERCICI 6: 

En la taula "transaction" ingressa una nova transacció amb la següent informació

INSERT INTO company (id)
VALUES ('b-9999');

Validem que la companyia s'ha afegit correctament:

SELECT * FROM company AS c
WHERE id= 'b-9999';

INSERT INTO credit_card (id)
VALUES ('CcU-9999');

validem que la targeta de crèdit s'ha afegit correctament:

SELECT * FROM credit_card AS cc
WHERE id = 'CcU-9999';

INSERT INTO transaction (Id,credit_card_id,company_id,user_id,lat,longitude,amount,declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999',9999,829.999,-117.999,111.11,0);

Validem que la transacció s'ha afegit correctament:

SELECT * FROM transaction AS t
WHERE t.Id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

EXERCICI 7:

Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

comprovem que la columna s'ha eliminat correctament:
SHOW COLUMNS FROM credit_card;

EXERCICI 8:


Descarrega els arxius CSV que trobaràs a l'apartat de recurs.
Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4
taules de les quals puguis realitzar les següents consultes:

codi SQL per crear la base de dades i les taules:

CREATE DATABASE IF NOT EXISTS business_sprint2;

Codi per comprovar que la base de dades s'ha creat correctament:
USE business_sprint2;

CREATE TABLE  
IF NOT EXISTS users (       
    id VARCHAR(15) PRIMARY KEY,     
    name VARCHAR(15),     
    surname VARCHAR(15),  
    phone VARCHAR(20),     
    email VARCHAR(35),     
    birth_date VARCHAR(20),     
    country VARCHAR(25),     
    city VARCHAR(25),     
    postal_code VARCHAR(15),     
    address VARCHAR(35),     
    signup_date DATE,     
    user_segment VARCHAR(35),     
    income_band VARCHAR(20)    
     );

CREATE TABLE 
IF NOT EXISTS companies (   
    company_id VARCHAR(15)  PRIMARY KEY,     
    company_name VARCHAR(25),     
    phone VARCHAR(20),     
    email VARCHAR(35),     
    country VARCHAR(25),  
    website VARCHAR(55),  
    merchant_category VARCHAR(20),  
    merchant_price_position VARCHAR(20)  
    );

CREATE TABLE 
IF NOT EXISTS credits_cards (   
    id VARCHAR(15) PRIMARY KEY,      
    user_id INT,     
    iban VARCHAR(55),     
    pan VARCHAR(35),     
    pin INT,     
    cvv INT,     
    track1 VARCHAR(155),     
    track2 VARCHAR(155),     
    expiring_date DATE,     
    card_type VARCHAR(35),     
    card_renewal_flag TINYINT(1)  
    );

CREATE TABLE 
IF NOT EXISTS transactions (   
    id VARCHAR(15)  PRIMARY KEY,      
    card_id VARCHAR(35),     
    business_id VARCHAR(35),     
    timestamp TIMESTAMP,     
    amount FLOAT,     
    declined TINYINT(1),     
    product_ids INT,  
    user_id INT,     
    lat FLOAT,     
    longitude FLOAT,     
    discount_amount FLOAT,     
    tax_amount FLOAT,     
    shipping_amount FLOAT,     
    channel VARCHAR(35),     
    campaign_id VARCHAR(35),     
    device_type VARCHAR(35),     
    is_international TINYINT(1),     
    decline_reason VARCHAR(35),     
    distance_km FLOAT      
    );	



ALTER TABLE transactions 
ADD FOREIGN KEY (user_id) REFERENCES users(id), 
ADD FOREIGN KEY (card_id) REFERENCES credits_cards(id), 
ADD FOREIGN KEY (business_id) REFERENCES companies(company_id)	

afegim la columna continent a la taula users ja que possiblement sigui necessària per a futures consultes:

SET SQL_SAFE_UPDATES = 0; 

UPDATE users
SET continent = CASE
    WHEN country IN ('United States', 'Canada', 'USA') THEN 'America' 
    ELSE 'Europe'
END;

SET SQL_SAFE_UPDATES = 1;

comprovem que la columna continent s'ha afegit correctament i que les dades s'han actualitzat correctament:
SELECT id, name, country, continent 
FROM users;

comprovem que les taules s'han creat correctament:
SHOW TABLES;


SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/jessica/Desktop/Escritorio - MacBook Air de Jessica/ESPECIALITZACIÓ/SPRINT_2/MATERIAL_S2/N1-Ex.8__american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/jessica/Desktop/Escritorio - MacBook Air de Jessica/ESPECIALITZACIÓ/SPRINT_2/MATERIAL_S2/N1-Ex.8__european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/jessica/Desktop/Escritorio - MacBook Air de Jessica/ESPECIALITZACIÓ/SPRINT_2/MATERIAL_S2/N1-Ex.8__companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



LOAD DATA LOCAL INFILE '/Users/jessica/Desktop/Escritorio - MacBook Air de Jessica/ESPECIALITZACIÓ/SPRINT_2/MATERIAL_S2/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/jessica/Desktop/Escritorio - MacBook Air de Jessica/ESPECIALITZACIÓ/SPRINT_2/MATERIAL_S2/N1-Ex.8__transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Comprovem que les dades s'han afegit correctament a les taules:
SELECT * FROM users;
SELECT * FROM companies;
SELECT * FROM credit_cards;
SELECT * FROM transactions;

EXERCICI 9:

Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT u.id, u.name, u.surname,
	
	(SELECT COUNT(id) 
    FROM transactions AS t
    WHERE t.user_id = u.id 
	) AS total_transactions

FROM users u 
WHERE
	(
	SELECT COUNT(id) 
    FROM transactions AS t
    WHERE t.declined = 0
    AND t.user_id = u.id 
	) > 80
    
GROUP BY u.id, u.name, u.surname
ORDER BY total_transactions;

EXERCICI 10:

Mostra la mitjana d amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT ROUND(AVG(t.amount), 2) AS avg_company, cc.iban, cc.id, c.company_name
FROM transactions AS t
INNER JOIN credit_cards AS cc ON t.card_id = cc.id
INNER JOIN companies AS c ON t.business_id = c.company_id
WHERE c.company_name = 'Donec Ltd' 
  AND t.declined = 0 
GROUP BY cc.iban, cc.id, c.company_name
ORDER BY avg_company;

NIVELL 2

EXERCICI 1:

Identifica els cinc dies que es va generar la quantitat més gran dingressos a la companyia per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE (t.timestamp) AS Fecha,ROUND(SUM(t.amount), 2) AS Total_ventas
FROM transactions AS t
WHERE declined = '0'
GROUP BY Fecha
ORDER BY Total_ventas DESC LIMIT 5;

EXERCICI 2:

Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions 
amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 
de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat


SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) AS `date`, t.amount
FROM companies AS c 
INNER JOIN transactions AS t ON c.company_id = t.business_id
WHERE t.amount BETWEEN 350 AND 400
  AND t.declined = 0 
  AND (DATE(t.timestamp) = '2015-04-29' 
       OR DATE(t.timestamp) = '2018-07-20' 
       OR DATE(t.timestamp) = '2024-03-13')
ORDER BY t.amount DESC;

EXERCICI 3:

Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es
requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que
realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les 
empreses on especifiquis si tenen igual o més de 400 transaccions o menys.

SELECT COUNT(t.id) AS total_transactions, c.company_name, c.company_id,
    CASE
        WHEN COUNT(t.id) >= 400 THEN 'High volume'
        ELSE 'Low volume'
    END AS classification_transactions
FROM transactions AS t
INNER JOIN companies AS c ON t.business_id = c.company_id
WHERE t.declined = 0
GROUP BY c.company_name, c.company_id;

EXERCICI 4:

Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM transactions AS t
WHERE t.id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

comprovem que el registre s'ha eliminat correctament:

SELECT * FROM transactions
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

EXERCICI 5:

La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà necessària que creïs una vista anomenada 
VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte.
País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada
ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount), 2) AS avg_company
FROM companies AS c
INNER JOIN transactions AS t 
ON t.business_id = c.company_id
WHERE t.declined = 0 
GROUP BY c.company_name, c.phone, c.country
ORDER BY avg_company DESC;


comprovem que la vista s'ha creat correctament:

SELECT * FROM VistaMarketing;

NIVELL 3

EXERCICI 1:

Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat
en si les tres últimes transaccions han estat declinades aleshores és
inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:
Quantes targetes estan actives?

CREATE TABLE estat_targetes AS
WITH TransaccionsNumerades AS (
    SELECT 
        card_id, 
        declined, 
        timestamp,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS posicio
    FROM transactions
)
SELECT 
    t.card_id,
    cc.card_type,
    CASE 
        WHEN SUM(t.declined) = 3 THEN 'Inactive'
        ELSE 'Active'
    END AS status
FROM TransaccionsNumerades AS t
INNER JOIN credit_cards AS cc ON t.card_id = cc.id 
WHERE t.posicio <= 3
  AND (cc.card_type = 'credit' OR cc.card_type = 'premium_credit')
GROUP BY t.card_id, cc.card_type;

comprovem el resultat de la taula estat_targetes:

SELECT COUNT(*) AS targetes_actives 
FROM estat_targetes 
WHERE status = 'Active';

comprovem que la taula s'ha creat correctament:

SELECT * FROM estat_targetes;

EXERCICI 2:



USE business_sprint2;


CREATE TABLE IF NOT EXISTS 
products (
    id INT PRIMARY KEY,
    product_name VARCHAR(70),
    price VARCHAR(30),      
    colour VARCHAR(30),
    weight FLOAT,
    warehouse_id VARCHAR(20),
    category VARCHAR(50),
    brand VARCHAR(50),
    cost VARCHAR(50),       
    launch_date DATE
);

comprovem que la taula s'ha creat correctament:
SHOW TABLES;

carreguem les dades a la taula products fent abans la conversió del fitxer CSV a SQL a través de la pàgina web

https://www.convertcsv.com/csv-to-sql.htm

comprovem que les dades s'han afegit correctament a la taula products:
SELECT * FROM products;

creem taula product_transactions per a relacionar els productes amb les transaccions:

CREATE TABLE products_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(255), 
    product_id INT,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

comprovem que la taula s'ha creat correctament:
SELECT * FROM business_sprint2.products_transactions;


separem els id's dels productes de la columna product_ids de la taula transactions i els inserim a la taula products_transactions:

INSERT INTO products_transactions (transaction_id, product_id)
SELECT 
    t.id AS transaction_id,
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', n.n), ',', -1) AS UNSIGNED) AS product_id
FROM transactions t
INNER JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
    UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) n ON CHAR_LENGTH(t.product_ids) - CHAR_LENGTH(REPLACE(t.product_ids, ',', '')) >= n.n - 1
ORDER BY t.id;

comprovem que les dades s'han afegit correctament a la taula products_transactions:
SELECT * FROM products_transactions;

SELECT 
    p.id AS codi_producte,
    p.product_name AS nom_producte,
    p.category AS categoria,
    COUNT(pt.id) AS vegades_venut
FROM products AS p
INNER JOIN products_transactions AS pt ON p.id = pt.product_id
GROUP BY p.id, p.product_name, p.category
ORDER BY vegades_venut DESC;


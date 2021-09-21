/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals(
id INT GENERATED ALWAYS AS IDENTITY,
name VARCHAR(100),
date_of_birth DATE,
escape_attempts INT,
neutered BOOLEAN,
weight_kg DECIMAL(10,2),
PRIMARY KEY(id)
);

--Add a column species of type string to your animals table.
ALTER TABLE animals
ADD COLUMN species varchar(100);


--Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before tranasction.
BEGIN;

UPDATE animals SET species = 'unspecified';

ROLLBACK;


/*
Inside a transaction:
  Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
  Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
  Commit the transaction.
  Verify that change was made and persists after commit.
*/
BEGIN;

UPDATE animals SET species = 'digimon' WHERE name like '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;


--Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
BEGIN;

DELETE FROM animals;

ROLLBACK;

/*
Inside a transaction:
  Delete all animals born after Jan 1st, 2022.
  Create a savepoint for the transaction.
  Update all animals' weight to be their weight multiplied by -1.
  Rollback to the savepoint
  Update all animals' weights that are negative to be their weight multiplied by -1.
  Commit transaction
*/
BEGIN;

DELETE FROM animals WHERE date_of_birth > '01-01-2022';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg*-1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;

COMMIT;
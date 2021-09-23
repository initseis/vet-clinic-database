/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '01-01-2016' AND '12-31-2019';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


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


/*
Write queries to answer the following questions:
  How many animals are there?
  How many animals have never tried to escape?
  What is the average weight of animals?
  Who escapes the most, neutered or not neutered animals?
  What is the minimum and maximum weight of each type of animal?
  What is the average number of escape attempts per animal type of those born between 1990 and 2000?
*/
SELECT COUNT(*) AS animals_count FROM animals;
SELECT COUNT(*) AS animals_tried_escape FROM animals WHERE escape_attempts > 0;
SELECT AVG(weight_kg) AS average_weight FROM animals;
SELECT neutered, SUM(escape_attempts) AS escape_count FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg)  FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '01-01-1990' AND '12-31-2000' GROUP BY species;


--## Vet clinic database: query multiple tables

select a.name from animals a inner join owners o on a.owner_id = o.id and o.full_name = 'Melody Pond';
select a.name from animals a inner join species e on a.species_id = e.id and e.name = 'Pokemon';
select o.full_name owner_name, a.name animal_name from animals a right join owners o on a.owner_id = o.id or (o.id is null);
select e.name, count(a.species_id) from animals a inner join species e on a.species_id = e.id group by e.name;
select a.name from animals a inner join owners o on a.owner_id = o.id inner join species e on a.species_id = e.id and o.full_name = 'Jennifer Orwell' and e.name = 'Digimon';
select a.name from animals a inner join owners o on a.owner_id = o.id and o.full_name = 'Dean Winchester' and a.escape_attempts = 0;
select full_name, max(animals_quantity) from (select o.full_name, count(a.owner_id) animals_quantity from animals a inner join owners o on a.owner_id = o.id group by o.full_name) as a group by full_name order by max desc limit 1;




--## Vet clinic database: add "join table" for visits
select animal_name from (select a.name animal_name, ve.name, v.visit_date from animals a inner join visits v on a.id = v.animals_id inner join vets ve on v.vets_id = ve.id and ve.name = 'William Tatcher' order by v.visit_date desc limit 1) as r;
select count(distinct a.name) seen_animals from animals a inner join visits v on a.id = v.animals_id inner join vets ve on v.vets_id = ve.id and ve.name = 'Stephanie Mendez';
select ve.name vet_name, spe.name vet_specialization from vets ve left join specializations s on ve.id = s.vets_id left join species spe on s.species_id = spe.id;
select a.name animal_name from animals a inner join visits v on a.id = v.animals_id inner join vets ve on v.vets_id = ve.id and ve.name = 'Stephanie Mendez' and (v.visit_date between '04-01-2020' and '08-30-2020');
select most_visits from (select a.name most_visits, count(a.name) from animals a inner join visits v on a.id = v.animals_id group by a.name order by count desc limit 1) as r;
select a.name Maisy_first_visit from animals a inner join visits v on a.id = v.animals_id inner join vets ve on v.vets_id = ve.id and ve.name = 'Maisy Smith' order by v.visit_date asc limit 1;
select a.name, ve.name, v.visit_date from animals a inner join visits v on a.id = v.animals_id inner join vets ve on v.vets_id = ve.id order by v.visit_date desc limit 1;
select (select count(visit_date) from visits)-count(visit_date) from visits v inner join animals a on v.animals_id = a.id inner join species spe on a.species_id = spe.id inner join vets ve on v.vets_id = ve.id inner join (select ve.name vet_name, spe.name species_name from vets ve left join specializations s on s.vets_id = ve.id left join species spe on s.species_id = spe.id) as r on ve.name = r.vet_name where spe.name = r.species_name;
select s.name from vets ve inner join visits v on ve.id = v.vets_id inner join animals a on v.animals_id = a.id inner join species s on a.species_id = s.id and ve.name = 'Maisy Smith' group by s.name order by count(s.name) desc limit 1;
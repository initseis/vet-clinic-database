/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '01-01-2016' AND '12-31-2019';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


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
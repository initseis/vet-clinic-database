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


--## Vet clinic database: query multiple tables

CREATE TABLE owners(
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(100),
  age INT,
  PRIMARY KEY(id)
);

CREATE TABLE species(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100),
  PRIMARY KEY(id)
);

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INT;

ALTER TABLE animals 
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owner_id INT;

ALTER TABLE animals 
ADD CONSTRAINT fk_owners
FOREIGN KEY (owner_id)
REFERENCES owners(id);




--## Vet clinic database: add "join table" for visits
create table vets(
	id int GENERATED ALWAYS AS IDENTITY,
	name varchar(100),
	age int,
	date_of_graduation date,
	primary key(id)
);

create table specializations(
	vets_id int,
	species_id int,
	foreign key (vets_id) references vets(id),
	foreign key (species_id) references species(id)
);

create table visits(
	vets_id int,
	animals_id int,
	visit_date date,
	foreign key (vets_id) references vets(id),
	foreign key (animals_id) references animals(id)	
);
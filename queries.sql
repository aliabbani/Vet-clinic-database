/*Queries that provide answers to the questions from all projects.*/

/* Find all animals whose name ends in "mon". */
SELECT * FROM animals WHERE name LIKE '%mon';
/* List the name of all animals born between 2016 and 2019. */
SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 2016 AND 2020;
/* List the name of all animals that are neutered and have less than 3 escape attempts. */
SELECT name FROM animals WHERE neutered=true AND escape_attempts<3;
/* List date of birth of all animals named either "Agumon" or "Pikachu". */
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
/* List name and escape attempts of animals that weigh more than 10.5kg. */
SELECT name, escape_attempts FROM animals WHERE weight_kg>10.5;
/* Find all animals that are neutered. */
SELECT * FROM animals WHERE neutered=true;
/* Find all animals not named Gabumon. */
SELECT * FROM animals WHERE name!='Gabumon';
/* Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;


/* Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before tranasction. */
BEGIN;
ALTER TABLE animals RENAME COLUMN species TO unspecified;
SELECT * FROM animals ;
ROLLBACK;

/* Inside a transaction: */
BEGIN;
/* Update the animals table by setting the species column to digimon for all animals that have a name ending in mon. */
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
/* Update the animals table by setting the species column to pokemon for all animals that don't have species already set. */
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
/* Commit the transaction. */
COMMIT;
/* Verify that change was made and persists after commit. */
SELECT * FROM animals ;

/* Inside a transaction delete all records in the animals table, then roll back the transaction. */
BEGIN;
DELETE FROM animals;
SELECT * FROM animals ;
ROLLBACK;

/* After the roll back verify if all records in the animals table still exist. */
SELECT * FROM animals ;

/* Inside a transaction: */
BEGIN;
/* Delete all animals born after Jan 1st, 2022. */
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
/* Create a savepoint for the transaction. */
SAVEPOINT SP1;
/* Update all animals' weight to be their weight multiplied by -1. */
UPDATE animals SET weight_kg = weight_kg * '-1' ;
/* Rollback to the savepoint */
ROLLBACK TO SP1;
/* Update all animals' weights that are negative to be their weight multiplied by -1. */
UPDATE animals SET weight_kg = weight_kg * '-1' WHERE id IN (5, 7, 8);
/* Commit transaction */
COMMIT;

/* How many animals are there? */
SELECT COUNT(*) FROM animals;
/* How many animals have never tried to escape? */
SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;
/* What is the average weight of animals? */
SELECT AVG(weight_kg) FROM animals;
/* Who escapes the most, neutered or not neutered animals? */
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
/* What is the minimum and maximum weight of each type of animal? */
SELECT MIN(weight_kg), MAX(weight_kg) FROM animals;
/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT AVG(escape_attempts) FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 1990 AND 2000;

-- Write queries (using JOIN) to answer the following questions:
-- What animals belong to Melody Pond?
SELECT animals.name, animals.owners_id, owners.id, owners.full_name 
FROM animals 
INNER JOIN owners 
ON animals.owners_id = owners.id 
WHERE owners.id = 4;
-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name, animals.species_id, species.id, species.name 
FROM animals 
INNER JOIN species
ON animals.species_id = species.id 
WHERE species.id = 1;
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT animals.name, animals.owners_id, owners.id, owners.full_name 
FROM animals 
RIGHT JOIN owners 
ON animals.owners_id = owners.id;
-- How many animals are there per species?
SELECT COUNT(A.species_id), S.id
FROM animals A
INNER JOIN species S
ON A.species_id = S.id 
GROUP BY S.id;
-- List all Digimon owned by Jennifer Orwell.
SELECT A.id, A.name
FROM animals A
INNER JOIN owners O ON A.owners_id = O.id
INNER JOIN species S ON A.species_id = S.id
WHERE O.id = 1 AND S.id = 2;
-- List all animals owned by Dean Winchester that haven't tried to escape.
N/A
-- Who owns the most animals?
SELECT COUNT(A.owners_id), O.full_name
FROM animals A
INNER JOIN owners O
ON A.owners_id = O.id
GROUP BY O.id;




-- Write queries to answer the following:
-- Who was the last animal seen by William Tatcher?
SELECT A.name AS animal_name, S.name AS vet_name, V.date_of_visit
FROM visits V
INNER JOIN animals A ON A.id = V.animals_id
INNER JOIN vets S ON S.id = V.vets_id
WHERE V.vets_id = 2
GROUP BY A.name, S.name, V.date_of_visit
ORDER BY V.date_of_visit DESC LIMIT 1;
-- How many different animals did Stephanie Mendez see?
SELECT COUNT(V.animals_id)
FROM visits V
WHERE V.vets_id = 4;
-- List all vets and their specialties, including vets with no specialties.
SELECT V.name AS vets_name, S.name AS species
FROM specializations P
FULL JOIN vets V ON V.id =P.vets_id
FULL JOIN species S ON S.id = P.species_id;
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT A.name AS animal_name
FROM visits V
INNER JOIN animals A ON A.id = V.animals_id
WHERE V.vets_id = 4 AND V.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';
-- What animal has the most visits to vets? 
SELECT A.name AS animal_name, COUNT(A.name)
FROM visits V
INNER JOIN animals A ON A.id = V.animals_id
GROUP BY A.name
ORDER BY count DESC LIMIT 1;
-- Who was Maisy Smith's first visit?
SELECT MIN(V.date_of_visit), A.name AS animal_name
FROM visits V
INNER JOIN animals A ON A.id = V.animals_id
WHERE V.vets_id = 3
GROUP BY animal_name, V.date_of_visit
ORDER BY V.date_of_visit ASC LIMIT 1;
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT MAX(V.date_of_visit) AS most_recent_visit, A.name AS animal_name, A.date_of_birth, A.escape_attempts, A.weight_kg, T.name AS vets_name, T.age, T.date_of_graduation
FROM visits V
INNER JOIN animals A ON A.id = V.animals_id
INNER JOIN vets T ON T.id = V.vets_id
GROUP BY V.date_of_visit, animal_name, A.date_of_birth, A.escape_attempts, A.weight_kg, vets_name, T.age, T.date_of_graduation
ORDER BY V.date_of_visit DESC LIMIT 1;
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(V.animals_id)
FROM visits V
WHERE V.vets_id = 3;
-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT COUNT(V.animals_id), A.species_id, S.name
FROM animals A
INNER JOIN visits V ON V.animals_id = A.id
INNER JOIN species S ON S.id = A.species_id
WHERE V.vets_id = 3
GROUP BY A.species_id, S.name
ORDER BY count DESC LIMIT 1;

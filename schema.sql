/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(30) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL NOT NULL,
  species VARCHAR(50),
  PRIMARY KEY(id)
);

-- Create a table named owners with the following columns: id: integer (set it as autoincremented PRIMARY KEY) full_name: string age: integer
CREATE TABLE owners(
id SERIAL PRIMARY KEY,
full_name VARCHAR(50) NOT NULL,
age INT
);

-- Create a table named species with the following columns: id: integer (set it as autoincremented PRIMARY KEY) name: string
CREATE TABLE species(
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL
);

-- Modify animals table:
-- Make sure that id is set as autoincremented PRIMARY KEY
Yes
-- Remove column species
ALTER TABLE animals DROP species;
-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD species_id INT,
Add CONSTRAINT fk_species FOREIGN KEY(id) REFERENCES species(id);
-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD owners_id INT,
Add CONSTRAINT fk_owners FOREIGN KEY(owners_id) REFERENCES owners(id);

-- Create a table named vets with the following columns: id: integer (set it as autoincremented PRIMARY KEY) | name: string | age: integer | date_of_graduation: date
CREATE TABLE vets(
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
age INT NOT NULL,
date_of_graduation DATE NOT NULL
);

-- There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.
CREATE TABLE specializations(
	species_id INT NOT NULL,
	vets_id INT NOT NULL,
	FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY (species_id, vets_id)
);

-- There is a many-to-many relationship between the tables animals and vets: an animal can visit multiple vets and one vet can be visited by multiple animals. Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit.
CREATE TABLE visits(
	animals_id INT NOT NULL,
	vets_id INT NOT NULL,
  date_of_visit DATE NOT NULL,
  id INT GENERATED ALWAYS AS IDENTITY,
	FOREIGN KEY (animals_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  PRIMARY KEY(id)
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animals_id, vets_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animals_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;
INSERT INTO visits (animals_id, vets_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animals_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

-- Depening on your machine speed, it might be enough or not. Check that by running 
explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;

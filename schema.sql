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
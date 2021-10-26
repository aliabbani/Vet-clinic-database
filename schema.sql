/* Database schema to keep the structure of entire database. */
/* ALTER TABLE animals ADD species VARCHAR(50); */

CREATE TABLE animals(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(30) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL NOT NULL,
  species VARCHAR(50)
  PRIMARY KEY(id)
);

CREATE TABLE patients (
  id INT SERIAL,
  name VARCHAR(50),
  date_of_birth DATE,
  PRIMARY KEY (id)
);

CREATE TABLE invoices (
  id INT SERIAL,
  total_amount DECIMAL,
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_history_id INT,
  PRIMARY KEY (id)
);

CREATE TABLE medical_histories (
  id INT SERIAL,
  admitted_at TIMESTAMP,
  patient_id INT,
  status VARCHAR(50),
  PRIMARY KEY (id),
  CONSTRAINT FK_medical_histories.patient_id
    FOREIGN KEY (patient_id)
      REFERENCES patients(id)
);

CREATE TABLE treatments (
  id INT SERIAL,
  type VARCHAR(50),
  name VARCHAR(50),
  PRIMARY KEY (id)
);


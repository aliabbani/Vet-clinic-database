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

CREATE INDEX ON medical_histories (patient_id);

CREATE TABLE treatments (
  id INT SERIAL,
  type VARCHAR(50),
  name VARCHAR(50),
  PRIMARY KEY (id)
);

CREATE TABLE invoice_items (
  id INT SERIAL,
  unit_price DECIMAL,
  quantity INT,
  total_price DECIMAL,
  invoice_id INT,
  treatment_id INT,
  PRIMARY KEY (id),
  CONSTRAINT FK_invoice_items.invoice_id
    FOREIGN KEY (invoice_id)
      REFERENCES invoices(id),
  CONSTRAINT FK_invoice_items.treatment_id
    FOREIGN KEY (treatment_id)
      REFERENCES treatments(id)
);

CREATE INDEX ON invoice_items (invoice_id);
CREATE INDEX ON invoice_items (treatment_id);

CREATE TABLE history_treatment_connection (
  id  INT SERIAL,
  treatment_id INT,
  history_id INT,
  PRIMARY KEY (id ),
  CONSTRAINT FK_history_treatment_connection.treatment_id
    FOREIGN KEY (treatment_id)
      REFERENCES treatments(id),
  CONSTRAINT FK_history_treatment_connection.history_id
    FOREIGN KEY (history_id)
      REFERENCES medical_histories(id)
);

CREATE INDEX ON history_treatment_connection (treatment_id);
CREATE INDEX ON history_treatment_connection (history_id);

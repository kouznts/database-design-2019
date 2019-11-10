use airport_db;

ALTER TABLE aircraft
ADD CHECK (aircraft_id > 0);

ALTER TABLE cashier
ADD CHECK (cashier_id > 0);

ALTER TABLE aircrew
ADD CHECK (aircrew_id > 0);

ALTER TABLE aircrew
ADD CHECK (admission_group >= 1 AND admission_group <= 4);

ALTER TABLE pilot
ADD CHECK (pilot_id > 0);

ALTER TABLE pilot
ADD CHECK (number_of_flights >= 0);

ALTER TABLE pilot
ADD CHECK (admission_group >= 1 AND admission_group <= 4);

ALTER TABLE copilot
ADD CHECK (copilot_id > 0);

ALTER TABLE copilot
ADD CHECK (number_of_flights >= 0);

ALTER TABLE copilot
ADD CHECK (admission_group >= 1 AND admission_group <= 4);

ALTER TABLE flight
ADD CHECK (flight_id > 0);

ALTER TABLE model
ADD CHECK (admission_group >= 1 AND admission_group <= 4);

ALTER TABLE model
ADD CHECK (run_length > 0);

ALTER TABLE model
ADD CHECK (takeoff_weight > 0);

ALTER TABLE model
ADD CHECK (height > 0);

ALTER TABLE model
ADD CHECK (number_of_seats > 0);

ALTER TABLE model
ADD CHECK (speed > 0);

ALTER TABLE passenger
ADD CHECK (passenger_id > 0);

ALTER TABLE ticket
ADD CHECK (ticket_id > 0);
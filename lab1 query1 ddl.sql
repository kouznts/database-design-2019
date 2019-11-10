use airport_db


CREATE TABLE aircraft
( 
	aircraft_id          smallint IDENTITY (1, 1) NOT NULL ,
	model_name           varchar(100)  NOT NULL 
)
go

CREATE TABLE aircrew
( 
	aircrew_id           smallint IDENTITY (1, 1) NOT NULL ,
	admission_group      smallint  NOT NULL ,
	pilot_id             smallint  NULL ,
	copilot_id           smallint  NULL 
)
go

CREATE TABLE cashier
( 
	cashier_id           smallint IDENTITY (1, 1) NOT NULL ,
	full_name            varchar(100)  NOT NULL 
)
go

CREATE TABLE copilot
( 
	copilot_id           smallint IDENTITY (1, 1) NOT NULL ,
	full_name            varchar(100)  NOT NULL ,
	admission_group      tinyint  NOT NULL ,
	number_of_flights    smallint  NOT NULL
)
go

CREATE TABLE flight
( 
	flight_id            int IDENTITY (1, 1) NOT NULL ,
	aircrew_id           smallint  NOT NULL ,
	destination          varchar(100)  NOT NULL ,
	departure_date       datetime  NOT NULL ,
	arrival_date         datetime  NOT NULL ,
	aircraft_id          smallint  NOT NULL 
)
go

CREATE TABLE model
( 
	model_name           varchar(100)  NOT NULL ,
	admission_group      tinyint  NOT NULL ,
	fuel                 varchar(100)  NOT NULL ,
	run_length           smallint  NOT NULL ,
	takeoff_weight       int  NOT NULL ,
	height               smallint  NOT NULL ,
	number_of_seats      smallint  NOT NULL ,
	speed                smallint  NOT NULL 
)
go

CREATE TABLE passenger
( 
	passenger_id         int IDENTITY (1, 1) NOT NULL ,
	full_name            varchar(100)  NOT NULL 
)
go

CREATE TABLE pilot
( 
	pilot_id             smallint IDENTITY (1, 1) NOT NULL ,
	full_name            varchar(100)  NOT NULL ,
	admission_group      tinyint  NOT NULL ,
	number_of_flights    smallint  NOT NULL
)
go

CREATE TABLE ticket
( 
	ticket_id            bigint IDENTITY (1, 1) NOT NULL ,
	price                smallmoney  NOT NULL ,
	cashier_id           smallint  NULL ,
	passenger_id         int  NULL ,
	flight_id            int  NOT NULL
)
go


ALTER TABLE aircraft
	ADD CONSTRAINT XPKaircraft PRIMARY KEY  CLUSTERED (aircraft_id ASC)
go

ALTER TABLE aircrew
	ADD CONSTRAINT XPKaircrew PRIMARY KEY  CLUSTERED (aircrew_id ASC)
go

ALTER TABLE cashier
	ADD CONSTRAINT XPKcashier PRIMARY KEY  CLUSTERED (cashier_id ASC)
go

ALTER TABLE copilot
	ADD CONSTRAINT XPKcopilot PRIMARY KEY  CLUSTERED (copilot_id ASC)
go

ALTER TABLE flight
	ADD CONSTRAINT XPKflight PRIMARY KEY  CLUSTERED (flight_id ASC)
go

ALTER TABLE passenger
	ADD CONSTRAINT XPKpassenger PRIMARY KEY  CLUSTERED (passenger_id ASC)
go

ALTER TABLE pilot
	ADD CONSTRAINT XPKpilot PRIMARY KEY  CLUSTERED (pilot_id ASC)
go

ALTER TABLE ticket
	ADD CONSTRAINT XPKticket PRIMARY KEY  CLUSTERED (ticket_id ASC)
go


ALTER TABLE aircraft
	ADD CONSTRAINT is_model_name FOREIGN KEY (model_name) REFERENCES model(model_name)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE aircrew
	ADD CONSTRAINT in_pilot_id FOREIGN KEY (pilot_id) REFERENCES pilot(pilot_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE aircrew
	ADD CONSTRAINT in_copilot_id FOREIGN KEY (copilot_id) REFERENCES copilot(copilot_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE flight
	ADD CONSTRAINT on_aircraft_id FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE flight
	ADD CONSTRAINT on_aircrew_id FOREIGN KEY (aircrew_id) REFERENCES aircrew(aircrew_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE ticket
	ADD CONSTRAINT sold FOREIGN KEY (cashier_id) REFERENCES cashier(cashier_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE ticket
	ADD CONSTRAINT bought FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE ticket
	ADD CONSTRAINT is_on_flight_id FOREIGN KEY (flight_id) REFERENCES flight(flight_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_aircraft ON aircraft FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,flight
      WHERE
        flight.aircraft_id = deleted.aircraft_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить самолёт'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,model
      WHERE
        deleted.model_name = model.model_name AND
        NOT EXISTS (
          SELECT * FROM aircraft
          WHERE
            aircraft.model_name = model.model_name
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить самолёт'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_aircraft ON aircraft FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insaircraft_id smallint,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(aircraft_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,flight
      WHERE
        flight.aircraft_id = deleted.aircraft_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить самолёт'
      GOTO ERROR
    END
  END
  IF
    UPDATE(model_name)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,model
        WHERE
          inserted.model_name = model.model_name
    select @nullcnt = count(*) from inserted where
      inserted.model_name IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить самолёт'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_aircrew ON aircrew FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,flight
      WHERE
        flight.aircrew_id = deleted.aircrew_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить экипаж'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,pilot
      WHERE
        deleted.pilot_id = pilot.pilot_id AND
        NOT EXISTS (
          SELECT * FROM aircrew
          WHERE
            aircrew.pilot_id = pilot.pilot_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить экипаж'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,copilot
      WHERE
        deleted.copilot_id = copilot.copilot_id AND
        NOT EXISTS (
          SELECT * FROM aircrew
          WHERE
            aircrew.copilot_id = copilot.copilot_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить экипаж'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_aircrew ON aircrew FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insaircrew_id smallint,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(aircrew_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,flight
      WHERE
        flight.aircrew_id = deleted.aircrew_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить экипаж'
      GOTO ERROR
    END
  END
  IF
    UPDATE(pilot_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,pilot
        WHERE
          inserted.pilot_id = pilot.pilot_id
    select @nullcnt = count(*) from inserted where
      inserted.pilot_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить экипаж'
      GOTO ERROR
    END
  END
  IF
    UPDATE(copilot_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,copilot
        WHERE
          inserted.copilot_id = copilot.copilot_id
    select @nullcnt = count(*) from inserted where
      inserted.copilot_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить экипаж'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_cashier ON cashier FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,ticket
      WHERE
        ticket.cashier_id = deleted.cashier_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить кассира'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_cashier ON cashier FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inscashier_id smallint,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(cashier_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ticket
      WHERE
        ticket.cashier_id = deleted.cashier_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить кассира'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_copilot ON copilot FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,aircrew
      WHERE
        aircrew.copilot_id = deleted.copilot_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить второго пилота'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_copilot ON copilot FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inscopilot_id smallint,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(copilot_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,aircrew
      WHERE
        aircrew.copilot_id = deleted.copilot_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить второго пилота'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_flight ON flight FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,ticket
      WHERE
        ticket.flight_id = deleted.flight_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить рейс'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,aircraft
      WHERE
        deleted.aircraft_id = aircraft.aircraft_id AND
        NOT EXISTS (
          SELECT * FROM flight
          WHERE
            flight.aircraft_id = aircraft.aircraft_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить рейс'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,aircrew
      WHERE
        deleted.aircrew_id = aircrew.aircrew_id AND
        NOT EXISTS (
          SELECT * FROM flight
          WHERE
            flight.aircrew_id = aircrew.aircrew_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить рейс'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_flight ON flight FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insflight_id integer,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(flight_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ticket
      WHERE
        ticket.flight_id = deleted.flight_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить рейс'
      GOTO ERROR
    END
  END
  IF
    UPDATE(aircraft_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,aircraft
        WHERE
          inserted.aircraft_id = aircraft.aircraft_id
    select @nullcnt = count(*) from inserted where
      inserted.aircraft_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить рейс'
      GOTO ERROR
    END
  END
  IF
    UPDATE(aircrew_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,aircrew
        WHERE
          inserted.aircrew_id = aircrew.aircrew_id
    select @nullcnt = count(*) from inserted where
      inserted.aircrew_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить рейс'
      GOTO ERROR
    END
  END

  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_model ON model FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,aircraft
      WHERE
        aircraft.model_name = deleted.model_name
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить модель'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_model ON model FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insmodel_name varchar(100),
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(model_name)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,aircraft
      WHERE
        aircraft.model_name = deleted.model_name
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить модель'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_passenger ON passenger FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,ticket
      WHERE
        ticket.passenger_id = deleted.passenger_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить пассажира'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_passenger ON passenger FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inspassenger_id int,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(passenger_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ticket
      WHERE
        ticket.passenger_id = deleted.passenger_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить пассажира'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_pilot ON pilot FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,aircrew
      WHERE
        aircrew.pilot_id = deleted.pilot_id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'невозможно удалить пилота'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_pilot ON pilot FOR UPDATE AS

BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @inspilot_id smallint,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(pilot_id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,aircrew
      WHERE
        aircrew.pilot_id = deleted.pilot_id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'невозможно обновить пилота'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tD_ticket ON ticket FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (SELECT * FROM deleted,cashier
      WHERE
        deleted.cashier_id = cashier.cashier_id AND
        NOT EXISTS (
          SELECT * FROM ticket
          WHERE
            ticket.cashier_id = cashier.cashier_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить билет'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,passenger
      WHERE
        deleted.passenger_id = passenger.passenger_id AND
        NOT EXISTS (
          SELECT * FROM ticket
          WHERE
            ticket.passenger_id = passenger.passenger_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить билет'
      GOTO ERROR
    END
    IF EXISTS (SELECT * FROM deleted,flight
      WHERE
        deleted.flight_id = flight.flight_id AND
        NOT EXISTS (
          SELECT * FROM ticket
          WHERE
            ticket.flight_id = flight.flight_id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'невозможно удалить билет'
      GOTO ERROR
    END
    RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

CREATE TRIGGER tU_ticket ON ticket FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insticket_id int,
           @errno   int,
           @errmsg  varchar(255)
  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(cashier_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,cashier
        WHERE
          inserted.cashier_id = cashier.cashier_id
    select @nullcnt = count(*) from inserted where
      inserted.cashier_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить билет'
      GOTO ERROR
    END
  END
  IF
    UPDATE(passenger_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,passenger
        WHERE
          inserted.passenger_id = passenger.passenger_id
    select @nullcnt = count(*) from inserted where
      inserted.passenger_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить билет'
      GOTO ERROR
    END
  END
  IF
    UPDATE(flight_id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,flight
        WHERE
          inserted.flight_id = flight.flight_id
    select @nullcnt = count(*) from inserted where
      inserted.flight_id IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'невозможно обновить билет'
      GOTO ERROR
    END
  END
  RETURN
ERROR:
    raiserror (@errmsg, @errno, @errno)
    rollback transaction
END
go

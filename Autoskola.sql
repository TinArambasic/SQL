SET lc_messages TO 'en_US.UTF-8';
set datestyle='ISO, YMD';
DROP TABLE IF EXISTS Ispit CASCADE;
DROP TABLE IF EXISTS Sat CASCADE;
DROP TABLE IF EXISTS Upis CASCADE;
DROP TABLE IF EXISTS Tecaj CASCADE;
DROP TABLE IF EXISTS Vozilo CASCADE;
DROP TABLE IF EXISTS InstruktorDozvole CASCADE;
DROP TABLE IF EXISTS VrstaDozvole CASCADE;
DROP TABLE IF EXISTS Instruktor CASCADE;
DROP TABLE IF EXISTS Kandidat CASCADE;

CREATE TABLE Kandidat (
    KandidatID SERIAL PRIMARY KEY,
    Ime VARCHAR(50) NOT NULL,
    Prezime VARCHAR(50) NOT NULL,
    Adresa TEXT NOT NULL,
    Telefon VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    DatumUpisa DATE NOT NULL
);

Select Ime || ' ' || Prezime as "Kandidat", DatumUpisa from Kandidat where DatumUpisa between '2024-05-01' and '2024-08-01';

CREATE TABLE Instruktor (
    InstruktorID SERIAL PRIMARY KEY,
    Ime VARCHAR(50) NOT NULL,
    Prezime VARCHAR(50) NOT NULL,
    Telefon VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    DatumZaposlenja DATE NOT NULL
);

CREATE TABLE VrstaDozvole (
    VrstaDozvoleID SERIAL PRIMARY KEY,
    Kategorija VARCHAR(10) NOT NULL UNIQUE,
    Opis TEXT
);

CREATE TABLE InstruktorDozvole (
    InstruktorID INTEGER NOT NULL,
    VrstaDozvoleID INTEGER NOT NULL,
    PRIMARY KEY (InstruktorID, VrstaDozvoleID),
    FOREIGN KEY (InstruktorID) REFERENCES Instruktor(InstruktorID),
    FOREIGN KEY (VrstaDozvoleID) REFERENCES VrstaDozvole(VrstaDozvoleID)
);

CREATE TABLE Vozilo (
    VoziloID SERIAL PRIMARY KEY,
    Registracija VARCHAR(20) NOT NULL UNIQUE,
    Marka VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    GodinaProizvodnje INTEGER NOT NULL,
    VrstaMjenjaca VARCHAR(20) NOT NULL,
    VrstaDozvoleID INTEGER NOT NULL,
    FOREIGN KEY (VrstaDozvoleID) REFERENCES VrstaDozvole(VrstaDozvoleID)
);

CREATE TABLE Tecaj (
    TecajID SERIAL PRIMARY KEY,
    Naziv VARCHAR(100) NOT NULL,
    Opis TEXT NOT NULL,
    Trajanje INTEGER NOT NULL,
    Cijena NUMERIC(10,2) NOT NULL,
    VrstaDozvoleID INTEGER NOT NULL,
    FOREIGN KEY (VrstaDozvoleID) REFERENCES VrstaDozvole(VrstaDozvoleID)
);

CREATE TABLE Upis (
    UpisID SERIAL PRIMARY KEY,
    KandidatID INTEGER NOT NULL,
    TecajID INTEGER NOT NULL,
    DatumUpisa DATE NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK(Status IN ('Aktivan', 'Završen', 'Otkazan')),
    FOREIGN KEY (KandidatID) REFERENCES Kandidat(KandidatID),
    FOREIGN KEY (TecajID) REFERENCES Tecaj(TecajID)
);
Select KandidatID, TecajID, Status from Upis where TecajID=2 and Status='Aktivan';

CREATE TABLE Sat (
    SatID SERIAL PRIMARY KEY,
    UpisID INTEGER NOT NULL,
    InstruktorID INTEGER NOT NULL,
    VoziloID INTEGER NOT NULL,
    DatumSata TIMESTAMP NOT NULL,
    Trajanje INTEGER NOT NULL,
    VrstaSata VARCHAR(50) NOT NULL,
    FOREIGN KEY (UpisID) REFERENCES Upis(UpisID),
    FOREIGN KEY (InstruktorID) REFERENCES Instruktor(InstruktorID),
    FOREIGN KEY (VoziloID) REFERENCES Vozilo(VoziloID)
);

CREATE TABLE Ispit (
    IspitID SERIAL PRIMARY KEY,
    UpisID INTEGER NOT NULL,
    DatumIspita DATE NOT NULL,
    Rezultat VARCHAR(20) NOT NULL CHECK(Rezultat IN ('Položen', 'Nije položen', 'Nije izašao')),
    InstruktorID INTEGER NOT NULL,
    FOREIGN KEY (UpisID) REFERENCES Upis(UpisID),
    FOREIGN KEY (InstruktorID) REFERENCES Instruktor(InstruktorID)
);

Commit;



TRUNCATE TABLE Ispit, Sat, Upis, Tecaj, Vozilo, InstruktorDozvole, VrstaDozvole, Instruktor, Kandidat RESTART IDENTITY;


INSERT INTO Kandidat (Ime, Prezime, Adresa, Telefon, Email, DatumUpisa) VALUES
('Marko', 'Horvat', 'Ilica 12, Zagreb', '0911234567', 'marko.horvat@email.com', '2024-01-15'),
('Ana', 'Kovačević', 'Trg bana Jelačića 5, Zagreb', '0922345678', 'ana.kovacevic@email.com', '2024-01-20'),
('Ivan', 'Babić', 'Vukovarska 33, Split', '0953456789', 'ivan.babic@email.com', '2024-02-01'),
('Petra', 'Jurić', 'Strossmayerova 8, Rijeka', '0984567890', 'petra.juric@email.com', '2024-02-10'),
('Luka', 'Novak', 'Gundulićeva 22, Osijek', '0995678901', 'luka.novak@email.com', '2024-02-18'),
('Maja', 'Knežević', 'Korzo 17, Rijeka', '0916789012', 'maja.knezevic@email.com', '2024-03-05'),
('Josip', 'Marković', 'Domovinskog rata 44, Zadar', '0927890123', 'josip.markovic@email.com', '2024-03-12'),
('Iva', 'Tomić', 'Frankopanska 9, Dubrovnik', '0958901234', 'iva.tomic@email.com', '2024-03-22'),
('Filip', 'Pavlović', 'Varaždinska 3, Varaždin', '0989012345', 'filip.pavlovic@email.com', '2024-04-02'),
('Elena', 'Božić', 'Kolodvorska 11, Zagreb', '0990123456', 'elena.bozic@email.com', '2024-04-15'),
('Ante', 'Lovrić', 'Matije Gupca 7, Sisak', '0911234500', 'ante.lovric@email.com', '2024-05-03'),
('Marija', 'Vuković', 'Kralja Tomislava 15, Karlovac', '0922345600', 'marija.vukovic@email.com', '2024-05-10'),
('Davor', 'Radić', 'Stjepana Radića 25, Slavonski Brod', '0953456700', 'davor.radic@email.com', '2024-05-20'),
('Lara', 'Petrović', 'Ante Starčevića 30, Pula', '0984567800', 'lara.petrovic@email.com', '2024-06-01'),
('Karlo', 'Matić', 'Radićeva 18, Šibenik', '0995678900', 'karlo.matic@email.com', '2024-06-08'),
('Tea', 'Kralj', 'Vatroslava Lisinskog 5, Zagreb', '0916789000', 'tea.kralj@email.com', '2024-06-15'),
('Zoran', 'Perić', 'Splitska 2, Dubrovnik', '0927890000', 'zoran.peric@email.com', '2024-06-25'),
('Sandra', 'Jakovljević', 'Zagrebačka 55, Vinkovci', '0958900000', 'sandra.jakovljevic@email.com', '2024-07-03'),
('Tomislav', 'Šimić', 'Vukovarska 88, Osijek', '0989000000', 'tomislav.simic@email.com', '2024-07-10'),
('Nika', 'Kovačić', 'Heinzelova 42, Zagreb', '0990000000', 'nika.kovacic@email.com', '2024-07-18');


INSERT INTO Instruktor (Ime, Prezime, Telefon, Email, DatumZaposlenja) VALUES
('Ivan', 'Horvat', '0911122333', 'ivan.horvat@autoskola.hr', '2018-03-12'),
('Sanja', 'Kovačić', '0922233444', 'sanja.kovacic@autoskola.hr', '2019-05-20'),
('Mario', 'Babić', '0953344555', 'mario.babic@autoskola.hr', '2020-01-15'),
('Tanja', 'Jurić', '0984455666', 'tanja.juric@autoskola.hr', '2020-08-30');


INSERT INTO VrstaDozvole (Kategorija, Opis) VALUES
('A1', 'Motocikli do 125 cm³, snage do 11 kW'),
('A2', 'Motocikli snage do 35 kW'),
('A', 'Motocikli bez ograničenja snage'),
('B', 'Automobili do 3.500 kg (uključuje F kategoriju)'),
('C', 'Teretna vozila preko 3.500 kg');


INSERT INTO InstruktorDozvole (InstruktorID, VrstaDozvoleID)
SELECT i.InstruktorID, v.VrstaDozvoleID
FROM Instruktor i
CROSS JOIN VrstaDozvole v;

INSERT INTO Vozilo (Registracija, Marka, Model, GodinaProizvodnje, VrstaMjenjaca, VrstaDozvoleID) VALUES
-- Igor Horvat
('ZG1000A1', 'Yamaha', 'YZF-R125', 2023, 'Ručni', 1),
('ZG1000A2', 'Kawasaki', 'Ninja 400', 2022, 'Ručni', 2),
('ZG1000A', 'BMW', 'R 1250 GS', 2023, 'Ručni', 3),
('ZG1000B', 'Volkswagen', 'Golf 8', 2023, 'Automatski', 4),
('ZG1000C', 'MAN', 'TGE 3.140', 2022, 'Ručni', 5),

-- Sanja Kovačić
('ZG2000A1', 'Honda', 'CBR125R', 2023, 'Ručni', 1),
('ZG2000A2', 'Yamaha', 'MT-07', 2022, 'Ručni', 2),
('ZG2000A', 'Ducati', 'Multistrada V4', 2023, 'Ručni', 3),
('ZG2000B', 'Škoda', 'Octavia', 2023, 'Automatski', 4),
('ZG2000C', 'Mercedes', 'Sprinter', 2022, 'Automatski', 5),

-- Mario Babić
('ZG3000A1', 'KTM', '125 Duke', 2023, 'Ručni', 1),
('ZG3000A2', 'Honda', 'CBR500R', 2022, 'Ručni', 2),
('ZG3000A', 'KTM', '1290 Super Duke R', 2023, 'Ručni', 3),
('ZG3000B', 'Renault', 'Clio', 2023, 'Ručni', 4),
('ZG3000C', 'Ford', 'Transit', 2022, 'Ručni', 5),

-- Tanja Jurić
('ZG4000A1', 'Suzuki', 'GSX-R125', 2023, 'Ručni', 1),
('ZG4000A2', 'KTM', '390 Duke', 2022, 'Ručni', 2),
('ZG4000A', 'Harley-Davidson', 'Sportster S', 2023, 'Ručni', 3),
('ZG4000B', 'Peugeot', '208', 2023, 'Automatski', 4),
('ZG4000C', 'Iveco', 'Daily', 2022, 'Automatski', 5);

INSERT INTO Tecaj (Naziv, Opis, Trajanje, Cijena, VrstaDozvoleID) VALUES
('Tečaj za A1', 'Osnovna obuka za motocikle do 125cc', 35, 2200.00, 1),
('Tečaj za A2', 'Obuka za motocikle do 35kW', 40, 2800.00, 2),
('Tečaj za A', 'Potpuna obuka za motocikle', 50, 3500.00, 3),
('Tečaj za B', 'Osnovna obuka za osobne automobile', 40, 2500.00, 4),
('Tečaj za C', 'Obuka za teretna vozila', 60, 4500.00, 5);

-- Upisi
INSERT INTO Upis (KandidatID, TecajID, DatumUpisa, Status) VALUES
(1, 4, '2024-01-15', 'Aktivan'),  -- B
(2, 4, '2024-01-20', 'Završen'),  -- B
(3, 1, '2024-02-01', 'Otkazan'),  -- A1
(4, 2, '2024-02-10', 'Aktivan'),  -- A2
(5, 3, '2024-02-18', 'Završen'),  -- A
(6, 5, '2024-03-05', 'Aktivan'),  -- C
(7, 4, '2024-03-12', 'Završen'),  -- B
(8, 5, '2024-03-22', 'Aktivan'),  -- C
(9, 1, '2024-04-02', 'Otkazan'),  -- A1
(10, 2, '2024-04-15', 'Završen'), -- A2
(11, 3, '2024-05-03', 'Aktivan'), -- A
(12, 4, '2024-05-10', 'Završen'), -- B
(13, 5, '2024-05-20', 'Aktivan'), -- C
(14, 1, '2024-06-01', 'Otkazan'), -- A1
(15, 2, '2024-06-08', 'Završen'), -- A2
(16, 3, '2024-06-15', 'Aktivan'), -- A
(17, 4, '2024-06-25', 'Završen'), -- B
(18, 5, '2024-07-03', 'Aktivan'), -- C
(19, 1, '2024-07-10', 'Otkazan'), -- A1
(20, 2, '2024-07-18', 'Aktivan'); -- A2


INSERT INTO Sat (UpisID, InstruktorID, VoziloID, DatumSata, Trajanje, VrstaSata) VALUES
-- B kat
(1, 1, 4, '2024-01-20 10:00', 45, 'Početna obuka'),
(2, 2, 9, '2024-01-25 14:00', 60, 'Gradska vožnja'),
(7, 3, 14, '2024-03-15 16:00', 90, 'Autocesta'),
(12, 4, 19, '2024-05-12 15:00', 60, 'Parkiranje'),
(17, 1, 4, '2024-06-28 16:00', 45, 'Ispitna ruta'),

-- A1 kat
(3, 2, 6, '2024-02-05 09:30', 45, 'Osnove vožnje'),
(9, 3, 11, '2024-04-05 10:30', 45, 'Ravnoteža'),
(14, 4, 16, '2024-06-05 07:00', 60, 'Vježba kretanja'),
(19, 1, 1, '2024-07-12 14:00', 90, 'Gradska vožnja'),

-- A2 kat
(4, 3, 7, '2024-02-15 11:00', 60, 'Početna obuka'),
(10, 4, 12, '2024-04-18 14:30', 90, 'Zavojite ceste'),
(15, 1, 2, '2024-06-12 11:30', 60, 'Napredna vožnja'),
(20, 2, 7, '2024-07-20 08:30', 90, 'Ispitna priprema'),

-- A kat
(5, 4, 8, '2024-02-22 15:30', 90, 'Početna obuka'),
(11, 1, 3, '2024-05-10 09:00', 120, 'Dugolinijska vožnja'),
(16, 2, 8, '2024-06-20 13:30', 90, 'Tehničke vježbe'),

-- C kat
(6, 1, 5, '2024-03-10 13:00', 120, 'Osnove upravljanja'),
(8, 2, 10, '2024-03-25 08:00', 180, 'Teretni terminal'),
(13, 3, 15, '2024-05-25 17:30', 150, 'Nepravilni teret'),
(18, 4, 20, '2024-07-05 10:00', 120, 'Ispitna ruta');

INSERT INTO Ispit (UpisID, DatumIspita, Rezultat, InstruktorID) VALUES
(1, '2024-02-25', 'Položen', 1),
(2, '2024-02-10', 'Položen', 2),
(3, '2024-02-20', 'Nije položen', 3),
(4, '2024-03-01', 'Nije izašao', 4),
(5, '2024-03-05', 'Položen', 1),
(6, '2024-03-20', 'Položen', 2),
(7, '2024-04-02', 'Položen', 3),
(8, '2024-04-10', 'Nije položen', 4),
(9, '2024-04-20', 'Nije izašao', 1),
(10, '2024-05-02', 'Položen', 2),
(11, '2024-05-25', 'Nije položen', 3),
(12, '2024-06-01', 'Položen', 4),
(13, '2024-06-10', 'Položen', 1),
(14, '2024-06-20', 'Nije položen', 2),
(15, '2024-07-01', 'Položen', 3),
(16, '2024-07-10', 'Nije položen', 4),
(17, '2024-07-15', 'Položen', 1),
(18, '2024-07-20', 'Položen', 2),
(19, '2024-07-25', 'Nije položen', 3),
(20, '2024-08-01', 'Položen', 4);

Commit;

Select Marka, Model from Vozilo where VrstaMjenjaca='Ručni';

select Rezultat, Ime ||' '|| Prezime as "Kandidat" from Ispit 
left join Upis using(UpisID) left join Kandidat using (KandidatID);



SELECT 
    vd.Kategorija,
    COUNT(DISTINCT v.VoziloID) AS BrojVozila,
    COUNT(s.SatID) AS BrojSati,
    ROUND(COUNT(s.SatID) * 100.0 / SUM(COUNT(s.SatID)) OVER (), 1) AS Postotak
FROM Vozilo v
JOIN VrstaDozvole vd ON v.VrstaDozvoleID = vd.VrstaDozvoleID
LEFT JOIN Sat s ON v.VoziloID = s.VoziloID
GROUP BY vd.Kategorija
ORDER BY BrojSati DESC;



WITH InstruktorSati AS (
    SELECT 
        i.InstruktorID,
        i.Ime ||' '|| i.Prezime AS Instruktor,
        vd.Kategorija,
        COUNT(s.SatID) AS BrojSati,
        SUM(s.Trajanje) AS UkupnoTrajanje,
        v.Marka ||' '|| v.Model AS Vozila
    FROM Instruktor i
    JOIN Sat s ON i.InstruktorID = s.InstruktorID
    JOIN Vozilo v ON s.VoziloID = v.VoziloID
    JOIN VrstaDozvole vd ON v.VrstaDozvoleID = vd.VrstaDozvoleID
    GROUP BY i.InstruktorID, vd.Kategorija, v.marka, v.model
),
UkupniSati AS (
    SELECT SUM(BrojSati) AS TotalSati
    FROM InstruktorSati
)
SELECT 
    isa.Instruktor,
    isa.Kategorija,
    isa.BrojSati,
    isa.UkupnoTrajanje,
    isa.Vozila,
    ROUND((isa.BrojSati * 100.0) / us.TotalSati, 2) AS PostotakUkupno
FROM InstruktorSati isa
CROSS JOIN UkupniSati us
ORDER BY BrojSati DESC;

ALTER TABLE Upis ADD COLUMN DatumZavrsetka DATE;
commit;

CREATE OR REPLACE FUNCTION provjeri_datume()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.DatumZavrsetka IS NOT NULL AND NEW.DatumZavrsetka < NEW.DatumUpisa THEN
        RAISE EXCEPTION 'Datum završetka % ne može biti prije datuma upisa %', 
                        NEW.DatumZavrsetka, NEW.DatumUpisa;
    END IF;
    RETURN NEW;
END;
$$LANGUAGE plpgsql;
commit;

CREATE TRIGGER sprijeci_datume
BEFORE INSERT OR UPDATE ON Upis
FOR EACH ROW
EXECUTE FUNCTION provjeri_datume();
commit;

INSERT INTO Upis (KandidatID, TecajID, DatumUpisa, DatumZavrsetka, Status)
VALUES (1, 4, '2024-01-15', '2024-02-15', 'Završen');


INSERT INTO Upis (KandidatID, TecajID, DatumUpisa, DatumZavrsetka, Status)
VALUES (2, 5, '2024-03-01', '2024-02-01', 'Završen');


CREATE OR REPLACE PROCEDURE promijeni_cijenu_kategorije_C(
    IN nova_cijena NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Tecaj
    SET Cijena = nova_cijena
    WHERE VrstaDozvoleID = (
        SELECT VrstaDozvoleID 
        FROM VrstaDozvole 
        WHERE Kategorija = 'C'
    );
    
    RAISE NOTICE 'Cijena za kategoriju C promijenjena na % kn', nova_cijena;
    
    RAISE NOTICE 'Promjena primijenjena na % tečaj/a', (SELECT COUNT(*) FROM Tecaj WHERE VrstaDozvoleID = (
        SELECT VrstaDozvoleID 
        FROM VrstaDozvole 
        WHERE Kategorija = 'C'
    ));
END;
$$;
commit;

call promijeni_cijenu_kategorije_C(5000.00);

CREATE OR REPLACE PROCEDURE promijeni_status_upisa(
    p_upis_id INTEGER,
    p_novi_status VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Upis SET Status = p_novi_status WHERE UpisID = p_upis_id;
    RAISE NOTICE 'Status upisa % promijenjen na %', p_upis_id, p_novi_status;
END;
$$;
commit;
call promijeni_status_upisa(9,'Aktivan');
commit;
select * from Upis;
SELECT t.Naziv, t.Cijena, v.Kategorija 
FROM Tecaj t
JOIN VrstaDozvole v ON t.VrstaDozvoleID = v.VrstaDozvoleID
WHERE v.Kategorija = 'C';


CREATE OR REPLACE FUNCTION izracunaj_godine_iskustva(
    p_instruktor_id INTEGER
)
RETURNS NUMERIC(5,2)  
LANGUAGE plpgsql
AS $$
DECLARE
    v_datum_zaposlenja DATE;
    v_godine_iskustva NUMERIC(5,2);
BEGIN
    
    SELECT DatumZaposlenja INTO v_datum_zaposlenja
    FROM Instruktor
    WHERE InstruktorID = p_instruktor_id;
    
    
    IF v_datum_zaposlenja IS NULL THEN
        RETURN 0;
    ELSE
        v_godine_iskustva := EXTRACT(YEAR FROM age(current_date, v_datum_zaposlenja)) + 
                            (EXTRACT(MONTH FROM age(current_date, v_datum_zaposlenja)) / 12.0);
        RETURN ROUND(v_godine_iskustva, 2);
    END IF;
END;
$$;
commit;

SELECT 
    Ime|| ' '|| Prezime AS Instruktor,
    DatumZaposlenja,
    izracunaj_godine_iskustva(InstruktorID) AS GodineIskustva
FROM Instruktor
ORDER BY GodineIskustva DESC;


--Nadodano da popuni sve potrebno iz dokumenta
-- Jednostavni Upiti
SELECT * FROM Instruktor WHERE DatumZaposlenja > '2020-01-01';

SELECT Naziv, Cijena FROM Tecaj ORDER BY Cijena DESC;

--Upiti nad više tablica
SELECT k.Ime, k.Prezime, t.Naziv AS Tecaj, u.Status
FROM Kandidat k
JOIN Upis u ON k.KandidatID = u.KandidatID
JOIN Tecaj t ON u.TecajID = t.TecajID;

SELECT i.Ime, i.Prezime, vd.Kategorija
FROM Instruktor i
JOIN InstruktorDozvole id ON i.InstruktorID = id.InstruktorID
JOIN VrstaDozvole vd ON id.VrstaDozvoleID = vd.VrstaDozvoleID;

SELECT Status, COUNT(*) AS BrojUpisa
FROM Upis
GROUP BY Status;

SELECT AVG(Cijena) AS ProsjecnaCijena FROM Tecaj;

SELECT MIN(DatumZaposlenja) AS NajstarijiZaposlenik, 
       MAX(DatumZaposlenja) AS NajnovijiZaposlenik
FROM Instruktor;

SELECT Kategorija, COUNT(*) AS BrojVozila
FROM Vozilo v
JOIN VrstaDozvole vd ON v.VrstaDozvoleID = vd.VrstaDozvoleID
GROUP BY Kategorija;

--Složeni upiti
SELECT Ime, Prezime
FROM Kandidat
WHERE KandidatID IN (SELECT KandidatID FROM Upis WHERE Status = 'Aktivan');


SELECT Naziv, Cijena,
       (SELECT AVG(Cijena) FROM Tecaj) AS ProsjecnaCijena
FROM Tecaj;

--Dodavanje vrijednosti
ALTER TABLE Upis ALTER COLUMN Status SET DEFAULT 'Aktivan';
ALTER TABLE Vozilo ALTER COLUMN GodinaProizvodnje SET DEFAULT EXTRACT(YEAR FROM CURRENT_DATE);
ALTER TABLE Tecaj ALTER COLUMN Trajanje SET DEFAULT 40;
commit;

--Dodavanje uvjeta
ALTER TABLE Kandidat ADD CONSTRAINT chk_email CHECK (Email LIKE '%@%.%');
ALTER TABLE Vozilo ADD CONSTRAINT chk_godina CHECK (GodinaProizvodnje BETWEEN 2000 AND EXTRACT(YEAR FROM CURRENT_DATE));
ALTER TABLE Tecaj ADD CONSTRAINT chk_cijena CHECK (Cijena > 0);
commit;
--Komentari tablica
COMMENT ON TABLE Kandidat IS 'Tablica koja pohranjuje podatke o kandidatima autoškole';
COMMENT ON TABLE Instruktor IS 'Tablica sa podacima o instruktorima autoškole';
COMMENT ON TABLE Vozilo IS 'Tablica vozila koja se koriste u autoškoli';
COMMENT ON TABLE Tecaj IS 'Tablica tečeva koji se nude u autoškoli';
COMMENT ON TABLE Upis IS 'Tablica upisa kandidata na tečeve';
commit;

--indexi
CREATE INDEX idx_upis_status ON Upis(Status);
CREATE INDEX idx_vozilo_kategorija ON Vozilo(VrstaDozvoleID);
CREATE INDEX idx_sat_datum ON Sat(DatumSata);
CREATE INDEX idx_kandidat_email ON Kandidat(Email);
commit;

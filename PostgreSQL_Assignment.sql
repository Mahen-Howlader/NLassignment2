-- Active: 1747608045198@@127.0.0.1@5432@conservation_db@public

-- rangers tabel
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(100)
);

-- sightings tabel
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT NOT NULL REFERENCES species (species_id) ON DELETE CASCADE,
    ranger_id INT NOT NULL REFERENCES rangers (ranger_id) ON DELETE CASCADE,
    "location" VARCHAR(50) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- rangers tabel insert value
INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

-- - species table  insert value
INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

-- sightings tabel insert value
INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

DROP Table sightings;

-- problem 1
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- problem 2
SELECT count(DISTINCT species_id) as unique_species_count
FROM sightings;

-- problem 3
SELECT * FROM sightings WHERE location ILIKE '%pass%';

-- problem 4
SELECT R.name, count(S.ranger_id) AS counts
FROM rangers R
    LEFT JOIN sightings S ON R.ranger_id = S.ranger_id
GROUP BY
    R.name
HAVING
    count(S.ranger_id) > 0
ORDER BY R.name ASC;

-- problem 5
SELECT SP.common_name
FROM species SP
    LEFT JOIN sightings SI ON SP.species_id = SI.species_id
WHERE
    SI.species_id IS NULL;

-- problem 6
SELECT SP.common_name, SI.sighting_time, R.name
FROM
    sightings SI
    JOIN species SP ON SI.species_id = SP.species_id
    JOIN rangers R ON SI.ranger_id = R.ranger_id
ORDER BY SI.sighting_time DESC
LIMIT 2;

-- problem 7
UPDATE species
set
    conservation_status = 'Historic'
WHERE
    EXTRACT(
        YEAR
        FROM species.discovery_date
    ) < 1800;



-- problem 8
SELECT
    sighting_id,
    sighting_time,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END as date_of_time
FROM sightings;

-- problem 9 
DELETE FROM rangers WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);
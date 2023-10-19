DO
$$
    BEGIN
        IF NOT EXISTS(SELECT 1 FROM pg_type WHERE typname = 'science_status') THEN
            CREATE TYPE science_status AS ENUM (
                'genius',
                'worker'
                );
        END IF;
    END
$$;

CREATE TABLE IF NOT EXISTS university
(
    id               serial PRIMARY KEY,
    title            varchar,
    information      varchar,
    university_grade int CHECK ( university_grade >= 100 and university_grade <= 500 )
);

CREATE TABLE IF NOT EXISTS myths
(
    id   serial PRIMARY KEY,
    text varchar,
    worth int CHECK ( worth > 0 )
);

CREATE TABLE IF NOT EXISTS scientists
(
    id            serial PRIMARY KEY,
    genius_degree  int CHECK ( genius_degree > 0 and genius_degree < 5 ),
    university_id int REFERENCES university (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS proofs
(
    id      serial PRIMARY KEY,
    text    varchar,
    myth_id int REFERENCES myths (id) ON DELETE RESTRICT,
    science_id int REFERENCES scientists(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS exploration_programs
(
    id            serial PRIMARY KEY,
    program_title varchar,
    university_id int REFERENCES university (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS scientists_and_programs
(
    scientist_id           int REFERENCES scientists (id) ON UPDATE CASCADE ON DELETE CASCADE,
    exploration_program_id int REFERENCES exploration_programs (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT scientist_and_program_key PRIMARY KEY (scientist_id, exploration_program_id)
);

CREATE TABLE IF NOT EXISTS persons
(
    id         serial PRIMARY KEY,
    science_id int REFERENCES scientists (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS personal_data
(
    id           serial PRIMARY KEY,
    first_name   varchar,
    last_name    varchar,
--     Add check
    phone_number varchar,
    birthday     date CHECK ((current_date - birthday) / 365 BETWEEN 18 AND 130),
    status       science_status
)
insert into university (title, information, university_grade)
values ('ITMO', 'best', 500),
       ('SPBGU', 'not best :c', 100),
       ('Politeh', 'gg', 250),
       ('Bonch', 'gl hf', 120);

insert into myths (text, worth)
values ('SPBGU best university', 1),
       ('ITMO is bad', 10),
       ('GG is termin', 12);

insert into scientists (genius_degree, university_id)
values (2, 2),
       (1, 1),
       (3, 1),
       (2, 1);

insert into proofs (text, myth_id, science_id)
values ('лень придумывать', 6, 2),
       ('еще что-то', 9, 1),
       ('smth', 10, 3);

insert into exploration_programs (program_title, university_id)
VALUES ('good program', 1),
       ('bad program', 2),
       ('average program', 1);

insert into scientists_and_programs (scientist_id, exploration_program_id)
values (1, 2),
       (2, 3),
       (3, 1);

insert into persons (science_id)
values (1), (2), (3);

insert into personal_data (first_name, last_name, phone_number, birthday, status)
values ('Anton', 'Prigozin', '+79111111111', '19-12-2000', 'worker'),
       ('Chelovek', 'Molodoy', '+79222222222', '20-02-1950', 'genius'),
       ('Kto-to', 'Nekto', null, null, 'worker');

-- Написать запрос определяющих список exploration_program с их рейтингом


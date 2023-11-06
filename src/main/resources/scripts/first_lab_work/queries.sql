select * from scientists_and_programs;

select
    ep.id,
    ep.program_title,
    count(*) as count
from exploration_programs ep
join scientists_and_programs sap on ep.id = sap.exploration_program_id
join scientists sc on sc.id = sap.scientist_id
join university u on ep.university_id = u.id
where ep.university_id != sc.university_id
group by ep.id
having count(*) = (select count(ep.id) as cnt
                   from exploration_programs ep
                            join scientists_and_programs sap on ep.id = sap.exploration_program_id
                            join scientists sc on sc.id = sap.scientist_id
                            join university u on ep.university_id = u.id
                   group by ep.id
                   order by cnt
                   limit 1);

select
    ep.id,
    count(ep.id)
from exploration_programs ep
         join scientists_and_programs sap on ep.id = sap.exploration_program_id
         join scientists sc on sc.id = sap.scientist_id
         join university u on ep.university_id = u.id
group by ep.id
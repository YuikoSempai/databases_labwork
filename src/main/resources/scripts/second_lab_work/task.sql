-- 1
select НЛ."ФАМИЛИЯ", НВ."ИД"
from "Н_ЛЮДИ" НЛ
         right join "Н_ВЕДОМОСТИ" НВ on НЛ."ИД" = НВ."ЧЛВК_ИД"
where НЛ."ОТЧЕСТВО" < 'Сергеевич'
  and НВ."ДАТА" < to_timestamp('2010-06-18', 'YYYY-MM-DD');

-- 2
select НЛ."ИД", НВ."ЧЛВК_ИД", НС."УЧГОД"
from "Н_ЛЮДИ" НЛ
         inner join "Н_ВЕДОМОСТИ" НВ on НЛ."ИД" = НВ."ЧЛВК_ИД"
         inner join "Н_СЕССИЯ" НС on НЛ."ИД" = НС."ЧЛВК_ИД"
where НЛ."ОТЧЕСТВО" < 'Георгиевич'
  and НВ."ИД" > 1250972
  and НС."ИД" = 1975;

-- 3
select count(*)
from (select нл."ФАМИЛИЯ",
             нл."ОТЧЕСТВО",
             LAG("ФАМИЛИЯ", 1) over (
                 order by "ФАМИЛИЯ", "ОТЧЕСТВО"
                 ) пред_фамилия,
             LAG("ОТЧЕСТВО", 1) over (
                 order by "ФАМИЛИЯ", "ОТЧЕСТВО"
                 ) пред_отчество
      from "Н_ЛЮДИ" нл
      order by "ФАМИЛИЯ", "ОТЧЕСТВО") as н
where пред_фамилия != "ФАМИЛИЯ"
  and "ОТЧЕСТВО" != пред_отчество;

-- 4
select "ФАМИЛИЯ", count("ФАМИЛИЯ") as cnt
from "Н_ЛЮДИ" нл
where "ФАМИЛИЯ" in (select нл."ФАМИЛИЯ"
                    from "Н_ЛЮДИ" нл
                             left join "Н_УЧЕНИКИ" ну on ну."ЧЛВК_ИД" = нл."ИД"
                    where ну."ИД" is null)
  and "ИД" in (select "ЧЛВК_ИД"
               from "Н_ВЕДОМОСТИ" нв
               where "ОТД_ИД" in (select но."ОТД_ИД"
                                  from "Н_ОТДЕЛЫ" но
                                  where "КОРОТКОЕ_ИМЯ" = 'ВТ'))
group by "ФАМИЛИЯ"
having count(*) > 10
order by cnt desc;

-- 5
select "ФАМИЛИЯ", round(avg(cast("ОЦЕНКА" as int))) as avg_grade
from (select "ФАМИЛИЯ",
             "ГРУППА",
             case
                 when "ОЦЕНКА" = 'зачет' then '5'
                 when "ОЦЕНКА" = 'осв' then '5'
                 when "ОЦЕНКА" = 'незач' then '2'
                 when "ОЦЕНКА" = 'неявка' then '2'
                 when cast("ОЦЕНКА" as int) > 90 then '5'
                 when cast("ОЦЕНКА" as int) between 80 and 90 then '4'
                 else "ОЦЕНКА"
                 end as "ОЦЕНКА"
      from "Н_ЛЮДИ" нл
               left join "Н_ВЕДОМОСТИ" нв on нв."ЧЛВК_ИД" = нл."ИД"
               left join "Н_УЧЕНИКИ" ну on ну."ЧЛВК_ИД" = нл."ИД"
          and "ОЦЕНКА" is not null) as grades
where grades."ГРУППА" = '4100'
group by "ФАМИЛИЯ"
having round(avg(cast("ОЦЕНКА" as int))) = round((select avg(cast(ФГО."ОЦЕНКА" as int))
                                                  from (select case
                                                                   when "ОЦЕНКА" = 'зачет' then '5'
                                                                   when "ОЦЕНКА" = 'осв' then '5'
                                                                   when "ОЦЕНКА" = 'незач' then '2'
                                                                   when "ОЦЕНКА" = 'неявка' then '2'
                                                                   when cast("ОЦЕНКА" as int) > 90 then '5'
                                                                   when cast("ОЦЕНКА" as int) between 80 and 90 then '4'
                                                                   else "ОЦЕНКА"
                                                                   end as "ОЦЕНКА"
                                                        from "Н_ЛЮДИ" нл
                                                                 left join "Н_ВЕДОМОСТИ" нв on нв."ЧЛВК_ИД" = нл."ИД"
                                                                 left join "Н_УЧЕНИКИ" ну on ну."ЧЛВК_ИД" = нл."ИД"
                                                            and "ОЦЕНКА" is not null) as ФГО));

-- 6
select "ГРУППА", "ФАМИЛИЯ", "ОТЧЕСТВО", "ИМЯ", "СОСТОЯНИЕ"
from "Н_УЧЕНИКИ" ну
         left join "Н_ЛЮДИ" нл on ну."ЧЛВК_ИД" = нл."ИД"
         left join "Н_ОБУЧЕНИЯ" но on но."ЧЛВК_ИД" = нл."ИД"
where ну."ВИД_ОБУЧ_ИД" in (select "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
                          from "Н_ФОРМЫ_ОБУЧЕНИЯ"
                          where "НАИМЕНОВАНИЕ" = 'Заочная')
and ну."НАЧАЛО" >= to_timestamp('2005-01-01 00:00:00.000000', 'YYYY-MM-DD');

-- 7
select count(distinct нв."ЧЛВК_ИД") from "Н_ВЕДОМОСТИ" нв
                left join "Н_УЧЕНИКИ" ну on нв."ЧЛВК_ИД" = ну."ЧЛВК_ИД"
where "ОЦЕНКА" in ('4', '5', 'зачет', 'осв')
and "ГРУППА" = '3100'
and "ПРИЗНАК" != 'обучен';
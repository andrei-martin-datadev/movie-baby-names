USE [sanjunipero01]
GO

/****** Object:  StoredProcedure [film].[sp_dataprep]    Script Date: 4/05/2025 12:23:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [film].[sp_dataprep]

as

begin


--select *
--from film.imdb_associations -- 835513

drop table if exists #movieactor

select imdb_title_id, convert(int,ordering) [order], imdb_name_id
	, case when category='actor' then 'M' else 'F' end Gender
	, REPLACE(REPLACE(REPLACE(REPLACE(characters,'["',''),'"]',''),'-',' '),'","',' ') Character
into #movieactor
from film.imdb_associations
where category in ('actress','actor')
order by 1, 2 -- 355,751

drop table if exists #movieactorrank

select a.*, b.original_title
	, b.title, b.year, b.language, b.duration, b.avg_vote, b.worlwide_gross_income income
	, ROW_NUMBER() OVER (PARTITION BY a.imdb_title_id ORDER BY a.[order] asc) rank, a.Character Character_Original
into #movieactorrank
from #movieactor a
inner join film.imdb_movies b
on a.imdb_title_id=b.imdb_title_id -- 355,743

delete from #movieactorrank
where rank > 4 -- 256,335

delete from #movieactorrank
where upper(language) not like '%ENGLISH%' -- 48,016

update #movieactorrank
set year=convert(int,dbo.ExtractNumbers(year)) -- 51392

delete from #movieactorrank
where year > 2014 -- 9070

/*
update #movieactorrank
set Character=right(Character, len(Character)-4)
where Character like 'Dr. %'
	or Character like 'Mr. %'
	or Character like 'Ms. %'
	or Character like 'Lt. %' -- 4363
*/



update #movieactorrank
set Character=right(Character, len(Character) - CHARINDEX(') ', Character) - 1)
where substring(Character,1,10) like '%) %'

update #movieactorrank
set Character=null
where substring(Character,1,1)='(' -- 31

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 3296

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 591

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 59

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 8

update #movieactorrank
set Character=replace(Character,',',' ')
where CHARINDEX(',',Character) > 0 -- 26

update #movieactorrank
set Character=replace(Character,'''','')
where CHARINDEX('''',Character) > 0 -- 4657

update #movieactorrank
set Character=replace(Character,'\','')
where CHARINDEX('\',Character) > 0 -- 529

update #movieactorrank
set Character=replace(Character,'"','')
where CHARINDEX('"',Character) > 0 -- 529

update #movieactorrank
set Character=replace(Character,'>','')
where CHARINDEX('>',Character) > 0 -- 1

update #movieactorrank
set Character=replace(Character,'‰','')
where CHARINDEX('‰',Character) > 0 -- 26



update #movieactorrank
set Character=null
where len(trim(Character))=0 -- 975


update #movieactorrank
set Character=right(Character, len(Character)-8)
where Character like '1st Lt. %'
	or Character like '2nd Lt. %'

update #movieactorrank
set Character=right(Character, len(Character)-9)
where Character like '1st Sgt. %'

update #movieactorrank
set Character=right(Character, len(Character)-11)
where Character like 'Air Marshal %' -- 2

update #movieactorrank
set Character=right(Character, len(Character)-19)
where Character like 'Detective Sergeant %'

update #movieactorrank
set Character=right(Character, len(Character)-20)
where Character like 'Detective Inspector %'

update #movieactorrank
set Character=right(Character, len(Character)-CHARINDEX(' ',Character))
where Character like 'ain %' 
	or Character like 'Sir %'
	or Character like 'Miss %' 
	or Character like 'King %'
	or Character like 'Uncle %'
	or Character like 'Queen %'
	or Character like 'Little %' -- 106
	or Character like 'Auntie %'
    or Character like 'Ensign %' 
    or Character like 'Granny %'
    or Character like 'Granma %'
	or Character like 'Sister %'
	or Character like 'Officer %' -- 154
    or Character like 'Captain %'
    or Character like 'Emperor %'
    or Character like 'Empress %'
    or Character like 'Grandpa %'
    or Character like 'Grandma %'
	or Character like 'Engineer %' -- 1
	or Character like 'Governor %'
	or Character like 'Sergeant %'
	or Character like 'Governess %' -- 1
	or Character like 'Lieutenant %' -- 118
	or Character like 'Engineer %'
	or Character like 'Father %'
	or Character like 'Detective %'
	or Character like 'Inspector %'
	or Character like 'Deputy %'
	or Character like 'Colonel %'
	or Character like 'Countess %'





/*
update #movieactorrank
set Character=null
where len(trim(Character))<=3
and left(Character,1)='#' -- 4
*/

update #movieactorrank
set Character=null
where Character like '%#%' -- 315

update #movieactorrank
set Character=null
where
	Character like '%Zombie%'
	or Character like '%Soldier%'
	or Character like '%Henchman%'
	or Character like '%Pirate%'
	or Character like '%Heckler%'
	or Character like '%Ensemble%'
	or Character like '%Entertainer%'
	or Character like '%Agent%'
	or Character like '%EMT%'
	or Character like '%Driver%'
	or Character like '%Attendant%'
	or Character like '%Camper%'
	or Character like '%Aircraft%'
	or Character like '%Airline%'
	or Character like '%Air Traffic%'
	or Character like '%Air Host%'
	or Character like '%Air Commodore%'
	or Character like '%&%' -- 677
	or Character like '%Voice%' -- 677
	or Character like '%Narrator%' -- 677


update #movieactorrank
set Character=null
where
	Character like 'The %'
	or Character like 'A %' -- 1651
	or Character like '% Man'
	or Character like 'Grand %'
	or Character like '% Duke %'
	or Character like '% Officer'
	or Character like '% Commander'
	or isnumeric(left(Character,1))=1
	or Character like '% Player'

update #movieactorrank
set Character=null
where Character in ('God','Godess','Empress','Emperor','Sister','Brother','Granddad','Grandfather'
						,'Grandma', 'Grandmother', 'Granny', 'Enginer', 'Deputy', 'CEO')

						

update #movieactorrank
set Character=trim(Character)

update #movieactorrank
set Character=null
where left(Character,1)='('
	and substring(Character,len(Character),1)=')' -- 2


update #movieactorrank
set Character=replace(Character,'‰','')
where CHARINDEX('‰',Character) > 0 -- 26

update #movieactorrank
set Character=replace(Character,'“','')
where CHARINDEX('“',Character) > 0 -- 6

update #movieactorrank
set Character=replace(Character,'³','')
where CHARINDEX('³',Character) > 0 -- 152

update #movieactorrank
set Character=replace(Character,'˜','')
where CHARINDEX('˜',Character) > 0 -- 1

update #movieactorrank
set Character=replace(Character,'¯','')
where CHARINDEX('¯',Character) > 0 -- 19

update #movieactorrank
set Character=replace(Character,'©','')
where CHARINDEX('©',Character) > 0 -- 499

update #movieactorrank
set Character=replace(Character,'‡','')
where CHARINDEX('‡',Character) > 0 -- 1

update #movieactorrank
set Character=replace(Character,'±','')
where CHARINDEX('±',Character) > 0 -- 45

update #movieactorrank
set Character=replace(Character,'§','')
where CHARINDEX('§',Character) > 0 -- 89

update #movieactorrank
set Character=replace(Character,'…','')
where CHARINDEX('…',Character) > 0 -- 3

update #movieactorrank
set Character=replace(Character,'¶','')
where CHARINDEX('¶',Character) > 0 -- 64

update #movieactorrank
set Character=replace(Character,'¤','')
where CHARINDEX('¤',Character) > 0 -- 52

update #movieactorrank
set Character=replace(Character,'(','')
where CHARINDEX('(',Character) > 0 -- 52

update #movieactorrank
set Character=replace(Character,')','')
where CHARINDEX(')',Character) > 0 -- 52

update #movieactorrank
set Character=replace(Character,'”','')
where CHARINDEX('”',Character) > 0 -- 3

update #movieactorrank
set Character=replace(Character,'„','')
where CHARINDEX('„',Character) > 0 -- 4

update #movieactorrank
set Character=replace(Character,'‚','')
where CHARINDEX('‚',Character) > 0 -- 1

update #movieactorrank
set Character=replace(Character,'²','')
where CHARINDEX('²',Character) > 0 -- 1



update #movieactorrank
set Character=trim(Character)

update #movieactorrank
set Character=null
where len(Character)=1

update #movieactorrank
set Character=null
where len(Character)=2
and substring(Character,2,1)='.'

update #movieactorrank
set Character=null
where len(Character)=4
and substring(Character,2,1)='.'
and substring(Character,4,1)='.'

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 3296

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 591

update #movieactorrank
set Character=trim(right(Character, len(Character) - charindex('.',Character)))
where charindex('.',Character) < CHARINDEX(' ',Character) and charindex('.',Character) > 0 -- 59

update #movieactorrank
set Character=dbo.ConvertNonBasicLatinToBasic(Character) 
where dbo.HasNonAlphabeticChar(Character)=1 -- 3694


--------- MIDDLE MIDDLE

drop table if exists #characternames

select 
	case when CHARINDEX(' ', Character) > 0 then left(Character, CHARINDEX(' ',Character)-1)
		else Character end [Name]
	, year as [Year], Gender
into #characternames
from #movieactorrank

delete from #characternames
where Name is null -- 4715

drop table if exists film.summary_characternames

select Name, Year, Gender, count(1) as [Count]
into film.summary_characternames
from #characternames
group by Name, Year, Gender
order by 2, 4 desc -- 92,553

drop table if exists film.summary_babynames

select Name, Year, Gender, Count
into film.summary_babynames
from pop.usa_babynames
where Year >= 1912 -- 1,726,994

-------------- PART II

drop table if exists #actors

select a.year, a.Gender
	, case when charindex(' ', b.name) > 0 then left(b.name, charindex(' ', b.name) - 1)
			else b.name end Name
into #actors
from #movieactorrank a
inner join film.imdb_names b
on a.imdb_name_id=b.imdb_name_id

update #actors
set Name=trim(Name)

delete from #actors
where isnumeric(left(Name,1))=1

delete from #actors
where len(Name)=1

delete from #actors
where len(Name)=2
and substring(Name,2,1)='.'

delete from #actors
where len(Name)=4
and substring(Name,2,1)='.'
and substring(Name,4,1)='.'


update #actors
set Name=replace(Name,'²','')
where CHARINDEX('²',Name) > 0 -- 1

update #actors
set Name=replace(Name,'˜','')
where CHARINDEX('˜',Name) > 0 -- 1

update #actors
set Name=replace(Name,'“','')
where CHARINDEX('“',Name) > 0 -- 1

update #actors
set Name=replace(Name,'‡','')
where CHARINDEX('‡',Name) > 0 -- 1

update #actors
set Name=replace(Name,'…','')
where CHARINDEX('…',Name) > 0 -- 1

update #actors
set Name=replace(Name,'‰','')
where CHARINDEX('‰',Name) > 0 -- 1

update #actors
set Name=replace(Name,'¯','')
where CHARINDEX('¯',Name) > 0 -- 1

update #actors
set Name=replace(Name,'€','')
where CHARINDEX('€',Name) > 0 -- 1


update #actors
set Name=dbo.ConvertNonBasicLatinToBasic(Name) 
where dbo.HasNonAlphabeticChar(Name)=1 -- 3134

update #actors
set Name = right(Name, len(Name)-1)
where Name like '''%'

update #actors
set Name = left(Name, len(Name)-1)
where Name like '%'''

drop table if exists film.summary_actornames

select Name, year as [Year], Gender, count(1) as [Count]
into film.summary_actornames
from #actors
group by Name, year, Gender -- 69097 --> 68,422


drop table if exists #distinctnames

select *
into #distinctnames
from (
select distinct Name
from film.summary_characternames -- 24,375
union
select distinct Name
from film.summary_babynames -- 93,800
union
select distinct Name
from film.summary_actornames
) x -- 110,839


drop table if exists #distinctyear

select *
into #distinctyear
from (
select distinct Year
from film.summary_characternames -- 24,375
union
select distinct Year
from film.summary_babynames -- 93,800
union
select distinct Year
from film.summary_actornames
) x -- 103


drop table if exists #distinctnameyear

select *
into #distinctnameyear
from #distinctnames a
cross join #distinctyear b -- 11,416,417

drop table if exists #actornames

select Name, Year, sum(Count) as Count
into #actornames
from film.summary_actornames
group by Name, Year -- 67396


drop table if exists #babynames

select Name, Year, sum(Count) as Count
into #babynames
from film.summary_babynames
group by Name, Year -- 1,574,414


drop table if exists #characters

select Name, Year, sum(Count) as Count
into #characters
from film.summary_characternames
group by Name, Year -- 90475



drop table if exists #allnames

select a.*, isnull(b.Count, 0) Count_ActorNames, isnull(c.Count, 0) Count_BabyNames, isnull(d.Count, 0) Count_CharacterNames
into #allnames
from #distinctnameyear a
left join #actornames b
on a.Name=b.Name and a.Year=b.Year
left join #babynames c
on a.Name=c.Name and a.Year=c.Year
left join #characters d
on a.Name=d.Name and a.Year=d.Year -- 11,416,417


delete
from #allnames
where Count_ActorNames+Count_BabyNames+Count_CharacterNames=0 -- 9,798,930

drop table if exists film.summary_allnames_CSV

select *
into film.summary_allnames_CSV
from #allnames -- 1,617,483


end

/*

select *
from film.summary_allnames_CSV

select Name, sum(Count_ActorNames), sum(Count_BabyNames), sum(Count_CharacterNames)
from film.summary_allnames_CSV
group by Name
order by 3 desc

*/
GO



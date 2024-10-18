create table Flight(orig text, dest text, airline text, cost int, descuento int);

insert into Flight values ('A', 'ORD', 'United', 200,10);
insert into Flight values ('ORD', 'B', 'American', 100,10);
insert into Flight values ('A', 'PHX', 'Southwest', 25,50);
insert into Flight values ('PHX', 'LAS', 'Southwest', 30,30);
insert into Flight values ('LAS', 'CMH', 'Frontier', 60,10);
insert into Flight values ('CMH', 'B', 'Frontier', 60,10);
insert into Flight values ('A', 'B', 'JetBlue', 195,10);
insert into Flight values ('CMH', 'PHX', 'Frontier', 80,20);












--------RED SOCIAL





create table Highschooler(ID int, name text, grade int);
create table Likes(ID1 int, ID2 int);

insert into Highschooler values (1510, 'Jordan 1', 9);
insert into Highschooler values (1689, 'Gabriel 1', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel 2', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan 2', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Likes values(1510, 1689);
insert into Likes values(1510,1381);
insert into Likes values(1689,1709);
insert into Likes values(1381,1247);
insert into Likes values(1709,1247);
insert into Likes values(1911,1247);
insert into Likes values(1911,1501);
insert into Likes values(1501,1934);
insert into Likes values(1934,1316);
insert into Likes values(1316,1782);
insert into Likes values(1782,1468);
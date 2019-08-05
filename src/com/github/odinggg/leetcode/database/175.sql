# 表1: Person
#
# +-------------+---------+
# | 列名         | 类型     |
# +-------------+---------+
# | PersonId    | int     |
# | FirstName   | varchar |
# | LastName    | varchar |
# +-------------+---------+
# PersonId 是上表主键
# 表2: Address
#
# +-------------+---------+
# | 列名         | 类型    |
# +-------------+---------+
# | AddressId   | int     |
# | PersonId    | int     |
# | City        | varchar |
# | State       | varchar |
# +-------------+---------+
# AddressId 是上表主键
#  
#
# 编写一个 SQL 查询，满足条件：无论 person 是否有地址信息，都需要基于上述两表提供 person 的以下信息：
#
#  
#
# FirstName, LastName, City, State
create table Person
(
    PersonId  int,
    FirstName varchar(20),
    LastName  varchar(20),
    primary key (PersonId)
);
create table Address
(
    AddressId int,
    PersonId  int,
    City      varchar(20),
    State     varchar(20),
    primary key (AddressId)
);

select p.FirstName,
       p.LastName,
       a.City,
       a.State
from Address a
         right join Person p on p.PersonId = a.PersonId;

/*
编写一个 SQL 查询，获取 Employee 表中第二高的薪水（Salary） 。

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
例如上述 Employee 表，SQL查询应该返回 200 作为第二高的薪水。如果不存在第二高的薪水，那么查询应返回 null。

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
*/
create table Employee
(
    Id     int,
    Salary int,
    primary key (Id)
);
insert into Employee (Id, Salary)
values (1, 100),
       (2, 200),
       (3, 300);

# 我的解 首先原表去重后根据Salary排序设置行号，取第二行别名为SecondHighestSalary
SELECT (select rIS.Salary
        from (select @rownum := @rownum + 1 as rownum,
                     Salary
              from (SELECT DISTINCT Salary from Employee) as e,
                   (SELECT @rownum := 0) as r
              order by Salary DESC) as rIS
        where rownum = 2) as SecondHighestSalary;
# 官方解 通过去重排序分页出第二条数据
SELECT
    (SELECT DISTINCT
         Salary
     FROM
         Employee
     ORDER BY Salary DESC
     LIMIT 1 OFFSET 1) AS SecondHighestSalary;

/*编写一个 SQL 查询，获取 Employee 表中第 n 高的薪水（Salary）。

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
例如上述 Employee 表，n = 2 时，应返回第二高的薪水 200。如果不存在第 n 高的薪水，那么查询应返回 null。

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
*/
# 如上
# CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
# BEGIN
#     RETURN (
#         # Write your MySQL query statement below.
#         SELECT (select rIS.Salary
#                 from (select @rownum := @rownum + 1 as rownum,
#                              Salary
#                       from (SELECT DISTINCT Salary from Employee) as e,
#                            (SELECT @rownum := 0) as r
#                       order by Salary DESC) as rIS
#                 where rownum = N) as SecondHighestSalary
#     );
# END
# 官方解
CREATE FUNCTION getNthHighestSalary2(N INT) RETURNS INT
BEGIN
    DECLARE M INT ;
    set M=N-1;
    RETURN (
        # Write your MySQL query statement below.
        select distinct Salary from Employee order by Salary desc limit 1 OFFSET M
    );
END

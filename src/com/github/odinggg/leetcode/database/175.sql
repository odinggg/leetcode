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
SELECT (SELECT DISTINCT Salary
        FROM Employee
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
# CREATE FUNCTION getNthHighestSalary2(N INT) RETURNS INT
# BEGIN
#     DECLARE M INT ;
#     set M=N-1;
#     RETURN (
#         # Write your MySQL query statement below.
#         select distinct Salary from Employee order by Salary desc limit 1 OFFSET M
#     );
# END
/*编写一个 SQL 查询来实现分数排名。如果两个分数相同，则两个分数排名（Rank）相同。请注意，平分后的下一个名次应该是下一个连续的整数值。换句话说，名次之间不应该有“间隔”。

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
例如，根据上述给定的 Scores 表，你的查询应该返回（按分数从高到低排列）：

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
*/
create table UserScore
(
    Id    int,
    Score double(4, 2),
    primary key (Id)
);
insert into UserScore(Id, Score)
VALUES (1, 3.50),
       (2, 3.65),
       (3, 4.00),
       (4, 3.85),
       (5, 4.00),
       (6, 3.65);
# 我的解
# select s.Score, CAST(rownum AS SIGNED) as Rank
# from Scores as u LEFT JOIN (select @rownum := @rownum + 1 as rownum, Score
#     from (select distinct Score from Scores ORDER BY Score DESC) as a, (SELECT @rownum := 0) as r) as s
# ON u.Score = s.Score
# ORDER BY Rank;
# 官方解 思路差不多，将distinct更换为group by

/*编写一个 SQL 查询，查找所有至少连续出现三次的数字。

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
例如，给定上面的 Logs 表， 1 是唯一连续出现至少三次的数字。

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
*/
create table Logs
(
    Id  int,
    Num int,
    primary key (Id)
);
insert into Logs(Id, Num)
values (1, 1),
       (2, 1),
       (3, 1),
       (4, 2),
       (5, 1),
       (6, 2),
       (7, 2);
# 错误理解，没考虑‘连续’，没做出来，QAQ，理解错题意
SELECT
    c.Num as ConsecutiveNums
FROM (select Num,count(1) as cou
      from Logs group by Num) as c
WHERE c.cou >= 3;

# 官方答案一 通过计数中间表统计连续数量
# SELECT DISTINCT a.Num AS ConsecutiveNums
# FROM (
#          SELECT Num,
#                 CASE
#
#                     WHEN @recorde = Num THEN
#                         @count := @count + 1
#                     WHEN @recorde <> @recorde := Num THEN
#                         @count := 1
#                     END AS n
#          FROM LOGS,
#               (SELECT @count := 0, @recorde := (SELECT Num FROM LOGS LIMIT 0, 1)) r
#      ) a
# WHERE a.n >= 3
# 官方答案二 通过自关联连续id值是否相等计算（弊端：id必须连续）
SELECT

    DISTINCT
    l1.Num AS ConsecutiveNums
FROM Logs l1,Logs l2, Logs l3
WHERE
        l1.Id = l2.Id -1
  and l2.Id = l3.Id - 1
  AND l1.Num = l2.Num
  AND l2.Num = l3.Num;
/*Employee 表包含所有员工，他们的经理也属于员工。每个员工都有一个 Id，此外还有一列对应员工的经理的 Id。

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
给定 Employee 表，编写一个 SQL 查询，该查询可以获取收入超过他们经理的员工的姓名。在上面的表格中，Joe 是唯一一个收入超过他的经理的员工。

+----------+
| Employee |
+----------+
| Joe      |
+----------+
*/
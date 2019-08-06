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
SELECT c.Num as ConsecutiveNums
FROM (select Num, count(1) as cou
      from Logs
      group by Num) as c
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
SELECT DISTINCT l1.Num AS ConsecutiveNums
FROM Logs l1,
     Logs l2,
     Logs l3
WHERE l1.Id = l2.Id - 1
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
create table Employee
(
    Id        int,
    Name      varchar(20),
    Salary    bigint,
    ManagerId int,
    primary key (Id)
);
insert into Employee(Id, Name, Salary, ManagerId)
values (1, 'Joe', 70000, 3),
       (2, 'Henry', 80000, 4),
       (3, 'Sam', 60000, NULL),
       (4, 'Max', 90000, NULL);
select e1.Name as Employee
from Employee e1,
     Employee e2
where e1.ManagerId = e2.Id
  and e1.Salary > e2.Salary;
select e1.Name as Employee
from Employee e1
         left join Employee e2 on e1.ManagerId = e2.Id and e1.Salary > e2.Salary
/*编写一个 SQL 查询，查找 Person 表中所有重复的电子邮箱。

示例：

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
根据以上输入，你的查询应返回以下结果：

+---------+
| Email   |
+---------+
| a@b.com |
+---------+
*/
create table Person
(
    Id    int,
    Email varchar(20),
    primary key (Id)
);
insert into Person(Id, Email)
values (1, 'a@b.com'),
       (2, 'c@d.com'),
       (3, 'a@b.com');
# 我的解，直观子查询
# SELECT e.Email
# from (select count(1) as con, Email from Person group by Email) as e
# WHERE e.con > 1;
# 官方解 利用having子句替换
# select Email
# from Person
# group by Email
# having count(Email) > 1;

/*某网站包含两个表，Customers 表和 Orders 表。编写一个 SQL 查询，找出所有从不订购任何东西的客户。

Customers 表：

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders 表：

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
例如给定上述表格，你的查询应返回：

+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
*/
create table Customers
(
    Id   int,
    Name varchar(20),
    primary key (Id)
);
create table Orders
(
    Id         int,
    CustomerId int,
    primary key (Id)
);
insert into Customers (Id, Name)
values (1, 'Joe'),
       (2, 'Henry'),
       (3, 'Sam'),
       (4, 'Max');
insert into Orders(Id, CustomerId)
VALUES (1, 3),
       (2, 1);
# 我的解
select c.Name as Customers
from Customers c
         left join Orders o on c.Id = o.CustomerId
where o.Id is null;
# 官方解
select Customers.name as 'Customers'
from Customers
where Customers.id not in
      (
          select CustomerId
          from Orders
      );

/*Employee 表包含所有员工信息，每个员工有其对应的 Id, salary 和 department Id。

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department 表包含公司所有部门的信息。

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
编写一个 SQL 查询，找出每个部门工资最高的员工。例如，根据上述给定的表格，Max 在 IT 部门有最高工资，Henry 在 Sales 部门有最高工资。

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
*/
create table Employee
(
    Id           int,
    Name         varchar(20),
    Salary       bigint,
    DepartmentId int,
    primary key (Id)
);
create table Department
(
    Id   int,
    Name varchar(20),
    primary key (Id)
);
insert into Employee (Id, Name, Salary, DepartmentId)
values (1, 'Joe', 70000, 1),
       (2, 'Henry', 80000, 2),
       (3, 'Sam', 60000, 2),
       (4, 'Max', 90000, 1);
insert into Department (Id, Name)
VALUES (1, 'IT'),
       (2, 'Sales');
# in 能多个字段，自己解与官方解相同
# select d.Name as Department,e.Name as Employee,e.Salary
# from Employee e,Department d where e.DepartmentId = d.Id
# and (e.Salary,e.DepartmentId) in (select max(Salary),DepartmentId
#                  from Employee
#                  group by DepartmentId);

/*Employee 表包含所有员工信息，每个员工有其对应的工号 Id，姓名 Name，工资 Salary 和部门编号 DepartmentId 。

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
Department 表包含公司所有部门的信息。

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
编写一个 SQL 查询，找出每个部门获得前三高工资的所有员工。例如，根据上述给定的表，查询结果应返回：

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
解释：

IT 部门中，Max 获得了最高的工资，Randy 和 Joe 都拿到了第二高的工资，Will 的工资排第三。销售部门（Sales）只有两名员工，Henry 的工资最高，Sam 的工资排第二。
*/

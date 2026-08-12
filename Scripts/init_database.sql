/*
Create database and schemas

Script Purpose:
This script create a new database names "Datawarehouse". Adittionally, the script sets up three schemas within the
database: "Bronze", "Silver", "Gold"
*/

Use master;
create database Datawarehouse;

-- create the data warehouse database

use Datawarehouse;
go

-- create the schemas
create schema Bronze;
go
create schema Silver;
go
create schema Gold;

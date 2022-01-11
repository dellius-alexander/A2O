

# Create PROCEDURE OR FUNCTION
# CREATE
#     [DEFINER = user]
#     PROCEDURE sp_name ([proc_parameter[,...]])
#     [characteristic ...] routine_body
#
# CREATE
#     [DEFINER = user]
#     FUNCTION sp_name ([func_parameter[,...]])
#     RETURNS type
#     [characteristic ...] routine_body
#
# proc_parameter:
#     [ IN | OUT | INOUT ] param_name type
#
# func_parameter:
#     param_name type
#
# type:
#     Any valid MySQL data type
#
# characteristic: {
#     COMMENT 'string'
#   | LANGUAGE SQL
#   | [NOT] DETERMINISTIC
#   | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
#   | SQL SECURITY { DEFINER | INVOKER }
# }
#
# routine_body:
#     Valid SQL routine statement


# DELIMITER //
#
# CREATE FUNCTION CalcIncome ( starting_value INT )
# RETURNS INT
#
# BEGIN
#
#    DECLARE income INT;
#
#    SET income = 0;
#
#    label1: WHILE income <= 3000 DO
#      SET income = income + starting_value;
#    END WHILE label1;
#
#    RETURN income;
#
# END; //
#
# DELIMITER ;

# name_of_ function – It is the name of the function that needs to be created in MySQL.
# parameter1, parameter2,… – We can pass the optional parameters to the functions that need to be
#   declared while creating it in the () brackets. A function can contain none, one or more than one parameter.
#   These parameters can belong to either of the three types –
# IN – These types of parameters are assigned the values while calling the function and the value cannot
#   be modified or overwritten inside the function but only referenced and used by the function.
# OUT – These are the parameters that can be assigned the values and overridden in the function but cannot
#   be referenced by it.
# IN OUT – These types of parameters are assigned the values while calling the function and the value can be
#   modified or overwritten inside the function as well as referenced and used by the function.
# BEGIN and END – BEGIN keyword marks the beginning of the function while END marks the completion of function
#   in MYSQL.
# RETURN Datatype – We can return any type of value from the execution of the function. The type of value that
#   will be returned needs to be specified after the RETURN clause. Once, MySQL finds the RETURN statement while
#   execution of the function, execution of the function is terminated and the value is returned.
# DETERMINISTIC – The function can be either deterministic or non-deterministic which needs to be specified here.
#   When the function returns the same value for the same values of parameter then it is called deterministic.
#       However, if the function returns a different value for the same values of functions then we can call that
#       function to be nondeterministic. When none of the types of function is mentioned, then MySQL will
#       consider function to be NON-DETERMINISTIC by default.
##########################################################################
# CREATE ASYMMETRIC KEY (Transact-SQL)
#
# CREATE ASYMMETRIC KEY asym_key_name
#    [ AUTHORIZATION database_principal_name ]
#    [ FROM <asym_key_source> ]
#    [ WITH <key_option> ]
#    [ ENCRYPTION BY <encrypting_mechanism> ]
#    [ ; ]
#
# <asym_key_source>::=
#      FILE = 'path_to_strong-name_file'
#    | EXECUTABLE FILE = 'path_to_executable_file'
#    | ASSEMBLY assembly_name
#    | PROVIDER provider_name
#
# <key_option> ::=
#    ALGORITHM = <algorithm>
#       |
#    PROVIDER_KEY_NAME = 'key_name_in_provider'
#       |
#       CREATION_DISPOSITION = { CREATE_NEW | OPEN_EXISTING }
#
# <algorithm> ::=
#       { RSA_4096 | RSA_3072 | RSA_2048 | RSA_1024 | RSA_512 }
#
# <encrypting_mechanism> ::=
#     PASSWORD = 'password'
##########################################################################
#  Generated column definitions have this syntax:
#
# col_name data_type [GENERATED ALWAYS] AS (expr)
#   [VIRTUAL | STORED] [NOT NULL | NULL]
#   [UNIQUE [KEY]] [[PRIMARY] KEY]
#   [COMMENT 'string']
##########################################################################
# Statement Labels
# [begin_label:] BEGIN
#     [statement_list]
# END [end_label]
#-- ----------------------------------------------------------------------
# BEGIN ... END syntax is used for writing compound statements, which can
# appear within stored programs (stored procedures and functions, triggers,
# and events). A compound statement can contain multiple statements, enclosed
# by the BEGIN and END keywords. statement_list represents a list of one or
# more statements, each terminated by a semicolon (;) statement delimiter.
# The statement_list itself is optional, so the empty compound statement
# (BEGIN END) is legal.
#-- ----------------------------------------------------------------------
# BEGIN ... END blocks can be nested.
# [begin_label:] LOOP
#     statement_list
# END LOOP [end_label]
#
# [begin_label:] REPEAT
#     statement_list
# UNTIL search_condition
# END REPEAT [end_label]
#
# [begin_label:] WHILE search_condition DO
#     statement_list
# END WHILE [end_label]
#-- ----------------------------------------------------------------------
# Labels are permitted for BEGIN ... END blocks and for the LOOP, REPEAT, and WHILE statements. Label use for those statements follows these rules:
#
# <begin_label> must be followed by a colon.
#
# <begin_label> can be given without end_label. If end_label is present, it must be the same as begin_label.
#
# <end_label> cannot be given without begin_label.
#
# Labels at the same nesting level must be distinct.
#
# Labels can be up to 16 characters long.
#
# To refer to a label within the labeled construct, use an ITERATE or LEAVE statement. The following example uses those statements to continue iterating or terminate the loop:
#
# CREATE PROCEDURE doiterate(p1 INT)
# BEGIN
#   label1: LOOP
#     SET p1 = p1 + 1;
#     IF p1 < 10 THEN ITERATE label1; END IF;
#     LEAVE label1;
#   END LOOP label1;
# END;
#-- ----------------------------------------------------------------------
##########################################################################
# Using LEAVE statement in loops
# The LEAVE statement allows you to terminate a loop. The general syntax for
# the LEAVE statement when using in the LOOP, REPEAT and WHILE statements.
#
# Using LEAVE with the LOOP statement:
#
# [label]: LOOP
#     IF condition THEN
#         LEAVE [label];
#     END IF;
#     -- statements
# END LOOP [label];

# Using LEAVE with the REPEAT statement:
#
# [label:] REPEAT
#     IF condition THEN
#         LEAVE [label];
#     END IF;
#     -- statements
# UNTIL search_condition
# END REPEAT [label];

# Using LEAVE with the WHILE statement:
#
# [label:] WHILE search_condition DO
#     IF condition THEN
#         LEAVE [label];
#     END IF;
#     -- statements
# END WHILE [label];


# The LEAVE causes the current loop specified by the label to be terminated.
# If a loop is enclosed within another loop, you can break out of both loops
# with a single LEAVE statement.
#-- ----------------------------------------------------------------------
##########################################################################
#-- ----------------------------------------------------------------------
drop table if exists Blog cascade;

drop table if exists Calendar cascade;

drop table if exists Church_Address cascade;

drop table if exists Church_Contact_Form_Email cascade;

drop table if exists Church_Contact_Form_Phone cascade;

drop table if exists Church_Contact_Form cascade;

drop table if exists Church_Emails cascade;

drop table if exists Church_Phones cascade;

drop table if exists Churches cascade;

drop table if exists Day cascade;

drop table if exists Month cascade;

drop table if exists Password cascade;

drop table if exists PreNeed_Form_Request_Email cascade;

drop table if exists PreNeed_Form_Request_Phone cascade;

drop table if exists PreNeed_Services_Requested cascade;

drop table if exists PreNeed_Form_Request cascade;

drop table if exists Services cascade;

drop table if exists Time cascade;

drop table if exists User_Address cascade;

drop table if exists Addresses cascade;

drop table if exists User_Email cascade;

drop table if exists Email cascade;

drop table if exists User_Phone cascade;

drop table if exists Phone cascade;

drop table if exists Type cascade;

drop table if exists User cascade;

drop table if exists Year cascade;

drop table if exists Zipcode cascade;

#-- ----------------------------------------------------------------------
##########################################################################
#-- ----------------------------------------------------------------------

CREATE TABLE Services (
                Service_Type VARCHAR(255) NOT NULL,
                Description VARCHAR(255) NOT NULL,
                PRIMARY KEY (Service_Type)
);


CREATE TABLE Phone (
                PhoneNumber VARCHAR(255) NOT NULL,
                PRIMARY KEY (PhoneNumber)
);


CREATE TABLE Email (
                Email VARCHAR(255) NOT NULL,
                PRIMARY KEY (Email)
);


CREATE TABLE Churches (
                Church_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Church_Name VARCHAR(255) NOT NULL,
                Denomination VARCHAR(255),
                Description TEXT,
                PRIMARY KEY (Church_ID)
);

ALTER TABLE Churches COMMENT 'collection of churches';


CREATE UNIQUE INDEX churches_church_id_uindex
 ON Churches
 ( Church_ID ASC );

CREATE TABLE Church_Phones (
                Church_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                PhoneNumber VARCHAR(255) NOT NULL,
                PRIMARY KEY (Church_ID, PhoneNumber)
);

ALTER TABLE Church_Phones COMMENT 'list of church phones';


CREATE TABLE Church_Emails (
                Church_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Email VARCHAR(255) NOT NULL,
                PRIMARY KEY (Church_ID, Email)
);

ALTER TABLE Church_Emails COMMENT 'list of emails';


CREATE TABLE Church_Contact_Form (
                CC_Form_ID VARBINARY(255) NOT NULL,
                Message TEXT,
                Church_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                PRIMARY KEY (CC_Form_ID)
);

ALTER TABLE Church_Contact_Form COMMENT 'church contact forms ';

ALTER TABLE Church_Contact_Form MODIFY COLUMN Message text COMMENT 'submitted message';


CREATE UNIQUE INDEX church_contact_form_cc_form_id_uindex
 ON Church_Contact_Form
 ( CC_Form_ID ASC );

CREATE UNIQUE INDEX church_contact_form_pk
 ON Church_Contact_Form
 ( CC_Form_ID ASC );

CREATE TABLE Addresses (
                Address_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Line_1 VARCHAR(255) NOT NULL,
                Line_2 VARCHAR(255),
                City VARCHAR(128) NOT NULL,
                State CHAR(2) NOT NULL,
                PostalCode CHAR(5) NOT NULL,
                RouteCode CHAR(4),
                ZipCode CHAR(10),
                PRIMARY KEY (Address_ID)
);

ALTER TABLE Addresses COMMENT 'all addresses stored here';


CREATE UNIQUE INDEX addresses_address_id_uindex
 ON Addresses
 ( Address_ID ASC );

CREATE TABLE Church_Address (
                Church_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Address_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                PRIMARY KEY (Church_ID, Address_ID)
);

ALTER TABLE Church_Address COMMENT 'a church may have multiple addresses on campus';


CREATE TABLE User (
                User_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Name VARCHAR(100),
                UserName VARCHAR(128),
                DateCreated DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
                PRIMARY KEY (User_ID)
);


CREATE UNIQUE INDEX user_username_uindex
 ON User
 ( UserName ASC );

CREATE UNIQUE INDEX user_id_uindex
 ON User
 ( User_ID ASC );

CREATE TABLE PreNeed_Form_Request (
                PreNeed_Request_Form_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                User_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Email VARCHAR(255) NOT NULL,
                PhoneNumber VARCHAR(255) NOT NULL,
                message VARCHAR(255),
                PRIMARY KEY (PreNeed_Request_Form_ID, User_ID)
);


CREATE INDEX user_email_preneed_form_request_fk
 ON PreNeed_Form_Request
 ( Email ASC );

CREATE INDEX user_phone_preneed_form_request_fk
 ON PreNeed_Form_Request
 ( PhoneNumber ASC );

CREATE TABLE PreNeed_Services_Requested (
                Service_Type VARCHAR(255) NOT NULL,
                PreNeed_Request_Form_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                PRIMARY KEY (Service_Type, PreNeed_Request_Form_ID)
);


CREATE TABLE User_Phone (
                User_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                PhoneNumber VARCHAR(255) NOT NULL,
                PRIMARY KEY (User_ID, PhoneNumber)
);


CREATE TABLE User_Email (
                User_ID VARBINARY(255) DEFAULT 0x30 NOT NULL,
                Email VARCHAR(255) NOT NULL,
                PRIMARY KEY (User_ID, Email)
);

create table if not exists Day
(
    Date                  varchar(16)    not null
        constraint `PRIMARY`
        primary key,
    Day_Number            int            null,
    Day_Name              char(16)       null,
    Day_Num_In_Year       int            null,
    Total_Available_Hours decimal(19, 2) null,
    Week_Start_Day        char(16)       null,
    Hours_Scheduled       decimal(19, 2) null
);

create table if not exists Month
(
    Month           int            not null
        constraint `PRIMARY`
        primary key,
    Total_Hours     decimal(19, 2) not null,
    Hours_Scheduled decimal(19, 2) not null,
    Month_Name      char(16)       not null
);

create table if not exists Services
(
    Service_Type varchar(255) not null,
    Description  varchar(255) not null,
    constraint Service_Type
        unique (Service_Type)
);

alter table Services
    add constraint `PRIMARY`
        primary key (Service_Type);

create table if not exists Time
(
    Time      int                                 not null
        constraint `PRIMARY`
        primary key,
    TimeStamp timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    TimeZone  char(32)                            not null
);

create table if not exists Type
(
    Type_Name   varchar(128) not null,
    Description varchar(255) null,
    constraint type_uindex
        unique (Type_Name)
)
    comment 'Used for Phone and Email; e.g. Home, Work';

alter table Type
    add constraint `PRIMARY`
        primary key (Type_Name);

create table if not exists Email
(
    Email varchar(255)                not null,
    Type  varchar(128) default 'HOME' not null,
    constraint Email
        unique (Email, Type),
    constraint Email_Type_fk
        foreign key (Type) references Type (Type_Name)
);

alter table Email
    add constraint `PRIMARY`
        primary key (Email, Type);

create trigger insert_email
    before insert
    on Email
    for each row
insert_email:
begin
    declare temp_email varchar(255);
    declare temp_type varchar(128);
    set new.Tupe = ucase(trim(new.Type));
    set new.Email = trim(new.Email);
    select Type_Name
    from alphatoo_a2o_backend.Type
    where alphatoo_a2o_backend.Type.Type_Name like new.Type
    into temp_type;
    if (ifnull(temp_type, null) is null) then
        insert into alphatoo_a2o_backend.Type(Type_Name, Description)
        values (new.Type, new.Type);
    end if;
end insert_email;

create table if not exists Phone
(
    PhoneNumber char(17)                    not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}'
        constraint `PRIMARY`
        primary key,
    Type        varchar(128) default 'HOME' null,
    constraint PhoneNumber
        unique (PhoneNumber, Type),
    constraint Phone_Type_FK
        foreign key (Type) references Type (Type_Name)
)
    comment ' {<country_code>####}-{<area_code>###}-{<local phone number>###-####}';

create trigger insert_phonenumber
    before insert
    on Phone
    for each row
insert_phonenumber:
begin
    # Phone Number Format: {<country_code>####}-{<area_code>###}-{<local phone number>###-####}
    declare temp_phone char(17);
    declare temp_type varchar(128);
    set new.PhoneNumber = alphatoo_a2o_backend.format_phone(new.PhoneNumber);
    set new.Type = ucase(trim(new.Type));
    insert_type:
    begin
        select Type_Name
        from alphatoo_a2o_backend.Type
        where alphatoo_a2o_backend.Type.Type_Name like new.Type
        into temp_type;
        if (ifnull(temp_type, null) is null) then
            insert into alphatoo_a2o_backend.Type(Type_Name, Description) values (new.Type, new.Type);
        end if;
#         leave insert_type;
    end insert_type;
    insert_phone:
    begin
        select PhoneNumber
        from alphatoo_a2o_backend.Phone
        where alphatoo_a2o_backend.Phone.PhoneNumber like new.PhoneNumber
        into temp_phone;
        if (ifnull(temp_phone, null) is not null) then -- if phone exists leave trigger insert_phonenumber
            leave insert_phonenumber;
        end if;
    end insert_phone;

end insert_phonenumber;

create trigger insert_type
    before insert
    on Type
    for each row
insert_type:
begin
    declare temp_type varchar(128);
    set new.Type_Name = ucase(trim(new.Type_Name));
    set new.Description = ucase(trim(new.Description));
    select Type_Name
    from alphatoo_a2o_backend.Type
    where alphatoo_a2o_backend.Type.Type_Name like new.Type_Name
    into temp_type;
    if (ifnull(temp_type, null) is not null) then
        leave insert_type;
    end if;
end insert_type;

create table if not exists User
(
    User_ID               varchar(255) default '00'              not null
        constraint `PRIMARY`
        primary key,
    User_Name             varchar(255)                           not null comment 'dataType: Email Address',
    FirstName             varchar(255)                           not null,
    LastName              varchar(255)                           not null,
    Preferred_Name        varchar(255)                           null,
    MailingList           char         default '0'               null comment 'value: [1=yes, 0=no]',
    DOB                   date                                   not null comment 'Date format: YYYY-mm-dd',
    Company_Name          varchar(255) default 'NONE'            null,
    Business_Name         varchar(255) default 'NONE'            null,
    Age                   char(3)                                null,
    Last_Update_TimeStamp timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint user_id_uindex
        unique (User_ID, Preferred_Name),
    constraint user_username_uindex
        unique (User_ID, User_Name)
);

create table if not exists Blog
(
    Blog_Id   varchar(255) default '00'              not null,
    User_ID   varchar(255) default '00'              not null,
    Date      date                                   not null,
    Time      time                                   not null,
    Message   blob                                   not null,
    TimeStamp datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint Blog_uindex
        unique (Blog_Id),
    constraint Blog_User_ID_FK
        foreign key (User_ID) references User (User_ID)
);

alter table Blog
    add constraint `PRIMARY`
        primary key (Blog_Id);

create trigger insert_blog_id
    before insert
    on Blog
    for each row
insert_blog_id:
begin
    set new.TimeStamp = now();
    set new.Date = substr(current_timestamp, 1, 10);
    set new.Time = substr(current_timestamp, 12, 8);
    set new.Blog_Id = Encrypt_Vals(concat(new.User_ID, ' ', new.TimeStamp), @private_key);
end insert_blog_id;

create table if not exists Password
(
    Passwd_ID varchar(255) default '00' not null,
    User_ID   varchar(255) default '00' not null,
    Password  varchar(255) default '00' not null,
    constraint Passwd_ID
        unique (Passwd_ID),
    constraint User_ID_FK
        foreign key (User_ID) references User (User_ID)
);

alter table Password
    add constraint `PRIMARY`
        primary key (Passwd_ID);

create trigger insert_passwd_id
    before insert
    on Password
    for each row
insert_passwd_id:
begin
    set new.Passwd_ID = Encrypt_Vals(concat(new.User_ID, ' ', new.Password), @private_key);
end insert_passwd_id;

create table if not exists PreNeed_Form_Request
(
    PreNeed_Request_Form_ID varchar(255) default '00'              not null,
    User_ID                 varchar(255) default '00'              not null,
    Contact_Name            varchar(255)                           null,
    Message                 text                                   null,
    TimeStamp               timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint PreNeed_Form_Request_uindex
        unique (PreNeed_Request_Form_ID, User_ID),
    constraint user_preneed_form_request_fk
        foreign key (User_ID, Contact_Name) references User (User_ID, Preferred_Name)
            on update cascade
);

alter table PreNeed_Form_Request
    add constraint `PRIMARY`
        primary key (PreNeed_Request_Form_ID, User_ID);

create trigger insert_preneed_form_id
    before insert
    on PreNeed_Form_Request
    for each row
insert_preneed_form_id:
begin
    set new.TimeStamp = current_timestamp();
    set new.PreNeed_Request_Form_ID = Encrypt_Vals(
            concat(new.User_ID, ' ', new.TimeStamp), @private_key);
end insert_preneed_form_id;

create table if not exists PreNeed_Form_Request_Email
(
    PreNeed_Request_Form_ID varchar(255) default '00' not null,
    Email                   varchar(255)              not null,
    Type                    varchar(128)              null,
    constraint `PRIMARY`
        primary key (PreNeed_Request_Form_ID, Email),
    constraint preneed_form_request_email_fk
        foreign key (Email, Type) references Email (Email, Type)
            on update cascade on delete cascade,
    constraint preneed_form_request_email_form_id_fk
        foreign key (PreNeed_Request_Form_ID) references PreNeed_Form_Request (PreNeed_Request_Form_ID)
            on update cascade on delete cascade
);

create table if not exists PreNeed_Form_Request_Phone
(
    PreNeed_Request_Form_ID varchar(255) default '00' not null,
    Phone                   char(17)                  not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    constraint `PRIMARY`
        primary key (PreNeed_Request_Form_ID, Phone),
    constraint preneed_form_request_phone_fk
        foreign key (Phone) references Phone (PhoneNumber)
            on update cascade on delete cascade,
    constraint preneed_form_request_phone_form_id_fk
        foreign key (PreNeed_Request_Form_ID) references PreNeed_Form_Request (PreNeed_Request_Form_ID)
            on update cascade on delete cascade
);

create table if not exists PreNeed_Services_Requested
(
    Service_Type            varchar(255)              not null,
    PreNeed_Request_Form_ID varchar(255) default '00' not null,
    constraint PreNeed_Services_Requested_uindex
        unique (Service_Type, PreNeed_Request_Form_ID),
    constraint preneed_form_request_preneed_services_requested_fk
        foreign key (PreNeed_Request_Form_ID) references PreNeed_Form_Request (PreNeed_Request_Form_ID),
    constraint services_preneed_services_requested_fk
        foreign key (Service_Type) references Services (Service_Type)
);

alter table PreNeed_Services_Requested
    add constraint `PRIMARY`
        primary key (Service_Type, PreNeed_Request_Form_ID);

create trigger insert_user
    before insert
    on User
    for each row
insert_user:
begin
    declare temp_email varchar(255);
    declare temp_address_id varchar(255);
    declare temp_exists varchar(8);
    declare temp_user_id varchar(255);
    set new.Last_Update_TimeStamp = current_timestamp();
    set new.Age = alphatoo_a2o_backend.get_age(new.DOB);
    set new.Preferred_Name = concat(new.FirstName, ' ', new.LastName);
    set temp_user_id = alphatoo_a2o_backend.Encrypt_Vals(
            concat(new.User_Name, '-', new.Preferred_Name, '-', new.DOB, '-', new.Last_Update_TimeStamp),
            @private_key);
    #     insert_email_user_name: begin
#         -- check alphatoo_a2o_backend.Email
#         select Email from alphatoo_a2o_backend.Email
#             where alphatoo_a2o_backend.Email.Email like new.User_Name into temp_email;
#         if (ifnull(temp_email, null) is null) then
#             insert into alphatoo_a2o_backend.Email(Email) values (new.User_Name);
#         end if;
#         -- check alphatoo_a2o_backend.User_Email
#         select Email from alphatoo_a2o_backend.User_Email
#             where alphatoo_a2o_backend.User_Email.Email like new.User_Name into temp_email;
#         if (ifnull(temp_email, null) is null) then -- the email does not exist in the db
#             insert into alphatoo_a2o_backend.User_Email(User_ID, Email) values (new.User_ID, new.User_Name);
#         end if;
#     end insert_email_user_name;

    -- check alphatoo_a2o_backend.Addresses and alphatoo_a2o_backend.User_Address
#     insert_user_address: begin
#         select Address_ID from alphatoo_a2o_backend.Addresses
#             where alphatoo_a2o_backend.Addresses.Address_ID like new.Address_ID into temp_address_id;
#         if (ifnull(temp_address_id, null) is not null) then -- the address_id exists in Addresses
#             select Address_ID from alphatoo_a2o_backend.User_Address
#                 where alphatoo_a2o_backend.User_Address.Address_ID like new.Address_ID
#                   and alphatoo_a2o_backend.User_Address.User_ID like temp_user_id into temp_address_id;
#             if (ifnull(temp_address_id, null) is null) then -- the address_id not exists in User_Address
#                 insert into alphatoo_a2o_backend.User_Address(User_ID, Address_ID)
#                     values (temp_user_id,new.Address_ID);
#             end if;
#         end if;
#     end insert_user_address;
    set new.User_ID = temp_user_id;
end insert_user;

create trigger update_user_email
    after insert
    on User
    for each row
update_user:
begin
    declare temp_email varchar(255);
    insert_email_user_name:
    begin
        -- check alphatoo_a2o_backend.Email
        select Email
        from alphatoo_a2o_backend.Email
        where alphatoo_a2o_backend.Email.Email like new.User_Name
        into temp_email;
        if (ifnull(temp_email, null) is null) then
            insert into alphatoo_a2o_backend.Email(Email) values (new.User_Name);
        end if;
        -- check alphatoo_a2o_backend.User_Email
        select Email
        from alphatoo_a2o_backend.User_Email
        where alphatoo_a2o_backend.User_Email.Email like new.User_Name
        into temp_email;
        if (ifnull(temp_email, null) is null) then -- the email does not exist in the db
            insert into alphatoo_a2o_backend.User_Email(User_ID, Email) values (new.User_ID, new.User_Name);
        end if;
    end insert_email_user_name;
end update_user;

create table if not exists User_Email
(
    User_ID varchar(255)                not null,
    Email   varchar(255)                not null,
    Type    varchar(128) default 'Home' null,
    constraint User_Email_uindex
        unique (User_ID, Email),
    constraint email_user_email_fk
        foreign key (Email, Type) references Email (Email, Type)
            on update cascade on delete cascade,
    constraint user_user_email_fk
        foreign key (User_ID, Email) references User (User_ID, User_Name)
);

alter table User_Email
    add constraint `PRIMARY`
        primary key (User_ID, Email);

create trigger insert_user_email
    after insert
    on User_Email
    for each row
insert_user_email:
begin
    declare temp_email varchar(255) default '0';
    select Email from Email where Email.Email like new.Email into temp_email;
    set temp_email = ifnull(temp_email, null);
    if (temp_email is null) then
        insert into alphatoo_a2o_backend.Email(Email, Type) VALUES (new.Email, new.Type);
    end if;
end insert_user_email;

create table if not exists User_Phone
(
    User_ID     varchar(255) default '00'   not null,
    PhoneNumber char(17)                    not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    Type        varchar(128) default 'Home' not null,
    constraint User_Phone_uindex
        unique (User_ID, PhoneNumber),
    constraint phone_user_phone_fk
        foreign key (PhoneNumber, Type) references Phone (PhoneNumber, Type)
            on update cascade on delete cascade,
    constraint user_user_phone_fk
        foreign key (User_ID) references User (User_ID)
);

alter table User_Phone
    add constraint `PRIMARY`
        primary key (User_ID, PhoneNumber);

create trigger insert_user_phone
    before insert
    on User_Phone
    for each row
insert_user_phone:
begin
    declare temp_type varchar(128);
    declare temp_phone varchar(17);
    declare temp_user_id varchar(255);
    set new.Type = ucase(trim(new.Type));
    set new.PhoneNumber = alphatoo_a2o_backend.format_phone(new.PhoneNumber);
    -- check User_ID constraint: user must exist in order to add user phone number
    select User_ID
    from alphatoo_a2o_backend.User
    where alphatoo_a2o_backend.User.User_ID like new.User_ID
    into temp_user_id;
    if (ifnull(temp_user_id, null) is null) then
        insert_type:
        begin
            select Type_Name
            from alphatoo_a2o_backend.Type
            where alphatoo_a2o_backend.Type.Type_Name like new.Type
            into temp_type;
            if (ifnull(temp_type, null) is null) then
                insert into alphatoo_a2o_backend.Type(Type_Name, Description) values (new.Type, new.Type);
            end if;
            #         leave insert_type;
        end insert_type;
        insert_phone:
        begin
            select PhoneNumber
            from alphatoo_a2o_backend.Phone
            where alphatoo_a2o_backend.Phone.PhoneNumber like new.PhoneNumber
            into temp_phone;
            if (ifnull(temp_phone, null) is null) then
                insert into alphatoo_a2o_backend.Phone(PhoneNumber, Type) values (new.PhoneNumber, new.Type);
            end if;
            #         leave insert_phone;
        end insert_phone;
    end if;

end insert_user_phone;

create table if not exists Year
(
    Year_Id   int     not null
        constraint `PRIMARY`
        primary key,
    Leap_Year char(5) not null
);

create table if not exists Calendar
(
    Year  int          not null,
    Month int          not null,
    Day   varchar(255) not null,
    Time  int          not null,
    constraint `PRIMARY`
        primary key (Year, Month, Day, Time),
    constraint Day_Calendar_FK
        foreign key (Day) references Day (Date),
    constraint Month_Calendar_FK
        foreign key (Month) references Month (Month),
    constraint Time_Calendar_FK
        foreign key (Time) references Time (Time),
    constraint Year_Calendar_FK
        foreign key (Year) references Year (Year_Id)
);

create table if not exists Zipcode
(
    Zipcode            char(10)     not null
        constraint `PRIMARY`
        primary key,
    Latitude           double       null,
    Longitude          double       null,
    City               varchar(128) not null,
    State_ID           char(2)      not null,
    State_Name         varchar(64)  not null,
    County_Fips        char(5)      not null,
    County_Name        varchar(64)  not null,
    All_County_Weights varchar(255) null,
    Timezone           varchar(45)  not null,
    constraint Zipcode_uindex
        unique (Zipcode, City, State_ID, State_Name, Timezone, County_Name)
);

create table if not exists Addresses
(
    Address_ID varchar(255) default '0000' not null,
    Type       char(16)     default 'HOME' not null,
    Line_1     varchar(255)                not null,
    Line_2     varchar(255) default 'N/A'  null,
    Zipcode    char(10)                    not null,
    City       varchar(64)                 null,
    State_ID   char(2)                     null,
    State_Name varchar(64)                 null,
    Timezone   varchar(45)                 null,
    constraint addresses_uindex
        unique (Address_ID),
    constraint addresses_type_fk
        foreign key (Type) references Type (Type_Name),
    constraint addresses_zipcode_fk
        foreign key (Zipcode, City, State_ID, State_Name, Timezone) references Zipcode (Zipcode, City, State_ID, State_Name, Timezone)
);

alter table Addresses
    add constraint `PRIMARY`
        primary key (Address_ID);

create trigger insert_addresses_address_id
    before insert
    on Addresses
    for each row
insert_addresses_address_id:
begin
    declare temp_City varchar(64);
    declare temp_State_ID char(2);
    declare temp_State_Name varchar(64);
    declare temp_Timezone varchar(45);
    set new.Type = ucase(trim(new.Type));
    select City, State_ID, State_Name, Timezone
    from alphatoo_a2o_backend.Zipcode
    where alphatoo_a2o_backend.Zipcode.Zipcode like new.Zipcode
    into temp_City,temp_State_ID,temp_State_Name,temp_Timezone;
    if (new.Line_2 is null) then
        set new.Line_2 = 'N/A';
    end if;
    set new.City = temp_City;
    set new.State_ID = temp_State_ID;
    set new.State_Name = temp_State_Name;
    set new.Timezone = temp_Timezone;
    set new.Address_ID =
            alphatoo_a2o_backend.Encrypt_Vals(concat(new.Type, ' ', new.Line_1, ' ', new.Line_2, ' ', new.Zipcode,
                                                     ' ', new.Timezone, ' ', current_timestamp()), @private_key);
    #     set new.Address_ID = alphatoo_a2o_backend.Encrypt_Vals(concat(new.Type, ' ', new.Line_1, ' ', new.Line_2, ' ', new.City, ' ',
#                                                      new.State_ID, ' ', new.Timezone,' ',current_timestamp()), @private_key);

    insert_type:
    begin
        if (ifnull((select Type_Name
                    from alphatoo_a2o_backend.Type
                    where alphatoo_a2o_backend.Type.Type_Name like new.Type), null) is null) then
            insert into alphatoo_a2o_backend.Type(Type_Name, Description)
            values (new.Type, new.Type);
        end if;
    end insert_type;
end insert_addresses_address_id;

create table if not exists Churches
(
    Church_ID    varchar(255) default '00'   not null,
    Church_Name  varchar(255)                not null,
    Denomination varchar(255) default 'NONE' null,
    Description  text                        null,
    Address_ID   varchar(255) default '00'   not null,
    constraint churches_church_id
        unique (Church_ID),
    constraint churches_address_fk
        foreign key (Address_ID) references Addresses (Address_ID)
)
    comment 'address_id/address must be inserted first before each Church insert';

alter table Churches
    add constraint `PRIMARY`
        primary key (Church_ID);

create table if not exists Church_Address
(
    Church_ID  varchar(255) default '00' not null,
    Address_ID varchar(255) default '00' not null,
    constraint `PRIMARY`
        primary key (Church_ID, Address_ID),
    constraint addresses_church_address_fk
        foreign key (Address_ID) references Addresses (Address_ID),
    constraint churches_church_address_fk
        foreign key (Church_ID) references Churches (Church_ID)
)
    comment 'a church may have multiple addresses on campus';

create table if not exists Church_Contact_Form
(
    CC_Form_ID   varchar(255) default '00'              not null,
    User_ID      varchar(255) default '00'              not null,
    Contact_Name varchar(255) default '00'              not null,
    Church_ID    varchar(255) default '00'              not null,
    Message      text                                   null comment 'submitted message',
    TimeStamp    timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint church_contact_form_pk
        unique (CC_Form_ID, User_ID, Church_ID),
    constraint church_contact_form_churches_fk
        foreign key (Church_ID) references Churches (Church_ID),
    constraint church_contact_form_user_id_fk
        foreign key (User_ID) references User (User_ID)
)
    comment 'church contact forms ';

alter table Church_Contact_Form
    add constraint `PRIMARY`
        primary key (CC_Form_ID, User_ID, Church_ID);

create trigger insert_church_contact_form_id
    before insert
    on Church_Contact_Form
    for each row
insert_church_contact_form_id:
begin
    set new.TimeStamp = current_timestamp;
    set new.Contact_Name = (select Preferred_Name
                            from alphatoo_a2o_backend.User
                            where new.User_ID = alphatoo_a2o_backend.User.User_ID);
    set new.CC_Form_ID = Encrypt_Vals(concat(new.Church_ID, ' ', new.User_ID, ' ', new.Contact_Name, ' ',
                                             new.TimeStamp), @private_key);
end insert_church_contact_form_id;

create table if not exists Church_Contact_Form_Email
(
    CC_Form_ID varchar(255) default '00' not null,
    Email      varchar(255)              not null,
    Type       varchar(128)              not null,
    constraint `PRIMARY`
        primary key (CC_Form_ID, Email),
    constraint church_contact_form_email_cc_form_id_fk
        foreign key (CC_Form_ID) references Church_Contact_Form (CC_Form_ID)
            on update cascade on delete cascade,
    constraint church_contact_form_email_fk
        foreign key (Email, Type) references Email (Email, Type)
            on update cascade on delete cascade
);

create table if not exists Church_Contact_Form_Phone
(
    CC_Form_ID varchar(255) default '00' not null,
    Phone      char(17)                  not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    constraint `PRIMARY`
        primary key (CC_Form_ID, Phone),
    constraint church_contact_form_cc_form_id_fk
        foreign key (CC_Form_ID) references Church_Contact_Form (CC_Form_ID)
            on update cascade on delete cascade,
    constraint church_contact_form_phone_fk
        foreign key (Phone) references Phone (PhoneNumber)
            on update cascade on delete cascade
);

create table if not exists Church_Emails
(
    Church_ID varchar(255) default '00' not null,
    Email     varchar(255)              not null,
    constraint Church_ID
        unique (Church_ID, Email),
    constraint churches_church_emails_fk
        foreign key (Church_ID) references Churches (Church_ID)
            on update cascade on delete cascade,
    constraint email_church_emails_fk
        foreign key (Email) references Email (Email)
            on update cascade on delete cascade
)
    comment 'list of emails';

alter table Church_Emails
    add constraint `PRIMARY`
        primary key (Church_ID, Email);

create table if not exists Church_Phones
(
    Church_ID   varchar(255) default '00' not null,
    PhoneNumber char(17)                  not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    constraint Church_Phones_uindex
        unique (Church_ID, PhoneNumber),
    constraint churches_church_phones_fk
        foreign key (Church_ID) references Churches (Church_ID)
            on update cascade on delete cascade,
    constraint phone_church_phones_fk
        foreign key (PhoneNumber) references Phone (PhoneNumber)
            on update cascade on delete cascade
)
    comment 'list of church phones';

alter table Church_Phones
    add constraint `PRIMARY`
        primary key (Church_ID, PhoneNumber);

create trigger insert_churches_id
    before insert
    on Churches
    for each row
insert_churches_id:
begin
    # create ID
    set new.Church_ID = Encrypt_Vals(concat(new.Church_ID, ' ', new.Church_Name, ' ',
                                            new.Denomination, ' ', new.Address_ID), @private_key);
end insert_churches_id;

create table if not exists User_Address
(
    User_ID    varchar(255) default '00' not null,
    Address_ID varchar(255) default '00' not null,
    constraint User_Address_uindex
        unique (User_ID, Address_ID),
    constraint addresses_user_address_fk
        foreign key (Address_ID) references Addresses (Address_ID)
            on update cascade on delete cascade,
    constraint user_user_address_fk
        foreign key (User_ID) references User (User_ID)
            on update cascade on delete cascade
)
    comment 'list of address associated with each user';

alter table User_Address
    add constraint `PRIMARY`
        primary key (User_ID, Address_ID);


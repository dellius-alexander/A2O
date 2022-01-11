##########################################################################
#-- ----------------------------------------------------------------------
# create database
drop database if exists alphatoo_a2o_backend;
create database alphatoo_a2o_backend;
use alphatoo_a2o_backend;
#-- ----------------------------------------------------------------------
# SETTINGS
# set GLOBAL storage_engine='InnoDb';
# SET GLOBAL default_storage_engine = 'InnoDB';
SET NAMES utf8;
SET time_zone = '-05:00';
select current_timestamp() as 'Current Time';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';
#-- ----------------------------------------------------------------------
##########################################################################
##########################################################################
# SETUP ENCRYPTION ALGORITHM AND PRIVATE/PUBLIC KEYS
-- Encryption algorithm; can be 'DSA' or 'DH' instead
SET @algo = 'RSA';
-- Key length in bits; make larger for stronger keys
SET @key_len = 224;
# select @key_len;
-- Create private key
set @private_key = ucase(sha2('alphatoo_a2o_backend', @key_len));
select @private_key as 'Private Key';
# -- Create public key
# set @public_key = hex(aes_encrypt('alphatoo_a2o_backend', @private_key));
# select @public_key;
#-- ----------------------------------------------------------------------
# # Use the private key to encrypt data and the public key to decrypt it
# # This requires that the members of the key pair be RSA keys.
#
# SET @ciphertext = asymmetric_encrypt(@algo, 'My secret text', @private);
# SET @plaintext = asymmetric_decrypt(@algo, @ciphertext, @public);

# # Conversely, you can encrypt using the public key and decrypt using the private key.
#
# SET @ciphertext = asymmetric_encrypt(@algo, 'My secret text', @pub);
# SET @plaintext = asymmetric_decrypt(@algo, @ciphertext, @private);
#-- ----------------------------------------------------------------------
##########################################################################
# SPECIAL VARIABLES LISTED HERE
SHOW VARIABLES LIKE 'secure_file_priv'; -- Directory of imported files
#-- ----------------------------------------------------------------------
set @special_char_regex = '[\-\+\(\)\\[\\]\_\=\*\%\^\#\!\&\/\~\'\"\?\>\<\.\,\:\;\@\`]+';
#-- ----------------------------------------------------------------------
#-- ----------------------------------------------------------------------
##########################################################################
# Create FUNCTIONS
##########################################################################
#-- ----------------------------------------------------------------------
drop
    function if exists alphatoo_a2o_backend.Encrypt_Vals;
create
#     definer = alphatoo_dalex@`76.105.120.24`
    function alphatoo_a2o_backend.Encrypt_Vals(object varchar(512), pub_key varchar(255))
    returns text
    comment '@param: object longtext => object must be of string format;'
    comment '@param: pub_key varchar(255) => pub_key must be hex formatted key;'
    deterministic
BEGIN
    if (object is null) then
        return null;
    elseif (object is not null) then
        return hex(aes_encrypt(object, pub_key));
    end if;

END;

# set @encrypt_key = Encrypt_Vals(concat('Jane ', 'Doe ','janedoe@gmail.com [',  1, '] 1979-01-04'),@private_key);
# select length(@encrypt_key) as 'length', @encrypt_key as 'KEY';
#
# select Decrypt_Vals(@encrypt_key,@private_key) as 'original';

#-- ----------------------------------------------------------------------
drop
    function if exists alphatoo_a2o_backend.Decrypt_Vals;
create
#     definer = alphatoo_dalex@`76.105.120.24`
    function alphatoo_a2o_backend.Decrypt_Vals(object text, pub_key varchar(255))
    returns text
    comment '@param: object text => object must be of hex format;'
    comment '@param: pub_key varchar(255) => pub_key must be hex formatted key;'
    deterministic
BEGIN
    if (object is null) then
        return null;
    end if;
    return aes_decrypt(unhex(object), pub_key);
END;
#-- ----------------------------------------------------------------------
drop function if exists alphatoo_a2o_backend.get_age;
create
    #     definer = alphatoo_dalex@`76.105.120.24`
    function alphatoo_a2o_backend.get_age(DOB date)
    returns int
    deterministic
    comment 'DOB Format: [YYYY-mm-dd]'
get_age:
begin
    return year(substr(current_timestamp, 1, 10)) - year(DOB) -
           (right(substr(current_timestamp, 1, 10), 5) < right(DOB, 5));
end get_age;

#-- ----------------------------------------------------------------------
drop function if exists alphatoo_a2o_backend.no_of_years;
create
#     definer = alphatoo_dalex@`76.105.120.24`
    function alphatoo_a2o_backend.no_of_years(DOB date)
    returns int
    deterministic
no_of_years:
BEGIN
    DECLARE date2 DATE;
    Select current_date() into date2;
    RETURN date(date2) - date(DOB);
END no_of_years;
#-- ----------------------------------------------------------------------

drop function if exists alphatoo_a2o_backend.format_phone;
create
    function alphatoo_a2o_backend.format_phone(phone char(32))
    returns char(17)
    deterministic
format_phone:
begin
    -- Phone Number Format: {<country_code>####}-{<area_code>###}-{<local phone number>###-####}
    declare temp_phone varchar(14);
    declare temp_country_code char(4) default '1';
    declare temp_area_code char(3);
    declare temp_local_prefix char(3);
    declare temp_local_suffix char(4);
    -- break phone number into segments
    split_phone_number:
    begin
        -- remove any special characters
        set temp_phone = lpad(regexp_replace(trim(phone), @special_char_regex, ''), 14, 0);
        -- remove leading zeroes
        set temp_country_code = regexp_replace(substr(temp_phone, -14, 4), '^[0]+', '');
        set temp_area_code = substr(temp_phone, -10, 3);
        set temp_local_prefix = substr(temp_phone, -7, 3);
        set temp_local_suffix = substr(temp_phone, -4, 4);
    end split_phone_number;
    -- check if country code is not entered
    check_country_code:
    begin
        if (length(temp_country_code) = 0) then
            set temp_country_code = '1';
        end if;
    end check_country_code;
    return concat(temp_country_code, '-', temp_area_code, '-', temp_local_prefix, '-', temp_local_suffix);
end format_phone;

# select format_phone('[+=12]-(206)-356_5206') as `Formated Phone`;
#-- ----------------------------------------------------------------------
drop function if exists alphatoo_a2o_backend.hexToBin;
create
#     definer = alphatoo_dalex@`76.105.120.24`
    function alphatoo_a2o_backend.hexToBin(obj varchar(512))
    returns longblob
    deterministic -- return datatype is constant or fits within the return datatype
#non deterministic -- return datatype can change; from, e.g. int to char, etc...
begin
    declare cntr varchar(16);
    declare len int;
    declare hexToBin varbinary(512) default '';
    declare start int default 1;
    declare chunks int;
    declare position int default 1;
    declare bin_sum bigint default 0;
    -- set values
    set chunks = LENGTH(obj) / 16;
    #     set hexToBin =  conv(substr(obj,start,16),16,2);
    -- loop through each chunk and aggregate sum of each chunk
    while chunks >= 1
        do
            -- start loop
            set cntr = substr(obj, start, 16);
#         set hexToBin = concat(hexToBin,'0000',cast(cntr as unsigned ));
            set hexToBin = concat(hexToBin, conv(cntr, 16, 2));
            set start = start + 16;
            set chunks = chunks - 1;
        end while;
    -- end of loop
    return hexToBin;

end;
# #-- ----------------------------------------------------------------------
# set @object = '8E1F000B331DD75AA926DDB1000CE0F67787E06E75DE19E0F30FD1250286B626041FEA29057BAB85F2FCF2BA437E7AC73AC537FB63D648929B717B33F06FFD1A8F';
# #-- ----------------------------------------------------------------------
# select length(@object) as 'length of object';
# select length(hexToBin(@object)) as 'length of hexToBin';
# #-- ----------------------------------------------------------------------
##########################################################################
##########################################################################
# Create Tables
##########################################################################
#-- ----------------------------------------------------------------------

drop table if exists alphatoo_a2o_backend.User cascade;
create table if not exists alphatoo_a2o_backend.User
(
    User_ID               varchar(255)                          not null,
    User_Name             varchar(255)                           not null comment 'dataType: Email Address',
    FirstName             varchar(255)                           not null,
    LastName              varchar(255)                           not null,
    Preferred_Name        varchar(255)                           null,
    MailingList           char(1)      default '0'               null comment 'value: [1=yes, 0=no]',
    DOB                   date                                   not null comment 'Date format: YYYY-mm-dd',
    Company_Name          varchar(255) default 'NONE'            null,
    Business_Name         varchar(255) default 'NONE'            null,
    Age                   char(3)                                null,
    Last_Update_TimeStamp timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint user_pk
        primary key (User_ID),
    constraint user_uindex
        unique (User_Name,FirstName,LastName,DOB),
    constraint user_username_uindex
        unique (User_ID,User_Name),
    constraint user_preferredname_uindex
        unique (User_ID,Preferred_Name)
);


drop trigger if exists alphatoo_a2o_backend.insert_user;
create trigger alphatoo_a2o_backend.insert_user
    before insert
    on alphatoo_a2o_backend.User
    for each row
insert_user:
begin
#     set foreign_key_checks = 1;
    set @temp_user_id = ifnull(new.User_ID,null);
    set @timestamp = current_timestamp();
    set @age = alphatoo_a2o_backend.get_age(new.DOB);
    set @preferred_name = concat(new.FirstName, ' ', new.LastName);
    -- create hash
    create_hash:
        begin
#         set @user_id = (select alphatoo_a2o_backend.Encrypt_Vals(concat(new.User_Name,'-',
#           @preferred_name,'-', @age,'-',@timestamp), @private_key));
        select alphatoo_a2o_backend.Encrypt_Vals(concat(new.User_Name,',',new.FirstName,',',new.LastName,',',new.DOB), @private_key)
                        into @temp_user_id;
    end create_hash;
    set new.User_ID = @temp_user_id;
    set new.Last_Update_TimeStamp = @timestamp;
    set new.Age = @age;
    set new.Preferred_Name = @preferred_name;
end insert_user;


drop trigger if exists alphatoo_a2o_backend.update_user_email;
create trigger alphatoo_a2o_backend.update_user_email
    after insert
    on alphatoo_a2o_backend.User
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


# INSERT INTO alphatoo_a2o_backend.User(User_ID,User_Name, FirstName, LastName, MailingList, DOB)
#     VALUES (1,'janedoe@gmail.com', 'Jane', 'Doe', '1',
#             '1979-01-03');
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Type cascade;
create table if not exists alphatoo_a2o_backend.Type
(
    Type_Name   varchar(128) not null,
    Description varchar(255) null,
    constraint type_pk
        primary key (Type_Name),
    constraint type_uindex
        unique index (Type_Name)

) comment 'Used for Phone and Email; e.g. Home, Work';

drop trigger if exists alphatoo_a2o_backend.insert_type;
create trigger alphatoo_a2o_backend.insert_type
    before insert
    on alphatoo_a2o_backend.Type
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

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Email cascade;
create table if not exists alphatoo_a2o_backend.Email
(
    Email varchar(255) not null,
    constraint email_pk
        primary key (Email),
    constraint email_uindex
        unique index (Email)
);

drop trigger if exists alphatoo_a2o_backend.insert_email;
create
    trigger alphatoo_a2o_backend.insert_email
    before insert
    on alphatoo_a2o_backend.Email
    for each row
insert_email:
begin
    declare temp_email varchar(255);
    set new.Email = trim(new.Email);
end insert_email;
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Zipcode;
create table if not exists alphatoo_a2o_backend.Zipcode
(
    Zipcode            char(10)     not null,
    Latitude           double       null,
    Longitude          double       null,
    City               varchar(128) not null,
    State_ID           char(2)      not null,
    State_Name         varchar(64)  not null,
    County_Fips        char(5)      not null,
    County_Name        varchar(64)  not null,
    All_County_Weights varchar(255) null,
    Timezone           varchar(45)  not null,
    constraint zipcode_pk
    primary key (Zipcode),
    constraint zipcode_uindex
        unique (Zipcode, City, State_ID, State_Name, Timezone, County_Name)
);

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Addresses;
create table if not exists alphatoo_a2o_backend.Addresses
(
    Address_ID varchar(255)                        not null,
    Type       char(16)  default 'HOME'            not null,
    Line_1     varchar(255)                        not null,
    Line_2     varchar(255)                        null,
    Zipcode    char(10)                            not null,
    City       varchar(64)                         null,
    State_ID   char(2)                             null,
    State_Name varchar(64)                         null,
    Timezone   varchar(45)                         null,
    TimeStamp  timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint addresses_pk
        primary key (Address_ID),
    constraint addresses_uindex_address
        unique (Type, Line_1, Line_2, Zipcode),
    constraint addresses_zipcode_fk
        foreign key (Zipcode, City, State_ID, State_Name, Timezone)
            references alphatoo_a2o_backend.Zipcode (Zipcode, City, State_Id, State_Name, Timezone)
            on update no action on delete no action,
    constraint addresses_type_fk
        foreign key (Type)
            references alphatoo_a2o_backend.Type (Type_Name)
            on update no action on delete no action
);


drop trigger if exists alphatoo_a2o_backend.insert_addresses_address_id;
create trigger alphatoo_a2o_backend.insert_addresses_address_id
    before insert
    on alphatoo_a2o_backend.Addresses
    for each row
insert_addresses_address_id:
begin
    set @temp_city = ifnull(new.City, '0');
    set @temp_state_id = ifnull(new.State_ID, '0');
    set @temp_state_name = ifnull(new.State_Name, '0');
    set @temp_timezone = ifnull(new.Timezone, '0');
    set @temp_address_id = ifnull(new.Address_ID, null);
    set new.Type = ucase(trim(new.Type));
    get_zipcode_info: -- check zipcode and get city, state, and timezone
    begin
        select City, State_ID, State_Name, Timezone
        from alphatoo_a2o_backend.Zipcode
        where alphatoo_a2o_backend.Zipcode.Zipcode like new.Zipcode
        into @temp_city, @temp_state_id, @temp_state_name, @temp_timezone;
    end get_zipcode_info;
    -- In case line_2 is null assign N/A
    if (new.Line_2 is null) then
        set new.Line_2 = 'N/A';
    end if;
    set new.City = @temp_city;
    set new.State_ID = @temp_state_id;
    set new.State_Name = @temp_state_name;
    set new.Timezone = @temp_timezone;
    set new.TimeStamp = current_timestamp();
    -- Create hash
    select alphatoo_a2o_backend.Encrypt_Vals(concat(new.Type,';', new.Line_1,';', new.Line_2,';', new.Zipcode,';', new.Timezone),
                   @private_key) into @temp_address_id;
    set new.Address_ID = @temp_address_id;
    insert_type: -- check and add new type if needed
    begin
        set @temp_type = (select Type_Name
                          from alphatoo_a2o_backend.Type
                          where alphatoo_a2o_backend.Type.Type_Name like new.Type);
        if (ifnull(@temp_type, null) is null) then
            insert into alphatoo_a2o_backend.Type(Type_Name, Description)
            values (new.Type, new.Type);
        end if;
    end insert_type;
end insert_addresses_address_id;

#
# drop trigger if exists alphatoo_a2o_backend.insert_addresses_address_id_hash;
# create
#     trigger alphatoo_a2o_backend.insert_addresses_address_id_hash
#     after insert
#     on alphatoo_a2o_backend.Addresses
#     for each row
# insert_addresses_address_id_hash:
# begin
#     set @temp_address_id = ifnull(alphatoo_a2o_backend.Addresses.Address_ID, null);
#     if (@temp_address_id is null) then
#         set @temp_address_id = alphatoo_a2o_backend.Encrypt_Vals(concat(alphatoo_a2o_backend.Addresses.Type, '-',
#             alphatoo_a2o_backend.Addresses.Line_1, '-', alphatoo_a2o_backend.Addresses.Line_2, '-',
#             alphatoo_a2o_backend.Addresses.Zipcode, '-', alphatoo_a2o_backend.Addresses.Timezone, '-', alphatoo_a2o_backend.Addresses.TimeStamp), @private_key);
# #         set @temp_address_id = alphatoo_a2o_backend.Encrypt_Vals(concat(Type, '-',
# #             Line_1, '-', Line_2, '-',
# #             Zipcode, '-', Timezone, '-', TimeStamp), @private_key);
#         update alphatoo_a2o_backend.Addresses
#             set alphatoo_a2o_backend.Addresses.Address_ID = @temp_address_id
#             where alphatoo_a2o_backend.Addresses.ID = new.ID;
#     end if;
# end insert_addresses_address_id_hash;
# set @hash_val = (select alphatoo_a2o_backend.Encrypt_Vals(concat('Home '), @private_key));
# select @hash_val;
# INSERT INTO alphatoo_a2o_backend.Addresses(Address_ID,Type, Line_1, Line_2, Zipcode, City, State_ID, State_Name)
#     VALUES (null,'Home', '2650 Johns Creek Rd', null, 30094, null, null, null);

#-- ----------------------------------------------------------------------


drop table if exists alphatoo_a2o_backend.User_Email cascade;
create table if not exists alphatoo_a2o_backend.User_Email
(
    User_ID varchar(255)                not null,
    Email   varchar(255)                not null,
    Type    varchar(128) default 'Home' null,
    primary key (User_ID, Email),
    constraint User_Email_uindex
        unique (User_ID, Email),
    constraint email_user_email_fk
        foreign key (Email) references alphatoo_a2o_backend.Email (Email)
            on update cascade on delete restrict,
    constraint user_user_email_fk
        foreign key (User_ID, Email) references alphatoo_a2o_backend.User (User_ID, User_Name)
            on update cascade on delete cascade
);


drop trigger if exists alphatoo_a2o_backend.insert_user_email;
create trigger alphatoo_a2o_backend.insert_user_email
    after insert
    on alphatoo_a2o_backend.User_Email
    for each row
insert_user_email:
begin
    declare temp_email varchar(255) default '0';
    select Email from alphatoo_a2o_backend.Email where alphatoo_a2o_backend.Email.Email like new.Email into temp_email;

    if (ifnull(temp_email, null) is null) then
        insert into alphatoo_a2o_backend.Email(Email) VALUES (new.Email, new.Type);
    end if;
end insert_user_email;

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.User_Phone cascade;
create table if not exists alphatoo_a2o_backend.User_Phone
(
    User_ID     varchar(255) default '00'   not null,
    PhoneNumber char(17)                    not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    Type        varchar(128) default 'Home' not null,
    primary key (User_ID, PhoneNumber),
    constraint User_Phone_uindex
        unique (User_ID, PhoneNumber),
    constraint phone_user_phone_fk
        foreign key (PhoneNumber, Type)
            references alphatoo_a2o_backend.Phone (PhoneNumber, Type)
            on update cascade on delete cascade,
    constraint user_user_phone_fk
        foreign key (User_ID)
            references alphatoo_a2o_backend.User (User_ID)
            on update no action on delete no action
);

drop trigger if exists alphatoo_a2o_backend.insert_user_phone;
create trigger alphatoo_a2o_backend.insert_user_phone
    before insert
    on alphatoo_a2o_backend.User_Phone
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

# select ifnull((select PhoneNumber from alphatoo_a2o_backend.Phone
# where alphatoo_a2o_backend.Phone.PhoneNumber like '678-650-9414'), 0) as 'Results';

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Day cascade;
create table if not exists alphatoo_a2o_backend.Day
(
    Date                  varchar(16)    not null,
    Day_Number            int            null,
    Day_Name              char(16)       null,
    Day_Num_In_Year       int            null,
    Total_Available_Hours decimal(19, 2) null,
    Week_Start_Day        char(16)       null,
    Hours_Scheduled       decimal(19, 2) null,
    primary key (Date)
);

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Month cascade;
create table if not exists alphatoo_a2o_backend.Month
(
    Month           int            not null,
    Total_Hours     decimal(19, 2) not null,
    Hours_Scheduled decimal(19, 2) not null,
    Month_Name      char(16)       not null,
    primary key (Month)
);
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Services cascade;
create table if not exists alphatoo_a2o_backend.Services
(
    Service_Type varchar(255) not null,
    Description  varchar(255) not null,
    primary key (Service_Type),
    constraint Service_Type
        unique (Service_Type)
);

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Time cascade;
create table if not exists alphatoo_a2o_backend.Time
(
    Time      int                                 not null,
    TimeStamp timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    TimeZone  char(32)                            not null,
    primary key (Time)
);

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Year;
create table if not exists alphatoo_a2o_backend.Year
(
    Year_Id   int     not null,
    Leap_Year char(5) not null,
    primary key (Year_Id)
);
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Calendar;
create table if not exists alphatoo_a2o_backend.Calendar
(
    Year  int          not null,
    Month int          not null,
    Day   varchar(255) not null,
    Time  int          not null,
    primary key (Year, Month, Day, Time),
    constraint Day_Calendar_FK
        foreign key (Day) references alphatoo_a2o_backend.Day (Date),
    constraint Month_Calendar_FK
        foreign key (Month) references alphatoo_a2o_backend.Month (Month),
    constraint Time_Calendar_FK
        foreign key (Time) references alphatoo_a2o_backend.Time (Time),
    constraint Year_Calendar_FK
        foreign key (Year) references alphatoo_a2o_backend.Year (Year_Id)
);

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Phone cascade;
create table if not exists alphatoo_a2o_backend.Phone
(
    PhoneNumber char(17)                    not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    Type        varchar(128) default 'HOME' null,
    primary key (PhoneNumber),
    constraint PhoneNumber
        unique (PhoneNumber, Type),
    constraint Phone_Type_FK
        foreign key (Type) references alphatoo_a2o_backend.Type (Type_Name)
)
    comment ' {<country_code>####}-{<area_code>###}-{<local phone number>###-####}'
;

drop trigger if exists alphatoo_a2o_backend.insert_phonenumber;
create
    trigger alphatoo_a2o_backend.insert_phonenumber
    before insert
    on alphatoo_a2o_backend.Phone
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

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Blog cascade;
create table if not exists alphatoo_a2o_backend.Blog
(
    Blog_Id   varchar(255) default '00'              not null,
    User_ID   varchar(255) default '00'              not null,
    Date      date                                   not null,
    Time      time                                   not null,
    Message   blob                                   not null,
    TimeStamp datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    primary key (Blog_Id),
    constraint Blog_uindex
        unique key (Blog_Id),
    constraint Blog_User_ID_FK
        foreign key (User_ID) references alphatoo_a2o_backend.User (User_ID)
);

drop trigger if exists alphatoo_a2o_backend.insert_blog_id;
create trigger alphatoo_a2o_backend.insert_blog_id
    before insert
    on alphatoo_a2o_backend.Blog
    for each row
insert_blog_id:
begin
    set new.TimeStamp = now();
    set new.Date = substr(current_timestamp, 1, 10);
    set new.Time = substr(current_timestamp, 12, 8);
    set new.Blog_Id = Encrypt_Vals(concat(new.User_ID, ' ', new.TimeStamp), @private_key);
end insert_blog_id;

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Password cascade;
create table if not exists alphatoo_a2o_backend.Password
(
    Passwd_ID varchar(255) default '00' not null,
    User_ID   varchar(255) default '00' not null,
    Password  varchar(255) default '00' not null,
    primary key (Passwd_ID),
    constraint Passwd_ID
        unique (Passwd_ID),
    constraint User_ID_FK
        foreign key (User_ID) references alphatoo_a2o_backend.User (User_ID)
);


drop trigger if exists alphatoo_a2o_backend.insert_passwd_id;
create trigger alphatoo_a2o_backend.insert_passwd_id
    before insert
    on alphatoo_a2o_backend.Password
    for each row
insert_passwd_id:
begin
    set new.Passwd_ID = Encrypt_Vals(concat(new.User_ID, ' ', new.Password), @private_key);
end insert_passwd_id;

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.PreNeed_Form_Request cascade;
create table if not exists alphatoo_a2o_backend.PreNeed_Form_Request
(
    PreNeed_Request_Form_ID varchar(255) default '00'              not null,
    User_ID                 varchar(255) default '00'              not null,
    Contact_Name            varchar(255)                           null,
    Message                 text                                   null,
    TimeStamp               timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    primary key (PreNeed_Request_Form_ID, User_ID),
    constraint PreNeed_Form_Request_uindex
        unique index (PreNeed_Request_Form_ID, User_ID),
    constraint user_preneed_form_request_fk
        foreign key (User_ID, Contact_Name)
            references alphatoo_a2o_backend.User (User_ID, Preferred_Name)
            on update restrict on delete no action
);


drop trigger if exists alphatoo_a2o_backend.insert_preneed_form_id;
create trigger alphatoo_a2o_backend.insert_preneed_form_id
    before insert
    on alphatoo_a2o_backend.PreNeed_Form_Request
    for each row
insert_preneed_form_id:
begin
    set new.TimeStamp = current_timestamp();
    set new.PreNeed_Request_Form_ID = Encrypt_Vals(
            concat(new.User_ID, ' ', new.TimeStamp), @private_key);
end insert_preneed_form_id;

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.PreNeed_Form_Request_Phone cascade;
create table if not exists alphatoo_a2o_backend.PreNeed_Form_Request_Phone
(
    PreNeed_Request_Form_ID varchar(255) default '00' not null,
    Phone                   char(17)                  not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    primary key (PreNeed_Request_Form_ID, Phone),
    constraint preneed_form_request_phone_fk
        foreign key (Phone)
            references alphatoo_a2o_backend.Phone (PhoneNumber)
            on update cascade on delete cascade,
    constraint preneed_form_request_phone_form_id_fk
        foreign key (PreNeed_Request_Form_ID)
            references alphatoo_a2o_backend.PreNeed_Form_Request (PreNeed_Request_Form_ID)
            on update cascade on delete cascade

);
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.PreNeed_Form_Request_Email cascade;
create table if not exists alphatoo_a2o_backend.PreNeed_Form_Request_Email
(
    PreNeed_Request_Form_ID varchar(255) default '00' not null,
    Email                   varchar(255)              not null,
    Type                    varchar(128)              null,
    primary key (PreNeed_Request_Form_ID, Email),
    constraint preneed_form_request_email_fk
        foreign key (Email)
            references alphatoo_a2o_backend.Email (Email)
            on update cascade on delete cascade,
    constraint preneed_form_request_email_form_id_fk
        foreign key (PreNeed_Request_Form_ID)
            references alphatoo_a2o_backend.PreNeed_Form_Request (PreNeed_Request_Form_ID)
            on update cascade on delete cascade

);
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.PreNeed_Services_Requested cascade;
create table if not exists alphatoo_a2o_backend.PreNeed_Services_Requested
(
    Service_Type            varchar(255)              not null,
    PreNeed_Request_Form_ID varchar(255) default '00' not null,
    primary key (Service_Type, PreNeed_Request_Form_ID),
    constraint PreNeed_Services_Requested_uindex
        unique (Service_Type, PreNeed_Request_Form_ID),
    constraint preneed_form_request_preneed_services_requested_fk
        foreign key (PreNeed_Request_Form_ID) references alphatoo_a2o_backend.PreNeed_Form_Request (PreNeed_Request_Form_ID),
    constraint services_preneed_services_requested_fk
        foreign key (Service_Type) references alphatoo_a2o_backend.Services (Service_Type)
)
;

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Churches cascade;
create table if not exists alphatoo_a2o_backend.Churches
(
    Church_ID    varchar(255) default '00'   not null,
    Church_Name  varchar(255)                not null,
    Denomination varchar(255) default 'NONE' null,
    Description  text                        null,
    Address_ID   varchar(255) default '00'   not null,
    primary key (Church_ID),
    constraint churches_church_id
        unique (Church_ID),
    constraint churches_address_fk
        foreign key (Address_ID)
            references alphatoo_a2o_backend.Addresses (Address_ID)
)
    comment 'collection of churches'
    comment 'address_id/address must be inserted first before each Church insert'
;


drop trigger if exists alphatoo_a2o_backend.insert_churches_id;
create trigger alphatoo_a2o_backend.insert_churches_id
    before insert
    on alphatoo_a2o_backend.Churches
    for each row
insert_churches_id:
begin
    # create ID
    set new.Church_ID = Encrypt_Vals(concat(new.Church_ID, ' ', new.Church_Name, ' ',
                                            new.Denomination, ' ', new.Address_ID), @private_key);
end insert_churches_id;

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Church_Contact_Form cascade;
create table if not exists alphatoo_a2o_backend.Church_Contact_Form
(
    CC_Form_ID   varchar(255) default '00'              not null,
    User_ID      varchar(255) default '00'              not null,
    Contact_Name varchar(255) default '00'              not null,
    Church_ID    varchar(255) default '00'              not null,
    Message      text                                   null comment 'submitted message',
    TimeStamp    timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    primary key (CC_Form_ID, User_ID, Church_ID),
    constraint church_contact_form_pk
        unique index (CC_Form_ID, User_ID, Church_ID),
    constraint church_contact_form_churches_fk
        foreign key (Church_ID)
            references alphatoo_a2o_backend.Churches (Church_ID),
    constraint church_contact_form_user_id_fk
        foreign key (User_ID)
            references alphatoo_a2o_backend.User (User_ID)
) comment 'church contact forms ';


drop trigger if exists alphatoo_a2o_backend.insert_church_contact_form_id;
create trigger alphatoo_a2o_backend.insert_church_contact_form_id
    before insert
    on alphatoo_a2o_backend.Church_Contact_Form
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
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Church_Contact_Form_Phone cascade;
create table if not exists alphatoo_a2o_backend.Church_Contact_Form_Phone
(
    CC_Form_ID varchar(255) default '00' not null,
    Phone      char(17)                  not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    primary key (CC_Form_ID, Phone),
    constraint church_contact_form_phone_fk
        foreign key (Phone)
            references alphatoo_a2o_backend.Phone (PhoneNumber)
            on update cascade on delete cascade,
    constraint church_contact_form_cc_form_id_fk
        foreign key (CC_Form_ID)
            references alphatoo_a2o_backend.Church_Contact_Form (CC_Form_ID)
            on update cascade on delete cascade

);
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Church_Contact_Form_Email cascade;
create table if not exists alphatoo_a2o_backend.Church_Contact_Form_Email
(
    CC_Form_ID varchar(255) default '00' not null,
    Email      varchar(255)              not null,
    Type       varchar(128)              not null,
    primary key (CC_Form_ID, Email),
    constraint church_contact_form_email_fk
        foreign key (Email)
            references alphatoo_a2o_backend.Email (Email)
            on update cascade on delete cascade,
    constraint church_contact_form_email_cc_form_id_fk
        foreign key (CC_Form_ID)
            references alphatoo_a2o_backend.Church_Contact_Form (CC_Form_ID)
            on update cascade on delete cascade

);
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Church_Address cascade;
create table if not exists alphatoo_a2o_backend.Church_Address
(
    Church_ID  varchar(255) default '00' not null,
    Address_ID varchar(255) default '00' not null,
    primary key (Church_ID, Address_ID),
    constraint addresses_church_address_fk
        foreign key (Address_ID) references alphatoo_a2o_backend.Addresses (Address_ID),
    constraint churches_church_address_fk
        foreign key (Church_ID) references alphatoo_a2o_backend.Churches (Church_ID)
) comment 'a church may have multiple addresses on campus';
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Church_Emails cascade;
create table if not exists alphatoo_a2o_backend.Church_Emails
(
    Church_ID varchar(255) default '00' not null,
    Email     varchar(255)              not null,
    primary key (Church_ID, Email),
    constraint Church_ID
        unique (Church_ID, Email),
    constraint churches_church_emails_fk
        foreign key (Church_ID) references alphatoo_a2o_backend.Churches (Church_ID)
            on update cascade on delete cascade,
    constraint email_church_emails_fk
        foreign key (Email) references alphatoo_a2o_backend.Email (Email)
            on update cascade on delete cascade
) comment 'list of emails';

#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.Church_Phones cascade;
create table if not exists alphatoo_a2o_backend.Church_Phones
(
    Church_ID   varchar(255) default '00' not null,
    PhoneNumber char(17)                  not null comment '{<country_code>####}-{<area_code>###}-{<local phone number>###-####}',
    primary key (Church_ID, PhoneNumber),
    constraint Church_Phones_uindex
        unique (Church_ID, PhoneNumber),
    constraint churches_church_phones_fk
        foreign key (Church_ID) references alphatoo_a2o_backend.Churches (Church_ID)
            on update cascade on delete cascade,
    constraint phone_church_phones_fk
        foreign key (PhoneNumber) references alphatoo_a2o_backend.Phone (PhoneNumber)
            on update cascade on delete cascade
) comment 'list of church phones';
#-- ----------------------------------------------------------------------
drop table if exists alphatoo_a2o_backend.User_Address cascade;
create table if not exists alphatoo_a2o_backend.User_Address
(
    User_ID    varchar(255) default '00' not null,
    Address_ID varchar(255) default '00' not null,
    primary key (User_ID, Address_ID),
    constraint User_Address_uindex
        unique (User_ID, Address_ID),
    constraint addresses_user_address_fk
        foreign key (Address_ID) references alphatoo_a2o_backend.Addresses (Address_ID)
            on update cascade on delete cascade,
    constraint user_user_address_fk
        foreign key (User_ID) references alphatoo_a2o_backend.User (User_ID)
            on update cascade on delete cascade
) comment 'list of address associated with each user';
#-- ----------------------------------------------------------------------
##########################################################################
# LOAD DATA FROM FILE
SET foreign_key_checks = 1;
# ##########################################################################
LOAD DATA INFILE '/mysql_files/csv_data/@city_state.csv'
    INTO TABLE Zipcode
    FIELDS TERMINATED BY ';'
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES (Zipcode, Latitude, Longitude, City, State_Id, State_Name,
                    County_Fips, County_Name, All_County_Weights, Timezone);
# #-- ----------------------------------------------------------------------
LOAD DATA INFILE '/mysql_files/csv_data/@addresses.csv'
    INTO TABLE alphatoo_a2o_backend.Addresses
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES (Type, Line_1, Line_2, Zipcode, City, State_ID, State_Name);
#-- ----------------------------------------------------------------------
# LOAD DATA INFILE '/mysql_files/csv_data/@Type.csv'
#     INTO TABLE alphatoo_a2o_backend.Type
#     FIELDS TERMINATED BY ','
#     ENCLOSED BY '"'
#     LINES TERMINATED BY '\n'
#     IGNORE 1 LINES (Type_Name, Description);
# #-- ----------------------------------------------------------------------
LOAD DATA INFILE '/mysql_files/csv_data/@user.csv'
    INTO TABLE alphatoo_a2o_backend.User
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    ignore 1 lines (User_Name, FirstName, LastName, MailingList, DOB, Company_Name,
                    Business_Name, Age, Last_Update_TimeStamp)
;
# #-- ----------------------------------------------------------------------
# LOAD DATA INFILE '/mysql_files/csv_data/@user_address.csv'
#     INTO TABLE alphatoo_a2o_backend.User_Address
#     FIELDS TERMINATED BY ','
#     ENCLOSED BY '"'
#     LINES TERMINATED BY '\n'
#     ignore 1 lines (User_ID, Address_ID)
# ;
# #-- ----------------------------------------------------------------------
# LOAD DATA INFILE '/mysql_files/csv_data/@user_phone.csv'
#     INTO TABLE alphatoo_a2o_backend.User_Phone
#     FIELDS TERMINATED BY ','
#     ENCLOSED BY '"'
#     LINES TERMINATED BY '\n'
#     IGNORE 1 LINES (User_ID, PhoneNumber, Type)
# ;
# #-- ----------------------------------------------------------------------
# LOAD DATA INFILE '/mysql_files/csv_data/@blog.csv'
#     INTO TABLE alphatoo_a2o_backend.Blog
#     FIELDS TERMINATED BY ','
#     ENCLOSED BY '"'
#     LINES TERMINATED BY '\n'
#     IGNORE 1 LINES (User_ID, Date, Time, Message, TimeStamp)
# ;
# #-- ----------------------------------------------------------------------
# LOAD DATA INFILE '/mysql_files/csv_data/@churches.csv'
#     INTO TABLE alphatoo_a2o_backend.Churches
#     FIELDS TERMINATED BY ','
#     ENCLOSED BY '"'
#     LINES TERMINATED BY '\n'
#     IGNORE 1 LINES
#     (Church_Name, Denomination, Description, Address_ID)
# ;
# #-- ----------------------------------------------------------------------

#-- ----------------------------------------------------------------------
##########################################################################
# SET foreign_key_checks = 1;
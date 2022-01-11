##########################################################################
# INSERT INTO TABLE
##########################################################################
insert into Addresses (Address_ID, Type, Line_1, Line_2, Zipcode, City, State_Name)
values (?, ?, ?, ?, ?, ?, ?);

insert into Blog (Blog_Id, User_ID, Date, Time, Message, TimeStamp)
values (?, ?, ?, ?, ?, ?);

insert into Calendar ("Year", "Month", "Day", "Time")
values (?, ?, ?, ?);

insert into Church_Address (Church_ID, Address_ID)
values (?, ?);

insert into Church_Contact_Form (CC_Form_ID, Message, Church_ID, Church_Name, Denomination, Address_ID,
                                 Type, Line_1, Line_2, Zipcode, City, State_ID, State_Name, Phone, Email, TimeStamp)
values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

insert into Church_Emails (Church_ID, Email)
values (?, ?);

insert into Church_Phones (Church_ID, PhoneNumber)
values (?, ?);

insert into Churches (Church_ID, Church_Name, Denomination, Description, Address_ID, Type, Line_1, Line_2,
                      Zipcode, City, State_ID, State_Name, Email, Phone)
values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

insert into Day ("Date", Day_Number, Day_Name, Day_Num_In_Year, Total_Available_Hours,
                 Week_Start_Day, Hours_Scheduled)
values (?, ?, ?, ?, ?, ?, ?);

insert into Email (Email,Type)
values (?, ?);

insert into Month ("Month", Total_Hours, Hours_Scheduled, Month_Name)
values (?, ?, ?, ?);

insert into Password (Passwd, User_ID, Password)
values (?, ?, ?);

insert into Phone (PhoneNumber, Type)
values (?, ?);

insert into PreNeed_Form_Request (PreNeed_Request_Form_ID, User_ID, Email, PhoneNumber, message)
values (?, ?, ?, ?, ?);

insert into PreNeed_Services_Requested (Service_Type, PreNeed_Request_Form_ID)
values (?, ?);

insert into Services (Service_Type, Description)
values (?, ?);

insert into Time ("Time", "TimeStamp", TimeZone)
values (?, ?, ?);


insert into Type (Type_Name, Description)
values (?, ?);

insert into User (User_ID, User_Name, FirstName, LastName, MailingList, DOB, Company_Name,
                  Business_Name, Age, Last_Update_TimeStamp)
values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

insert into User (User_Name, FirstName, LastName, MailingList, DOB, Company_Name,
                  Business_Name, Age, Last_Update_TimeStamp)
    values ('alex@gmail.com','Alex','Xander',0,'2001-02-20','',
            'Hyfi Solutions',null,null);


insert into User_Address (User_ID, Address_ID)
values (?, ?);

insert into User_Email (User_ID, Email)
values (?, ?);

insert into User_Phone (User_ID, PhoneNumber)
values (?, ?);

insert into Year (Year_Id, Leap_Year)
values (?, ?);

insert into Zipcode (Zipcode, Latitude, Longitude, City, State_Id, State_Name, County_Fips,
                     County_Name, All_County_Weights, Timezone)
values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

##########################################################################
# LOAD DATA FROM FILE
##########################################################################
#-- ----------------------------------------------------------------------
LOAD DATA INFILE '/mysql_files/@city_state.csv'
    INTO TABLE alphatoo_a2o_backend.Zipcode
    FIELDS TERMINATED BY ';'
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES (Zipcode, Latitude, Longitude, City, State_Id, State_Name,
                    County_Fips, County_Name, All_County_Weights, Timezone);
#-- ----------------------------------------------------------------------
LOAD DATA INFILE '/mysql_files/@user.csv'
    INTO TABLE alphatoo_a2o_backend.User
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    ignore 1 lines (User_Name, Preferred_Name, FirstName, LastName, MailingList,
                    DOB, Company_Name, Business_Name);
#-- ----------------------------------------------------------------------
LOAD DATA INFILE '/mysql_files/@blog.csv'
    INTO TABLE alphatoo_a2o_backend.Blog
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES (Blog_Id, User_ID, Date, Time, Message, TimeStamp);
#-- ----------------------------------------------------------------------
LOAD DATA INFILE '/mysql_files/@addresses.csv'
    INTO TABLE alphatoo_a2o_backend.Addresses
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES (Type, Line_1, Line_2, Zipcode, City, State_ID, State_Name);
#-- ----------------------------------------------------------------------

LOAD DATA INFILE '/mysql_files/@churches.csv'
    INTO TABLE alphatoo_a2o_backend.Churches
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES (Church_ID, Church_Name, Denomination, Description, Address_ID,
                    Type, Line_1, Line_2, Zipcode, City, State_Name, Email, Phone);


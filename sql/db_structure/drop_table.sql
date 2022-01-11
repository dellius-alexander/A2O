drop table if exists alpha2omega.Blog cascade;

drop table if exists alpha2omega.Calendar cascade;

drop table if exists alpha2omega.Church_Address cascade;

drop table if exists alpha2omega.Church_Contact_Form cascade;

drop table if exists alpha2omega.Church_Emails cascade;

alter table alpha2omega.Church_Phones
    drop foreign key churches_church_phones_fk;

drop table if exists alpha2omega.Churches cascade;

drop table if exists alpha2omega.Church_Phones cascade;

drop table if exists alpha2omega.Day cascade;

drop table if exists alpha2omega.Month cascade;

drop table if exists alpha2omega.Password cascade;

drop table if exists alpha2omega.PreNeed_Services_Requested cascade;

drop table if exists alpha2omega.PreNeed_Form_Request cascade;

drop table if exists alpha2omega.Services cascade;

drop table if exists alpha2omega.Time cascade;

drop table if exists alpha2omega.User_Address cascade;

drop table if exists alpha2omega.Addresses cascade;

drop table if exists alpha2omega.User_Email cascade;

drop table if exists alpha2omega.Email cascade;

drop table if exists alpha2omega.User_Phone cascade;

drop table if exists alpha2omega.Phone cascade;

drop table if exists alpha2omega.Type cascade;

drop table if exists alpha2omega.User cascade;

drop table if exists alpha2omega.Year cascade;

drop table if exists alpha2omega.Zipcode cascade;

drop function if exists Encrypt_Vals ;

drop function if exists no_of_years ;


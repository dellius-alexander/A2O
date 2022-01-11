##########################################################################
# VARIABLES
##########################################################################
-- Encryption algorithm; can be 'DSA' or 'DH' instead
SET @algo = 'RSA';
-- Key length in bits; make larger for stronger keys
SET @key_len = 256;
select @key_len;
-- Create private key
set @priv_key = ucase(hex(sha2('alpha2omega',@key_len)));
select @priv_key;
-- Create public key
set @pub_key = ucase(hex(aes_encrypt('alpha2omega',@priv_key)));
select @pub_key;
# # Use the private key to encrypt data and the public key to decrypt it
# # This requires that the members of the key pair be RSA keys.
#
# SET @ciphertext = asymmetric_encrypt(@algo, 'My secret text', @priv);
# SET @plaintext = asymmetric_decrypt(@algo, @ciphertext, @pub);

# # Conversely, you can encrypt using the public key and decrypt using the private key.
#
# SET @ciphertext = asymmetric_encrypt(@algo, 'My secret text', @pub);
# SET @plaintext = asymmetric_decrypt(@algo, @ciphertext, @priv);
##########################################################################
##########################################################################
# Create FUNCTIONS
##########################################################################
drop function if exists alpha2omega.Encrypt_Vals;
create function alpha2omega.Encrypt_Vals( object text, pub_key varchar(255) ) returns text
    comment '@param: object text => object must be of string format;'
    comment '@param: pub_key varchar(255) => pub_key must be hex formatted key;'
    deterministic
BEGIN
    if (object is null) then
        return null;
    end if;
    return hex(aes_encrypt(object, pub_key));
END;
#
drop function if exists alpha2omega.Decrypt_Vals;
create function alpha2omega.Decrypt_Vals( object text, pub_key varchar(255) ) returns text
    comment '@param: object text => object must be of hex format;'
    comment '@param: pub_key varchar(255) => pub_key must be hex formatted key;'
    deterministic
BEGIN
    if (object is null) then
        return null;
    end if;
    return aes_decrypt(unhex(object),pub_key);
END;
#
select Encrypt_Vals('Dellius',@pub_key);
select Decrypt_Vals('BDF31EDA72668B01EC515FD3AA9E9591',@pub_key);
#
drop function if exists alpha2omega.no_of_years;
create function alpha2omega.no_of_years(DOB date) returns int deterministic
BEGIN
    DECLARE date2 DATE;
    Select current_date() into date2;
    RETURN date(date2) - date(DOB);
END;
#
##########################################################################
# Create TRIGGER
##########################################################################
drop trigger  if exists alpha2omega.update_preneed_form_id;
create trigger alpha2omega.update_preneed_form_id
    before insert
    on alpha2omega.PreNeed_Form_Request
    for each row
begin
    insert into alpha2omega.PreNeed_Form_Request
    set new.PreNeed_Request_Form_ID = Encrypt_Vals(concat(new.User_ID, ' ', new.Email, ' ', new.PhoneNumber, ' ', new.Message), @pub_key);
end;
#
drop trigger if exists alpha2omega.update_user_id;
create trigger alpha2omega.update_user_id
    before insert
    on alpha2omega.User
    for each row
begin
    set new.Last_Update_TimeStamp = current_timestamp();
    if (new.User_ID = 0) then
        set new.User_ID = Encrypt_Vals(concat(new.User_Name, ' ', new.FirstName, ' ',new.LastName,' ', new.DOB, ' ', new.Last_Update_TimeStamp), @pub_key);
    end if;
end;
#
drop trigger if exists alpha2omega.update_addresses_address_id;
create trigger alpha2omega.update_addresses_address_id
    before insert
    on alpha2omega.Addresses
    for each row
begin
    declare  temp_City       varchar(64);
    declare  temp_State_ID   char(2);
    declare  temp_State_Name varchar(64);
    select City, State_Id, State_Name from Zipcode where new.Zipcode = Zipcode.Zipcode into temp_City,temp_State_ID,temp_State_Name;
    set new.City = temp_City;
    set new.State_ID = temp_State_ID;
    set new.State_Name = temp_State_Name;
    set new.Address_ID =
            Encrypt_Vals(concat(new.Line_1, ' ', new.Line_2, ' ', new.City, ' ', new.State_Name, ' ', new.ZipCode),
                         @pub_key);
end;
#
drop trigger  if exists alpha2omega.update_church_contact_form_id;
create trigger alpha2omega.update_church_contact_form_id
    before insert
    on alpha2omega.Church_Contact_Form
    for each row
begin
    set new.CC_Form_ID = Encrypt_Vals(concat(new.Church_ID,' ', new.Message), @pub_key);
end;



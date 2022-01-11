SHOW PLUGINS;

# INSTALL PLUGIN openssl_udf SONAME 'openssl_udf';
# # Create all encryption function.
# CREATE FUNCTION alphatoo_a2o_backend.asymmetric_decrypt RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION asymmetric_derive RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION asymmetric_encrypt RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION asymmetric_sign RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION asymmetric_verify RETURNS INTEGER
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION create_asymmetric_priv_key RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION create_asymmetric_pub_key RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION create_dh_parameters RETURNS STRING
#   SONAME 'openssl_udf.so';
# CREATE FUNCTION create_digest RETURNS STRING
#   SONAME 'openssl_udf.so';
#
# # Don't forget to delete function once used
# DROP FUNCTION asymmetric_decrypt;
# DROP FUNCTION asymmetric_derive;
# DROP FUNCTION asymmetric_encrypt;
# DROP FUNCTION asymmetric_sign;
# DROP FUNCTION asymmetric_verify;
# DROP FUNCTION create_asymmetric_priv_key;
# DROP FUNCTION create_asymmetric_pub_key;
# DROP FUNCTION create_dh_parameters;
# DROP FUNCTION create_digest;

create function alpha2omega.Encrypt_Vals(object text, key_length int) returns binary(1)
    comment '@object text, @key_length int' deterministic
BEGIN
    return cast(ucase(sha2(object, key_length)) AS BINARY);
END;

create function alpha2omega.no_of_years(DOB date) returns int deterministic
BEGIN
    DECLARE date2 DATE;
    Select current_date() into date2;
    RETURN date(date2) - date(DOB);
END;

SET @priv = create_asymmetric_priv_key('DSA', 2048);
select @priv;
SET @pub = create_asymmetric_pub_key('DSA', @priv);

show plugins;
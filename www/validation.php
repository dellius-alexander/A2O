<?php
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
 /**
 * Recursively prints array [ key: values ]
 * @param  $arr the array of values
 */
function print_arr($arr)
{
    foreach($arr as $key => $value)
    {
        if(is_array($value))
        {
            printf($key . '<br>');
            print_arr($value);
            return;
        }
    printf($key . ': ' . $value . '<br>');
    }
    return;
}

date_default_timezone_set('America/New_York');
// echo date_default_timezone_get() . "<br>";
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
 /**
 * Test the input
 * trim(), stripslashes(),htmlspecialchars()
 * @param  data The data to be sanitized
 */
  function test_input($data){
  $data = trim($data);
  $data = stripslashes($data);
  return htmlspecialchars($data);
  }
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
 /**
 * Check for sql injection
 * @param mixed $str 
 * @return bool 
 */
function IsInjected($str)
{
    $injections = array('(\n+)',
          '(\r+)',
          '(\t+)',
          '(%0A+)',
          '(%0D+)',
          '(%08+)',
          '(%09+)'
          );
               
    $inject = join('|', $injections);
    $inject = "/$inject/i";
    
    if(preg_match($inject,$str))
    {
      return true;
    }
    else
    {
      return false;
    }
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/**
 * Process OBN form data
 * @param mixed $_post 
 * @return void 
 */
function obn_validation($_post)
{
    $name           = test_input($_post['Fullname']);
    $email          = test_input($_post['Email']);
    $from = $name . ' <' . $email . '>';
    $to =   'Church Contact Form <pre-need@alphatoomegacssi.com>';
    $Bcc =  'Church Contact Form <info@pre-need.care>, ' .
            'Church Contact Form <alphatoomega.cs@gmail.com>, ' . 
            'Dellius Alexander <dellius.alexander@gmail.com>';
    $a2o_contact = 'Church Contact Form <pre-need@alphatoomegacssi.com>';
    $church_name    = test_input($_post['Church_Name']);
    $phone          = test_input($_post['Contact-Phone-Number']);
    $address        = test_input($_post['Church-Address']);
    $message        = test_input($_post['Message']);
    $subject = "ATO Church Contact Form Submission";
    $a2o_logo = '<html><head><meta content="width=device-width, initial-scale=1" name="viewport">' .
        '<link href="images/favicon.ico" rel="shortcut icon" type="image/x-icon">' .
        '<script type="text/javascript">WebFont.load({  google: ' .
        '{families: ["Changa One:400,400italic","Open Sans:300,300italic,400'. 
        ',400italic,600,600italic,
700,700italic,800,800italic","Stylish:regular:korean,latin",'.
        '"Righteous:regular","Special Elite:regular","Open Sans Condensed:300,300italic,700:cyrillic,
greek,latin,vietnamese","Bree Serif:regular"]  }});</script>' .
        '</head><body style="'.'font:Stylish;font-size:1.2rem;background-image: url(\"https://www.alphatoomegacssi.com/images/skyblue_clouds_1.jpg\");">';
    $a2o_logo .=    '<br><div style="padding:50px;position: absolute; top: 50%;left: 0;right:0;margin:-25px 0 0 -25px;background-color: #18bfed;color:#fff;">' 
    . '<img src="https://www.alphatoomegacssi.com/images/ATO-LOGO-ATO-CSSI.png"'
    . 'alt="Alpha To Omega Logo" width="15%" height="15%" style="background-color:#ffffff;box-shadow: 5px 5px rgba(0, 98, 90, 0.4),0px 10px rgba(0, 98, 90, 0.3),15px 15px rgba(0, 98, 90, 0.2),20px 20px rgba(0, 98, 90, 0.1),25px 25px rgba(0, 98, 90, 0.05);"/><br>';
    // create the body of your message
    $body = $a2o_logo   . '<h3 style="color:#fff;font-weight: bold;">'
                        . 'Church Contact Form Submission:</h3> <pre style="color:#fff;font-weight: bold;">' 
                        . "\nContact Name: \t". $name 
                        . "\nChurch Name: \t" . $church_name
                        . "\nPhone: \t\t\t"       . $phone
                        . "\nEmail: \t\t\t"       . $email
                        . "\nAddress: \t\t"       . $address
                        . "\nMessage: \t\t"     . $message 
                        . "</pre></div></body></html>";
    
    // define your message headers
    $headers =  implode("\r\n", [
                'MIME-Version: 1.0',
                'Content-type: text/html; charset: utf-8',
                'From: '.$from,
                'Cc: '.$from,
                'Bcc: '.$Bcc,
                'Reply-To: '.$a2o_contact,
                'X-Mailer: PHP/' . phpversion()]);
    // send the mail to all parties
    $mail = mail($to,$subject,$body,$headers);
    // $mail = mail($to,$subject,$body,$headers,"-f".$to);
    if($mail)
    {
        echo    '<br><div style="display: flex;align-items: center;justify-content: center;font-size:2em;">' .
                '<strong>Thank you for contacting Omega Broadcasting Network.<br>' .
                $name . " someone will contact you shortly.<br><br>" .
                "You will be redirected back to our Omega Broadcasting Network page......</strong><br/><br/></div>";
    }
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/**
 * Process pre-need form data
 * @param mixed $_post 
 * @return void 
 */
function pre-need_validation($_post)
{
    // get the submitted form data and pre-defined variables
    $name = test_input($_post['name']);
    $email = test_input($_post['email']);
    $from = $name . ' <' . $email . '>';
    $to =   'pre-need Services <pre-need@alphatoomegacssi.com>';
    $Bcc =  'pre-need Services <info@pre-need.care>, ' . 
            'pre-need Services <alphatoomega.cs@gmail.com>, ' .
            'Dellius Alexander <dellius.alexander@gmail.com>';
    $a2o_contact = 'pre-need Services <pre-need@alphatoomegacssi.com>';
    $phone = test_input($_post['phone']);
    $services_selected = "<br>";
    if(is_array($_post['select-services']))
    {
        $temp = $_post['select-services'];
        for ($i=0; $i < count($_post['select-services']); $i++) { 
            if ($i == 0){$services_selected .= "\t- " . test_input($temp[$i]);}
            $services_selected .= "\n\t- " . test_input($temp[$i]);
        }
    
    }
    else
    {
        $services_selected = test_input($_post['select-services']);
    }
 
    $subject = "pre-need Agent Contact Form Submission";
    $description =  test_input($_post['Description-of-needs-Optional']);
    $a2o_logo = '<html><head><meta content="width=device-width, initial-scale=1" name="viewport">' .
        '<link href="images/favicon.ico" rel="shortcut icon" type="image/x-icon">' .
        '<script type="text/javascript">WebFont.load({  google: ' .
        '{families: ["Changa One:400,400italic","Open Sans:300,300italic,400'. 
        ',400italic,600,600italic,
700,700italic,800,800italic","Stylish:regular:korean,latin",'.
        '"Righteous:regular","Special Elite:regular","Open Sans Condensed:300,300italic,700:cyrillic,
greek,latin,vietnamese","Bree Serif:regular"]  }});</script>' .
        '</head><body style="'.'font:Stylish;font-size:1.2rem;background-image: url(\"https://www.alphatoomegacssi.com/images/skyblue_clouds_1.jpg\");">';
    $a2o_logo .=    '<br><div style="padding:50px;position: absolute; top: 50%;left: 0;right:0;margin:-25px 0 0 -25px;background-color: #18bfed;color:#fff;">' .
                    '<img src="https://www.alphatoomegacssi.com/images/ATO-LOGO-ATO-CSSI.png"' .
                    'alt="Alpha To Omega Logo" width="15%" height="15%" style="background-color:#ffffff;box-shadow: 5px 5px rgba(0, 98, 90, 0.4),'. 
                    '0px 10px rgba(0, 98, 90, 0.3),15px 15px rgba(0, 98, 90, 0.2),20px 20px rgba(0, 98, 90, 0.1),25px 25px rgba(0, 98, 90, 0.05);"/><br>';
    // create the body of your message
    $body = $a2o_logo   . '<h3 style="color:#fff;font-weight: bold;">'
                        . 'pre-need Inquiry: </h3><pre style="color:#fff;font-weight: bold;">'
                        . "\nCustomer Name: \t\t" . $name 
                        . "\nServices Selected: \t" . $services_selected
                        . "\nPhone: \t" . $phone
                        . "\nEmail: \t" . $email
                        . "\nMessage: \t" . $description . "</pre></div></body></html>";
    
    // define your message headers
    $headers =  implode("\r\n", [
                'MIME-Version: 1.0',
                'Content-type: text/html; charset: utf-8',
                'From: '.$from,
                'Cc: '.$from,
                'Bcc: '.$Bcc,
                'Reply-To: '.$a2o_contact,
                'X-Mailer: PHP/' . phpversion()]);
    // send the mail to all parties
    $mail = mail($to,$subject,$body,$headers);
    // $mail = mail($to,$subject,$body,$headers,"-f".$to);
    if($mail)
    {
        echo    '<br><div style="display: flex;align-items: center;justify-content: center;font-size:2em;">' .
                '<strong>Thank you for your Time.  A pre-need agent will be with your shortly.<br>' .
                "You will be redirected back to our pre-need page......</strong><br/><br/></div>";
    }
} // End of pre-need_validation($_POST)

////////////////////////////////////////////////////////////////////////////////
// print_r($_POST);
// echo $_POST['submit'] . "<br>";
////////////////////////////////////////////////////////////////////////////////
// Start of validation check
if( $_SERVER['REQUEST_METHOD'] == 'POST' && !empty($_POST) && $_POST['pre-need-form-validation'] == 'pre-need-form-validation')
{
    pre-need_validation($_POST); // validate preneed.html form submission
    // echo "pre-need form submission found...";
    echo    '<script type="text/javascript">' .
                ' setTimeout(function(){window.location = "./preneed.html";}, 6000);' .
                '</script>';
    exit();
}
// OBN form validation
if( $_SERVER['REQUEST_METHOD'] == 'POST' && !empty($_POST) && $_POST['obn-form-validation'] == 'obn-form-validation')
{
    obn_validation($_POST); // validate omega-broadcasting-network.html form submission
    echo    '<script type="text/javascript">' .
            ' setTimeout(function(){window.location = "./omega-broadcasting-network.html";}, 6000);' .
            '</script>';
    exit();
}
else
{
    // redirect and exit back to home if all fails
    echo  '<h4>Something went wrong.<br>Redirecting back to Home......</h4><br>';
    echo  '<script type="text/javascript">' .
          ' setTimeout(function(){window.location.href = "https://alphatoomegacssi.com";}, 6000);' .
          '</script>';

    exit();
}

?>
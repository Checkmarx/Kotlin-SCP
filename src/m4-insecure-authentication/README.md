M4: Insecure Authentication
===========================

Weak authentication for mobile applications is fairly prevalent due to mobile
device's input factor: 4-digit PINs are a great example of it.
Either a weak password policy due to usability requirements or authentication
based on features like TouchID make your application vulnerable: contrary to
what you may think, unlike passwords, you may be forced to give up your
fingerprint.

Unless there's a functional requirement, mobile applications do not require a
backend server to which they should be authenticated in real-time. Even when
such backend server exists usually users are not required to be online at all
times. This poses a great challenge on mobile applications authentication as if
authentication has to happen locally, then it can be bypassed on jailbroken
devices through runtime manipulation or modification of the binary.

Insecure Authentication is not only about guessable passwords, default user
accounts or data breaches. At certain circumstances the authentication mechanism
can be bypassed and the system will fail to identify the user and log its
(malicious) activity. Usually in this scenario, user's will gain access to
sensitive functionalities as the system will also fail to validate its role,
highlighting also problems with the authorization controls.

The movie below shows Insecure Authentication exploitation on our Kotlin
application.

@todo show signup requesting 4-digits PIN
@todo show getting access to local database and username:password

Now it is time to improve the application establishing a strong password policy
and storing authentication data safely: we will keep authentication data locally
as not all applications have a backend server to handle it.

@todo implement a strong password policy
@todo store a salted version of username and passowrd

Keep in mind that this is just a brief overview over Insecure Authentication.
Specially if you're doing local authentication you're recommended to carefully
read sections M8 - Code Tampering and M9 - Reverse Engineering 

## Resources

### Tools

### Reading

* [OWASP Authentication Cheat Sheet: Implement Proper Password Strength
  Controls][1]

[1]: https://www.owasp.org/index.php/Authentication_Cheat_Sheet#Implement_Proper_Password_Strength_Controls


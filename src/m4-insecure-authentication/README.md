M4: Insecure Authentication
===========================

Weak authentication for mobile applications is fairly prevalent due to mobile
device's input factor: 4-digit PINs are a great example of it.
Either a weak password policy due to usability requirements or authentication
based on features like TouchID make your application vulnerable: contrary to
what you may think, unlike passwords, you may be forced to give up your
fingerprint.

Unless there's a functional requirement, mobile applications do not require a
back-end server to which they should be authenticated in real-time. Even when
such back-end server exists usually users are not required to be online at all
times. This poses a great challenge on mobile applications authentication as if
authentication has to happen locally, then it can be bypassed on jailbroken
devices through runtime manipulation or modification of the binary.

Insecure Authentication is not only about guessable passwords, default user
accounts or data breaches. At certain circumstances the authentication mechanism
can be bypassed and the system will fail to identify the user and log its
(malicious) activity. Usually in this scenario, user's will gain access to
sensitive functionalities as the system will also fail to validate its role,
highlighting also problems with the authorization controls.

The movie below shows [Kotlin Goat][0] authentication exploitation

{% youtube src="https://www.youtube.com/watch?v=qJO2A2uox1E" %}{% endyoutube %}

Now it is time to improve the application establishing a strong password policy
and storing authentication data safely: we will keep authentication data locally
as not all applications have a back-end server to handle it. When such back-end
exists, password policy should be the same on both sides. Optionally password
strength validation can be delegated to the back-end.

The [PasswordHelper object][4] implements [OWASP recommendations for Password
Strength][1]

```kotlin
package com.cx.vulnerablekotlinapp.helpers

object PasswordHelper {

    /**
     * Performs given password validation according to OWASP proper password strength
     * @link https://www.owasp.org/index.php/Authentication_Cheat_Sheet#Implement_Proper_Password_Strength_Controls
     */
    fun strength (password: String): Boolean {
        var complexityRulesMatches: Int = 0

        if (!length(password)) {
            return false
        }

        // Password must meet at least 3 out of the following 4 complexity rules
        if (hasAtLeastOneUppercaseLetter(password)) {
            complexityRulesMatches++
        }

        if (hasAtLeastOneLowercaseLetter(password)) {
            complexityRulesMatches++
        }

        if (hasAtLeastOneDigit(password)) {
            complexityRulesMatches++
        }

        if (hasAtLeastOneSpecialChar(password)) {
            complexityRulesMatches++
        }

        if (complexityRulesMatches < 3) {
            return false
        }
        //

        if (!noMoreThanTwoIdenticalCharsInARow(password)) {
            return false
        }

        return true
    }
    // ...
}
```

`PasswordHelper.strength()` is then called from `signupAttempt()` on Kotlin Goat
`SignupActivity` ([source][5])

```kotlin
package com.cx.vulnerablekotlinapp
// ...
class SignupActivity : AppCompatActivity() {
    // ...
    private fun attemptSignup() {
        val name: String = this.name.text.toString()
        val email: String = this.email.text.toString()
        val password: String = this.password.text.toString()
        val confirmPassword: String = this.confirmPassword.text.toString()

        // test password strength
        if (!PasswordHelper.strength(password)) {
            this.password.error = """|Weak password. Please use:
                                  |* both upper and lower case letters
                                  |* numbers
                                  |* special characters (e.g. !"#$%&')
                                  |* from 10 to 128 characters sequence""".trimMargin()
            this.password.requestFocus()
            return;
        }
        // ...
    }
    // ...
}
```

Although passwords are now stronger, they're still stored as clear text on
database. Someone with access to the device is still able to retrieve and
manipulate database records. To address this issue, we will store a salted
version of `username` and `password`.

In the case of password storage, [OWASP recommends the following algorithms][6]:
[bcrypt][7], [PDKDF2][8], [Argon2][9] and [scrypt][10]. Those take care of
hashing and salting passwords in a robust way. 

We'll use `bcrypt` which should be good enough for most of the situations.
The advantage of `bcrypt` is that it is simpler to use and is therefore less
error-prone.

After adding [jBCrypt][11] as dependency to have access to a `bcrypt`
implementation, we just need to make two little changes to [Kotlin Goat][0].
First in the `attemptSignup()` method of `SignupActivity` so that passwords are
stored as a salted hash ([source][12])

```kotlin
package com.cx.vulnerablekotlinapp
// ...
class SignupActivity : AppCompatActivity() {
    // ...
    /**
     * Attempts to create a new account on back-end
     */
    private fun attemptSignup() {
        //...
        // hashing password
        val hashedPassword: String = BCrypt.hashpw(password, BCrypt.gensalt())
        val account: Account = Account(name, email, hashedPassword)
        // ...
    }
}
```
and the second one in the `UserLoginTask` `doInBackground()` method to compare
provided password with the stored one using `Bcrypt.checkpw()` method
([source][13])

```kotlin
package com.cx.vulnerablekotlinapp
// ...
class LoginActivity : AppCompatActivity(), LoaderCallbacks<Cursor> {
    // ...
    inner class UserLoginTask internal constructor(private val mUsername: String, private val mPassword: String) : AsyncTask<Void, Void, Boolean>() {
        override fun doInBackground(vararg params: Void): Boolean? {
            if ((mUsername == "Supervisor") and (mPassword == "MySuperSecretPassword123!")){
                return true
            }
            else {
                val account:Account = DatabaseHelper(applicationContext).getAccount(mUsername)
                if (BCrypt.checkpw(mPassword, account.password)) {
                    // ...
                }
                // ...
            }
        }
    }
}
```

Keep in mind that this is just a brief overview over Insecure Authentication.
Specially if you're doing local authentication you're recommended to carefully
read sections [M8: Code Tampering][2] and [M9: Reverse Engineering][3]

## Resources

### Tools

* [jBCrypt][11]

### Reading

* [OWASP Authentication Cheat Sheet: Implement Proper Password Strength
  Controls][1]
* [BCrypt][7]
* [PBKDF2][8]
* [Argon2][9]
* [Scrypt][10]
* [OWASP Mobile Top 10 2016: M4 - Insecure Authentication][14]

[0]: https://github.com/PauloASilva/KotlinGoat
[1]: https://www.owasp.org/index.php/Authentication_Cheat_Sheet#Implement_Proper_Password_Strength_Controls
[2]: ../m8-code-tampering/README.md
[3]: ../m9-reverse-engineering/README.md
[4]: https://github.com/PauloASilva/KotlinGoat/blob/feature/m4-insecure-authentication/packages/clients/android/app/src/main/java/com/cx/vulnerablekotlinapp/helpers/PasswordHelper.kt
[5]: https://github.com/PauloASilva/KotlinGoat/blob/feature/m4-insecure-authentication/packages/clients/android/app/src/main/java/com/cx/vulnerablekotlinapp/SignupActivity.kt#L42
[6]: https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet#Leverage_an_adaptive_one-way_function
[7]: https://en.wikipedia.org/wiki/Bcrypt
[8]: https://en.wikipedia.org/wiki/PBKDF2
[9]: https://en.wikipedia.org/wiki/Argon2
[10]: https://en.wikipedia.org/wiki/Scrypt
[11]: http://www.mindrot.org/projects/jBCrypt/
[12]: https://github.com/PauloASilva/KotlinGoat/blob/feature/m4-insecure-authentication/packages/clients/android/app/src/main/java/com/cx/vulnerablekotlinapp/SignupActivity.kt#L58
[13]: https://github.com/PauloASilva/KotlinGoat/blob/feature/m4-insecure-authentication/packages/clients/android/app/src/main/java/com/cx/vulnerablekotlinapp/LoginActivity.kt#L225
[14]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M4-Insecure_Authentication

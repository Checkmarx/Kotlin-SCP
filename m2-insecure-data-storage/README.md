---
nav_order: 2
---

M2: Insecure Data Storage
=========================

The [Android ecosystem][7] provides several ways to store data for an app.  The
kind of storage used by developers depends on the kind of data stored, the usage
of the data, and also whether the data should be kept private or shared to other
apps.

Data in Android can be stored in:
* **App-specific storage**: dedicated directories within internal or external storage 
  than enable developers to store files that are meant to be used by the app only;
* **Shared storage**: directories that contains files that are meant to to be shared
  by multiple apps;
* **KeyStore**: a secure way to store cryptographic keys, and other sensitive information.

Data is typically stored in the following formats:
* **SQLite Databases**: the preferred way to store structure data in app-specific 
  directories;
* **Shared Preferences**: an Android API that helps developers store key-pair values 
  in a dedicated directory inside internal storage.

Unfortunately, it is very common to find sensitive information stored in clear
text. For instance, it is frequent to find API keys, passwords, and Personally
Identifiable Information (PII) stored on the Shared Preferences or databases
used by the app.

In the case of the [Goatlin app][0], when a user performs a sign up, the
credentials are stored locally inside the database. Here is the extract of the
SignupActivity class showing the creation of the account and how it is stored
into the database:

```kotlin
/**
 * Attempts to create a new account on back-end
 */
private fun attemptSignup() {
    val name: String = this.name.text.toString()
    val email: String = this.email.text.toString()
    val password: String = this.password.text.toString()
    val confirmPassword: String = this.confirmPassword.text.toString()

    if (confirmPassword != password) {
        this.confirmPassword.error = "Passwords don't match"
        this.confirmPassword.requestFocus()
        return;
    }

    val account: Account = Account(name, email, password)

    val call: Call<Void> = apiService.signup(account)
    call.enqueue(object: Callback<Void> {
        override fun onFailure(call: Call<Void>, t: Throwable) {
            Log.e("SingupActivity", t.message.toString())
        }

        override fun onResponse(call: Call<Void>, response: Response<Void>) {
            val emailField: AutoCompleteTextView = findViewById(R.id.email)
            var message:String = ""

            when (response.code()) {
                201 -> {
                    if (createLocalAccount(account)) {
                        val intent = Intent(this@SignupActivity, LoginActivity::class.java)

                        startActivity(intent)
                    } else {
                        message = "Failed to create local account"
                    }
                }
                409 -> {
                    message = "This account already exists"
                    emailField.error = message
                    emailField.requestFocus()
                }
                else -> {
                    message = "Failed to create account"
                }
            }
        }
    }
}
```

When the app receives a response from the back-end with the HTTP code 201, the
function `createLocalAccount()` is called.
As shown below, this function only adds the username and password into the
database:

```kotlin
/**
 * Creates local account
 */
private fun createLocalAccount(account: Account): Boolean {
    return DatabaseHelper(applicationContext).createAccount(account.email,
       account.password)
}
```

Here is the code of the `createAccount()` function provided by the
`DatabaseHelper` class:

```kotlin
public fun createAccount(username: String, password: String) : Boolean {
    val db: SQLiteDatabase = this.writableDatabase
    val record: ContentValues = ContentValues()
    var status = true

    record.put("username", username) record.put("password", password)

    try {
        db.insertOrThrow(TABLE_ACCOUNTS, null, record)
    } catch (e: SQLException) {
        Log.e("Database signup", e.toString())
        status = false
    } finally {
        return status
    }
}
```

In the same manner, we can observe that the credentials are checked locally by
retrieving the credentials stored inside the database. Here is an extract of
the `LoginActivity` class where the check is made:

```kotlin
override fun doInBackground(vararg params: Void): Boolean? {
    if ((mUsername == "Supervisor") and (mPassword == "MySuperSecretPassword123!")){
        return true
    } else {
        try {
            val account: Account = DatabaseHelper(applicationContext).getAccount(mUsername)

            if (mPassword == account.password) {
                val prefs: SharedPreferences = applicationContext.getSharedPreferences(
                    applicationContext.packageName, Context.MODE_PRIVATE)
                val editor: SharedPreferences.Editor = prefs.edit()

                editor.putInt("userId", account.id).apply()
                editor.putString("userEmail", mUsername).apply()
            }

            return account.id > -1
        } catch(e: Exception) {
            return false
        }
    }
}
```

The app retrieves the account stored in the database by using the `getAccount()`
function. If the password stored in the database matches the password provided
by the user, the authentication is successful.

An attacker able to access the database of the app (rooting the device, backup
of the app, etc.) can retrieve the credentials of the different users using the
app.

In this example, since this database is stored under `/data/data/com.cx.vulnerablekotlinapp/databases` 
we can fetch it as such:

```
~ adb exec-out run-as com.cx.vulnerablekotlinapp cat /data/data/com.cx.vulnerablekotlinapp/databases/data > /tmp/kotlin-goat.sqlite
```

Using [sqlitebrowser][4], it is easy to inspect the content of an SQLite
database. Here is the content of the `Accounts` table used by the app:

![Viewing the content of the Goatlin database][sqlitebrowser-database]

As discussed before, we can confirm that the passwords are stored in clear text
without using any encryption mechanism.

## Resources

### Tools

* [apktool][1]
* [jadx][2]
* [jd-gui][3]
* [sqlitebrowser][4]

### Readings

* [Android documentation: Data and file storage overview][7]
* [OWASP Mobile Top 10 2016: M2 - Insecure Data Storage][6]
* [OWASP Mobile Security Testing guide - Test Data Storage] [5]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://sqlitebrowser.org/
[5]: https://github.com/OWASP/owasp-mstg/blob/master/Document/0x05d-Testing-Data-Storage.md
[6]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M2-Insecure_Data_Storage
[7]: https://developer.android.com/guide/topics/data/data-storage
[sqlitebrowser-database]: assets/sqlitebrowser-database.png

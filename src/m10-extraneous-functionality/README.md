M10: Extraneous Functionality
=============================
As the name suggests extraneous functionality are functions or secrets hidden inside the app.
Those functionalities allow an attacker to perform unintended actions such as:
* Accessing administrative or debug functions
* Retrieving hidden secrets (API keys, account credentials, personal information, etc)
* Discovering hidden back-end endpoints

In the case of the kotlin-goat app, a backdoor account is hardcoded inside the code. 
When performing static analysis using [apktool][1], [jadx][2] or [jd-gui][3], an attacker
is able to identify it on the LoginActivity file

``` 
inner class UserLoginTask internal constructor(private val mUsername: String, private val mPassword: String) : AsyncTask<Void, Void, Boolean>() {

        override fun doInBackground(vararg params: Void): Boolean? {
            if ((mUsername == "Supervisor") and (mPassword == "MySuperSecretPassword123!")){
                return true
            }
            else {

                val account:Account = DatabaseHelper(applicationContext).getAccount(mUsername)
                if (mPassword == account.password) {
```

## Resources
### Tools

* [apktool][1]
* [jadx][2]
* [jd-gui][3]


### Readings
* [M10: OWASP Mobile Top 10 2016] [4]


[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M10-Extraneous_Functionality

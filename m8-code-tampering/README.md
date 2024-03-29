---
nav_order: 8
---

M8: Code Tampering
==================

Once a mobile application is delivered and installed on a device, both the code
and data will be available there. This gives the adversary the chance to
directly modify the code, manipulate memory content, change or replace system
APIs, or simply modify application's data and resources. This is known as **Code
Tampering**.

Rogue mobile applications play an important role in fraud-based attacks,
becoming even more prevalent than malware. Typically attackers are able to exploit 
code modification by tricking users into installing malicious/modified apps via phishing attacks.

Notice that Kotlin has no advantage over plain Java when it comes to avoiding
reverse engineering.

Technically, all mobile applications are vulnerable to code tampering, but some
are historically more targeted (e.g. mobile games) than others. Deciding whether
or not to address this risk is a matter of business impact that can range from
revenue loss to reputational damage.

[OWASP Reverse Engineering and Code Modification Prevention Project][1] is a
great reference on how to detect and prevent Reverse Engineering and Code
Modification. Generally speaking, applications should be able to detect at
runtime whether code was added or removed based upon what they know about their
integrity at compile time.

To address this weakness on [Goatlin][0], we followed OWASP recommendation on
Android Root detection. The [`RootDetectionHelper` class][3] implements a few
techniques such as:

* Whether the kernel was signed with custom keys generated by a third-party
  developer:
```kotlin
private fun detectDeveloperBuild(): Boolean {
    val buildTags: String = Build.TAGS

    return buildTags.contains("test-keys")
}
```
* OTA certificates are available:
```kotlin
private fun detectOTACertificates(): Boolean {
    val otaCerts: File = File("/etc/security/otacerts.zip")

    return otaCerts.exists()
}
```
* Well-known applications to gain root access on Android devices are installed:
```kotlin
private fun detectRootedAPKs(ctx: Context): Boolean {
    val knownRootedAPKs: Array<String> = arrayOf(
        "com.noshufou.android.su",
        "com.thirdparty.superuser",
        "eu.chainfire.supersu",
        "com.koushikdutta.superuser",
        "com.zachspong.temprootremovejb",
        "com.ramdroid.appquarantine"
    )
    val pm: PackageManager = ctx.packageManager

    for(uri in knownRootedAPKs) {
        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES)
            return true
        } catch (e: PackageManager.NameNotFoundException) {
            // application is not installed
        }
    }

    return false
}
```
* `su` binary is available:
```kotlin
private fun detectForSUBinaries(): Boolean {
    var suBinaries: Array<String> = arrayOf(
        "/system/bin/su",
        "/system/xbin/su",
        "/sbin/su",
        "/system/su",
        "/system/bin/.ext/.su",
        "/system/usr/we-need-root/su-backup",
        "/system/xbin/mu"
    )

    for (bin in suBinaries) {
        if (File(bin).exists()) {
            return true
        }
    }

    return false
}
```
* Attempt to run `su` and check the id of current user:

To prevent the application to run on a Rooted environment, the
`RootDetectionHelper.check()` method, which combines all the described
techniques, is called on our main activity (Login). If a Rooted environment is
detected, then the user is presented a dialog and the application is forced to
close:

```kotlin
package com.cx.goatlin
// ...
class LoginActivity : AppCompatActivity(), LoaderCallbacks<Cursor> {
    // ...
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        if (RootDetectionHelper.check(applicationContext)) {
            forceCloseApp()
        }
        //  ...
    }
    // ...
    private fun forceCloseApp() {
        val dialog: AlertDialog.Builder = AlertDialog.Builder(this)

        dialog
                .setMessage("The application can not run on rooted devices")
                .setCancelable(false)
                .setPositiveButton("Close Application", DialogInterface.OnClickListener {
                    _, _ -> finish()
                })

        val alert: AlertDialog = dialog.create()

        alert.setTitle("Unsafe Device")
        alert.show()
    }
    //...
}
```

## Resources

### Readings

* [OWASP Reverse Engineering and Code Modification Prevention Project][1]
* [Android Root Detection Techniques][2]
* [OWASP Mobile Top 10 2016: M8 - Code Tampering][4]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://www.owasp.org/index.php/OWASP_Reverse_Engineering_and_Code_Modification_Prevention_Project
[2]: https://blog.netspi.com/android-root-detection-techniques/
[3]: https://github.com/Checkmarx/Goatlin/blob/feature/m8-code-tampering/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/RootDetectionHelper.kt
[4]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M8-Code_Tampering

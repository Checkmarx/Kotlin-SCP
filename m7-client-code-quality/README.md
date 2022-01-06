---
nav_order: 7
---

M7: Client Code Quality
=======================

This category includes code-level issues like a buffer overflow in C, or a
DOM-based XSS in a Webview mobile app. It's usually something that requires code
changes to be fixed, since it is caused by an improper API or language constructs
usage.

Although Client Code Quality issues are prevalent, the exploitation often
requires low-level knowledge. The typical primary goal is to execute foreign
code within the mobile code's address space.

Consistent coding patterns and coding style guidelines broadly accepted in the
organization will help to improve code quality. Since these issues are not
easily detected on code review, using a static analysis tool usually provides
the results. Buffer overflows and memory leaks should be top priorities over
other code quality issues yet to be resolved.

[Detekt][1] is one of such static code analysis tools for Kotlin licensed under
the [Apache License 2.0][3]. It provides several integration mechanisms such as
a Gradle plugin and a SonarQube integration, but it can also run standalone.

Running Detekt on [Goatlin][0] source code, results as bellow:

```
$ java -jar detekt-cli/build/libs/detekt-cli-1.0.0-RC12-all.jar -r txt:/tmp/goatlin.txt -i goatlin/packages/clients/android/

Overall debt: 7h

Complexity Report:
        - 1230 lines of code (loc)
        - 912 source lines of code (sloc)
        - 610 logical lines of code (lloc)
        - 87 comment lines of code (cloc)
        - 145 McCabe complexity (mcc)
        - 47 number of total code smells
        - 9 % comment source ratio
        - 237 mcc per 1000 lloc
        - 77 code smells per 1000 lloc

Project Statistics:
        - number of properties: 149
        - number of functions: 75
        - number of classes: 18
        - number of packages: 5
        - number of kt files: 17
```

The report summary highlights several issues grouped by ruleset. Below are just
the most relevant issues found:

```
Ruleset: complexity - 40min debt
        TooManyFunctions - 15/11 - [DatabaseHelper] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/DatabaseHelper.kt:16:1
        ComplexMethod - 15/10 - [showProgress] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/LoginActivity.kt:126:5
Ruleset: exceptions - 1h 40min debt
        TooGenericExceptionCaught - [exception] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/DatabaseHelper.kt:46:18
        TooGenericExceptionThrown - [installDatabaseFromAssets] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/DatabaseHelper.kt:47:13
        TooGenericExceptionThrown - [getAccount] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/DatabaseHelper.kt:91:13
        TooGenericExceptionThrown - [getNote] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/DatabaseHelper.kt:165:13
        TooGenericExceptionCaught - [e] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/EditNoteActivity.kt:67:20
Ruleset: style - 4h 10min debt
        MagicNumber - [lowerBoundary] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/CryptoHelper.kt:12:63
        WildcardImport - [LoginActivity.kt] at goatlin/packages/clients/android/app/src/main/java/com/cx/goatlin/LoginActivity.kt:20:1
```

## Resources

### Tools

* [Detekt][1]
* [SonarQube][2]

### Readings

* [Kotlin Coding Conventions][4]
* [Kotlin style guide][5]
* [Idiomatic Kotlin. Best Practices.][6]
* [OWASP Mobile Top 10 2016: M7 - Client Code Quality][7]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://github.com/detekt/detekt/
[2]: https://www.sonarqube.org/
[3]: https://www.apache.org/licenses/LICENSE-2.0
[4]: https://kotlinlang.org/docs/reference/coding-conventions.html
[5]: https://developer.android.com/kotlin/style-guide
[6]: https://blog.philipphauer.de/idiomatic-kotlin-best-practices/
[7]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M7-Poor_Code_Quality

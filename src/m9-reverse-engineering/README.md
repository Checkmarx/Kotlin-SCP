M9: Reverse Engineering
=======================

One of the first steps when performing security assessments on Android
applications is to perform static analysis of the app in order to understand its
internals such as:

* How is it working?
* What kind of communications are established?
* Which libraries are used?

Several tools are available to perform this task such as [apktool][1], [jadx][2]
or [jd-gui][3].

Apktool is a decompiling tool, allowing to obtain the smali bytecode of the app,
which is executed by the Dalvik virtual machine. The code obtained is very low
level, but it permits a deep overview of the app internals. Here is an
example of smali bytecode:

```
# static fields
.field static final synthetic $$delegatedProperties:[Lkotlin/reflect/KProperty;

# instance fields
.field private _$_findViewCache:Ljava/util/HashMap;
.field private final apiService$delegate:Lkotlin/Lazy;
.field private listView:Landroid/widget/ListView;

# direct methods
.method static constructor <clinit>()V
    .locals 5
    const/4 v0, 0x1
    new-array v0, v0, [Lkotlin/reflect/KProperty;
    new-instance v1, Lkotlin/jvm/internal/PropertyReference1Impl;
    const-class v2, Lcom/cx/goatlin/HomeActivity;
    invoke-static {v2}, Lkotlin/jvm/internal/Reflection;->getOrCreateKotlinClass(Ljava/lang/Class;)Lkotlin/reflect/KClass;
    move-result-object v2
    const-string v3, "apiService"
    const-string v4, "getApiService()Lcom/cx/goatlin/api/service/Client;"
    invoke-direct {v1, v2, v3, v4}, Lkotlin/jvm/internal/PropertyReference1Impl;-><init>(Lkotlin/reflect/KDeclarationContainer;Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {v1}, Lkotlin/jvm/internal/Reflection;->property1(Lkotlin/jvm/internal/PropertyReference1;)Lkotlin/reflect/KProperty1;
    move-result-object v1
    check-cast v1, Lkotlin/reflect/KProperty;
    const/4 v2, 0x0
    aput-object v1, v0, v2
    sput-object v0, Lcom/cx/goatlin/HomeActivity;->$$delegatedProperties:[Lkotlin/reflect/KProperty;
    return-void
.end method
```

In order to obtain Java code, an attacker can use [jadx][2] or [jd-gui][3] to
decompile the app. The video below demonstrates it using [jadx][2] on [Kotlin
Goat][0]

{% youtube src="https://www.youtube.com/watch?v=8b882SulnQA" %}{% endyoutube %}

As you can see, there is no obfuscation at all on the [Goatlin][0]. An attacker
is able to easily analyze the app in order to understand the inner mechanisms.

In order to slow down the process of reverse engineering, developers use various
techniques to obfuscate the code such as renaming the variables and name
functions with weird names or using a non-Latin charset. Here is an example
where all the variables and method names were renamed:

![Android app using obfuscation technique][jadx-obfuscation]

The most well known tool to perform code obfuscation is [Proguard][4].
Quoting Wikipedia: "_ProGuard is an open source command-line tool that shrinks,
optimizes and obfuscates Java code. It is able to optimize bytecode as well as
detect and remove unused instructions._"

The [Android documentation][6] provides guidance on how to shrink your code and
resources. In this [article][7], you can find explanations on how to enable
Proguard with Android Studio.

## Resources

### Tools

* [apktool][1]
* [jadx][2]
* [jd-gui][3]
* [Proguard][4]

### Readings

* [Android documentation: Shrink your code and resources][6]
* [Enabling Proguard for Android][7]
* [OWASP Mobile Top 10 2016: M9 - Reverse Engineering][5]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://www.guardsquare.com/en/products/proguard
[5]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M9-Reverse_Engineering
[6]: https://developer.android.com/studio/build/shrink-code
[7]: https://medium.com/@maheshwar.ligade/enabling-proguard-for-android-98e2b19e90a4
[jadx-obfuscation]: assets/jadx-obfuscation.png

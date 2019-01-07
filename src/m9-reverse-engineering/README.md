M9: Reverse Engineering
=======================
One of the first step when performing security assessments on Android applications is to perform static analysis of the app in order to understand its internals such as:
* How is it working? 
* What kind of communications are established? 
* Which libraries are used? 

Several tools are available to perform this task such as [apktool][1], [jadx][2] or [jd-gui][3].

Apktool is a tool allowing to obtain the smali bytecode of the app, which is executed by the Dalvik virtual machine. The code obtained is very low level but allows to have a deep overview of the app internals. Here is an example of smali bytecode:
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

    const-class v2, Lcom/cx/vulnerablekotlinapp/HomeActivity;

    invoke-static {v2}, Lkotlin/jvm/internal/Reflection;->getOrCreateKotlinClass(Ljava/lang/Class;)Lkotlin/reflect/KClass;

    move-result-object v2

    const-string v3, "apiService"

    const-string v4, "getApiService()Lcom/cx/vulnerablekotlinapp/api/service/Client;"

    invoke-direct {v1, v2, v3, v4}, Lkotlin/jvm/internal/PropertyReference1Impl;-><init>(Lkotlin/reflect/KDeclarationContainer;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {v1}, Lkotlin/jvm/internal/Reflection;->property1(Lkotlin/jvm/internal/PropertyReference1;)Lkotlin/reflect/KProperty1;

    move-result-object v1

    check-cast v1, Lkotlin/reflect/KProperty;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sput-object v0, Lcom/cx/vulnerablekotlinapp/HomeActivity;->$$delegatedProperties:[Lkotlin/reflect/KProperty;

    return-void
.end method

```

In order to obtain Java code, an attacker can use [jadx][2] or [jd-gui][3] to decompile the app. Here is an example using [jadx][2] on the kotlin-goat app:
![Decompilation of the kotlin-goat app using Jadx][jadx]


In order to slow down the process of reverse engineering, developers use some techniques to obfuscate the code such renaming the variables and name functions with weird names or using a non latin charset.

FIXME - add an image with obfuscated code

Different tools can be used to obfuscate the code of your Android app sucha as proguard.
 


## Resources

### Tools

* [apktool][1]
* [jadx][2]
* [jd-gui][3]


### Readings
* [M9: OWASP Mobile Top 10 2016] [4]


[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M9-Reverse_Engineering

[jadx]: assets/jadx.png
M9: Reverse Engineering
=======================
One of the first step when performing security assessments on Android applications is to perform static analysis of the app in order to understand the internals of the app: how is it working? what kind of communications are established? which libraries are used? 

Several tools are available to perform this task such as apktool, jadx or jd-gui.

Apktool is a tool decompiling the APK of the app and allows to obtain the smali bytecode of the app, which is executed by the Dalvik virtual machine. The code obtained is very low level but allows to have a deep overview of the app internals.

Another tools such as jadx or jd-gui allows to decompile the app in order to obtain Java code. Here is an example with the kotlin-goat app:
FIXME - add an image of jadx

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
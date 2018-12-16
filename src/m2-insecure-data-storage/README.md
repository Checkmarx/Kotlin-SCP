M2: Insecure Data Storage
=========================
Several ways exist to store data for Android apps:
* Databases: Internal SQLite databases only avalaible for the app.
* Internal storage: Files only available for the app.
* External storage: Files usually stored on the SDCard (or any removable device). Files are available for everyone.
* Shared Preferences: XML files mostly used as key-pair values to store configuration parameters.

FIXME

## Resources

### Tools

* [apktool][1]
* [jadx][2]
* [jd-gui][3]


### Readings

* [OWASP Mobile Security Testing guide - Test Data Storage] [4]


[1]: https://github.com/skylot/jadx
[2]: http://jd.benow.ca/
[3]: https://ibotpeaches.github.io/Apktool/
[4]: https://github.com/OWASP/owasp-mstg/blob/master/Document/0x05d-Testing-Data-Storage.md
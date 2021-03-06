---
nav_order: 6
---

M6: Insecure Authorization
==========================

It is important to distinguish between authentication and authorization: the
former is the act of identifying an individual whereas the latter is the act of
checking that the identified individual has the necessary permissions to perform
the act. To exploit Insecure Authorization, adversaries usually log in to the
application as a legitimate user first, then they typically force-browse to a
vulnerable endpoint.

Because authentication precedes authorization, if an application fails to
identify an individual before making an API request, then it automatically
suffers from Insecure Authorization.

Usually, Insecure Authorization is greatly associated with IDOR - Insecure
Direct Object Reference, but it is also found on hidden endpoints that
developers assume will be accessed only by someone with the right role. If the
mobile application sends the user role or permissions to the back-end as part of
the request, it is likely vulnerable to Insecure Authorization.

The movie below demonstrates how Insecure Authorization can be exploited on 
[Goatlin][0].

{% include youtube-player.html id="vsyTMpRnFtA" %}

Insecure Authorization in [Goatlin][0] is clearly a back-end issue.
Although [API routes][1] include [**authentication** middleware][2] when
appropriate, no permissions (authorization) are validated:

```javascript
router.put('/accounts/:username/notes/:note', auth, async (req, res, next) => {
    // ...
});

router.get('/accounts/:username/notes', auth, async (req, res, next) => {
    // ...
});
```

In this case, resources can be managed only by their owner. This is the
validation that our [authorization middleware][3] will be responsible for:

```javascript
function ownership (req, res, next) {
    if (req.params.username !== req.account.username) {
        res.statusMessage = "Unauthorized"
        return res.status(403).end();
    }

    next();
}
```

This is how API routes look like when they include both authentication and
authorization middlewares:

```javascript
router.put('/accounts/:username/notes/:note', [auth, ownership], async (req, res, next) => {
    // ...
});

router.get('/accounts/:username/notes', [auth, ownership], async (req, res, next) => {
    // ...
});
```

## Resources

### Readings

* [Insecure Direct Object Reference Prevention Cheat Sheet][5]
* [Testing for Insecure Direct Object References (OTG-AUTHZ-004)][6]
* [Using middleware - Express][7]
* [OWASP Mobile Top 10 2016: M6 - Insecure Authorization][8]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://github.com/Checkmarx/Goatlin/blob/master/packages/services/api/src/routes/accounts.js#L29
[2]: https://github.com/Checkmarx/Goatlin/blob/master/packages/services/api/src/middleware/auth.js
[3]: https://github.com/Checkmarx/Goatlin/blob/feature/m6-insecure-authorization/packages/services/api/src/middleware/ownership.js
[5]: https://www.owasp.org/index.php/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet
[6]: https://www.owasp.org/index.php/Testing_for_Insecure_Direct_Object_References_(OTG-AUTHZ-004)
[7]: https://expressjs.com/en/guide/using-middleware.html
[8]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M6-Insecure_Authorization

How to Contribute
=================

Here are the basics of contributing to GitHub:

1. Fork and clone the project
2. Set up the project locally
3. Create an upstream remote and sync your local copy
4. Branch each set of work
5. Push the work to your own repository
6. Create a new pull request
7. Look out for any code feedback and respond accordingly

We follow [Vincent Driessen's branching model][1]: [Git flow][2] and
[Git Flow Hooks][3] by [Jaspern Brouwer][4]. These will be great additions to
your environment.

The book sources are written on [Markdown format][5], taking advantage of
[gitbook-cli][6] ([Node.js][7] is required).

While in the development stage, you can live preview your work:

```shell
$ npm run serve
```

The output will include an URL like `http://localhost:4000` where you can
preview the book.

## How to start

1. fork [Kotlin-SCP repository][8]
2. clone your fork:
   ```
   git clone git@github.com:[YOUR-USERNAME]/Kotlin-SCP.git
   ```
3. enter your local copy:
   ```
   cd kotlin-scp
   ```
4. initialize git flow:
   ```
   $ git flow init
   ```
5. fetch remote branches:
   ```
   $ git fetch --all
   ```
6. install development dependencies:
   ```
   $ npm install 
   ```

### New section / sub-section

Simply put, every time you want to work on a new section, or add a sub-section,
you should start a "feature":

```shell
$ git flow feature start my-new-section
```

To keep your work safe, don't forget to publish your feature often:

```shell
$ git flow feature publish
```

### Typos / Urgent updates

For typos and any other issues that should not wait for the next release to be
fixed, you should start a hotfix:

```shell
$ git flow hotfix start
```

Once you're ready to merge your work with others, you should go to main
repository and open a New Pull Request to the `develop` branch. Then,
someone will review your work, comment, request changes, and/or simply merge it
to  branch `develop` of the project's main repository. Hotfixes will be merged
both to `develop` and `master` branches, making changes immediately available.
Features become available on the next release.

Remember to keep `master` and `develop` branches of your fork up to date with
the upstream ones.

## How to Build

If you have `node` installed, you can run:

```
$ npm i && node_modules/.bin/gitbook install && npm run build
```

You can also build the book using an ephemeral Docker container:

```
$ docker-compose run -u node:node --rm build
```

[1]: http://nvie.com/posts/a-successful-git-branching-model
[2]: https://github.com/petervanderdoes/gitflow-avh
[3]: https://github.com/jaspernbrouwer/git-flow-hooks
[4]: https://github.com/jaspernbrouwer
[5]: http://daringfireball.net/projects/markdown
[6]: https://github.com/GitbookIO/gitbook-cli
[7]: https://nodejs.org/
[8]: https://github.com/Checkmarx/Kotlin-SCP

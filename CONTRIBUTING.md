---
nav_order: 12
---

How-to Contribute
=================

---
> Pull requests should be opened to the `develop` branch as `master` is
> reserved for releases.

---

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

The guide sources are written on [Markdown format][5], taking advantage of
[Jekyll][6] for [GitHub Pages][7].

While in the development stage, you can live preview your work using the [GitHub
Pages Ruby Gem][9].

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
to branch `develop` of the project's main repository. Hotfixes will be merged
both to `develop` and `master` branches, making changes immediately available.
Features become available on the next release.

Remember to keep `master` and `develop` branches of your fork up to date with
the upstream ones.

## Testing locally

You can do it using the [GitHub Pages Ruby Gem][9]: "_A simple Ruby Gem to
bootstrap dependencies for setting up and maintaining a local Jekyll environment
in sync with GitHub Pages._"

Provided that Docker is installed, follow the official [GitHub Pages Ruby
Gem instructions][11] to build the Docker image and run the server.


[1]: http://nvie.com/posts/a-successful-git-branching-model
[2]: https://github.com/petervanderdoes/gitflow-avh
[3]: https://github.com/jaspernbrouwer/git-flow-hooks
[4]: https://github.com/jaspernbrouwer
[5]: http://daringfireball.net/projects/markdown
[6]: https://jekyllrb.com/
[7]: https://pages.github.com/
[8]: https://github.com/Checkmarx/Kotlin-SCP
[9]: https://github.com/github/pages-gem
[11]: https://github.com/github/pages-gem#docker


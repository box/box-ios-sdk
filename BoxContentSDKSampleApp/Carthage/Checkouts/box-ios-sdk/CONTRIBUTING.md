Contributing
============

All contributions are welcome to this project.

Contributor License Agreement
-----------------------------

Before a contribution can be merged into this project, please fill out
the [Contributor License Agreement (CLA)](http://box.github.io/cla).

How to contribute
-----------------

-  **File an issue** - if you found a bug, want to request an
   enhancement, or want to implement something (bug fix or feature).
-  **Send a pull request** - if you want to contribute code. Please be
   sure to file an issue first.

Pull request best practices
============

We want to accept your pull requests. Please follow these steps:

Step 1: File an issue
---------------------

Before writing any code, please file an issue stating the problem you
want to solve or the feature you want to implement. This allows us to
give you feedback before you spend any time writing code. There may be a
known limitation that can't be addressed, or a bug that has already been
fixed in a different way. The issue allows us to communicate and figure
out if it's worth your time to write a bunch of code for the project.

Step 2: Fork this repository on GitHub
-------------------------------------

This will create your own copy of our repository.

Step 3: Set the remote fetch origin
-------------------------------

The remote fetch origin is the project under the Box organization.
Setting this will ensure you're pulling in the latest changes from the main repository.

```
git remote set-url origin https://github.com/box/box-ios-content-sdk.git
```

```
git remote set-url origin --push https://github.com/<YOUR_GITHUB_USERNAME>/box-ios-content-sdk.git
```


Step 4: Rebase
--------------

Before sending a pull request, rebase against origin, like thus:

```
git fetch origin
```
```
git pull --rebase
```


This will add your changes on top of what's already in origin.

Step 5: Run the tests
---------------------

Make sure that all tests are passing before submitting a pull request.

Step 6: Send the pull request
-----------------------------

Send the pull request from your fork to us. Be sure to include
a description that lets us know what work you did.

Keep in mind that we like to see one issue addressed per pull request,
as this helps keep our git history clean so we can more easily track
down issues.

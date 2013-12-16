Compact Language Detector 2
===========================

This is a fork of https://code.google.com/p/cld2/, with added features for enabling a more liberal approach to language detection, where weaker answers are less likely to be discarded. This fork may be more suitable for smaller input samples where a potentiallly weak answer is more useful than no answer at all.

To enable the new behaviour call using the new kCLDFlagLiberal flag.

Origin
------

This fork was created using the git-svn plugin:

``` sh
git svn clone https://cld2.googlecode.com/svn -s
git checkout -b develop
```

Changes from the subversion origin should be pulled into the master branch, you can then either rebase or merge the develop branch:

``` sh
git checkout master
git svn init http://cld2.googlecode.com/svn/trunk
git svn fetch

git checkout develop
git merge master
```

Installation
------------

By default lib(64) and include files will be installed to /usr, you can change the install prefix by setting PREFIX.

```
make
make check
sudo make install PREFIX=/opt/cld2
```

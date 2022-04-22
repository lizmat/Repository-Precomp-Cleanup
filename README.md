[![Actions Status](https://github.com/lizmat/Repository-Precomp-Cleanup/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/Repository-Precomp-Cleanup/actions)

NAME
====

Repository::Precomp::Cleanup - provide logic for cleaning up precomp directories

SYNOPSIS
========

```raku
use Repository::Precomp::Cleanup;

cleanup-precomp($*REPO);          # cleanup first repository only

my int $cleaned;
for $*REPO.repo-chain -> $repo {  # cleanup all repositories
    $cleaned += $_ with cleanup-precomp($repo);
}
say "Freed up $cleaned bytes in total";
```

DESCRIPTION
===========

`Repository::Precomp::Cleanup` is a module that exports a `cleanup-precomp` subroutine that will remove all outdated precompiled files from a given repository precompilation-store. It returns the number of bytes that were freed (as reported by `IO::Path.s`).

SCRIPTS
=======

This distribution also installs a `clean-precomp` script that will either cleanup the specified repositories by name, or all repositories that can be cleaned from the current repository chain.

WHY
===

If you are a module developer that tries to keep up-to-date with all latest versions of Rakudo, and/or you're a core developer working on the setting, you can easily lose a lot of disk-space by outdated precompilation files (as each precompilation file is keyed to a specific version of the core).

The script provided by this distribution, allows you to easily free up this disk-space without having to wonder what can be removed, and what cannot.

    $ clean-precomp

Clean out all precompilation stores in the current repository chain.

    $ clean-precomp . lib

Clean out precompilation stores of repositories in "." and "lib".

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Repository-Precomp-Cleanup . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.


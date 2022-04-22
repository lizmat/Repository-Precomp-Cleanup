NAME
====

Precomp::Cleanup - provide logic for cleaning up precomp directories

SYNOPSIS
========

```raku
use Precomp::Cleanup;

cleanup-precomp($*REPO);          # cleanup first repository only

my int $cleaned;
for $*REPO.repo-chain -> $repo {  # cleanup all repositories
    $cleaned += $_ with cleanup-precomp($repo);
}
say "Freed up $cleaned bytes in total";
```

DESCRIPTION
===========

Precomp::Cleanup is a module that exports a `cleanup-precomp` subroutine that will remove all outdated precompiled files from a given repository. It returns the number of bytes that were freed (as reported by `IO::Path.s`).

SCRIPTS
=======

This distribution also includes a `clean-precomp` script that will either cleanup the specified repositories by name, or all repositories that can be cleaned.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.


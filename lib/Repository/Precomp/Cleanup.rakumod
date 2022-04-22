my str $compilation-id = Compiler.id;

my sub cleanup-precomp(CompUnit::Repository:D $repo --> Int:D) is export {
    $repo ~~ CompUnit::Repository::Locally
      ?? (my $io := $repo.precomp-store.prefix).d
        ?? unlink-recursively($io, :keep)
        !! Failure.new("Repository {
               $repo.?name // $repo.prefix.basename
           } has no precomp directory")
      !! 0
}

my sub unlink-recursively(IO::Path:D $io, :$keep --> Int:D) {
    my int $bytes;
    for $io.dir {
        my $basename := .basename;
        if .d {
            $bytes += unlink-recursively($_)
              if $basename ne $compilation-id;
        }
        elsif $basename ne 'CACHEDIR.TAG' {
            $bytes += .s;
            .unlink;
        }
    }

    $io.rmdir unless $keep;
    $bytes
}

=begin pod

=head1 NAME

Repository::Precomp::Cleanup - provide logic for cleaning up precomp directories

=head1 SYNOPSIS

=begin code :lang<raku>

use Repository::Precomp::Cleanup;

cleanup-precomp($*REPO);          # cleanup first repository only

my int $cleaned;
for $*REPO.repo-chain -> $repo {  # cleanup all repositories
    $cleaned += $_ with cleanup-precomp($repo);
}
say "Freed up $cleaned bytes in total";

=end code

=head1 DESCRIPTION

C<Repository::Precomp::Cleanup> is a module that exports a C<cleanup-precomp>
subroutine that will remove all outdated precompiled files from a given
repository precompilation-store.  It returns the number of bytes that were
freed (as reported by C<IO::Path.s>).

=head1 SCRIPTS

This distribution also installs a C<clean-precomp> script that will either
cleanup the specified repositories by name, or all repositories that can
be cleaned from the current repository chain.

=head1 WHY

If you are a module developer that tries to keep up-to-date with all latest
versions of Rakudo, and/or you're a core developer working on the setting,
you can easily lose a lot of disk-space by outdated precompilation files
(as each precompilation file is keyed to a specific version of the core).

The script provided by this distribution, allows you to easily free up this
disk-space without having to wonder what can be removed, and what cannot.

=begin code

$ clean-precomp

=end code

Clean out all precompilation stores in the current repository chain.

=begin code

$ clean-precomp . lib

=end code

Clean out precompilation stores of repositories in "." and "lib".

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Repository-Precomp-Cleanup .
Comments and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4

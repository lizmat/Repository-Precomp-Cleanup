my str $compilation-id = Compiler.id;

my sub cleanup-precomp(CompUnit::Repository:D $repo --> Int:D) is export {
    my $identifier := $repo.?name // $repo.id;
    if $repo.?prefix -> $prefix {
        (my $io := $prefix.add("precomp")).d
          ?? unlink-recursively($io, :keep)
          !! Failure.new("Repository $identifier has no precomp directory")
    }
    else {
        Failure.new("Repository $identifier has no directory")
    }
}

my sub unlink-recursively(IO::Path:D $io, :$keep --> Int:D) {
    my int $bytes;
    for $io.dir {
        if .d {
            $bytes += unlink-recursively($_)
              if .basename ne $compilation-id;
        }
        else {
            $bytes += .s;
            .unlink;
        }
    }

    $io.rmdir unless $keep;
    $bytes
}

=begin pod

=head1 NAME

Precomp::Cleanup - provide logic for cleaning up precomp directories

=head1 SYNOPSIS

=begin code :lang<raku>

use Precomp::Cleanup;

cleanup-precomp($*REPO);          # cleanup first repository only

my int $cleaned;
for $*REPO.repo-chain -> $repo {  # cleanup all repositories
    $cleaned += $_ with cleanup-precomp($repo);
}
say "Freed up $cleaned bytes in total";

=end code

=head1 DESCRIPTION

Precomp::Cleanup is a module that exports a C<cleanup-precomp> subroutine
that will remove all outdated precompiled files from a given repository.
It returns the number of bytes that were freed (as reported by C<IO::Path.s>).

=head1 SCRIPTS

This distribution also includes a C<clean-precomp> script that will either
cleanup the specified repositories by name, or all repositories that can
be cleaned.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4

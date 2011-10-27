use inc::Module::Install;

name     'DBIx-Goose';
all_from 'lib/DBIx/Goose.pm';
author   q{Brad Haywood <brad@geeksware.net>};
license  'perl';

build_requires 'Test::More';
requires 'Module::Finder';
requires 'SQL::Abstract::More';
requires 'DBD::SQLite';
auto_install;

WriteAll;


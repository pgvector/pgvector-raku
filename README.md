# pgvector-raku

[pgvector](https://github.com/pgvector/pgvector) examples for Raku

Supports [DBIish](https://github.com/raku-community-modules/DBIish) and [DB::Pg](https://github.com/CurtTilmes/raku-dbpg)

[![Build Status](https://github.com/pgvector/pgvector-raku/actions/workflows/build.yml/badge.svg)](https://github.com/pgvector/pgvector-raku/actions)

## Getting Started

Follow the instructions for your database library:

- [DBIish](#dbiish)
- [DB::Pg](#dbpg)

## DBIish

Enable the extension

```raku
$dbh.execute('CREATE EXTENSION IF NOT EXISTS vector');
```

Create a table

```raku
$dbh.execute('CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))');
```

Insert vectors

```raku
my $embedding1 = '[1,1,1]';
my $embedding2 = '[2,2,2]';
my $embedding3 = '[1,1,2]';
$dbh.execute('INSERT INTO items (embedding) VALUES (?), (?), (?)', $embedding1, $embedding2, $embedding3);
```

Get the nearest neighbors

```raku
my $embedding = '[1,1,1]';
.say for $dbh.execute('SELECT * FROM items ORDER BY embedding <-> ? LIMIT 5', $embedding).allrows();
```

Add an approximate index

```raku
$dbh.execute('CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)');
# or
$dbh.execute('CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)');
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

See a [full example](dbiish.raku)

## DB::Pg

Enable the extension

```raku
$pg.query('CREATE EXTENSION IF NOT EXISTS vector');
```

Create a table

```raku
$pg.query('CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))');
```

Insert vectors

```raku
my $embedding1 = '[1,1,1]';
my $embedding2 = '[2,2,2]';
my $embedding3 = '[1,1,2]';
$pg.query('INSERT INTO items (embedding) VALUES ($1), ($2), ($3)', $embedding1, $embedding2, $embedding3);
```

Get the nearest neighbors

```raku
my $embedding = '[1,1,1]';
.say for $pg.query('SELECT * FROM items ORDER BY embedding <-> $1 LIMIT 5', $embedding).arrays;
```

Add an approximate index

```raku
$pg.query('CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)');
# or
$pg.query('CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)');
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

See a [full example](dbpg.raku)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-raku/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-raku/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-raku.git
cd pgvector-raku
createdb pgvector_raku_test
zef install DB::Pg
raku dbiish.raku
raku dbpg.raku
```

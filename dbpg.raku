use DB::Pg;

my $pg = DB::Pg.new(conninfo => 'dbname=pgvector_raku_test');

$pg.query('CREATE EXTENSION IF NOT EXISTS vector');
$pg.query('DROP TABLE IF EXISTS items');
$pg.query('CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))');

my $embedding1 = '[1,1,1]';
my $embedding2 = '[2,2,2]';
my $embedding3 = '[1,1,2]';
$pg.query('INSERT INTO items (embedding) VALUES ($1), ($2), ($3)', $embedding1, $embedding2, $embedding3);

my $embedding = '[1,1,1]';
.say for $pg.query('SELECT * FROM items ORDER BY embedding <-> $1 LIMIT 5', $embedding).arrays;

$pg.query('CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)');

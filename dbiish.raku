use v6;
use DBIish;

my $dbh = DBIish.connect("Pg", :database<pgvector_raku_test>);

$dbh.execute('CREATE EXTENSION IF NOT EXISTS vector');
$dbh.execute('DROP TABLE IF EXISTS items');
$dbh.execute('CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))');

my $embedding1 = '[1,1,1]';
my $embedding2 = '[2,2,2]';
my $embedding3 = '[1,1,2]';
$dbh.execute('INSERT INTO items (embedding) VALUES (?), (?), (?)', $embedding1, $embedding2, $embedding3);

my $embedding = '[1,1,1]';
.say for $dbh.execute('SELECT * FROM items ORDER BY embedding <-> ? LIMIT 5', $embedding).allrows();

$dbh.execute('CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)');

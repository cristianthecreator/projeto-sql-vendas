BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "clientes" (
	"id"	INTEGER,
	"nome"	TEXT NOT NULL,
	"email"	TEXT UNIQUE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "itens_pedido" (
	"id"	INTEGER,
	"pedido_id"	INTEGER NOT NULL,
	"produto_id"	INTEGER NOT NULL,
	"quantidade"	INTEGER NOT NULL CHECK("quantidade" > 0),
	"preco_unitario_centavos"	INTEGER NOT NULL CHECK("preco_unitario_centavos" >= 0),
	PRIMARY KEY("id"),
	FOREIGN KEY("pedido_id") REFERENCES "pedidos"("id"),
	FOREIGN KEY("produto_id") REFERENCES "produtos"("id")
);
CREATE TABLE IF NOT EXISTS "pedidos" (
	"id"	INTEGER,
	"cliente_id"	INTEGER NOT NULL,
	"data_pedido"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("cliente_id") REFERENCES "clientes"("id")
);
CREATE TABLE IF NOT EXISTS "produtos" (
	"id"	INTEGER,
	"nome"	TEXT NOT NULL,
	"preco_centavos"	INTEGER NOT NULL CHECK("preco_centavos" >= 0),
	"estoque"	INTEGER NOT NULL CHECK("estoque" >= 0),
	PRIMARY KEY("id")
);
INSERT INTO "clientes" VALUES (1,'Ana Silva','ana@example.com');
INSERT INTO "clientes" VALUES (2,'Bruno Santos','bruno@example.com');
INSERT INTO "clientes" VALUES (3,'Carla Souza','carla@example.com');
INSERT INTO "itens_pedido" VALUES (1,1,1,2,2590);
INSERT INTO "itens_pedido" VALUES (2,1,2,1,8990);
INSERT INTO "itens_pedido" VALUES (3,2,3,1,75000);
INSERT INTO "pedidos" VALUES (1,1,'2026-09-21');
INSERT INTO "pedidos" VALUES (2,2,'2026-09-21');
INSERT INTO "produtos" VALUES (1,'Mouse',2590,20);
INSERT INTO "produtos" VALUES (2,'Teclado',8990,15);
INSERT INTO "produtos" VALUES (3,'Monitor',75000,8);
CREATE VIEW resumo_clientes AS
SELECT
    clientes.id AS cliente_id,
    clientes.nome AS cliente,
    COALESCE(
        SUM(itens_pedido.quantidade * itens_pedido.preco_unitario_centavos),
        0
    ) / 100.0 AS total_gasto_reais
FROM clientes
LEFT JOIN pedidos ON pedidos.cliente_id = clientes.id
LEFT JOIN itens_pedido ON itens_pedido.pedido_id = pedidos.id
GROUP BY clientes.id, clientes.nome;
COMMIT;

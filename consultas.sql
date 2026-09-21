-- 1. Listar clientes
SELECT * FROM clientes;

-- 2. Mostrar produtos com preços em reais
SELECT nome, preco_centavos / 100.0 AS preco_reais, estoque
FROM produtos;

-- 3. Calcular o faturamento total
SELECT
    SUM(quantidade * preco_unitario_centavos) / 100.0
        AS faturamento_total_reais
FROM itens_pedido;

-- 4. Ordenar produtos por quantidade vendida
SELECT
    produtos.nome AS produto,
    SUM(itens_pedido.quantidade) AS unidades_vendidas
FROM itens_pedido
JOIN produtos ON itens_pedido.produto_id = produtos.id
GROUP BY produtos.id, produtos.nome
ORDER BY unidades_vendidas DESC, produtos.nome ASC;

-- 5. Consultar quanto cada cliente gastou
SELECT * FROM resumo_clientes
ORDER BY total_gasto_reais DESC;
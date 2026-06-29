-- =====================================================================
-- Apostila Banco de Dados com PostgreSQL - Parte 1
-- Script 03: Indices nas chaves estrangeiras mais consultadas
-- (PKs e UNIQUE ja sao indexadas automaticamente; FKs nao!)
-- Prof. Dr. Anuar Jose Mincache | github.com/220719
-- =====================================================================

CREATE INDEX idx_endereco_cliente    ON endereco(cliente_id);
CREATE INDEX idx_produto_categoria   ON produto(categoria_id);
CREATE INDEX idx_produto_fornecedor  ON produto(fornecedor_id);
CREATE INDEX idx_pedido_cliente      ON pedido(cliente_id);
CREATE INDEX idx_pedido_status       ON pedido(status);
CREATE INDEX idx_item_produto        ON item_pedido(produto_id);
CREATE INDEX idx_pagamento_pedido    ON pagamento(pedido_id);
CREATE INDEX idx_avaliacao_produto   ON avaliacao(produto_id);
CREATE INDEX idx_avaliacao_cliente   ON avaliacao(cliente_id);

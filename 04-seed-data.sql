-- =====================================================================
-- Apostila Banco de Dados com PostgreSQL - Parte 1
-- Script 04: Carga de dados de exemplo (seed)
-- Execute apos os scripts 02 e 03, conectado ao banco 'ecommerce'.
-- Prof. Dr. Anuar Jose Mincache | github.com/220719
-- =====================================================================

-- Clientes
INSERT INTO cliente (nome, email, cpf, telefone) VALUES
  ('Ana Souza',      'ana.souza@email.com',   '11122233344', '44999990001'),
  ('Bruno Lima',     'bruno.lima@email.com',  '22233344455', '44999990002'),
  ('Carla Mendes',   'carla.mendes@email.com','33344455566', '44999990003');

-- Enderecos (1:N com cliente)
INSERT INTO endereco (cliente_id, logradouro, numero, bairro, cidade, uf, cep, principal) VALUES
  (1, 'Av. Colombo',     '5790', 'Zona 07',   'Maringa',  'PR', '87020900', TRUE),
  (1, 'Rua Joubert de Carvalho', '210', 'Centro', 'Maringa', 'PR', '87013000', FALSE),
  (2, 'Av. Brasil',      '1200', 'Centro',    'Londrina', 'PR', '86010000', TRUE),
  (3, 'Rua das Flores',  '88',   'Jardim',    'Maringa',  'PR', '87050000', TRUE);

-- Categorias (auto-relacionamento: hierarquia)
INSERT INTO categoria (nome, categoria_pai_id) VALUES
  ('Eletronicos', NULL),     -- id 1 (raiz)
  ('Informatica', 1),        -- id 2 -> filha de Eletronicos
  ('Perifericos', 2),        -- id 3 -> filha de Informatica
  ('Livros', NULL);          -- id 4 (raiz)

-- Fornecedores
INSERT INTO fornecedor (razao_social, cnpj, email) VALUES
  ('TechParts Distribuidora LTDA', '01234567000189', 'vendas@techparts.com'),
  ('Livraria Saber LTDA',          '98765432000110', 'contato@saber.com');

-- Produtos
INSERT INTO produto (nome, descricao, preco, categoria_id, fornecedor_id) VALUES
  ('Mouse Optico USB',     'Mouse com 1200 DPI',           50.00,  3, 1),
  ('Teclado ABNT2',        'Teclado com layout brasileiro',120.00, 3, 1),
  ('Monitor 24 polegadas', 'Full HD 1920x1080',            900.00, 2, 1),
  ('Notebook 15"',         'Intel i5, 8GB RAM, 256GB SSD', 3200.00,2, 1),
  ('Banco de Dados - Curso','Apostila completa de SQL',     0.00,  4, 2);

-- Estoque (1:1 com produto)
INSERT INTO estoque (produto_id, quantidade, quantidade_minima, localizacao) VALUES
  (1, 150, 20, 'A1'),
  (2,  80, 15, 'A2'),
  (3,  25,  5, 'B1'),
  (4,  10,  3, 'B2'),
  (5, 999,  0, 'DIGITAL');

-- Cupom
INSERT INTO cupom (codigo, tipo_desconto, valor, validade) VALUES
  ('BEMVINDO10', 'percentual', 10.00, '2026-12-31'),
  ('FRETE20',    'fixo',       20.00, '2026-12-31');

-- Pedidos
INSERT INTO pedido (cliente_id, endereco_entrega_id, cupom_id, status, valor_total) VALUES
  (1, 1, 1,    'pago',     153.00),   -- Ana, com cupom BEMVINDO10
  (2, 3, NULL, 'enviado',  900.00),   -- Bruno, sem cupom
  (1, 1, NULL, 'pendente', 3200.00);  -- Ana, notebook

-- Itens dos pedidos (associativa N:M; preco_unitario = preco no momento - RN5)
INSERT INTO item_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
  (1, 1, 1, 50.00),     -- pedido 1: 1 mouse
  (1, 2, 1, 120.00),    -- pedido 1: 1 teclado
  (2, 3, 1, 900.00),    -- pedido 2: 1 monitor
  (3, 4, 1, 3200.00);   -- pedido 3: 1 notebook

-- Pagamentos
INSERT INTO pagamento (pedido_id, metodo, valor, status) VALUES
  (1, 'pix',            153.00, 'aprovado'),
  (2, 'cartao_credito', 900.00, 'aprovado');

-- Avaliacoes (N:M cliente x produto)
INSERT INTO avaliacao (cliente_id, produto_id, nota, comentario) VALUES
  (1, 1, 5, 'Mouse otimo, chegou rapido.'),
  (1, 2, 4, 'Teclado bom, mas um pouco barulhento.'),
  (2, 3, 5, 'Monitor excelente pelo preco.');

-- Conferencia rapida:
--   SELECT c.nome, p.id AS pedido, p.status, p.valor_total
--   FROM cliente c JOIN pedido p ON p.cliente_id = c.id;

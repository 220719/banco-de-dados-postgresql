# 🗄️ Banco de Dados Relacional com PostgreSQL

Apostila didática completa de Banco de Dados Relacional com PostgreSQL, construída a partir de um **estudo de caso de e-commerce** que cobre todos os tipos de relacionamento (1:1, 1:N, N:M, auto-relacionamento) e os conceitos fundamentais da área.

> **Prof. Dr. Anuar José Mincache** · Universidade Estadual de Maringá (UEM)  
> [github.com/220719](https://github.com/220719) · ORCID: 0000-0001-8528-8020

---

## 📚 Partes da apostila

| Parte | Conteúdo | Status |
|-------|----------|--------|
| **Parte 1** | Fundamentos, Modelagem (MER), Normalização (1FN→3FN), DDL completo | ✅ Disponível |
| Parte 2 | DML (INSERT/UPDATE/DELETE), Transações ACID, SELECT básico | 🔜 Em breve |
| Parte 3 | JOINs, Agregações, Subqueries, CTEs | 🔜 Em breve |
| Parte 4 | Window Functions, Functions, Triggers, JSON | 🔜 Em breve |
| Parte 5 | Performance, Índices, Boas práticas | 🔜 Em breve |

---

## 🗂️ Estrutura do repositório

---

## ⚡ Início rápido

### Pré-requisitos
- [PostgreSQL 16+](https://www.postgresql.org/download/)
- [pgAdmin 4](https://www.pgadmin.org/) ou `psql`

### Executar os scripts em ordem
```bash
psql -U postgres -f sql/01-create-database.sql
psql -U postgres -d ecommerce -f sql/02-create-tables.sql
psql -U postgres -d ecommerce -f sql/03-constraints-indexes.sql
psql -U postgres -d ecommerce -f sql/04-seed-data.sql
```

Ou abra cada `.sql` no **Query Tool do pgAdmin** e pressione **F5**.

---

## 🏗️ O banco: sistema de e-commerce

12 tabelas cobrindo todos os tipos de relacionamento:

| Tabela | Papel | Relacionamento |
|--------|-------|----------------|
| `cliente` | Quem compra | — |
| `endereco` | Endereços de entrega | 1:N com cliente |
| `categoria` | Hierarquia de produtos | Auto-relacionamento |
| `fornecedor` | Quem fornece | — |
| `produto` | Itens à venda | 1:N com categoria e fornecedor |
| `estoque` | Quantidade em estoque | **1:1** com produto |
| `cupom` | Descontos aplicáveis | — |
| `pedido` | Compras realizadas | 1:N com cliente |
| `item_pedido` | Itens de um pedido | **N:M** pedido × produto |
| `pagamento` | Pagamentos | 1:N com pedido |
| `avaliacao` | Notas e comentários | **N:M** com atributos |

### Diagrama ER

![Diagrama ER](docs/erd.png)

---

## 📋 Regras de negócio implementadas

- **RN1** `UNIQUE` — e-mail de cliente é único
- **RN2** `NOT NULL FK` — produto tem exatamente uma categoria e um fornecedor
- **RN3** `CHECK (preco >= 0)` — preço nunca negativo
- **RN4** `CHECK (nota BETWEEN 1 AND 5)` — avaliação de 1 a 5
- **RN5** `preco_unitario` em `item_pedido` — preço congelado no momento da compra
- **RN6** `CHECK (status IN (...))` — status de pedido só aceita valores válidos
- **RN7** `ON DELETE CASCADE` — itens são apagados junto com o pedido

---

## 📄 Licença

Material didático de uso livre para fins educacionais.  
Cite como: *Mincache, A. J. (2025). Banco de Dados Relacional com PostgreSQL.

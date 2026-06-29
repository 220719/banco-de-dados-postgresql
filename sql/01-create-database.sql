-- =====================================================================
-- Apostila Banco de Dados com PostgreSQL - Parte 1
-- Script 01: Criacao do banco de dados
-- Prof. Dr. Anuar Jose Mincache | github.com/220719
-- =====================================================================

-- Execute este bloco conectado ao banco 'postgres' (padrao).
CREATE DATABASE ecommerce
    WITH ENCODING = 'UTF8'
         LC_COLLATE = 'pt_BR.UTF-8'
         LC_CTYPE   = 'pt_BR.UTF-8'
         TEMPLATE   = template0;

-- Em seguida, conecte-se ao banco recem-criado (comando do psql):
--   \c ecommerce
-- e rode os proximos scripts (02, 03, 04) ja dentro dele.

-- 1. Criação da Tabela física
DROP TABLE IF EXISTS tb_passagens_emitidas_gold;
CREATE TABLE tb_passagens_emitidas_gold AS
SELECT 
    v.nome_orgao_superior,
    COUNT(p.id_passagem)               AS total_passagens_emitidas,
    ROUND(AVG(p.valor_passagem), 2)    AS valor_medio_passagem,
    ROUND(SUM(p.valor_passagem), 2)    AS valor_total_passagens
FROM silver_passagem p
INNER JOIN silver_viagem v ON p.id_viagem = v.id_viagem
GROUP BY v.nome_orgao_superior;

-- 2. Criação da View
CREATE OR REPLACE VIEW vw_passagens_emitidas_gold AS
SELECT 
    nome_orgao_superior,
    total_passagens_emitidas,
    valor_medio_passagem,
    valor_total_passagens
FROM tb_passagens_emitidas_gold;
-- 1. Qual a média de valor total (total\_amount) recebido em um mês considerando todos os yellow táxis da frota?
SELECT
  month_reference,
  ROUND(AVG(avg_vl_amount), 2) AS media_valor_total
FROM `potent-poetry-295317.nyc_tlc_gold.tbl_yellow_gold`
GROUP BY month_reference
ORDER BY month_reference;

-- 2. Qual a média de passageiros (passenger\_count) por cada hora do dia que pegaram táxi no mês de maio considerando todos os táxis da frota?
SELECT
  hour_trip,
  type_service,
  ROUND(AVG(avg_count_passenger), 2) AS media_passageiros_por_hora
FROM `potent-poetry-295317.nyc_tlc_gold.tbl_passenger_hour_gold`
WHERE date_reference BETWEEN '2023-05-01' AND '2023-05-31'
GROUP BY hour_trip, type_service
ORDER BY type_service, hour_trip;
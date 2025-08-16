# Desafio Técnico – iFood (Data Engineering)

## Visão Geral
Este repositório apresenta a solução completa para o desafio técnico de engenharia de dados proposto pelo iFood. O objetivo foi construir um pipeline de ingestão, tratamento e disponibilização de dados dos táxis de Nova York, com análises agregadas em camadas estruturadas (Raw, Bronze, Silver e Gold).

---

## Arquitetura em Camadas

### 1. Raw (Data Lake)
- Armazenamento dos arquivos `.parquet` originais.
- Estrutura: `gs://teste_ifood_nyc/nyc_tlc_raw/{ano}/{mes}/{tipo}_tripdata_*.parquet`
- Dados sem transformação.

### 2. Bronze (BigQuery)
- Leitura dos arquivos `.parquet` da Raw via PySpark.
- Escrita no BigQuery como tabela particionada por data de coleta e clusterizada por tipo de corrida.
- Separação por tipo: `tbl_yellow_bronze`, `tbl_green_bronze`, `tbl_fhv_bronze`, `tbl_fhvhv_bronze`

### 3. Silver (BigQuery)
- Tratamento de dados: tipos corrigidos, dados inválidos filtrados (como passageiros zerados ou datas inconsistentes).
- Inclusão do campo `nm_vendor` mapeando os códigos de empresa de táxi.
- Tabelas: `tbl_yellow_silver`, `tbl_green_silver`, `tbl_fhv_silver`, `tbl_fhvhv_silver`

### 4. Gold (BigQuery)
- Agregações para análises mensais e por hora do dia.
- Tabelas:
  - `tbl_yellow_gold`, `tbl_green_gold`, `tbl_fhv_gold`, `tbl_fhvhv_gold`
  - `tbl_passenger_hour_gold`: média de passageiros por hora em maio.

## Ferramentas Utilizadas
- Google Cloud Platform (GCP):
  - Cloud Storage (GCS)
  - BigQuery
- PySpark (Dataproc Serverless)
- SQL (BigQuery Standard SQL)

---

## Organização do Repositório
```
ifood-case/
├── src/                    # Código PySpark e SQL
│   └── app.ipynb      # Notebook com toda a implementação
├── analysis/               # Consultas SQL de análise
├── README.md               
└── requirements.txt        
```

---

## Instruções de Execução
1. Suba os dados originais para o GCS (`nyc_tlc_raw`).
2. Execute o notebook `app.ipynb` em ambiente com suporte a PySpark (Dataproc ou Colab com conector).
3. As tabelas serão criadas automaticamente no BigQuery nas camadas Bronze → Silver → Gold.

---

## Observações
- Dados com `count_passenger = 0` foram mantidos, mas identificados como possíveis inconsistências.
- Foram filtrados registros fora do intervalo `2023-01-01` a `2025-05-31`.
- As tabelas incluem documentação de colunas (descrições) para facilitar manutenção e entendimento.
- O enunciado recomendava o uso do Databricks Community Edition, porém a versão gratuita não permite leitura direta de arquivos do Google Cloud Storage (GCS) de forma simples. Por esse motivo, foi utilizada a solução com **Dataproc Serverless** no GCP, que oferece integração nativa com GCS e BigQuery, além de permitir o uso completo do PySpark sem limitações técnicas.
- Essa abordagem também facilita a disponibilização das tabelas diretamente aos usuários finais no BigQuery, conforme solicitado no desafio.

---

## Visualização dos Resultados

- Para facilitar a análise dos dados processados, foi construído um dashboard no Looker Studio, que exibe as principais métricas e tendências com base na camada Gold:

## Dashboard Interativo – Looker Studio:
[https://lookerstudio.google.com/u/0/reporting/6a3caf29-9157-4ada-b4ad-c1d1ab2738f0/page/tEnnC]
-------------------------------------------------------------------
--                  Author: Nabilla Inka Safitri                 --
--              PBI: Kimia Farma Big Data Analytics              --
--                        Date: 25/06/2025                       --
--                      Tool Used: BigQuery                      --
-------------------------------------------------------------------


-------------------------------------------------------------------
--  Create a new table table_analysis in the kimia_farma dataset --
-------------------------------------------------------------------
--  The alias used for kf_final_transaction is kfft
--  The alias used for kf_inventory is kfi
--  The alias used for kf_kantor_cabang is kfkc
--  The alias used for kf_product is kfp


-- Create a new table table_analysis in the kimia_farma dataset
CREATE TABLE `rakamin-kf-analytics-463915.kimia_farma.table_analysis` AS
SELECT
  kfft.transaction_id,
  kfft.date,
  kfkc.branch_id,
  kfkc.branch_name,
  kfkc.kota,
  kfkc.provinsi,
  kfkc.rating AS rating_cabang,
  kfft.customer_name,
  kfp.product_id,
  kfp.product_name,
  kfp.price AS actual_price,
  kfft.discount_percentage,

  -- Create Persentase Gross Laba
  CASE
    WHEN kfp.price <= 50000 THEN 0.10
    WHEN kfp.price <= 100000 THEN 0.15
    WHEN kfp.price <= 300000 THEN 0.20
    WHEN kfp.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Create Nett Sales = Harga setelah diskon
  kfp.price * (1 - (kfft.discount_percentage/100)) AS nett_sales,

  -- Create Nett Profit = Nett Sales * Persentase Laba
  
    (kfp.price * (1 - (kfft.discount_percentage/100))) *
    CASE
      WHEN kfp.price <= 50000 THEN 0.10
      WHEN kfp.price <= 100000 THEN 0.15
      WHEN kfp.price <= 300000 THEN 0.20
      WHEN kfp.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS nett_profit,

  kfft.rating AS rating_transaksi,
 

FROM
  `rakamin-kf-analytics-463915.kimia_farma.kf_final_transaction` kfft
JOIN
  `rakamin-kf-analytics-463915.kimia_farma.kf_product` kfp
  ON kfft.product_id = kfp.product_id
JOIN
  `rakamin-kf-analytics-463915.kimia_farma.kf_kantor_cabang` kfkc
  ON kfft.branch_id = kfkc.branch_id;

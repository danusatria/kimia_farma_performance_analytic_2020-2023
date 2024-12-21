WITH PersentaseGrossLaba AS (
  SELECT DISTINCT
    product_id,
    CASE 
      WHEN price <= 50000 THEN 0.1
      WHEN price > 50000 AND price <= 100000 THEN 0.15
      WHEN price > 100000 AND price <= 300000 THEN 0.20
      WHEN price > 300000 AND price <= 500000 THEN 0.25
      WHEN price > 500000 THEN 0.3
    END AS persentase_gross_laba
  FROM kimia_farma.kf_final_transaction
)

SELECT DISTINCT 
  FT.transaction_id,
  FT.date,
  KC.branch_id,
  KC.branch_name,
  KC.kota,
  KC.provinsi,
  KC.rating,
  FT.customer_name,
  FT.product_id,
  PD.product_name,
  PD.price as actual_price,
  FT.discount_percentage,
  PGL.persentase_gross_laba,
  (FT.price - FT.price * FT.discount_percentage) AS nett_sales,
  (FT.price - FT.price * FT.discount_percentage) * PGL.persentase_gross_laba AS nett_profit,
  FT.rating as rating_transaksi
FROM 
  kimia_farma.kf_final_transaction as FT
LEFT JOIN
  kimia_farma.kf_kantor_cabang as KC
  ON FT.branch_id = KC.branch_id
LEFT JOIN
  kimia_farma.kf_product as PD
  ON FT.product_id = PD.product_id
LEFT JOIN
  PersentaseGrossLaba as PGL
  ON PGL.product_id = FT.product_id


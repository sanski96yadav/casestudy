DAX:

```Customer Acquisition Cost (CAC) = DIVIDE([Ad Spend], [New Customers])```
```New Customers = SUM(fact_marketing_efficiency_daily[count_new_customers])```
```Acquisition Marketing Efficiency Ratio (aMER) = DIVIDE([New Customer Revenue],[Ad Spend])```
```Net Revenue = SUM(fact_marketing_efficiency_daily[net_revenue])```
```Marketing Efficiency Ratio (MER) = DIVIDE([Net Revenue],[Ad Spend])```
```New Customer Revenue = SUM(fact_marketing_efficiency_daily[net_revenue_new])```

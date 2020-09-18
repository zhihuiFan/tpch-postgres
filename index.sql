 create index idx_supplier_s_nationkey on public.supplier(s_nationkey);/* size: 264 KB, benefit: 1248.92, gain: 4.73075912937973 */
 create index idx_supplier_s_suppkey on public.supplier(s_suppkey);/* size: 264 KB, benefit: 490.174, gain: 1.85671939271869 */
 create index idx_part_p_partkey_p_size on public.part(p_partkey, p_size);/* size: 6112 KB, benefit: 6920.49, gain: 1.13227988038388 */
 create index idx_lineitem_l_shipdate on public.lineitem(l_shipdate);/* size: 183232 KB, benefit: 159049, gain: 0.86801798744215 */
 create index idx_customer_c_nationkey on public.customer(c_nationkey);/* size: 3928 KB, benefit: 1777.53, gain: 0.452526799530216 */
 create index idx_orders_o_orderdate on public.orders(o_orderdate);/* size: 45800 KB, benefit: 15046.4, gain: 0.32852475095524 */
 create index idx_lineitem_l_partkey_l_suppkey_l_shipdate on public.lineitem(l_partkey, l_suppkey, l_shipdate);/* size: 235576 KB, benefit: 62157.6, gain: 0.263853743059565 */
 create index idx_supplier_s_name on public.supplier(s_name);/* size: 504 KB, benefit: 132.982, gain: 0.26385373917837 */
 create index idx_part_p_size on public.part(p_size);/* size: 5240 KB, benefit: 1121.34, gain: 0.213995431215708 */
 create index idx_lineitem_l_shipdate_l_discount on public.lineitem(l_shipdate, l_discount);/* size: 209408 KB, benefit: 23672.8, gain: 0.113046277706081 */
 create index idx_lineitem_l_receiptdate on public.lineitem(l_receiptdate);/* size: 183232 KB, benefit: 20082.7, gain: 0.109602458819284 */
 create index idx_part_p_type on public.part(p_type);/* size: 8944 KB, benefit: 81.8424, gain: 0.00915053492155399 */
 create index idx_orders_o_custkey_o_orderdate on public.orders(o_custkey, o_orderdate);/* size: 58888 KB, benefit: 538.857, gain: 0.00915053473463397 */
 create index idx_customer_c_acctbal on public.customer(c_acctbal);/* size: 4256 KB, benefit: 5.8925, gain: 0.0013845159595174 */
analyze;
vacuum;

# SECTION A: Limitations of RDBMS

Relational databases like MySQL store data in fixed table structures with predefined schemas. This becomes a limitation when dealing with highly diverse product data. For example, laptops may have attributes like RAM, processor, and storage, while shoes may have size, color, and material. In a relational model, supporting these variations requires either many nullable columns or multiple additional tables, which increases complexity and reduces readability.

Frequent schema changes are also problematic in relational systems. Adding new product attributes requires altering table structures, which can be costly and disruptive in production environments. Additionally, relational databases do not naturally support nested data. Storing customer reviews for products would require a separate reviews table and joins, making queries more complex and slower.

As the product catalog grows and becomes more dynamic, these constraints make relational databases less flexible and harder to maintain for such use cases.

--- 

# Section B: NoSQL Benefits

MongoDB is well-suited for handling diverse and evolving product data because it uses a flexible, document-based schema. Each product can store only the fields relevant to it. For example, a laptop document can contain RAM and processor, while a shoe document can contain size and color without requiring schema changes.

MongoDB also supports embedded documents, allowing related data like customer reviews to be stored directly inside the product document. This makes data retrieval simpler and faster since no joins are required.

Additionally, MongoDB is horizontally scalable, meaning it can distribute data across multiple servers easily. This allows the system to handle large volumes of product data and high traffic efficiently. These features make MongoDB more suitable for dynamic, large-scale product catalogs compared to traditional relational databases.

---

# Section C: Trade-offs

While MongoDB offers flexibility and scalability, it has some disadvantages compared to relational databases. First, MongoDB does not enforce strong relational integrity such as foreign key constraints, which increases the risk of inconsistent data if not handled carefully at the application level.

Second, MongoDB is not ideal for complex transactional systems that require strict ACID compliance across multiple collections. Although MongoDB supports transactions, relational databases like MySQL are more mature and reliable for financial and transactional workloads.

Therefore, MongoDB is best used for flexible and analytical workloads rather than strict transactional systems.




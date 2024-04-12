CREATE(Collection_A:COLLECTIONS{name:'Collection_A',launchyear:2020})
CREATE(Collection_B:COLLECTIONS{name:'Collection_B',launchyear:2021})
CREATE(Collection_C:COLLECTIONS{name:'Collection_C',launchyear:2022})
CREATE(Collection_D:COLLECTIONS{name:'Collection_D',launchyear:2023})
CREATE(Collection_E:COLLECTIONS{name:'Collection_E',launchyear:2024})

CREATE(Product_A:PRODUCTS{name:'Product_A',size:'S',price:17})
CREATE(Product_B:PRODUCTS{name:'Product_B',size:'M',price:11})
CREATE(Product_C:PRODUCTS{name:'Product_C',size:'L',price:12})
CREATE(Product_D:PRODUCTS{name:'Product_D',size:'XL',price:16})
CREATE(Product_E:PRODUCTS{name:'Product_E',size:'S',price:18})
CREATE(Product_F:PRODUCTS{name:'Product_F',size:'M',price:19})
CREATE(Product_G:PRODUCTS{name:'Product_G',size:'L',price:20})

CREATE(Artisan_A:ARTISAN{name:'Artisan_A',gender:'M'})
CREATE(Artisan_B:ARTISAN{name:'Artisan_B',gender:'M'})
CREATE(Artisan_C:ARTISAN{name:'Artisan_C',gender:'F'})
CREATE(Artisan_D:ARTISAN{name:'Artisan_D',gender:'F'})
CREATE(Artisan_E:ARTISAN{name:'Artisan_E',gender:'F'})

CREATE(Product_A)-[:IS_COLLECTION]->(Collection_A),
(Product_B)-[:IS_COLLECTION]->(Collection_B),
(Product_C)-[:IS_COLLECTION]->(Collection_C),
(Product_D)-[:IS_COLLECTION]->(Collection_D),
(Product_E)-[:IS_COLLECTION]->(Collection_E),
(Product_F)-[:IS_COLLECTION]->(Collection_E),
(Product_G)-[:IS_COLLECTION]->(Collection_E)


CREATE(Artisan_A)-[:DESIGNS]->(Product_A),
(Artisan_A)-[:DESIGNS]->(Product_F),
(Artisan_A)-[:DESIGNS]->(Product_G),
(Artisan_B)-[:DESIGNS]->(Product_B),
(Artisan_C)-[:DESIGNS]->(Product_C),
(Artisan_D)-[:DESIGNS]->(Product_D),
(Artisan_E)-[:DESIGNS]->(Product_E)

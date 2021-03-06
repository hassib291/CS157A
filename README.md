# CS157A
# SQL queries for the tasks
1. Task 1: (Registered user report information about the registered users)
           SELECT * FROM user;
           
2. Task 2: (Insert a new customer)
	   INSER INTO User(user_id,username,password,full_name,address,email,phone)
	   VALUES ((user_id),(username),(password),(full_name),(address),(email),(phone))
For example:
           INSER INTO User(user_id, username, password, full_name, address, email, phone)
           VALUES (‘107’,’Susan’,'mtm156@89',’Susan Cortez’,’564 Washington St, San Jose, CA 95113’,’susan@gmail.com’,4084718369);
  Note: We need to replace the information in single quotes with variables in paranthesis.

3. Task 3: (Display a list of the customers that don’t buy at all.)
	   SELECT * 
	   FROM User
	   WHERE NOT EXISTS ( SELECT * 
			      FROM Orders_Placed_User OP
                              WHERE User.user_id = OP.user_id)
                                        
                                        

4. Task 4: (Sales report: report the total of sales by the month and year )
        SELECT Sum(total_cost) as TotalCost
	FROM Orders
	WHERE order_date BETWEEN '2018-10-12' AND '2018-10-15';
	
5. Task 5:(Apply a sale on a category items like a percentage.)
	
	UPDATE products_belong_category as cat
	LEFT JOIN products_has_options PHO ON(cat.product_id = PHO.product_id)
	SET price = price * (fill with discount amount)
	WHERE category_id = (fill with category id);
	
For example

	UPDATE Products_Has_Options PHO
	JOIN Product P ON (PHO.product_id = P.product_id)
	JOIN Products_Belong_Category PBC ON (PBC.product_id = P.product_id)
	JOIN Category C ON (C.category_id = PBC.category_id)
	SET on_sale = 1, price = price * 0.2
	WHERE C.category_id = 4000



6. Task 6:
	SELECT P.product_id, OP.option_id, product_name
	FROM Orders_Has_Products OP 
		INNER JOIN Products_Has_Options PHO ON ( OP.product_id = PHO.product_id and OP.option_id = PHO.option_id) 
            	INNER JOIN Product P ON (OP.product_id = P.product_id) 
	WHERE PHO.on_sale = 1


                                
7. Task 7: (Display a report of products on sale.)
	SELECT P.product_id, product_name
	FROM  Product P
		Natural Join Products_Has_Options PHO 
	WHERE on_sale=1
	   
8. Task 8: (Common product in shopping cart: Report the common product in the shopping carts of Customers now for marketing purposes. )
          SELECT P.product_id, Op.option_id,product_name, option_name, Sum(CHP.quantity) as TotalQuantity
          FROM Product P
	       INNER JOIN Carts_Has_Products CHP ON P.product_id = CHP.product_id
               INNER JOIN Options Op ON CHP.option_id = Op.option_id
          GROUP BY P.product_id, Op.option_id
	  ORDER BY TotalQuantity DESC 
     	 LIMIT 5 
          
9. Task 9:(Insert a new product)
	INSERT INTO Product(product_id, name, description) 
		VALUES ((product_id), (name),(description));
	INSERT INTO Products_Has_Options(product_id,option_id,quantity,price,on_sale,specs) 
		VALUES((product_id),(option_id),(quantity),(price),(on_sale),(specs)) ;
	INSERT INTO Products_Sold_Vendor(vendor_id,product_id) 
		VALUES((vendor_id),(product_id)) ;
	INSERT INTO Products_Belong_Category(product_id,category_id)
		VALUES((product_id),(category_id))

For exmaple: 
        INSERT INTO Product(product_id, name, description) 
		VALUES ("1401", "Samsung","The iPhone X display so immersive the device itself disappears the experience.");
	INSERT INTO Products_Has_Options(product_id,option_id,quantity,price,on_sale,specs) 
		VALUES('1401','1201','20','899','0','Iphone XS Storage capacity 256 GB') ;
	INSERT INTO Products_Sold_Vendor(vendor_id,product_id) 
		VALUES('140','400') ;
	INSERT INTO Products_Belong_Category(product_id,category_id)
		VALUES('140','400')
	   

10. Task 10: (Functionality: Inventory report: get a report about the counts of items in the inventory.)

          SELECT P.product_id, Op.option_id,product_name, option_name, quantity
          FROM Product P, Products_Has_Options CHO, Options Op 
          WHERE P.product_id = CHO.product_id AND CHO.option_id = Op.option_id AND quantity <10
	  
11. Task 11:(Update information regarding a specific product)
	UPDATE Product
   	SET product_name = (product_name)
	WHERE product_id = (product_id)

For example: 
	UPDATE Product
   	SET product_name = 'Macbook Pro (2018)'
	WHERE product_id = 1200
	
	
12. Task 12: (Display the number of product is each category )
	SELECT category_name, Count(P.product_id) as ProductNumber
	FROM Category
		INNER JOIN Products_Belong_Category PBC ON (PBC.category_id = Category.category_id)
            	INNER JOIN Product P ON (PBC.product_id = P.product_id)
	GROUP BY category_name

	
	
13. Task 13:(Display best (top 5) performing products):
	SELECT P.product_id, product_name, SUM(quantity) AS TotalQuantity, total_cost
	FROM Orders OD
		INNER JOIN Orders_Has_Products OP ON (OD.order_id = OP.order_id)
            	INNER JOIN Product P ON (OP.product_id = P.product_id)
	GROUP BY product_id, OD.order_id
	ORDER BY SUM(quantity) DESC
	Limit 5;
	
	(Display worst (top 5) performing products):
	
	SELECT P.product_id, product_name, SUM(quantity) AS TotalQuantity, total_cost
	FROM Orders OD
		INNER JOIN Orders_Has_Products OP ON (OD.order_id = OP.order_id)
            	INNER JOIN Product P ON (OP.product_id = P.product_id)
	GROUP BY product_id, OD.order_id
	ORDER BY SUM(quantity) ASC
	Limit 5;

14. Task 14: (Inventory report: get a report about items out of stock with vendor information to reorder. )
           SELECT V.vendor_id, vendor_name, product_name, quantity
          FROM Vendor V
		INNER JOIN Products_Sold_Vendor PSV ON (PSV.vendor_id = V.vendor_id)
                INNER JOIN Product P ON (P.product_id = PSV.product_id)
                INNER JOIN Products_Has_Options PHO ON (P.product_id = PHO.product_id)
          WHERE quantity <0








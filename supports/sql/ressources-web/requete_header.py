
Next we will show how to print column headers with the data from the database table. 

import pymysql

con = pymysql.connect('localhost', 'user17', 
    's$cret', 'testdb')

with con:

    cur = con.cursor()
    cur.execute("SELECT * FROM cities")

    rows = cur.fetchall()

    desc = cur.description

    print("{0:>3} {1:>10}".format(desc[0][0], desc[1][0]))

    for row in rows:    
        print("{0:3} {1:>10}".format(row[0], row[2]))
        

When we write prepared statements, we use placeholders instead of directly writing the values into the statements. Prepared statements increase security and performance. 


import pymysql

con = pymysql.connect('localhost', 'user17', 
    's$cret', 'testdb')

# user input
myid = 4

with con:    

    cur = con.cursor()
        
    cur.execute("SELECT * FROM cities WHERE id=%s", myid) 
    
    cid, name, population  = cur.fetchone()
    print(cid, name, population)
    
    
    
    import pymysql.cursors

connection = pymysql.connect(host='localhost',
                             user='user',
                             password='passwd',
                             db='db',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

try:
    with connection.cursor() as cursor:
        sql = "INSERT INTO `users` (`email`, `password`) VALUES (%s, %s)"
        cursor.execute(sql, ('webmaster@python.org', 'very-secret'))

    # connection is not autocommit by default. So you must commit to save changes.
    connection.commit()

finally:
    connection.close()

        
# ACME Audits


# About
This application that consumes/accepts a CSV (Comma Separated Values) file of N-Rows and perform bulk import of all data into the data base.

Each Row is comprised of:
 - **object_id:** is a unique identifier for a specific object.
 - **object_type:** denotes the object type.
 - **timestamp:** needs no explanation
 - **object_changes:** serialized json comprised of properties that changed at **timestamp**, and their accompanying values.

Here's an example CSV:

```
object_id,object_type,timestamp,object_changes	
1,Order,1484730554,"{\"customer_name\":\"Jack\",\"customer_address\":\"Trade St.\",\"status\":\"unpaid\"}"
2,Order,1484730623,"{\"customer_name\":\"Sam\",\"customer_address\":\"Gecko St.\",\"status\":\"unpaid\"}"

```

After the application consumes the CSV, the user will be able to query the system for the states of objects
consumed at a specific point in time.


Examples:-
1. What's the state of Order Id=1 At timestamp=1484730554 ? <br>
`{:customer_name=>"Jack", :customer_address=>"Trade St.", :status=>"unpaid"}`

2. What's the state of Order Id=1 At timestamp=1484722542 ? <br>
`{} # Object Didn't Exist at that time`

3. What's the state of Order Id=2 At timestamp=1484730623 ? <br>
`{:customer_name=>"Sam", :customer_address=>"Gecko St.", :status=>"unpaid"}`

# Setup

`> bundle install`<br>
`> rake db:create`<br>
`> rake db:migrate`<br>

Start the server. Hit `localhost:3000`

# ch-rest-api
Deployed at `https://pure-crag-7012.herokuapp.com`

### The Company API support following:

#### Create a new company
```
curl -i -H "Content-Type: application/json" -X POST -d \
'{
  "name": "Apple",
  "address": "1 Infinite Loop",
  "city": "Cupertino, CA",
  "country": "US"
}' \
https://pure-crag-7012.herokuapp.com/company
```                       

#### Get a list of all companies
`curl -i https://pure-crag-7012.herokuapp.com/company`

#### Get details about a company
`curl -i https://pure-crag-7012.herokuapp.com/company/1`

#### Update a company
```
curl -i -H "Content-Type: application/json" -X PUT -d \
'{
  "name": "Apple",
  "address": "New address",
  "city": "Cupertino, CA",
  "country": "US"
}' \
https://pure-crag-7012.herokuapp.com/company/3
```

#### Attach pdf-versions of passport(s) of the directors and beneficial owner(s) of the company
```
curl -i -X POST -F \
"file=@/home/jack/somefile.pdf" https://pure-crag-7012.herokuapp.com/company/3/passport 
```


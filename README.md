# Graph Transfers

Web app with transfers of top european football leagues using graph database Neo4j.

Data are taken from: https://github.com/ewenme/transfers

App was initialy made for school project at Prague University of Economics and Business.

## Build Setup

```bash
# install dependencies
$ yarn install

# serve with hot reload at localhost:3000
$ yarn dev

# build for production and launch server
$ yarn build
$ yarn start

# generate static project
$ yarn generate
```

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

## How to develop

- Upload data to Neo4j database (manually to corresponding folder or using their desktop app)
  - data are stored in `database/transfers.csv`
  - you can use same data or make your own with same columns (attributes)
- Run init Cypher query to seed the database
  - init script is in `database/init.cql` file
- Edit connection config in `plugins/neo4jApi` if needed
  - @TODO for author: Add ENV variables...
- And then install dependencies and start
  - `yarn && yarn dev`

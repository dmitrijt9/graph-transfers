import { auth, driver } from 'neo4j-driver'
class Neo4jApi {
  session = null
  driver = null

  initDriver() {
    try {
      this.driver = driver(
        'neo4j://localhost',
        auth.basic('neo4j', 'password')
        // { disableLosslessIntegers: true }
      )

      return this.driver
    } catch (e) {
      console.error(e)
    }
  }

  async closeDriver() {
    if (this.session) {
      this.session.close()
      this.session = undefined
    }
    if (!this.driver) return
    await this.driver.close()
    this.driver = undefined
  }

  openSession() {
    const driver = this.driver ?? this.initDriver()
    try {
      this.session = driver.session({
        database: 'graph-transfers',
      })
      return this.session
    } catch (e) {
      console.error(e)
    }
  }

  async query(query, params) {
    const session = this.session ?? this.openSession()

    try {
      const { records } = await session.run(query, params)
      await this.closeDriver()
      return records
    } catch (e) {
      console.error(e)
    }
  }
}
export default (_, inject) => {
  // Inject $hello(msg) in Vue, context and store.
  inject('neo4j', new Neo4jApi())
}

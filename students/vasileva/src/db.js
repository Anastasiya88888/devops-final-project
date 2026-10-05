const { Pool } = require('pg');

const pool = new Pool({
    host: process.env.DB_HOST || 'db',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'tododb',
});

async function initDB() {
    let retries = 10;
    while (retries) {
        try {
            await pool.query(`
                CREATE TABLE IF NOT EXISTS todos (
                    id SERIAL PRIMARY KEY,
                    title VARCHAR(255) NOT NULL,
                    done BOOLEAN DEFAULT false,
                    created_at TIMESTAMP DEFAULT NOW()
                )
            `);
            console.log('Database ready, todos table exists.');
            return;
        } catch (err) {
            console.error('DB not ready, retrying...', err.message);
            retries -= 1;
            await new Promise(res => setTimeout(res, 3000));
        }
    }
    console.error('Could not connect to database after multiple retries.');
}

module.exports = { pool, initDB };

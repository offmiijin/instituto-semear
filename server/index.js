import 'dotenv/config'
import express from 'express'

const app = express()
const PORT = Number(process.env.PORT ?? 3001)

app.get('/api/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'instituto-semear-api',
    timestamp: new Date().toISOString(),
  })
})

app.listen(PORT, () => {
  console.log(`API disponível em http://localhost:${PORT}/api/health`)
})

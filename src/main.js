import './style.css'

document.querySelector('#app').innerHTML = `
  <main class="page">
    <header class="hero">
      <p class="eyebrow">Instituto Semear</p>
      <h1>Educação e apoio à comunidade</h1>
      <p class="lead">
        O Instituto Semear apoia crianças e adolescentes com reforço escolar,
        oficinas de cultura e acompanhamento das famílias.
      </p>
    </header>

    <section class="card">
      <h2>Saúde do sistema</h2>
      <p id="api-status" class="status" aria-live="polite">Status da API: verificando…</p>
      <p id="api-time" class="muted"></p>
    </section>
  </main>
`

const statusEl = document.querySelector('#api-status')
const timeEl = document.querySelector('#api-time')

async function checkApiHealth() {
  try {
    const response = await fetch('/api/health')
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`)
    }

    const data = await response.json()
    const receivedAt = new Date().toLocaleString('pt-BR')

    statusEl.textContent = `Status da API: ${data.status}`
    statusEl.classList.add('ok')
    timeEl.textContent = `Resposta recebida em ${receivedAt} (servidor: ${data.service})`
  } catch (error) {
    statusEl.textContent = 'Status da API: indisponível'
    statusEl.classList.add('error')
    timeEl.textContent = `Não foi possível consultar /api/health (${error.message}). A API está rodando com npm run api?`
  }
}

checkApiHealth()

const express = require('express')
const cors = require('cors')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const { PrismaClient } = require('@prisma/client')
require('dotenv').config()

const app = express()
const prisma = new PrismaClient()

app.use(cors())
app.use(express.json())

// Registro
app.post('/auth/registro', async (req, res) => {
  const { nombre, email, password, telefono, rol } = req.body

  if (!['musico', 'local'].includes(rol)) {
    return res.status(400).json({ error: 'El rol debe ser musico o local' })
  }

  try {
    const existe = await prisma.usuario.findUnique({ where: { email } })
    if (existe) return res.status(400).json({ error: 'El email ya está registrado' })

    const hash = await bcrypt.hash(password, 10)
    const usuario = await prisma.usuario.create({
      data: { nombre, email, password: hash, telefono, rol }
    })
    res.json({ mensaje: 'Usuario creado', id: usuario.id })
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// Login
app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body
  try {
    const usuario = await prisma.usuario.findUnique({ where: { email } })
    if (!usuario) return res.status(400).json({ error: 'Credenciales inválidas' })

    const valido = await bcrypt.compare(password, usuario.password)
    if (!valido) return res.status(400).json({ error: 'Credenciales inválidas' })

    const token = jwt.sign(
      { id: usuario.id, rol: usuario.rol },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    )
    res.json({ token, nombre: usuario.nombre, rol: usuario.rol })
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

app.listen(3000, () => console.log('Backend corriendo en http://localhost:3000'))
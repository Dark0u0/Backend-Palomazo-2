const express = require('express')
const cors = require('cors')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const crypto = require('crypto')
const nodemailer = require('nodemailer')
const Stripe = require('stripe')
const { PrismaClient } = require('@prisma/client')
require('dotenv').config()

const app = express()
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY)
const prisma = new PrismaClient()

app.use(cors({
  origin: 'https://frontend-palomazo.vercel.app'
}))
app.use(express.json())

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_APP_PASS
  }
})

// ─── MIDDLEWARE: VALIDAR SESIÓN ACTIVA ────────────────────────
const validarSesion = async (req, res, next) => {
  const authHeader = req.headers['authorization']
  if (!authHeader) return next()

  const token = authHeader.split(' ')[1]
  if (!token) return next()

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET)
    const usuario = await prisma.usuario.findUnique({
      where: { id: decoded.id },
      select: { sessionToken: true, activo: true }
    })

    if (!usuario || !usuario.activo) {
      return res.status(401).json({ error: 'Sesión inválida' })
    }

    if (usuario.sessionToken !== token) {
      return res.status(401).json({
        error: 'Tu sesión fue cerrada porque iniciaste sesión en otro dispositivo',
        codigo: 'SESION_DESPLAZADA'
      })
    }

    req.usuarioId = decoded.id
    next()
  } catch (e) {
    next()
  }
}

app.use(validarSesion)

// ─── OBTENER GÉNEROS ──────────────────────────────────────────
app.get('/generos', async (req, res) => {
  try {
    const generos = await prisma.genero.findMany({ orderBy: { nombre: 'asc' } })
    res.json(generos)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── REGISTRO ─────────────────────────────────────────────────
app.post('/auth/registro', async (req, res) => {
  const {
    nombre, email, password, telefono, rol,
    nombreArtistico, biografia, precioPorHora, localidad, generosIds,
    nombreNegocio, ubicacion, descripcion
  } = req.body

  try {
    const rolData = await prisma.rol.findUnique({ where: { nombre: rol } })
    if (!rolData) return res.status(400).json({ error: 'Rol inválido' })

    const existe = await prisma.usuario.findUnique({ where: { email } })
    if (existe) return res.status(400).json({ error: 'El email ya está registrado' })

    const hash = await bcrypt.hash(password, 10)

    if (rol === 'musico') {
      if (!nombreArtistico || !precioPorHora || !localidad) {
        return res.status(400).json({ error: 'Faltan campos del perfil de músico' })
      }
      const usuario = await prisma.usuario.create({
        data: {
          nombre, email, password: hash, telefono,
          rolId: rolData.id,
          musico: {
            create: {
              nombreArtistico,
              biografia: biografia || null,
              precioPorHora: parseFloat(precioPorHora),
              localidad,
              generos: {
                create: (generosIds || []).map(id => ({
                  genero: { connect: { id: parseInt(id) } }
                }))
              }
            }
          }
        }
      })
      return res.json({ mensaje: 'Músico registrado', id: usuario.id })
    }

    if (rol === 'local') {
      if (!nombreNegocio || !ubicacion) {
        return res.status(400).json({ error: 'Faltan campos del perfil de local' })
      }
      const usuario = await prisma.usuario.create({
        data: {
          nombre, email, password: hash, telefono,
          rolId: rolData.id,
          local: {
            create: { nombreNegocio, ubicacion, descripcion: descripcion || null }
          }
        }
      })
      return res.json({ mensaje: 'Local registrado', id: usuario.id })
    }

  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── LOGIN ────────────────────────────────────────────────────
app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body
  try {
    const usuario = await prisma.usuario.findUnique({
      where: { email },
      include: {
        rol: true,
        musico: { include: { generos: { include: { genero: true } } } },
        local: true
      }
    })
    if (!usuario) return res.status(400).json({ error: 'Credenciales inválidas' })

    const valido = await bcrypt.compare(password, usuario.password)
    if (!valido) return res.status(400).json({ error: 'Credenciales inválidas' })

    if (!usuario.activo) return res.status(400).json({ error: 'Usuario inactivo' })

    const token = jwt.sign(
      { id: usuario.id, rol: usuario.rol.nombre },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    )

    await prisma.usuario.update({
      where: { id: usuario.id },
      data: { sessionToken: token }
    })

    const perfil = usuario.musico
      ? {
          ...usuario.musico,
          generos: usuario.musico.generos.map(g => g.genero.nombre)
        }
      : usuario.local

    res.json({
      token,
      id: usuario.id,
      nombre: usuario.nombre,
      email: usuario.email,
      telefono: usuario.telefono,
      rol: usuario.rol.nombre,
      perfil
    })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── LOGOUT ───────────────────────────────────────────────────
app.post('/auth/logout', async (req, res) => {
  const { id } = req.body
  try {
    await prisma.usuario.update({
      where: { id: parseInt(id) },
      data: { sessionToken: null }
    })
    res.json({ mensaje: 'Sesión cerrada' })
  } catch (e) {
    res.status(500).json({ error: 'Error al cerrar sesión' })
  }
})

// ─── SOLICITAR RECUPERACIÓN DE CONTRASEÑA ─────────────────────
app.post('/auth/recuperar', async (req, res) => {
  const { email } = req.body
  try {
    const usuario = await prisma.usuario.findUnique({ where: { email } })

    if (!usuario) {
      return res.json({ mensaje: 'Si el email existe, recibirás un correo en breve' })
    }

    const token = crypto.randomBytes(32).toString('hex')
    const expira = new Date(Date.now() + 60 * 60 * 1000)

    await prisma.usuario.update({
      where: { email },
      data: { resetToken: token, resetTokenExpira: expira }
    })

    const linkReset = `https://frontend-palomazo.vercel.app/reset-password?token=${token}`

    await transporter.sendMail({
      from: `"Palomazo" <${process.env.GMAIL_USER}>`,
      to: email,
      subject: 'Recupera tu contraseña de Palomazo',
      html: `
        <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto; padding: 32px; background: #0F0F0F; color: #fff; border-radius: 12px;">
          <h2 style="color: #7C3AED;">🎵 Palomazo</h2>
          <p>Recibimos una solicitud para restablecer tu contraseña.</p>
          <p>Haz clic en el botón de abajo. El link expira en <strong>1 hora</strong>.</p>
          <a href="${linkReset}" style="display: inline-block; margin: 24px 0; padding: 14px 28px; background: #7C3AED; color: #fff; border-radius: 8px; text-decoration: none; font-weight: bold;">
            Restablecer contraseña
          </a>
          <p style="color: #666; font-size: 13px;">Si no solicitaste esto, ignora este correo.</p>
        </div>
      `
    })

    res.json({ mensaje: 'Si el email existe, recibirás un correo en breve' })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al procesar la solicitud' })
  }
})

// ─── RESTABLECER CONTRASEÑA ────────────────────────────────────
app.post('/auth/reset-password', async (req, res) => {
  const { token, password } = req.body
  try {
    const usuario = await prisma.usuario.findFirst({
      where: {
        resetToken: token,
        resetTokenExpira: { gt: new Date() }
      }
    })

    if (!usuario) {
      return res.status(400).json({ error: 'El link es inválido o ya expiró' })
    }

    const hash = await bcrypt.hash(password, 10)

    await prisma.usuario.update({
      where: { id: usuario.id },
      data: {
        password: hash,
        resetToken: null,
        resetTokenExpira: null,
        sessionToken: null
      }
    })

    res.json({ mensaje: 'Contraseña actualizada correctamente' })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al restablecer la contraseña' })
  }
})

const cloudinary = require('cloudinary').v2
const { CloudinaryStorage } = require('multer-storage-cloudinary')
const multer = require('multer')

cloudinary.config({
  cloud_name: 'dz3cc935x',
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
})

const storage = new CloudinaryStorage({
  cloudinary,
  params: { folder: 'palomazo', allowed_formats: ['jpg', 'jpeg', 'png', 'webp'] }
})
const upload = multer({ storage })

// ─── SUBIR FOTO ───────────────────────────────────────────────
app.post('/upload/foto', upload.single('foto'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No se recibió ningún archivo' })
    }
    res.json({ url: req.file.path })
  } catch (e) {
    console.error('Error en /upload/foto:', e)
    res.status(500).json({ error: e.message || 'Error al subir la foto' })
  }
})

// ─── OBTENER MÚSICOS ──────────────────────────────────────────
app.get('/musicos', async (req, res) => {
  try {
    const musicos = await prisma.musico.findMany({
      include: {
        usuario: { select: { nombre: true, activo: true } },
        generos: { include: { genero: true } },
        resenas: true
      },
      where: { usuario: { activo: true } }
    })
    const data = musicos.map(m => ({
      id: m.id,
      nombreArtistico: m.nombreArtistico,
      foto: m.foto,
      biografia: m.biografia,
      precioPorHora: m.precioPorHora,
      localidad: m.localidad,
      generos: m.generos.map(g => g.genero.nombre),
      calificacion: m.resenas.length
        ? (m.resenas.reduce((acc, r) => acc + r.calificacion, 0) / m.resenas.length).toFixed(1)
        : null,
      totalResenas: m.resenas.length
    }))
    res.json(data)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── OBTENER MÚSICO POR ID ────────────────────────────────────
app.get('/musicos/:id', async (req, res) => {
  try {
    const m = await prisma.musico.findUnique({
      where: { id: parseInt(req.params.id) },
      include: {
        usuario: { select: { nombre: true, email: true, telefono: true } },
        generos: { include: { genero: true } },
        resenas: {
          include: {
            local: { select: { nombreNegocio: true, foto: true } }
          },
          orderBy: { creadoEn: 'desc' }
        }
      }
    })
    if (!m) return res.status(404).json({ error: 'Músico no encontrado' })
    res.json({
      ...m,
      generos: m.generos.map(g => g.genero.nombre),
      calificacion: m.resenas.length
        ? (m.resenas.reduce((acc, r) => acc + r.calificacion, 0) / m.resenas.length).toFixed(1)
        : null
    })
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── OBTENER LOCAL POR ID ─────────────────────────────────────
app.get('/local/:id', async (req, res) => {
  try {
    const local = await prisma.local.findUnique({
      where: { id: parseInt(req.params.id) },
      include: { usuario: { select: { nombre: true, telefono: true } } }
    })
    if (!local) return res.status(404).json({ error: 'Local no encontrado' })
    res.json(local)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── CREAR SOLICITUD ──────────────────────────────────────────
app.post('/solicitudes', async (req, res) => {
  const { localId, musicoId, fecha, duracionHoras, horaInicio, horaFin, tipoEvento, precioPorHora } = req.body
  try {
    const montoMusico = parseFloat(precioPorHora) * parseInt(duracionHoras)
    const comisionApp = +(montoMusico * 0.10).toFixed(2)
    const montoTotal = +(montoMusico + comisionApp).toFixed(2)

    const solicitud = await prisma.solicitud.create({
      data: {
        localId: parseInt(localId),
        musicoId: parseInt(musicoId),
        fecha: new Date(fecha),
        duracionHoras: parseInt(duracionHoras),
        horaInicio,
        horaFin,
        tipoEvento: tipoEvento || null,
        notas: 'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.',
        montoMusico,
        comisionApp,
        montoTotal,
        estado: 'pendiente'
      }
    })

    const musico = await prisma.musico.findUnique({ where: { id: parseInt(musicoId) } })
    await prisma.notificacion.create({
      data: {
        usuarioId: musico.usuarioId,
        solicitudId: solicitud.id,
        tipo: 'nueva_solicitud',
        mensaje: 'Tienes una nueva solicitud de contratación'
      }
    })

    res.json(solicitud)
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al crear la solicitud' })
  }
})

// ─── SOLICITUDES DE UN LOCAL ──────────────────────────────────
app.get('/solicitudes/local/:localId', async (req, res) => {
  try {
    const solicitudes = await prisma.solicitud.findMany({
      where: { localId: parseInt(req.params.localId) },
      include: {
        musico: { select: { nombreArtistico: true, foto: true } },
        pago: true
      },
      orderBy: { creadoEn: 'desc' }
    })
    res.json(solicitudes)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── SOLICITUDES DE UN MÚSICO ─────────────────────────────────
app.get('/solicitudes/musico/:musicoId', async (req, res) => {
  try {
    const solicitudes = await prisma.solicitud.findMany({
      where: { musicoId: parseInt(req.params.musicoId) },
      include: {
        local: { select: { id: true, nombreNegocio: true, ubicacion: true, foto: true } },
        pago: true
      },
      orderBy: { creadoEn: 'desc' }
    })

    // Vista "segura" para el músico: solo su monto, sin comisionApp ni montoTotal
    const solicitudesParaMusico = solicitudes.map(s => ({
      id: s.id,
      fecha: s.fecha,
      duracionHoras: s.duracionHoras,
      horaInicio: s.horaInicio,
      horaFin: s.horaFin,
      tipoEvento: s.tipoEvento,
      notas: s.notas,
      estado: s.estado,
      local: s.local,
      monto: s.montoMusico, // <- lo que el músico realmente cobra, ej. 500
      pago: s.pago
        ? {
            id: s.pago.id,
            estado: s.pago.estado,
            fechaPago: s.pago.fechaPago,
            musicoLlego: s.pago.musicoLlego,
            resenado: s.pago.resenado,
            // el músico ve su propio total (anticipo + restante = montoMusico),
            // nunca pago.monto (que incluye la comisión del local)
            montoTotal: +(parseFloat(s.pago.montoLiberado) + parseFloat(s.pago.montoRetenido)).toFixed(2),
            montoLiberado: s.pago.montoLiberado,
            montoRetenido: s.pago.montoRetenido
          }
        : null
    }))

    res.json(solicitudesParaMusico)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── MÚSICO RESPONDE ──────────────────────────────────────────
app.put('/solicitudes/:id/responder', async (req, res) => {
  const { respuesta } = req.body
  try {
    const solicitud = await prisma.solicitud.update({
      where: { id: parseInt(req.params.id) },
      data: { estado: respuesta },
      include: { local: true }
    })
    await prisma.notificacion.create({
      data: {
        usuarioId: solicitud.local.usuarioId,
        solicitudId: solicitud.id,
        tipo: 'respuesta_solicitud',
        mensaje: respuesta === 'aceptada' ? 'El músico aceptó tu solicitud' : 'El músico rechazó tu solicitud'
      }
    })
    res.json(solicitud)
  } catch (e) {
    res.status(500).json({ error: 'Error al responder la solicitud' })
  }
})

// ─── CREAR PAYMENT INTENT (Stripe) ───────────────────────────
app.post('/stripe/crear-pago', async (req, res) => {
  const { solicitudId } = req.body
  try {
    const solicitud = await prisma.solicitud.findUnique({
      where: { id: parseInt(solicitudId) },
      include: {
        musico: { select: { nombreArtistico: true, stripeAccountId: true } }
      }
    })
    if (!solicitud) return res.status(404).json({ error: 'Solicitud no encontrada' })
    if (solicitud.estado !== 'aceptada') return res.status(400).json({ error: 'La solicitud no está aceptada' })

    const montoEnCentavos = Math.round(parseFloat(solicitud.montoTotal) * 100)

    // El cobro se queda completo en tu cuenta principal de Stripe.
    // Las transferencias al músico se hacen por separado, en confirmar-pago y en liberar.
    const paymentIntentData = {
      amount: montoEnCentavos,
      currency: 'mxn',
      metadata: {
        solicitudId: solicitudId.toString(),
        musico: solicitud.musico.nombreArtistico
      }
    }

    const paymentIntent = await stripe.paymentIntents.create(paymentIntentData)

    res.json({ clientSecret: paymentIntent.client_secret })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al crear el pago' })
  }
})
// ─── CONFIRMAR PAGO EXITOSO ───────────────────────────────────
app.post('/stripe/confirmar-pago', async (req, res) => {
  const { solicitudId, paymentIntentId } = req.body
  try {
    const solicitud = await prisma.solicitud.findUnique({
      where: { id: parseInt(solicitudId) },
      include: {
        musico: { select: { stripeAccountId: true } }
      }
    })
    if (!solicitud) return res.status(404).json({ error: 'Solicitud no encontrada' })

    const montoMusico = parseFloat(solicitud.montoMusico)
    const monto = parseFloat(solicitud.montoTotal)
    const anticipo = +(montoMusico * 0.35).toFixed(2)
    const restante = +(montoMusico - anticipo).toFixed(2)

    // Transferencia REAL del anticipo (35%) al músico, si tiene cuenta Connect activa
    if (solicitud.musico.stripeAccountId) {
      try {
        await stripe.transfers.create({
          amount: Math.round(anticipo * 100),
          currency: 'mxn',
          destination: solicitud.musico.stripeAccountId,
          source_transaction: paymentIntentId
        })
      } catch (stripeError) {
        console.error('Error al transferir el anticipo:', stripeError.message)
        // Puedes decidir si quieres detener el flujo aquí o continuar
      }
    }

    const pago = await prisma.pago.create({
      data: {
        solicitudId: parseInt(solicitudId),
        monto,
        montoRetenido: restante,
        montoLiberado: anticipo,
        estado: 'parcial',
        mpPagoId: paymentIntentId,
        fechaPago: new Date()
      }
    })

    await prisma.solicitud.update({
      where: { id: parseInt(solicitudId) },
      data: { estado: 'pagada' }
    })

    res.json(pago)
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al confirmar el pago' })
  }
})

// ─── CREAR CUENTA CONNECT (músico se registra en Stripe) ──────
app.post('/stripe/crear-cuenta-connect', async (req, res) => {
  const { musicoId, email } = req.body
  try {
    // Crear cuenta Express en Stripe
    const cuenta = await stripe.accounts.create({
      type: 'express',
      country: 'MX',
      email: email,
      capabilities: {
        transfers: { requested: true }
      }
    })

    // Guardar el stripeAccountId en la DB del músico
    await prisma.musico.update({
      where: { id: parseInt(musicoId) },
      data: { stripeAccountId: cuenta.id }
    })

    res.json({ accountId: cuenta.id })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al crear cuenta de Stripe' })
  }
})

// ─── GENERAR LINK DE ONBOARDING (músico llena sus datos) ──────
app.post('/stripe/link-onboarding', async (req, res) => {
  const { musicoId } = req.body
  try {
    const musico = await prisma.musico.findUnique({
      where: { id: parseInt(musicoId) }
    })

    if (!musico?.stripeAccountId) {
      return res.status(400).json({ error: 'El músico no tiene cuenta de Stripe' })
    }

    const link = await stripe.accountLinks.create({
      account: musico.stripeAccountId,
      refresh_url: `https://frontend-palomazo.vercel.app/dashboard/musico`,
      return_url: `https://frontend-palomazo.vercel.app/dashboard/musico?stripe=ok`,
      type: 'account_onboarding'
    })

    res.json({ url: link.url })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al generar link de onboarding' })
  }
})

// ─── VERIFICAR SI MÚSICO TIENE CUENTA ACTIVA ──────────────────
app.get('/stripe/estado-cuenta/:musicoId', async (req, res) => {
  try {
    const musico = await prisma.musico.findUnique({
      where: { id: parseInt(req.params.musicoId) }
    })

    if (!musico?.stripeAccountId) {
      return res.json({ conectado: false })
    }

    const cuenta = await stripe.accounts.retrieve(musico.stripeAccountId)
    res.json({
      conectado: cuenta.charges_enabled && cuenta.payouts_enabled,
      accountId: musico.stripeAccountId
    })
  } catch (e) {
    res.json({ conectado: false })
  }
})

// ─── TRANSFERIR AL MÚSICO AL LIBERAR PAGO ─────────────────────
app.put('/pagos/:id/liberar', async (req, res) => {
  try {
    const pagoActual = await prisma.pago.findUnique({
      where: { id: parseInt(req.params.id) },
      include: {
        solicitud: {
          include: {
            musico: true
          }
        }
      }
    })

    if (!pagoActual) return res.status(404).json({ error: 'Pago no encontrado' })

    const musico = pagoActual.solicitud.musico
    const restante = parseFloat(pagoActual.montoRetenido) // el 65% pendiente, no el total

    // Transferencia REAL del restante (65%) al músico
    if (musico.stripeAccountId && pagoActual.mpPagoId && restante > 0) {
      try {
        await stripe.transfers.create({
          amount: Math.round(restante * 100),
          currency: 'mxn',
          destination: musico.stripeAccountId,
          source_transaction: pagoActual.mpPagoId
        })
      } catch (stripeError) {
        console.error('Error en transferencia Stripe:', stripeError.message)
        // No fallamos el liberar aunque falle la transferencia, pero lo dejamos loggeado
      }
    }

    const pago = await prisma.pago.update({
      where: { id: parseInt(req.params.id) },
      data: {
        estado: 'liberado',
        montoLiberado: pagoActual.monto,
        montoRetenido: 0,
        musicoLlego: true
      }
    })

    res.json(pago)
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al liberar el pago' })
  }
})

// ─── PAGOS DE UN LOCAL ────────────────────────────────────────
app.get('/pagos/local/:localId', async (req, res) => {
  try {
    const pagos = await prisma.pago.findMany({
      where: { solicitud: { localId: parseInt(req.params.localId) } },
      include: {
        solicitud: {
          include: {
            musico: { select: { nombreArtistico: true, foto: true } }
          }
        }
      },
      orderBy: { creadoEn: 'desc' }
    })
    res.json(pagos)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── CANCELAR PAGO ────────────────────────────────────────────
app.put('/pagos/:id/cancelar', async (req, res) => {
  try {
    const pago = await prisma.pago.update({
      where: { id: parseInt(req.params.id) },
      data: { estado: 'cancelado' }
    })
    res.json(pago)
  } catch (e) {
    res.status(500).json({ error: 'Error al cancelar el pago' })
  }
})

// ─── CREAR RESEÑA ─────────────────────────────────────────────
app.post('/resenas', async (req, res) => {
  const { localId, musicoId, calificacion, comentario, pagoId } = req.body
  try {
    if (comentario && comentario.length > 500) {
      return res.status(400).json({ error: 'El comentario no puede superar 500 caracteres' })
    }
    const resena = await prisma.resena.create({
      data: {
        localId: parseInt(localId),
        musicoId: parseInt(musicoId),
        calificacion: parseInt(calificacion),
        comentario: comentario || null
      }
    })
    if (pagoId) {
      await prisma.pago.update({
        where: { id: parseInt(pagoId) },
        data: { resenado: true }
      })
    }
    res.json(resena)
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al crear la reseña' })
  }
})

// ─── DESCARTAR RESEÑA ─────────────────────────────────────────
app.put('/pagos/:id/skip-resena', async (req, res) => {
  try {
    const pago = await prisma.pago.update({
      where: { id: parseInt(req.params.id) },
      data: { resenado: true }
    })
    res.json(pago)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── OBTENER RESEÑAS DE UN MÚSICO ─────────────────────────────
app.get('/resenas/musico/:musicoId', async (req, res) => {
  try {
    const resenas = await prisma.resena.findMany({
      where: { musicoId: parseInt(req.params.musicoId) },
      include: { local: { select: { nombreNegocio: true, foto: true } } },
      orderBy: { creadoEn: 'desc' }
    })
    res.json(resenas)
  } catch (e) {
    res.status(500).json({ error: 'Error del servidor' })
  }
})

// ─── EDITAR PERFIL USUARIO ────────────────────────────────────
app.put('/usuario/:id', async (req, res) => {
  const { nombre, email, telefono, password } = req.body
  try {
    const data = { nombre, email, telefono }
    if (password) data.password = await bcrypt.hash(password, 10)
    const usuario = await prisma.usuario.update({
      where: { id: parseInt(req.params.id) },
      data
    })
    res.json({ mensaje: 'Usuario actualizado', usuario })
  } catch (e) {
    res.status(500).json({ error: 'Error al actualizar usuario' })
  }
})

// ─── EDITAR PERFIL MÚSICO ─────────────────────────────────────
app.put('/musico/:id', async (req, res) => {
  const { nombreArtistico, biografia, precioPorHora, localidad, generosIds, foto, galeria } = req.body
  try {
    await prisma.musicoGenero.deleteMany({ where: { musicoId: parseInt(req.params.id) } })
    const musico = await prisma.musico.update({
      where: { id: parseInt(req.params.id) },
      data: {
        nombreArtistico,
        biografia,
        precioPorHora: parseFloat(precioPorHora),
        localidad,
        foto: foto || undefined,
        galeria: galeria || undefined,
        generos: {
          create: (generosIds || []).map(id => ({
            genero: { connect: { id: parseInt(id) } }
          }))
        }
      }
    })
    res.json({ mensaje: 'Perfil actualizado', musico })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al actualizar perfil' })
  }
})

// ─── EDITAR PERFIL LOCAL ──────────────────────────────────────
app.put('/local/:id', async (req, res) => {
  const { nombreNegocio, ubicacion, descripcion, foto, galeria } = req.body
  try {
    const local = await prisma.local.update({
      where: { id: parseInt(req.params.id) },
      data: {
        nombreNegocio,
        ubicacion,
        descripcion,
        foto: foto || undefined,
        galeria: galeria || undefined
      }
    })
    res.json({ mensaje: 'Local actualizado', local })
  } catch (e) {
    console.error(e)
    res.status(500).json({ error: 'Error al actualizar local' })
  }
})

// ─── ELIMINAR CUENTA ──────────────────────────────────────────
app.delete('/usuario/:id', async (req, res) => {
  try {
    await prisma.usuario.update({
      where: { id: parseInt(req.params.id) },
      data: { activo: false }
    })
    res.json({ mensaje: 'Cuenta desactivada' })
  } catch (e) {
    res.status(500).json({ error: 'Error al eliminar cuenta' })
  }
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => console.log(`Backend corriendo en puerto ${PORT}`))

//para que cuncione local
//app.listen(3000, () => console.log('Backend corriendo en http://localhost:3000'))
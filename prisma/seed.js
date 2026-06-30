const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

async function main() {
  await prisma.rol.createMany({
    data: [
      { nombre: 'musico' },
      { nombre: 'local' }
    ],
    skipDuplicates: true
  })
  console.log('Roles creados')

  await prisma.genero.createMany({
    data: [
      { nombre: 'Rock' },
      { nombre: 'Pop' },
      { nombre: 'Jazz' },
      { nombre: 'Blues' },
      { nombre: 'Reggae' },
      { nombre: 'Salsa' },
      { nombre: 'Cumbia' },
      { nombre: 'Norteño' },
      { nombre: 'Banda' },
      { nombre: 'Electrónica' },
      { nombre: 'Hip Hop' },
      { nombre: 'R&B' },
      { nombre: 'Soul' },
      { nombre: 'Funk' },
      { nombre: 'Metal' },
      { nombre: 'Indie' },
      { nombre: 'Clásica' },
      { nombre: 'Flamenco' },
      { nombre: 'Bossa Nova' },
      { nombre: 'Tropical' },
    ],
    skipDuplicates: true
  })
  console.log('Géneros creados')
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect())
/*
  Warnings:

  - You are about to drop the column `rol` on the `Usuario` table. All the data in the column will be lost.
  - Added the required column `rolId` to the `Usuario` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Usuario` DROP COLUMN `rol`,
    ADD COLUMN `activo` BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN `rolId` INTEGER NOT NULL;

-- CreateTable
CREATE TABLE `Rol` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `Rol_nombre_key`(`nombre`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Musico` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuarioId` INTEGER NOT NULL,
    `nombreArtistico` VARCHAR(191) NOT NULL,
    `foto` VARCHAR(191) NULL,
    `biografia` TEXT NULL,
    `precioPorHora` DECIMAL(10, 2) NOT NULL,
    `localidad` VARCHAR(191) NOT NULL,
    `generos` VARCHAR(191) NULL,

    UNIQUE INDEX `Musico_usuarioId_key`(`usuarioId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Local` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuarioId` INTEGER NOT NULL,
    `nombreNegocio` VARCHAR(191) NOT NULL,
    `ubicacion` VARCHAR(191) NOT NULL,
    `descripcion` TEXT NULL,
    `foto` VARCHAR(191) NULL,

    UNIQUE INDEX `Local_usuarioId_key`(`usuarioId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Solicitud` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `localId` INTEGER NOT NULL,
    `musicoId` INTEGER NOT NULL,
    `fecha` DATETIME(3) NOT NULL,
    `hora` VARCHAR(191) NOT NULL,
    `lugar` VARCHAR(191) NOT NULL,
    `descripcion` TEXT NULL,
    `estado` VARCHAR(191) NOT NULL DEFAULT 'pendiente',
    `creadoEn` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Mensaje` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `solicitudId` INTEGER NOT NULL,
    `remitenteId` INTEGER NOT NULL,
    `contenido` TEXT NOT NULL,
    `creadoEn` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pago` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `solicitudId` INTEGER NOT NULL,
    `monto` DECIMAL(10, 2) NOT NULL,
    `montoRetenido` DECIMAL(10, 2) NOT NULL,
    `montoLiberado` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `estado` VARCHAR(191) NOT NULL DEFAULT 'retenido',
    `mpPagoId` VARCHAR(191) NULL,
    `musicoLlego` BOOLEAN NOT NULL DEFAULT false,
    `fechaPago` DATETIME(3) NULL,
    `creadoEn` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Pago_solicitudId_key`(`solicitudId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Resena` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `localId` INTEGER NOT NULL,
    `musicoId` INTEGER NOT NULL,
    `calificacion` INTEGER NOT NULL,
    `comentario` TEXT NULL,
    `creadoEn` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Notificacion` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuarioId` INTEGER NOT NULL,
    `solicitudId` INTEGER NULL,
    `tipo` VARCHAR(191) NOT NULL,
    `mensaje` VARCHAR(191) NOT NULL,
    `leida` BOOLEAN NOT NULL DEFAULT false,
    `creadoEn` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Usuario` ADD CONSTRAINT `Usuario_rolId_fkey` FOREIGN KEY (`rolId`) REFERENCES `Rol`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Musico` ADD CONSTRAINT `Musico_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Local` ADD CONSTRAINT `Local_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Solicitud` ADD CONSTRAINT `Solicitud_localId_fkey` FOREIGN KEY (`localId`) REFERENCES `Local`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Solicitud` ADD CONSTRAINT `Solicitud_musicoId_fkey` FOREIGN KEY (`musicoId`) REFERENCES `Musico`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Mensaje` ADD CONSTRAINT `Mensaje_solicitudId_fkey` FOREIGN KEY (`solicitudId`) REFERENCES `Solicitud`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pago` ADD CONSTRAINT `Pago_solicitudId_fkey` FOREIGN KEY (`solicitudId`) REFERENCES `Solicitud`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Resena` ADD CONSTRAINT `Resena_localId_fkey` FOREIGN KEY (`localId`) REFERENCES `Local`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Resena` ADD CONSTRAINT `Resena_musicoId_fkey` FOREIGN KEY (`musicoId`) REFERENCES `Musico`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Notificacion` ADD CONSTRAINT `Notificacion_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Notificacion` ADD CONSTRAINT `Notificacion_solicitudId_fkey` FOREIGN KEY (`solicitudId`) REFERENCES `Solicitud`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

/*
  Warnings:

  - You are about to drop the column `generos` on the `Musico` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `Musico` DROP COLUMN `generos`;

-- CreateTable
CREATE TABLE `Genero` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `Genero_nombre_key`(`nombre`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MusicoGenero` (
    `musicoId` INTEGER NOT NULL,
    `generoId` INTEGER NOT NULL,

    PRIMARY KEY (`musicoId`, `generoId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `MusicoGenero` ADD CONSTRAINT `MusicoGenero_musicoId_fkey` FOREIGN KEY (`musicoId`) REFERENCES `Musico`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MusicoGenero` ADD CONSTRAINT `MusicoGenero_generoId_fkey` FOREIGN KEY (`generoId`) REFERENCES `Genero`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

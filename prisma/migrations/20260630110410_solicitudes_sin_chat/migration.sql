/*
  Warnings:

  - You are about to drop the column `descripcion` on the `Solicitud` table. All the data in the column will be lost.
  - You are about to drop the column `hora` on the `Solicitud` table. All the data in the column will be lost.
  - You are about to drop the column `lugar` on the `Solicitud` table. All the data in the column will be lost.
  - You are about to drop the `Mensaje` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `comisionApp` to the `Solicitud` table without a default value. This is not possible if the table is not empty.
  - Added the required column `duracionHoras` to the `Solicitud` table without a default value. This is not possible if the table is not empty.
  - Added the required column `horaFin` to the `Solicitud` table without a default value. This is not possible if the table is not empty.
  - Added the required column `horaInicio` to the `Solicitud` table without a default value. This is not possible if the table is not empty.
  - Added the required column `montoMusico` to the `Solicitud` table without a default value. This is not possible if the table is not empty.
  - Added the required column `montoTotal` to the `Solicitud` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `Mensaje` DROP FOREIGN KEY `Mensaje_solicitudId_fkey`;

-- AlterTable
ALTER TABLE `Solicitud` DROP COLUMN `descripcion`,
    DROP COLUMN `hora`,
    DROP COLUMN `lugar`,
    ADD COLUMN `comisionApp` DECIMAL(10, 2) NOT NULL,
    ADD COLUMN `duracionHoras` INTEGER NOT NULL,
    ADD COLUMN `horaFin` VARCHAR(191) NOT NULL,
    ADD COLUMN `horaInicio` VARCHAR(191) NOT NULL,
    ADD COLUMN `montoMusico` DECIMAL(10, 2) NOT NULL,
    ADD COLUMN `montoTotal` DECIMAL(10, 2) NOT NULL,
    ADD COLUMN `tipoEvento` VARCHAR(191) NULL;

-- DropTable
DROP TABLE `Mensaje`;

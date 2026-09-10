-- XAMPP-Lite
-- version 8.5.5
-- https://xampplite.sf.net/
--
-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 03/09/2026 às 23:02
-- Versão do servidor: 11.4.10-MariaDB-log
-- Versão do PHP: 8.5.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `sevenshows_db`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `artistagendablocks`
--

CREATE TABLE `artistagendablocks` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `StartDate` datetime(6) NOT NULL,
  `Reason` varchar(255) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `EndDate` datetime(6) NOT NULL DEFAULT '0001-01-01 00:00:00.000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artistagendablocks`
--

INSERT INTO `artistagendablocks` (`Id`, `UserId`, `StartDate`, `Reason`, `CreatedAt`, `EndDate`) VALUES
('368f299f-3b67-460e-bc8e-be6132935dff', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', '2026-09-22 00:00:00.000000', 'Folga', '2026-09-01 23:57:16.236088', '2026-09-23 00:00:00.000000'),
('65f42e3e-8ff2-4f3a-9717-dae7cf5030b8', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', '2026-09-10 00:00:00.000000', 'Descanso', '2026-09-01 21:07:32.188017', '0001-01-01 00:00:00.000000'),
('867e5e60-7370-418d-898c-818f3211d884', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', '2026-12-25 00:00:00.000000', 'Feriado de Natal - Recesso da Banda', '2026-08-27 22:04:44.562499', '0001-01-01 00:00:00.000000'),
('d92ceac5-763f-4800-9905-e9181d1a3d2a', '143a8824-6fd8-45a7-9aaa-9c9003549a9c', '2026-12-25 00:00:00.000000', 'Feriado de Natal - Recesso da Banda', '2026-08-27 21:45:18.245834', '0001-01-01 00:00:00.000000');

-- --------------------------------------------------------

--
-- Estrutura para tabela `artistevents`
--

CREATE TABLE `artistevents` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Title` longtext NOT NULL,
  `EventDate` datetime(6) NOT NULL,
  `VenueName` longtext NOT NULL,
  `City` longtext NOT NULL,
  `State` longtext NOT NULL,
  `Status` longtext NOT NULL,
  `ArtistPackageId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `BasePackagePrice` decimal(18,2) NOT NULL DEFAULT 0.00,
  `ContractorName` varchar(150) DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL DEFAULT '0001-01-01 00:00:00.000000',
  `DistanceKm` int(11) NOT NULL DEFAULT 0,
  `EventType` varchar(100) DEFAULT NULL,
  `ExtraHours` int(11) NOT NULL DEFAULT 0,
  `ExtraHoursValueCharged` decimal(18,2) NOT NULL DEFAULT 0.00,
  `ExtraKm` int(11) NOT NULL DEFAULT 0,
  `ExtraKmValueCharged` decimal(18,2) NOT NULL DEFAULT 0.00,
  `RequestedDurationHours` int(11) NOT NULL DEFAULT 0,
  `TotalProposedPrice` decimal(18,2) NOT NULL DEFAULT 0.00,
  `Notes` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artistevents`
--

INSERT INTO `artistevents` (`Id`, `UserId`, `Title`, `EventDate`, `VenueName`, `City`, `State`, `Status`, `ArtistPackageId`, `BasePackagePrice`, `ContractorName`, `CreatedAt`, `DistanceKm`, `EventType`, `ExtraHours`, `ExtraHoursValueCharged`, `ExtraKm`, `ExtraKmValueCharged`, `RequestedDurationHours`, `TotalProposedPrice`, `Notes`) VALUES
('2852885c-a63b-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Aniversário de 15 Anos - Roberta', '2026-09-13 21:00:00.000000', 'Salão de Festas Versailles', 'Londrina', 'PR', 'In_Negotiation', NULL, 1800.00, 'Marcos Alencar (Pai da Debutante)', '2026-09-01 19:27:23.000000', 45, 'Aniversário', 0, 0.00, 5, 25.00, 3, 1825.00, 'Quero negociar o frete com você.'),
('28763122-a63b-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Formatura Medicina UNIFIL', '2026-09-18 23:30:00.000000', 'Pavilhão de Exposições Moringão', 'Londrina', 'PR', 'Rejected', NULL, 6000.00, 'Comissão de Formatura Turma LVIII', '2026-09-01 19:27:23.000000', 50, 'Formatura', 2, 700.00, 10, 50.00, 5, 6750.00, 'Não quero fazer esse show.'),
('28991b01-a63b-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Festa do Peão de Sertanópolis', '2026-09-21 00:30:00.000000', 'Arena de Rodeios Municipal', 'Sertanópolis', 'PR', 'Pending', NULL, 8500.00, 'Sindicato Rural Patronal', '2026-09-01 19:27:23.000000', 90, 'Show Público / Rodeio', 0, 0.00, 50, 250.00, 3, 8750.00, NULL),
('b8499c28-a63a-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Casamento Priscila & Igor', '2026-09-06 20:00:00.000000', 'Espaço Imperial Eventos', 'Londrina', 'PR', 'Confirmed', NULL, 2500.00, 'Priscila Vasconcelos', '2026-09-01 19:24:15.000000', 120, 'Casamento', 1, 350.00, 80, 400.00, 4, 3250.00, NULL),
('b86e86a5-a63a-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Corporativo Sicredi - Final de Ano', '2026-09-11 19:30:00.000000', 'Recanto das Palmeiras', 'Ibiporã', 'PR', 'Rejected', NULL, 3500.00, 'Carlos Eduardo (Diretor Sicredi)', '2026-09-01 19:24:15.000000', 30, 'Corporativo', 0, 0.00, 0, 0.00, 3, 3500.00, NULL),
('b89c7335-a63a-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Festival de Inverno 2026', '2026-09-16 22:00:00.000000', 'Praça Central de Cornélio', 'Cornélio Procópio', 'PR', 'Pre_Approved', NULL, 5000.00, 'Secretaria de Cultura e Turismo', '2026-09-01 19:24:16.000000', 75, 'Festival Público', 2, 700.00, 35, 175.00, 5, 5875.00, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `artistwallettransactions`
--

CREATE TABLE `artistwallettransactions` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Type` longtext NOT NULL,
  `Value` decimal(18,2) NOT NULL,
  `IsReleased` tinyint(1) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artistwallettransactions`
--

INSERT INTO `artistwallettransactions` (`Id`, `UserId`, `Type`, `Value`, `IsReleased`, `CreatedAt`) VALUES
('61f59aa9-a67a-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Receivable', 1500.00, 1, '2026-08-15 21:00:00.000000'),
('61f5a110-a67a-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Payout', 500.00, 1, '2026-08-20 14:30:00.000000'),
('61f5a1c4-a67a-11f1-be5c-ecf4bbfb6669', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Receivable', 2200.00, 0, '2026-09-01 23:00:00.000000');

-- --------------------------------------------------------

--
-- Estrutura para tabela `artist_addresses`
--

CREATE TABLE `artist_addresses` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Street` varchar(255) NOT NULL,
  `Number` varchar(20) NOT NULL,
  `Complement` varchar(100) DEFAULT NULL,
  `Neighborhood` varchar(100) NOT NULL,
  `City` varchar(100) NOT NULL,
  `State` varchar(2) NOT NULL,
  `ZipCode` varchar(10) NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artist_addresses`
--

INSERT INTO `artist_addresses` (`Id`, `Street`, `Number`, `Complement`, `Neighborhood`, `City`, `State`, `ZipCode`, `UserId`) VALUES
('288914c2-9315-47f6-be0d-6b3bbc5b0645', 'Rua das Flores', '500', NULL, 'Centro', 'São Paulo', 'SP', '03401001', '92265d77-2b62-4301-83e3-073949420cda'),
('3defba23-ceca-4f09-bcac-3b250dc7181f', 'Rua das Flores', '500', NULL, 'Centro', 'São Paulo', 'SP', '03401001', 'c65498da-7bef-490f-8854-9a94412a670c'),
('55a78527-cdc0-48e7-b57f-46903ab18f74', 'Rua das Flores', '500', NULL, 'Centro', 'São Paulo', 'SP', '03401001', '143a8824-6fd8-45a7-9aaa-9c9003549a9c'),
('d22b0684-99c7-43ca-b617-d45a6cc35f42', 'Rua das Flores', '500', NULL, 'Centro', 'São Paulo', 'SP', '03401001', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9');

-- --------------------------------------------------------

--
-- Estrutura para tabela `artist_availabilities`
--

CREATE TABLE `artist_availabilities` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `DayOfWeek` int(11) NOT NULL,
  `StartTime` time(6) NOT NULL,
  `EndTime` time(6) NOT NULL,
  `IsAvailable` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artist_availabilities`
--

INSERT INTO `artist_availabilities` (`Id`, `UserId`, `DayOfWeek`, `StartTime`, `EndTime`, `IsAvailable`) VALUES
('31e0e3c3-cc4a-4c18-8833-6f7bf4b51656', '143a8824-6fd8-45a7-9aaa-9c9003549a9c', 6, '18:00:00.000000', '04:00:00.000000', 1),
('5c4d77f8-d6a0-4550-acee-be1493ee02bd', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 5, '19:00:00.000000', '03:00:00.000000', 1),
('5d16003c-4e2c-4c6b-8f08-56ff432ca589', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 6, '18:00:00.000000', '04:00:00.000000', 1),
('8a990157-b8e9-4672-b78c-3f7ae2b32543', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 0, '12:00:00.000000', '23:59:00.000000', 1),
('f89aabb6-a498-42a7-aa09-a608510e5a66', '143a8824-6fd8-45a7-9aaa-9c9003549a9c', 5, '19:00:00.000000', '03:00:00.000000', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `artist_comercial_settings`
--

CREATE TABLE `artist_comercial_settings` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `FreeRadiusKm` int(11) NOT NULL,
  `ExtraKmValue` decimal(18,2) NOT NULL,
  `AcceptExtraHours` tinyint(1) NOT NULL,
  `ExtraHourValue` decimal(18,2) NOT NULL,
  `AttendedRegions` varchar(500) NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artist_comercial_settings`
--

INSERT INTO `artist_comercial_settings` (`Id`, `FreeRadiusKm`, `ExtraKmValue`, `AcceptExtraHours`, `ExtraHourValue`, `AttendedRegions`, `UserId`) VALUES
('26933dd3-19f9-429b-8b51-366c9abff5c2', 35, 2.50, 1, 150.00, 'Todo o estado de SP, Campinas e região metropolitana.', '143a8824-6fd8-45a7-9aaa-9c9003549a9c'),
('56b291c4-d719-4d03-b8e1-e2a66a5e0cf1', 35, 200.00, 1, 100.00, 'Norte pioneiro do Paraná', 'c65498da-7bef-490f-8854-9a94412a670c'),
('cf3f9f32-f8db-4eae-8246-21bdae450c7d', 45, 2.50, 1, 130.00, 'Pinhal e Santo Antônio', '92265d77-2b62-4301-83e3-073949420cda'),
('ed75448d-e34e-4114-8e72-96fb347e561d', 40, 2.50, 1, 150.00, 'Todo o estado de SP, Campinas e região metropolitana.', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9');

-- --------------------------------------------------------

--
-- Estrutura para tabela `artist_medias`
--

CREATE TABLE `artist_medias` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `MediaType` varchar(20) NOT NULL,
  `MediaUrl` varchar(500) NOT NULL,
  `Caption` varchar(255) DEFAULT NULL,
  `CreatedAt` datetime(6) NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artist_medias`
--

INSERT INTO `artist_medias` (`Id`, `MediaType`, `MediaUrl`, `Caption`, `CreatedAt`, `UserId`) VALUES
('01600deb-b141-4387-b929-4544f738e9ba', 'Photo', '/uploads/artist-medias/photo_92265d77-2b62-4301-83e3-073949420cda_8ebed449-33c8-486a-bc59-119e418c8ef6.jpg', NULL, '2026-09-02 17:44:40.025387', '92265d77-2b62-4301-83e3-073949420cda'),
('04bd1999-121a-408c-b39a-f841023e7c2a', 'Photo', '/uploads/artist-medias/photo_92265d77-2b62-4301-83e3-073949420cda_75fb36f9-493a-4a2a-86a6-43c3df9fdcf9.jpg', NULL, '2026-09-02 17:44:11.051454', '92265d77-2b62-4301-83e3-073949420cda'),
('133b11e0-2a6c-4947-9988-b925c802f293', 'Video', 'https://www.youtube.com/watch?v=Lwuwu8L00gs', 'Teste vídeo 3', '2026-08-31 21:42:25.743267', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('1a1b48aa-3890-46fe-99ce-b276aa30d044', 'Photo', '/uploads/artist-medias/photo_92265d77-2b62-4301-83e3-073949420cda_b498c87f-20a6-4d3d-b1be-0a1eed0fbfc4.jpg', NULL, '2026-09-02 17:44:30.719136', '92265d77-2b62-4301-83e3-073949420cda'),
('246dd4da-b9cf-4a57-8c49-22acb621fb7b', 'Video', 'https://www.youtube.com/watch?v=fRejrHqKxZg', 'Teste vídeo 1', '2026-08-31 21:39:51.268208', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('2e7cd862-67cf-4fdd-8aef-41ccd8e4a924', 'Cover', '/uploads/artist-medias/cover_dd1fc02e-741c-42f6-8d63-764e8067d8c9_c2121d36-7fa6-4e1d-8457-4746e0e439b3.jpg', NULL, '2026-08-31 19:43:19.451799', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('2e9ad1f8-0bb7-42be-a9d1-0235dda43af3', 'Photo', '/uploads/artist-medias/photo_c65498da-7bef-490f-8854-9a94412a670c_ee662b26-cab3-4b11-9be7-fe15971c7b27.jpg', NULL, '2026-09-02 14:50:29.598976', 'c65498da-7bef-490f-8854-9a94412a670c'),
('3210a427-d77f-4073-a17a-c9d2a13ab0ed', 'Photo', '/uploads/artist-medias/photo_dd1fc02e-741c-42f6-8d63-764e8067d8c9_7b941cc2-e6e6-4d42-ab1c-8cb7616f5280.jpg', NULL, '2026-08-31 19:47:37.427904', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('3f1e934f-0390-4533-9961-f8a8dc83622e', 'Photo', '/uploads/artist-medias/photo_c65498da-7bef-490f-8854-9a94412a670c_012e0120-5c80-46ac-9d56-70378f76aa9a.jpg', NULL, '2026-09-02 14:50:48.061120', 'c65498da-7bef-490f-8854-9a94412a670c'),
('419e12f0-6602-4865-9261-a4559088a261', 'Photo', '/uploads/artist-medias/photo_dd1fc02e-741c-42f6-8d63-764e8067d8c9_442d975a-a5de-46ad-aeed-b73cdec88533.jpg', NULL, '2026-08-31 21:43:26.909744', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('4aedace9-10d0-4887-8aa8-6e55ea254d48', 'Photo', '/uploads/artist-medias/photo_dd1fc02e-741c-42f6-8d63-764e8067d8c9_bd2df4e1-b2c0-4473-8ae4-8325b30a81b0.jpg', NULL, '2026-08-31 20:33:25.175912', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('66d5df1e-a6ed-404a-9561-472fe4a69a67', 'Photo', '/uploads/artist-medias/photo_dd1fc02e-741c-42f6-8d63-764e8067d8c9_17e02354-5797-4f58-98c3-e5a623830d69.jpg', NULL, '2026-08-31 21:12:29.654974', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('6846ad04-8dba-4dcf-a330-c9432444f0fb', 'Video', 'https://www.youtube.com/watch?v=oTivhgjbhIg', 'Teste vídeo 2', '2026-08-31 21:41:27.079619', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('686e02ed-079e-4d0e-b2d7-6d582705843b', 'Photo', '/uploads/artist-medias/photo_92265d77-2b62-4301-83e3-073949420cda_2af0af00-510c-4296-8c03-99aa72cc27af.jpg', NULL, '2026-09-02 17:44:21.293787', '92265d77-2b62-4301-83e3-073949420cda'),
('7f18f1d8-f281-4d7c-8eea-cf34db10468e', 'Photo', '/uploads/artist-medias/photo_c65498da-7bef-490f-8854-9a94412a670c_d8878eb2-dec2-4dcf-8612-117a59cece9a.jpg', NULL, '2026-09-02 14:50:39.646808', 'c65498da-7bef-490f-8854-9a94412a670c'),
('8d8a38f2-a062-48ca-b665-2b3c09a3b94b', 'Photo', '/uploads/artist-medias/photo_c65498da-7bef-490f-8854-9a94412a670c_aed673c3-d8f8-4289-bf34-b1f51747c34d.jpg', NULL, '2026-09-02 14:29:55.101134', 'c65498da-7bef-490f-8854-9a94412a670c'),
('90302aca-a4ca-420e-be6a-b19909a64f6f', 'Video', 'https://www.youtube.com/watch?v=_ymtGFnITOw', 'Teste', '2026-09-02 16:26:47.197290', 'c65498da-7bef-490f-8854-9a94412a670c'),
('972e93fa-95a6-48c0-b76f-306203a82b7b', 'Photo', '/uploads/artist-medias/photo_dd1fc02e-741c-42f6-8d63-764e8067d8c9_b81ecde5-4d2a-4646-86c4-5b47fb59e9c3.jpg', NULL, '2026-08-31 21:38:59.491987', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('af357f95-0e2c-4c2e-a6b4-11c2b46dbda8', 'Cover', '/uploads/artist-medias/cover_143a8824-6fd8-45a7-9aaa-9c9003549a9c_263fd6d8-8890-4937-8a09-e4d8491d74aa.jpg', NULL, '2026-08-27 21:42:25.280683', '143a8824-6fd8-45a7-9aaa-9c9003549a9c'),
('b8790f7e-5156-4e5c-abb6-30151dd0e3f9', 'Photo', '/uploads/artist-medias/photo_92265d77-2b62-4301-83e3-073949420cda_fc7afae8-bdcb-44cd-812a-b15a938246b6.jpg', NULL, '2026-09-02 17:43:59.701906', '92265d77-2b62-4301-83e3-073949420cda'),
('bff5ba25-3725-455f-b880-996e836318f4', 'Photo', '/uploads/artist-medias/photo_c65498da-7bef-490f-8854-9a94412a670c_0d726620-7536-4202-b22e-9851ee0e7d40.jpg', NULL, '2026-09-02 14:50:21.288806', 'c65498da-7bef-490f-8854-9a94412a670c'),
('da0ac809-d253-4174-84ea-d6ed7783b4f0', 'Cover', '/uploads/artist-medias/cover_c65498da-7bef-490f-8854-9a94412a670c_3fbc24c3-f56b-44ed-a6b9-24d4ce2563d0.jpg', NULL, '2026-09-02 14:29:43.554111', 'c65498da-7bef-490f-8854-9a94412a670c'),
('e111eb24-6a5b-43a5-898b-0ed0bf38e6ce', 'Cover', '/uploads/artist-medias/cover_92265d77-2b62-4301-83e3-073949420cda_c25c0974-151a-4819-adb9-4ce6f2464031.jpg', NULL, '2026-09-02 17:45:35.449866', '92265d77-2b62-4301-83e3-073949420cda'),
('f3a20fe1-f843-4334-8633-9e625ec2ca29', 'Photo', '/uploads/artist-medias/photo_143a8824-6fd8-45a7-9aaa-9c9003549a9c_6604db44-22d7-4c98-a5cf-7f1e0a9c8cd6.jpg', 'Minha primeira apresentação oficial com a banda completa! #rock', '2026-08-27 21:42:33.258598', '143a8824-6fd8-45a7-9aaa-9c9003549a9c'),
('f9a1bfcf-fe13-49b4-bb38-093ea92e62e9', 'Video', 'https://www.youtube.com/watch?v=JKGjmQnmpOs', 'Teste', '2026-09-02 17:46:15.831940', '92265d77-2b62-4301-83e3-073949420cda');

-- --------------------------------------------------------

--
-- Estrutura para tabela `artist_packages`
--

CREATE TABLE `artist_packages` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Title` varchar(100) NOT NULL,
  `DurationMinutes` int(11) NOT NULL,
  `BasePrice` decimal(18,2) NOT NULL,
  `Description` varchar(1000) NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `artist_packages`
--

INSERT INTO `artist_packages` (`Id`, `Title`, `DurationMinutes`, `BasePrice`, `Description`, `UserId`) VALUES
('1ef39ff1-2a48-4cb4-893d-f573ebfa5c03', 'Show Oficial Pocket Acústico', 120, 1200.00, 'Formato reduzido ideal para bares e eventos corporativos de pequeno porte.', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('276abb96-3910-42cb-a7eb-cbec1a77b188', 'Show Oficial Pocket Acústico', 90, 1200.00, 'Formato reduzido ideal para bares e eventos corporativos de pequeno porte.', '143a8824-6fd8-45a7-9aaa-9c9003549a9c'),
('3f8dfed3-22b9-44d3-a83b-fd67ba7412e2', 'Teste 5', 120, 579.00, 'Teste 5', '92265d77-2b62-4301-83e3-073949420cda'),
('531c2510-91da-4dbf-9d8c-e7555e0c1d7e', 'Teste 1', 120, 500.00, 'Teste 1', '92265d77-2b62-4301-83e3-073949420cda'),
('9b7ec718-36c7-4b25-a3ab-8dffb1df4be3', 'teste 1', 120, 500.00, 'ttttttt', 'c65498da-7bef-490f-8854-9a94412a670c'),
('9e601406-2360-4746-807d-1f4296a964a3', 'Show Especial de Casamentos', 240, 3000.00, 'Show especial para casamentos, maior duração, repertório adaptado, entrada dos noivos e outras adaptações', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9'),
('a95d448d-9d27-4948-901a-92c6b64e5050', 'Teste 3', 120, 1000.00, 'Teste 3', '92265d77-2b62-4301-83e3-073949420cda'),
('adf73677-7769-44b9-b234-bf0ee58d230d', 'Show teste', 120, 1800.00, 'Testando', 'c65498da-7bef-490f-8854-9a94412a670c'),
('d02bdfe4-0aab-46fc-9c18-5f28e403b789', 'Mais um', 120, 400.00, 'Mais um', 'c65498da-7bef-490f-8854-9a94412a670c');

-- --------------------------------------------------------

--
-- Estrutura para tabela `roles`
--

CREATE TABLE `roles` (
  `Id` varchar(50) NOT NULL,
  `Description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `roles`
--

INSERT INTO `roles` (`Id`, `Description`) VALUES
('SuperAdmin', 'Administrador Global do SaaS'),
('Tenant', 'Musico, Banda ou Agencia Parceira');

-- --------------------------------------------------------

--
-- Estrutura para tabela `saasplans`
--

CREATE TABLE `saasplans` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Name` longtext NOT NULL,
  `Description` longtext NOT NULL,
  `MonthlyFee` decimal(18,2) NOT NULL,
  `DefaultTakeRatePercent` decimal(5,2) NOT NULL,
  `MaxShowsPerMonth` int(11) NOT NULL,
  `MaxPhotosCount` int(11) NOT NULL,
  `MaxVideosCount` int(11) NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `DurationMonths` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `saasplans`
--

INSERT INTO `saasplans` (`Id`, `Name`, `Description`, `MonthlyFee`, `DefaultTakeRatePercent`, `MaxShowsPerMonth`, `MaxPhotosCount`, `MaxVideosCount`, `IsActive`, `DurationMonths`) VALUES
('b15b7263-ff09-4407-b254-ebc2c9816a35', 'Bronze', 'Ideal para músicos solo e bandas iniciantes', 49.70, 5.00, 3, 5, 2, 1, 0),
('eb4910ac-db32-4a9a-b2fd-afbcfb36074d', 'Plano Prata Automatizado', 'Acesso ilimitado', 99.90, 3.00, 5, 20, 10, 1, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `saas_invoices`
--

CREATE TABLE `saas_invoices` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `AsaasInvoiceId` varchar(100) NOT NULL,
  `Value` decimal(18,2) NOT NULL,
  `Status` varchar(30) NOT NULL,
  `PaymentMethod` varchar(50) NOT NULL,
  `PixCopyPaste` text DEFAULT NULL,
  `DueDate` datetime(6) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `saas_invoices`
--

INSERT INTO `saas_invoices` (`Id`, `UserId`, `AsaasInvoiceId`, `Value`, `Status`, `PaymentMethod`, `PixCopyPaste`, `DueDate`, `CreatedAt`) VALUES
('918071f1-a719-11f1-be5c-ecf4bbfb6669', '92265d77-2b62-4301-83e3-073949420cda', 'pay_real_vencida_777', 49.70, 'PAYMENT_OVERDUE', 'PIX', '://pix2536asaas.com', '2026-07-10 23:59:59.000000', '2026-07-01 10:00:00.000000'),
('91807665-a719-11f1-be5c-ecf4bbfb6669', '92265d77-2b62-4301-83e3-073949420cda', 'pay_real_paga_888', 49.70, 'PAYMENT_RECEIVED', 'CREDIT_CARD', NULL, '2026-08-10 23:59:59.000000', '2026-08-01 10:00:00.000000'),
('91807808-a719-11f1-be5c-ecf4bbfb6669', '92265d77-2b62-4301-83e3-073949420cda', 'pay_real_aberta_999', 49.70, 'PENDING', 'PIX', '://pix2536asaas.com', '2026-09-10 23:59:59.000000', '2026-09-01 10:00:00.000000');

-- --------------------------------------------------------

--
-- Estrutura para tabela `saas_subscriptions`
--

CREATE TABLE `saas_subscriptions` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `UserId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `SaaSPlanId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `StartDate` datetime(6) NOT NULL,
  `EndDate` datetime(6) NOT NULL,
  `AsaasSubscriptionId` varchar(100) DEFAULT NULL,
  `CreditCardToken` varchar(255) DEFAULT NULL,
  `PaymentMethod` varchar(50) NOT NULL,
  `Status` varchar(30) NOT NULL,
  `CreatedAt` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `saas_subscriptions`
--

INSERT INTO `saas_subscriptions` (`Id`, `UserId`, `SaaSPlanId`, `StartDate`, `EndDate`, `AsaasSubscriptionId`, `CreditCardToken`, `PaymentMethod`, `Status`, `CreatedAt`) VALUES
('1c8fb89a-a989-4442-97a8-46523434f4ce', '143a8824-6fd8-45a7-9aaa-9c9003549a9c', 'b15b7263-ff09-4407-b254-ebc2c9816a35', '2026-08-27 21:42:52.321459', '2026-08-27 21:42:52.321551', 'sub_2dwk38ishfxu5nzk', NULL, 'PIX', 'Active', '2026-08-27 21:42:52.320848'),
('a419b343-1a14-45b2-a758-d581fe440221', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'b15b7263-ff09-4407-b254-ebc2c9816a35', '2026-08-27 22:03:41.557419', '2026-08-27 22:03:41.557501', 'sub_ijkgnrh9w8keswi8', NULL, 'PIX', 'Active', '2026-08-27 22:03:41.556803');

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `Id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(150) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `PersonType` varchar(20) NOT NULL,
  `SaaSPlanId` char(36) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `SubscriptionStatus` varchar(50) NOT NULL,
  `AsaasWalletId` varchar(100) DEFAULT NULL,
  `Cnpj` varchar(18) DEFAULT NULL,
  `Cpf` varchar(14) NOT NULL DEFAULT '',
  `ProfileStatus` varchar(50) NOT NULL,
  `AsaasAccountStatus` varchar(30) NOT NULL DEFAULT '',
  `AsaasOnboardingUrl` varchar(255) DEFAULT NULL,
  `BirthDate` datetime(6) NOT NULL DEFAULT '0001-01-01 00:00:00.000000',
  `CompanyType` varchar(30) DEFAULT NULL,
  `IncomeValue` decimal(18,2) NOT NULL DEFAULT 0.00,
  `MobilePhone` varchar(20) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`Id`, `Name`, `Email`, `PasswordHash`, `PersonType`, `SaaSPlanId`, `SubscriptionStatus`, `AsaasWalletId`, `Cnpj`, `Cpf`, `ProfileStatus`, `AsaasAccountStatus`, `AsaasOnboardingUrl`, `BirthDate`, `CompanyType`, `IncomeValue`, `MobilePhone`) VALUES
('143a8824-6fd8-45a7-9aaa-9c9003549a9c', 'Banda Um', 'bandaum@asaas.com', '$2a$11$oTPIbnED.JUZNbXgIuY1nuIgQl/oi0hIEL1v7hqlK7z8TUqg1YQyq', 'Legal', 'b15b7263-ff09-4407-b254-ebc2c9816a35', 'Active', NULL, '29070330000135', '82986965067', 'Active', 'PENDING', NULL, '1994-08-25 00:00:00.000000', 'MEI', 7500.00, '11988887777'),
('77777777-7777-7777-7777-777777777777', 'Administrador SevenShows', 'admin@sevenshows.com.br', '$2a$11$GxZgz/m2gqH1Q7Z0kDy8ve6MzJVXcxNqWqeZzvTfNDMhRbK68ICEq', 'Legal', NULL, 'Active', NULL, '00000000000100', '00000000000', 'Active', 'APPROVED', NULL, '1980-01-01 00:00:00.000000', 'LTDA', 0.00, '11999999999'),
('92265d77-2b62-4301-83e3-073949420cda', 'Banda Quatro', 'bandaquatro@asaas.com', '$2a$11$Ig1qb1R46YptnudSiEPpPO1a86dEmKPBkn0cNe69aLux9i17GOgn6', 'Legal', 'eb4910ac-db32-4a9a-b2fd-afbcfb36074d', 'Active', '0356037d-19b9-4bf1-9d1e-efc2f1521746', '83014479000142', '64458116045', 'Active', 'APPROVED', 'https://asaas.com', '1994-08-25 00:00:00.000000', 'MEI', 7500.00, '11988887777'),
('c65498da-7bef-490f-8854-9a94412a670c', 'Banda Tres', 'bandatres@asaas.com', '$2a$11$b9MJytO/RHsPjm3hIJD7T.MKnocFFxKQQCNZwicMD1ZsodqvrEHFO', 'Legal', 'b15b7263-ff09-4407-b254-ebc2c9816a35', 'Pending', '19451c52-77c3-4a43-b2da-5a39f202e503', '96356756000147', '56929656070', 'Incomplete_Packages', 'APPROVED', 'https://asaas.com', '1994-08-25 00:00:00.000000', 'MEI', 7500.00, '11988887777'),
('dd1fc02e-741c-42f6-8d63-764e8067d8c9', 'Banda Dois', 'bandadois@asaas.com', '$2a$11$Y45aSYWUwZMk9LZKbe8ptOzZEDyMrRZL.i4NXxHI9q0VRFeEl97eG', 'Legal', 'b15b7263-ff09-4407-b254-ebc2c9816a35', 'Active', 'f8c6e0b1-b553-4d75-8b3b-5c4fdd4bd9ef', '31505251000151', '03774392072', 'Active', 'APPROVED', 'https://asaas.com', '1994-08-25 00:00:00.000000', 'MEI', 7500.00, '11988887777');

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_roles`
--

CREATE TABLE `user_roles` (
  `role_id` varchar(50) NOT NULL,
  `user_id` char(36) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_roles`
--

INSERT INTO `user_roles` (`role_id`, `user_id`) VALUES
('Tenant', '143a8824-6fd8-45a7-9aaa-9c9003549a9c'),
('SuperAdmin', '77777777-7777-7777-7777-777777777777'),
('Tenant', '92265d77-2b62-4301-83e3-073949420cda'),
('Tenant', 'c65498da-7bef-490f-8854-9a94412a670c'),
('Tenant', 'dd1fc02e-741c-42f6-8d63-764e8067d8c9');

-- --------------------------------------------------------

--
-- Estrutura para tabela `__efmigrationshistory`
--

CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `__efmigrationshistory`
--

INSERT INTO `__efmigrationshistory` (`MigrationId`, `ProductVersion`) VALUES
('20260822234327_InitialCreate', '9.0.0'),
('20260823004845_FixDecimalPrecision', '9.0.0'),
('20260823155322_CriarEstruturaDeSeguranca', '9.0.0'),
('20260823160457_CriarEstruturaDeSegurancaESeed', '9.0.0'),
('20260823163945_CorrigirHashSenhaAdmin', '9.0.0'),
('20260823225605_AtualizarUserComPlanoEAsaas', '9.0.0'),
('20260825181601_CriarTabelaDeEnderecosDoArtista', '9.0.0'),
('20260825184546_SepararCpfECnpjNoUsuario', '9.0.0'),
('20260825192030_AdicionarColunaProfileStatusNoUsuario', '9.0.0'),
('20260825205618_CriarEstruturaDeLogisticaEPacotesDoArtista', '9.0.0'),
('20260826133652_CriarEstruturaDeMidiasDoArtista', '9.0.0'),
('20260826184804_AdicionarRecorrenciaEContratosDoSaaS', '9.0.0'),
('20260827143159_CriarEstruturaDaAgendaEBloqueiosDoArtista', '9.0.0'),
('20260827174301_AdicionarColunasDeSubcontaEWalletDoArtista', '9.0.0'),
('20260827181458_AdicionarDataDeNascimentoObrigatoriaNoUser', '9.0.0'),
('20260827211130_CriarEstruturaRealDeComplianceDaWallet', '9.0.0'),
('20260829182735_AdicionarTabelasAgendaEFinanceiro', '9.0.0'),
('20260901163008_AdicionarCamposLogisticaAgenda', '9.0.0'),
('20260901200235_AdicionarColunaNotesArtistEvent', '9.0.0'),
('20260901231751_AtualizarCamposRangeAgendaBlocks', '9.0.0'),
('20260902215557_CriarTabelaSaasInvoices', '9.0.0');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `artistagendablocks`
--
ALTER TABLE `artistagendablocks`
  ADD PRIMARY KEY (`Id`);

--
-- Índices de tabela `artistevents`
--
ALTER TABLE `artistevents`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_artistevents_ArtistPackageId` (`ArtistPackageId`),
  ADD KEY `IX_artistevents_UserId` (`UserId`);

--
-- Índices de tabela `artistwallettransactions`
--
ALTER TABLE `artistwallettransactions`
  ADD PRIMARY KEY (`Id`);

--
-- Índices de tabela `artist_addresses`
--
ALTER TABLE `artist_addresses`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_artist_addresses_UserId` (`UserId`);

--
-- Índices de tabela `artist_availabilities`
--
ALTER TABLE `artist_availabilities`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_artist_availabilities_UserId` (`UserId`);

--
-- Índices de tabela `artist_comercial_settings`
--
ALTER TABLE `artist_comercial_settings`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_artist_comercial_settings_UserId` (`UserId`);

--
-- Índices de tabela `artist_medias`
--
ALTER TABLE `artist_medias`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_artist_medias_UserId` (`UserId`);

--
-- Índices de tabela `artist_packages`
--
ALTER TABLE `artist_packages`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_artist_packages_UserId` (`UserId`);

--
-- Índices de tabela `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`Id`);

--
-- Índices de tabela `saasplans`
--
ALTER TABLE `saasplans`
  ADD PRIMARY KEY (`Id`);

--
-- Índices de tabela `saas_invoices`
--
ALTER TABLE `saas_invoices`
  ADD PRIMARY KEY (`Id`);

--
-- Índices de tabela `saas_subscriptions`
--
ALTER TABLE `saas_subscriptions`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_saas_subscriptions_SaaSPlanId` (`SaaSPlanId`),
  ADD KEY `IX_saas_subscriptions_UserId` (`UserId`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_users_SaaSPlanId` (`SaaSPlanId`);

--
-- Índices de tabela `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`role_id`,`user_id`),
  ADD KEY `IX_user_roles_user_id` (`user_id`);

--
-- Índices de tabela `__efmigrationshistory`
--
ALTER TABLE `__efmigrationshistory`
  ADD PRIMARY KEY (`MigrationId`);

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `artistevents`
--
ALTER TABLE `artistevents`
  ADD CONSTRAINT `FK_artistevents_artist_packages_ArtistPackageId` FOREIGN KEY (`ArtistPackageId`) REFERENCES `artist_packages` (`Id`),
  ADD CONSTRAINT `FK_artistevents_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `artist_addresses`
--
ALTER TABLE `artist_addresses`
  ADD CONSTRAINT `FK_artist_addresses_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `artist_availabilities`
--
ALTER TABLE `artist_availabilities`
  ADD CONSTRAINT `FK_artist_availabilities_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `artist_comercial_settings`
--
ALTER TABLE `artist_comercial_settings`
  ADD CONSTRAINT `FK_artist_comercial_settings_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `artist_medias`
--
ALTER TABLE `artist_medias`
  ADD CONSTRAINT `FK_artist_medias_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `artist_packages`
--
ALTER TABLE `artist_packages`
  ADD CONSTRAINT `FK_artist_packages_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `saas_subscriptions`
--
ALTER TABLE `saas_subscriptions`
  ADD CONSTRAINT `FK_saas_subscriptions_SaaSPlans_SaaSPlanId` FOREIGN KEY (`SaaSPlanId`) REFERENCES `saasplans` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_saas_subscriptions_users_UserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FK_users_SaaSPlans_SaaSPlanId` FOREIGN KEY (`SaaSPlanId`) REFERENCES `saasplans` (`Id`);

--
-- Restrições para tabelas `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `FK_user_roles_roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_user_roles_users_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`Id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
